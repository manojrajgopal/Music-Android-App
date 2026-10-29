import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cadence/core/errors/app_exception.dart';
import 'package:cadence/data/database/app_database.dart';
import 'package:cadence/data/repositories/settings_repository.dart';
import 'package:cadence/data/services/artwork_service.dart';
import 'package:cadence/data/services/backup_service.dart';
import 'package:cadence/data/services/import_service.dart';
import 'package:cadence/data/services/metadata_service.dart';
import 'package:cadence/data/services/storage_paths.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late StoragePaths paths;
  late ImportService importer;
  late Directory source;

  setUp(() {
    db = memoryDb();
    paths = tempPaths();
    importer = ImportService(db, paths, ArtworkService(db, paths));
    source = Directory.systemTemp.createTempSync('cadence_src_');
  });
  tearDown(() => db.close());

  group('audio sniffing', () {
    test('recognises formats by content, not extension', () {
      expect(sniffAudioFormat(Uint8List.fromList('ID3\x04'.codeUnits)), AudioFormat.mp3);
      expect(sniffAudioFormat(Uint8List.fromList('fLaC'.codeUnits)), AudioFormat.flac);
      expect(
        sniffAudioFormat(Uint8List.fromList([...'RIFF'.codeUnits, 0, 0, 0, 0, ...'WAVE'.codeUnits])),
        AudioFormat.wav,
      );
      expect(sniffAudioFormat(Uint8List.fromList('<!DOCTYPE html>'.codeUnits)), isNull);
    });
  });

  group('import', () {
    test('imports a file, records metadata, and rejects exact duplicates', () async {
      final wav = writeWav(source, 'My Song.wav');
      final first = await importer.importFile(wav, displayName: 'My Song.wav');
      expect(first.outcome, ImportOutcome.imported);
      expect(first.track!.title, 'My Song', reason: 'title falls back to the file name');
      expect(first.track!.fileHash, hasLength(64));
      expect(File(paths.resolveSource(first.track!.sourceUri)).existsSync(), isTrue);
      expect(wav.existsSync(), isTrue, reason: 'the original is never moved or deleted');

      final again = await importer.importFile(wav, displayName: 'My Song.wav');
      expect(again.outcome, ImportOutcome.duplicate);
      expect(await db.tracksDao.allTracks(), hasLength(1));
    });

    test('rejects non-audio content with a clear reason', () async {
      final fake = File('${source.path}/song.mp3')..writeAsStringSync('<html>not audio</html>');
      final result = await importer.importFile(fake, displayName: 'song.mp3');
      expect(result.outcome, ImportOutcome.failed);
      expect(result.message, contains('not a supported audio file'));
      expect(paths.musicDir.listSync(), isEmpty, reason: 'no partial copy is left behind');
    });

    test('rejects unsupported extensions', () async {
      final f = File('${source.path}/clip.mid')..writeAsBytesSync([1, 2, 3]);
      expect((await importer.importFile(f, displayName: 'clip.mid')).outcome, ImportOutcome.failed);
    });

    test('rescan keeps ids, marks missing files and never duplicates', () async {
      final a = (await importer.importFile(writeWav(source, 'a.wav'), displayName: 'a.wav')).track!;
      final b = (await importer.importFile(writeWav(source, 'b.wav', seed: 1), displayName: 'b.wav')).track!;
      File(paths.resolveSource(b.sourceUri)).deleteSync();

      final report = await importer.rescan();
      expect(report.checked, 2);
      expect(report.missing, 1);
      expect(report.added, 0);
      final tracks = await db.tracksDao.allTracks();
      expect(tracks.map((t) => t.id).toSet(), {a.id, b.id});
      expect(tracks.firstWhere((t) => t.id == b.id).availability, Availability.missing);

      // Relinking restores the same track id.
      final relinked = await importer.relink(
        tracks.firstWhere((t) => t.id == b.id),
        writeWav(source, 'b2.wav', seed: 1),
        displayName: 'b2.wav',
      );
      expect(relinked.id, b.id);
      expect(relinked.availability, Availability.available);
    });

    test('rescan indexes orphan files in the music folder once', () async {
      writeWav(paths.musicDir, 'orphan.wav', seed: 7);
      expect((await importer.rescan()).added, 1);
      expect((await importer.rescan()).added, 0);
      expect(await db.tracksDao.allTracks(), hasLength(1));
    });
  });

  group('backup', () {
    late SettingsRepository settings;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      settings = SettingsRepository(await SharedPreferences.getInstance());
    });

    test('round-trips playlists, favorites, ratings and history into another library', () async {
      final a = await insertTrack(db, makeTrack(title: 'A', hash: 'h-a', rating: 5, favorite: true));
      final b = await insertTrack(db, makeTrack(title: 'B', hash: 'h-b'));
      final p = await db.playlistsDao.createPlaylist('Road trip');
      await db.playlistsDao.addTracks(p, [b.id, a.id, b.id]);
      final h = await db.historyDao.startRecord(a.id, DateTime.utc(2026, 5, 1));
      await db.historyDao.updateRecord(h, listenedMs: 90000, endedAt: DateTime.utc(2026, 5, 1), counted: true);

      final bytes = await BackupService(db, settings).create();

      // A second device with the same files (matched by hash) but new ids.
      final other = memoryDb();
      addTearDown(other.close);
      await insertTrack(other, makeTrack(id: 'x', title: 'A', hash: 'h-a'));
      await insertTrack(other, makeTrack(id: 'y', title: 'B', hash: 'h-b'));
      final existing = await other.playlistsDao.createPlaylist('Road trip');

      final service = BackupService(other, settings);
      final parsed = service.parse(bytes);
      final preview = await service.preview(parsed);
      expect(preview.matchedTracks, 2);
      expect(preview.playlistEntries, 3);
      expect(preview.historyRecords, 1);

      final report = await service.restore(parsed, conflict: RestoreConflict.keepLocal);
      expect(report.playlistsCreated, 1);
      final playlists = await other.playlistsDao.allPlaylists();
      expect(playlists.map((p) => p.name), containsAll(['Road trip', 'Road trip (restored)']));
      expect(await other.playlistsDao.items(existing), isEmpty, reason: 'existing data is untouched');
      final restored = playlists.firstWhere((p) => p.name.endsWith('(restored)'));
      expect([for (final i in await other.playlistsDao.items(restored.id)) i.track.title], ['B', 'A', 'B']);
      final x = (await other.tracksDao.byId('x'))!;
      expect(x.isFavorite, isTrue);
      expect(x.rating, 5);

      // Restoring the same backup again never duplicates history.
      await service.restore(parsed, conflict: RestoreConflict.keepLocal);
      expect(await other.historyDao.allRecords(), hasLength(1));
    });

    test('conflict policy decides between local and backup ratings', () async {
      await insertTrack(db, makeTrack(id: 'a', hash: 'h', rating: 2));
      final bytes = await BackupService(db, settings).create();
      await db.tracksDao.setRating('a', 4);
      final service = BackupService(db, settings);
      await service.restore(service.parse(bytes), conflict: RestoreConflict.keepLocal);
      expect((await db.tracksDao.byId('a'))!.rating, 4);
      await service.restore(service.parse(bytes), conflict: RestoreConflict.preferBackup);
      expect((await db.tracksDao.byId('a'))!.rating, 2);
    });

    test('rejects invalid, foreign and newer backups', () {
      final service = BackupService(db, settings);
      expect(() => service.parse(Uint8List.fromList([1, 2, 3])), throwsA(isA<AppException>()));

      Uint8List zip(Map<String, String> files) {
        final archive = Archive();
        files.forEach((k, v) => archive.addFile(ArchiveFile.string(k, v)));
        return ZipEncoder().encodeBytes(archive);
      }

      expect(
        () => service.parse(zip({'manifest.json': '{"format":"other","version":1}', 'data.json': '{}'})),
        throwsA(isA<AppException>()),
      );
      expect(
        () => service.parse(zip({'manifest.json': '{"format":"cadence-backup","version":99}', 'data.json': '{}'})),
        throwsA(isA<AppException>().having((e) => e.code, 'code', 'newer')),
      );
      expect(
        () => service.parse(zip({'manifest.json': '{"format":"cadence-backup","version":1}'})),
        throwsA(isA<AppException>()),
      );
      expect(
        () => service.parse(
          zip({'manifest.json': '{"format":"cadence-backup","version":1}', 'data.json': '{"tracks": 5}'}),
        ),
        throwsA(isA<AppException>()),
      );
    });

    test('archive entry paths are never extracted to disk', () {
      final archive = Archive()
        ..addFile(ArchiveFile.string('../../evil.txt', 'x'))
        ..addFile(ArchiveFile.string('manifest.json', '{"format":"cadence-backup","version":1}'))
        ..addFile(ArchiveFile.string('data.json', '{"tracks":[]}'));
      final parsed = BackupService(db, settings).parse(ZipEncoder().encodeBytes(archive));
      expect(parsed.tracks, isEmpty);
      expect(File('${Directory.current.parent.path}/evil.txt').existsSync(), isFalse);
    });
  });
}
