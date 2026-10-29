import 'package:audio_service/audio_service.dart';
import 'package:cadence/app/providers.dart';
import 'package:cadence/app/theme/app_theme.dart';
import 'package:cadence/audio/playback_controller.dart';
import 'package:cadence/data/database/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers.dart';

class MockPlayback extends Mock implements PlaybackController {}

/// Pumps [child] with an in-memory database, temp storage and mocked
/// playback so screens can be tested without platform audio plugins.
Future<({AppDatabase db, MockPlayback playback})> pumpScreen(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const [],
  ThemeData? theme,
  Future<void> Function(AppDatabase db)? seed,
  Size size = const Size(400, 860),
  MediaItem? item,
  PlaybackState? state,
}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final db = memoryDb();
  final playback = MockPlayback();
  when(() => playback.togglePlay()).thenAnswer((_) async {});
  when(() => playback.next()).thenAnswer((_) async {});
  when(() => playback.previous()).thenAnswer((_) async {});
  when(() => playback.cycleRepeat()).thenAnswer((_) async {});
  when(() => playback.toggleShuffle()).thenAnswer((_) async {});
  when(() => playback.move(any(), any())).thenAnswer((_) async {});
  when(() => playback.removeAt(any())).thenAnswer((_) async {});
  when(() => playback.jumpTo(any())).thenAnswer((_) async {});
  when(
    () => playback.playTracks(
      any(),
      startIndex: any(named: 'startIndex'),
      context: any(named: 'context'),
    ),
  ).thenAnswer((_) async {});
  if (seed != null) await tester.runAsync(() => seed(db));

  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        storagePathsProvider.overrideWithValue(tempPaths()),
        sharedPreferencesProvider.overrideWithValue(prefs),
        playbackControllerProvider.overrideWithValue(playback),
        currentMediaItemProvider.overrideWith((ref) => Stream.value(item)),
        playbackStateProvider.overrideWith((ref) => Stream.value(state ?? PlaybackState())),
        ...overrides,
      ],
      child: MaterialApp(theme: theme ?? AppTheme.dark(), home: child),
    ),
  );
  addTearDown(() => tester.runAsync(db.close));
  return (db: db, playback: playback);
}

/// Lets drift streams deliver their first values.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
    await tester.pump();
  }
}

MediaItem testItem({String title = 'Night Drive', String artist = 'The Hours'}) => MediaItem(
  id: 'entry-1',
  title: title,
  artist: artist,
  duration: const Duration(minutes: 3),
  extras: const {'trackId': 'track-1', 'path': '/tmp/x.mp3'},
);

List<Override> playerOverrides({bool playing = false, LoopMode loop = LoopMode.off}) => [
  currentTrackProvider.overrideWith((ref) => Stream.value(null)),
  isPlayingProvider.overrideWith((ref) => Stream.value(playing)),
  positionProvider.overrideWith((ref) => Stream.value(const Duration(seconds: 42))),
  durationProvider.overrideWith((ref) => Stream.value(const Duration(minutes: 3))),
  loopModeProvider.overrideWith((ref) => Stream.value(loop)),
];

/// testWidgets that unmounts the tree inside the test body, so timers that
/// drift schedules when its stream queries are cancelled get flushed before
/// the framework checks for pending timers.
@isTest
void screenTest(String description, Future<void> Function(WidgetTester tester) body) {
  testWidgets(description, (tester) async {
    await body(tester);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
  });
}
