import 'package:audio_service/audio_service.dart';
import 'package:cadence/app/theme/app_theme.dart';
import 'package:cadence/app/theme/artwork_color_controller.dart';
import 'package:cadence/audio/playback_controller.dart';
import 'package:cadence/core/widgets/now_playing_bars.dart';
import 'package:cadence/core/widgets/track_widgets.dart';
import 'package:cadence/data/database/app_database.dart';
import 'package:cadence/features/home/home_screen.dart';
import 'package:cadence/features/import_music/import_hub.dart';
import 'package:cadence/features/library/library_screen.dart';
import 'package:cadence/features/player/player_screen.dart';
import 'package:cadence/features/player/queue_screen.dart';
import 'package:cadence/features/search/search_screen.dart';
import 'package:cadence/features/shell/app_shell.dart';
import 'package:cadence/features/shell/mini_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers.dart';
import 'harness.dart';

double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  setUpAll(() => registerFallbackValue(<Track>[]));

  group('navigation', () {
    screenTest('has four icon-only tabs and a distinct center action', (tester) async {
      final tapped = <int>[];
      var center = 0;
      await pumpScreen(
        tester,
        Scaffold(
          bottomNavigationBar: FloatingNavBar(index: 0, onTab: tapped.add, onCenter: () => center++),
        ),
      );
      for (final label in ['Home', 'New', 'Library', 'Search']) {
        expect(find.bySemanticsLabel(label), findsOneWidget);
        expect(find.text(label), findsNothing, reason: 'no permanent text labels');
      }
      expect(find.bySemanticsLabel('Add music and more'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('New'));
      await tester.tap(find.bySemanticsLabel('Search'));
      await tester.tap(find.bySemanticsLabel('Add music and more'));
      expect(tapped, [1, 3], reason: 'center action is not a tab');
      expect(center, 1);
    });

    screenTest('center action sheet offers import, link, playlist, rescan and queue', (tester) async {
      await pumpScreen(
        tester,
        Builder(
          builder: (context) => Scaffold(
            body: TextButton(onPressed: () => showImportHub(context), child: const Text('open')),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      for (final t in ['Import files', 'From a link', 'New playlist', 'Rescan library', 'Open queue']) {
        expect(find.text(t), findsOneWidget);
      }
    });
  });

  group('mini-player', () {
    screenTest('is hidden without a current track', (tester) async {
      await pumpScreen(tester, const Scaffold(body: MiniPlayer()));
      await tester.pump();
      expect(find.byType(IconButton), findsNothing);
    });

    screenTest('shows the current track and controls the engine', (tester) async {
      final env = await pumpScreen(
        tester,
        const Scaffold(body: MiniPlayer()),
        overrides: playerOverrides(playing: true),
        item: testItem(),
      );
      await tester.pump();
      await tester.pump();
      expect(find.text('Night Drive'), findsOneWidget);
      expect(find.text('The Hours'), findsOneWidget);
      await tester.tap(find.byTooltip('Pause'));
      await tester.tap(find.byTooltip('Next track'));
      verify(() => env.playback.togglePlay()).called(1);
      verify(() => env.playback.next()).called(1);
    });
  });

  group('home', () {
    screenTest('shows an import empty state instead of placeholder music', (tester) async {
      await pumpScreen(tester, const HomeScreen());
      await settle(tester);
      expect(find.text('Your library is empty'), findsOneWidget);
      expect(find.text('Import music'), findsOneWidget);
      expect(find.text('Heavy Rotation'), findsNothing);
    });

    screenTest('renders sections from real data with honest hints', (tester) async {
      await pumpScreen(
        tester,
        const HomeScreen(),
        seed: (db) async {
          await insertTrack(db, makeTrack(title: 'Ocean', genre: 'Ambient', language: 'Kannada', year: 2026));
        },
      );
      await settle(tester);
      expect(find.text('Heavy Rotation'), findsOneWidget);
      expect(find.textContaining('Play some music'), findsOneWidget);
      expect(find.text('Find Your Mood'), findsOneWidget);
    });
  });

  group('library', () {
    screenTest('lists the nine categories in order, then Recently Added', (tester) async {
      await pumpScreen(
        tester,
        const LibraryScreen(),
        seed: (db) async {
          await insertTrack(db, makeTrack(title: 'Older', dateAdded: DateTime(2026, 1, 1)));
          await insertTrack(db, makeTrack(title: 'Newest', dateAdded: DateTime(2026, 9, 1)));
        },
      );
      await settle(tester);
      const labels = [
        'Playlists',
        'Artists',
        'Albums',
        'Songs',
        'Made for You',
        'TV',
        'Genres',
        'Compilations',
        'Composers',
      ];
      final ys = [for (final l in labels) tester.getTopLeft(find.text(l)).dy];
      expect(ys, [...ys]..sort(), reason: 'categories appear in the required order');
      await tester.scrollUntilVisible(find.text('Newest'), 200);
      expect(find.text('Recently Added'), findsOneWidget);
      expect(tester.getTopLeft(find.text('Newest')).dy, lessThan(tester.getTopLeft(find.text('Older')).dy));
    });

    screenTest('TV explains itself instead of showing fabricated content', (tester) async {
      await pumpScreen(tester, const LibraryCategoryScreen(category: LibraryCategory.tv));
      await settle(tester);
      expect(find.text('TV music'), findsOneWidget);
      expect(find.textContaining('tag "TV"'), findsOneWidget);
    });

    screenTest('unavailable files are labelled', (tester) async {
      final track = makeTrack(title: 'Gone').copyWith(availability: Availability.missing);
      await pumpScreen(
        tester,
        Scaffold(
          body: SongRow(track: track, onTap: () {}),
        ),
      );
      expect(find.textContaining('File unavailable'), findsOneWidget);
    });
  });

  group('search', () {
    screenTest('finds songs as you type, including Kannada', (tester) async {
      await pumpScreen(
        tester,
        const SearchScreen(),
        seed: (db) async {
          await insertTrack(db, makeTrack(title: 'ಬೊಂಬೆ ಹೇಳುತೈತೆ', artist: 'Rajkumar'));
          await insertTrack(db, makeTrack(title: 'Blue Sky', artist: 'Other'));
        },
      );
      await settle(tester);
      expect(find.text('Search your library'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'ಬೊಂಬೆ');
      await tester.pump(const Duration(milliseconds: 300));
      await settle(tester);
      expect(find.text('ಬೊಂಬೆ ಹೇಳುತೈತೆ'), findsOneWidget);
      expect(find.text('Blue Sky'), findsNothing);
      expect(find.text('Artist'), findsOneWidget, reason: 'filter chips appear with a query');
      expect(find.byTooltip('Voice search'), findsOneWidget);
    });
  });

  group('player', () {
    screenTest('controls drive the playback controller', (tester) async {
      final env = await pumpScreen(tester, const PlayerScreen(), overrides: playerOverrides(), item: testItem());
      await tester.pump();
      await tester.pump();
      expect(find.text('Night Drive'), findsOneWidget);
      expect(find.text('0:42'), findsOneWidget);
      await tester.tap(find.byTooltip('Play'));
      await tester.tap(find.byTooltip('Next'));
      await tester.tap(find.byTooltip('Previous'));
      await tester.tap(find.byTooltip('Repeat off'));
      await tester.tap(find.byTooltip('Shuffle off'));
      verify(() => env.playback.togglePlay()).called(1);
      verify(() => env.playback.next()).called(1);
      verify(() => env.playback.previous()).called(1);
      verify(() => env.playback.cycleRepeat()).called(1);
      verify(() => env.playback.toggleShuffle()).called(1);
      expect(find.text('Sleep'), findsOneWidget);
      expect(find.text('Queue'), findsOneWidget);
      expect(find.text('Speed'), findsOneWidget);
      expect(find.byIcon(Icons.star_outline_rounded), findsNothing);
      expect(find.byIcon(Icons.star_rounded), findsNothing);
    });

    screenTest('queue shows items, highlights current, and jumps on tap', (tester) async {
      final items = [
        for (var i = 0; i < 3; i++) MediaItem(id: 'e$i', title: 'Song $i', extras: {'trackId': 't$i', 'path': '/x'}),
      ];
      final env = await pumpScreen(
        tester,
        const QueueScreen(),
        overrides: [queueProvider.overrideWith((ref) => Stream.value(items))],
        state: PlaybackState(queueIndex: 1),
      );
      await tester.pump();
      expect(find.text('1 up next'), findsOneWidget);
      expect(find.byType(NowPlayingBars), findsOneWidget);
      await tester.tap(find.text('Song 2'));
      verify(() => env.playback.jumpTo(2)).called(1);
    });
  });

  group('themes and colors', () {
    test('dark and light themes keep body text readable', () {
      for (final theme in [AppTheme.dark(), AppTheme.light()]) {
        final c = theme.colorScheme;
        expect(_contrast(c.onSurface, c.surface), greaterThan(7), reason: theme.brightness.name);
        expect(_contrast(c.onSurfaceVariant, c.surface), greaterThan(4.5), reason: theme.brightness.name);
      }
    });

    test('artwork palettes stay readable for pale, dark and grey covers', () {
      for (final seed in [0xFFFFFFF0, 0xFF000000, 0xFF808080, 0xFFFFEB3B, 0xFF1A237E]) {
        for (final b in Brightness.values) {
          final p = ArtworkPalette.fromSeeds(seed, seed, b);
          expect(
            _contrast(p.onBackground, p.backgroundTop),
            greaterThan(4.5),
            reason: '${seed.toRadixString(16)} ${b.name}',
          );
          expect(
            _contrast(p.accent, p.backgroundBottom),
            greaterThan(3),
            reason: '${seed.toRadixString(16)} ${b.name}',
          );
        }
      }
    });

    screenTest('light theme renders the library', (tester) async {
      await pumpScreen(tester, const LibraryScreen(), theme: AppTheme.light());
      await settle(tester);
      expect(find.text('Library'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('responsive layout', () {
    screenTest('compact phone width has no overflow on Home', (tester) async {
      await pumpScreen(
        tester,
        const HomeScreen(),
        size: const Size(320, 640),
        seed: (db) async {
          for (var i = 0; i < 6; i++) {
            await insertTrack(
              db,
              makeTrack(title: 'A rather long song title number $i', playCount: i + 1, language: 'English'),
            );
          }
        },
      );
      await settle(tester);
      expect(tester.takeException(), isNull);
    });
  });
}
