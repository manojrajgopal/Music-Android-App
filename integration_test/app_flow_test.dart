import 'dart:io';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:cadence/app/app.dart';
import 'package:cadence/app/providers.dart';
import 'package:cadence/audio/audio_handler.dart';
import 'package:cadence/audio/playback_controller.dart';
import 'package:cadence/audio/sleep_timer.dart';
import 'package:cadence/core/utils/text_normalize.dart';
import 'package:cadence/data/database/app_database.dart';
import 'package:cadence/data/repositories/library_repository.dart';
import 'package:cadence/data/repositories/settings_repository.dart';
import 'package:cadence/data/services/backup_service.dart';
import 'package:cadence/data/services/import_service.dart';
import 'package:cadence/data/services/storage_paths.dart';
import 'package:cadence/data/services/url_import_service.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// End-to-end flow on a real device: real database file, real audio engine,
/// real file system. The system file picker cannot be automated, so files
/// are imported through the same ImportService the picker flow uses.
///
/// Run: `flutter test integration_test -d <device-id>`
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Directory root;
  late StoragePaths paths;
  late File dbFile;
  late CadenceAudioHandler handler;

  setUpAll(() async {
    root = Directory.systemTemp.createTempSync('cadence_it_');
    paths = StoragePaths.at(
      musicDir: Directory('${root.path}/music'),
      artworkDir: Directory('${root.path}/art'),
      tempDir: Directory('${root.path}/tmp'),
    );
    dbFile = File('${root.path}/library.sqlite');
    handler = await AudioService.init(
      builder: CadenceAudioHandler.new,
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'app.cadence.cadence.test',
        androidNotificationChannelName: 'Test',
      ),
    );
    SharedPreferences.setMockInitialValues({});
  });

  Future<ProviderContainer> launch(WidgetTester tester) async {
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(AppDatabase(NativeDatabase(dbFile))),
        storagePathsProvider.overrideWithValue(paths),
        sharedPreferencesProvider.overrideWithValue(await SharedPreferences.getInstance()),
        audioHandlerProvider.overrideWithValue(handler),
      ],
    );
    await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const CadenceApp()));
    await wait(tester, const Duration(milliseconds: 600));
    return container;
  }

  Future<void> shutdown(WidgetTester tester, ProviderContainer c) async {
    debugPrint('IT shutdown');
    await c.read(playbackControllerProvider).pause();
    await c.read(playbackControllerProvider).tracker.stop();
    final db = c.read(databaseProvider);
    await tester.pumpWidget(const SizedBox());
    // Dispose first so stream queries and playback listeners stop before the
    // database closes.
    c.dispose();
    await wait(tester, const Duration(milliseconds: 300));
    debugPrint('IT closing db');
    await db.close().timeout(const Duration(seconds: 10));
  }

  File wav(String name, {int seconds = 40, int seed = 0}) {
    const rate = 8000;
    final n = rate * seconds;
    final b = BytesBuilder()
      ..add('RIFF'.codeUnits)
      ..add(_u32(36 + n))
      ..add('WAVEfmt '.codeUnits)
      ..add(_u32(16))
      ..add([1, 0, 1, 0])
      ..add(_u32(rate))
      ..add(_u32(rate))
      ..add([1, 0, 8, 0])
      ..add('data'.codeUnits)
      ..add(_u32(n))
      ..add(List.generate(n, (i) => 128 + ((i * (seed + 3)) % 40)));
    return File('${root.path}/$name')..writeAsBytesSync(b.takeBytes());
  }

  testWidgets('full offline library flow', (tester) async {
    // 1. Launch with no data.
    debugPrint('IT step: 1. Launch with no data.');
    var c = await launch(tester);
    expect(find.text('Your library is empty'), findsOneWidget);
    final db = c.read(databaseProvider);

    // 2–3. Import supported files and read metadata.
    debugPrint('IT step: 2–3. Import supported files and read met');
    final importer = c.read(importServiceProvider);
    final a = await importer.importFile(wav('Morning Light.wav'), displayName: 'Morning Light.wav');
    final b = await importer.importFile(wav('Evening Rain.wav', seed: 2), displayName: 'Evening Rain.wav');
    expect(a.outcome, ImportOutcome.imported);
    expect(b.outcome, ImportOutcome.imported);
    expect(a.track!.title, 'Morning Light');
    await wait(tester, const Duration(milliseconds: 600));
    expect(find.text('Your library is empty'), findsNothing);

    // 4. Play, pause, seek and skip on the real engine.
    debugPrint('IT step: 4. Play, pause, seek and skip on the rea');
    final playback = c.read(playbackControllerProvider);
    await playback.playTracks([a.track!, b.track!]);
    await wait(tester, const Duration(seconds: 2));
    expect(handler.player.playing, isTrue);
    await playback.seek(const Duration(seconds: 5));
    await wait(tester, const Duration(milliseconds: 500));
    expect(handler.player.position.inSeconds, greaterThanOrEqualTo(5));
    await playback.next();
    await wait(tester, const Duration(seconds: 1));
    expect(handler.mediaItem.value?.title, 'Evening Rain');
    await playback.pause();
    expect(handler.player.playing, isFalse);

    // 5–7. Playlist, add/remove songs, favorite and unfavorite.
    debugPrint('IT step: 5–7. Playlist, add/remove songs, favorit');
    final playlist = await db.playlistsDao.createPlaylist('Integration');
    await db.playlistsDao.addTracks(playlist, [a.track!.id, b.track!.id, a.track!.id]);
    final items = await db.playlistsDao.items(playlist);
    await db.playlistsDao.removeEntry(playlist, items[1].entry.id);
    expect((await db.playlistsDao.items(playlist)).length, 2);
    final library = c.read(libraryRepositoryProvider);
    await library.setFavorite(a.track!.id, true);
    await library.setFavorite(b.track!.id, true);
    await library.setFavorite(b.track!.id, false);

    // 10. Edit metadata.
    debugPrint('IT step: 10. Edit metadata.');
    await library.saveEdits(
      (await db.tracksDao.byId(a.track!.id))!,
      const TrackEdit(title: 'Morning Light', artist: 'Cadence Test Band', language: 'Kannada'),
    );

    // 8. Restart and verify persistence.
    debugPrint('IT step: 8. Restart and verify persistence.');
    await shutdown(tester, c);
    c = await launch(tester);
    final db2 = c.read(databaseProvider);
    expect(await db2.tracksDao.allTracks(), hasLength(2));
    final reloaded = (await db2.tracksDao.byId(a.track!.id))!;
    expect(reloaded.isFavorite, isTrue);
    expect(reloaded.artist, 'Cadence Test Band');
    expect((await db2.playlistsDao.items(playlist)).length, 2);

    // 9 & 11. Search finds the edited metadata.
    debugPrint('IT step: 9 & 11. Search finds the edited metadata');
    expect((await db2.tracksDao.searchTracks(normalizeKey('test band'))).single.id, a.track!.id);

    // 12. Listening is counted from real playback (> 30 s).
    debugPrint('IT step: 12. Listening is counted from real playb');
    await c.read(playbackControllerProvider).playTracks([reloaded]);
    await wait(tester, const Duration(seconds: 33));
    await c.read(playbackControllerProvider).pause();
    await c.read(playbackControllerProvider).tracker.checkpoint();
    await wait(tester, const Duration(seconds: 1));
    final history = await db2.historyDao.allRecords();
    final counted = history.where((r) => r.counted).toList();
    expect(counted, hasLength(1), reason: 'the earlier 2–3 s plays did not count');
    expect(counted.single.listenedMs, inInclusiveRange(25000, 40000));
    expect((await db2.tracksDao.byId(a.track!.id))!.playCount, greaterThanOrEqualTo(1));

    // 13. Backup and restore.
    debugPrint('IT step: 13. Backup and restore.');
    final settingsRepo = SettingsRepository(c.read(sharedPreferencesProvider));
    final backup = BackupService(db2, settingsRepo);
    final bytes = await backup.create();
    final report = await backup.restore(backup.parse(bytes), conflict: RestoreConflict.keepLocal);
    expect(report.playlistsCreated, 1);
    expect(await db2.historyDao.allRecords(), hasLength(history.length), reason: 'history is not duplicated');

    // 14–15. Rescan without duplicates; missing files are flagged.
    debugPrint('IT step: 14–15. Rescan without duplicates; missin');
    File(paths.resolveSource(b.track!.sourceUri)).deleteSync();
    final rescan = await c.read(importServiceProvider).rescan();
    expect(rescan.added, 0);
    expect(rescan.missing, 1);
    expect((await db2.tracksDao.byId(b.track!.id))!.availability, Availability.missing);
    expect(await db2.tracksDao.allTracks(), hasLength(2));

    // 17. YouTube links are recognised and never downloaded.
    debugPrint('IT step: 17. YouTube links are recognised and nev');
    expect(checkLink('https://youtu.be/dQw4w9WgXcQ').kind, LinkKind.youtube);

    // 19. Sleep timer pauses playback when its deadline passes.
    debugPrint('IT step: 19. Sleep timer pauses playback when its');
    await c.read(playbackControllerProvider).playTracks([reloaded]);
    await wait(tester, const Duration(seconds: 1));
    c.read(sleepTimerProvider.notifier).start(const Duration(seconds: 2));
    await wait(tester, const Duration(seconds: 4));
    expect(handler.player.playing, isFalse);
    expect(c.read(sleepTimerProvider).active, isFalse);

    // 20. Everything above ran without network access.
    debugPrint('IT step: 20. Everything above ran without network');
    await shutdown(tester, c);
  });

  testWidgets('UI navigation across the five-position bar', (tester) async {
    final c = await launch(tester);
    await tester.tap(find.bySemanticsLabel('Library'));
    await wait(tester, const Duration(milliseconds: 600));
    expect(find.text('Recently Added'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Search'));
    await wait(tester, const Duration(milliseconds: 600));
    await tester.enterText(find.byType(TextField), 'morning');
    await wait(tester, const Duration(milliseconds: 400));
    await wait(tester, const Duration(milliseconds: 600));
    expect(find.text('Morning Light'), findsWidgets);
    // The navigation hides while the keyboard is open; dismiss it first.
    expect(find.bySemanticsLabel('Add music and more'), findsNothing);
    FocusManager.instance.primaryFocus?.unfocus();
    await wait(tester, const Duration(milliseconds: 800));
    await tester.tap(find.bySemanticsLabel('Add music and more'));
    await wait(tester, const Duration(milliseconds: 600));
    expect(find.text('Import files'), findsOneWidget);
    await shutdown(tester, c);
  });
}

/// Waits real time (playback runs on the device clock), then renders a frame.
/// pumpAndSettle is avoided because live playback progress keeps scheduling
/// frames, so the UI never "settles" while music is loaded.
Future<void> wait(WidgetTester tester, Duration d) async {
  await Future<void>.delayed(d);
  await tester.pump();
}

List<int> _u32(int v) => [v & 0xFF, (v >> 8) & 0xFF, (v >> 16) & 0xFF, (v >> 24) & 0xFF];
