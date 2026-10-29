import 'package:cadence/core/utils/text_normalize.dart';
import 'package:cadence/data/database/app_database.dart';
import 'package:cadence/data/database/daos/tracks_dao.dart';
import 'package:cadence/data/repositories/library_repository.dart';
import 'package:cadence/data/services/artwork_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = memoryDb());
  tearDown(() => db.close());

  group('schema', () {
    test('creates all tables and seeds mood tags', () async {
      final moods = await db.tagsDao.allTags();
      expect(moods.map((t) => t.name), containsAll(Mood.values.map((m) => m.label)));
      expect(await db.tracksDao.allTracks(), isEmpty);
    });
  });

  group('playlists', () {
    late List<Track> tracks;
    late int playlist;

    setUp(() async {
      tracks = [
        for (final n in ['A', 'B', 'C']) await insertTrack(db, makeTrack(title: n)),
      ];
      playlist = await db.playlistsDao.createPlaylist('Mix');
    });

    Future<List<String>> order() async => [for (final i in await db.playlistsDao.items(playlist)) i.track.title];

    test('allows intentional duplicates and keeps insertion order', () async {
      await db.playlistsDao.addTracks(playlist, [tracks[0].id, tracks[1].id, tracks[0].id]);
      expect(await order(), ['A', 'B', 'A']);
    });

    test('reorders transactionally and renumbers on removal', () async {
      await db.playlistsDao.addTracks(playlist, [for (final t in tracks) t.id]);
      await db.playlistsDao.moveEntry(playlist, 0, 2);
      expect(await order(), ['B', 'C', 'A']);
      final items = await db.playlistsDao.items(playlist);
      await db.playlistsDao.removeEntry(playlist, items[1].entry.id);
      expect(await order(), ['B', 'A']);
      expect((await db.playlistsDao.items(playlist)).map((i) => i.entry.position), [0, 1]);
    });

    test('duplicating copies entries; deleting never removes tracks', () async {
      await db.playlistsDao.addTracks(playlist, [tracks[2].id, tracks[0].id]);
      final copy = await db.playlistsDao.duplicatePlaylist(playlist, 'Mix copy');
      expect([for (final i in await db.playlistsDao.items(copy)) i.track.title], ['C', 'A']);
      await db.playlistsDao.deletePlaylist(playlist);
      expect(await db.playlistsDao.items(playlist), isEmpty);
      expect((await db.tracksDao.allTracks()).length, 3);
      expect((await db.playlistsDao.items(copy)).length, 2);
    });
  });

  group('tracks', () {
    test('favorites and ratings persist', () async {
      final t = await insertTrack(db, makeTrack());
      await db.tracksDao.setFavorite(t.id, true);
      await db.tracksDao.setRating(t.id, 4);
      final loaded = (await db.tracksDao.byId(t.id))!;
      expect(loaded.isFavorite, isTrue);
      expect(loaded.rating, 4);
      expect(await db.tracksDao.watchFavorites().first, hasLength(1));
    });

    test('sorting is stable and supports every sort key', () async {
      await insertTrack(
        db,
        makeTrack(id: 'b', title: 'Same', durationMs: 3, playCount: 1, dateAdded: DateTime(2026, 2)),
      );
      await insertTrack(
        db,
        makeTrack(id: 'a', title: 'Same', durationMs: 3, playCount: 1, dateAdded: DateTime(2026, 2)),
      );
      await insertTrack(
        db,
        makeTrack(id: 'c', title: 'Alpha', durationMs: 1, playCount: 9, dateAdded: DateTime(2026, 3)),
      );
      for (final sort in TrackSort.values) {
        final first = await db.tracksDao.watchSongs(sort: sort).first;
        final second = await db.tracksDao.watchSongs(sort: sort).first;
        expect(first.map((t) => t.id), second.map((t) => t.id), reason: sort.name);
      }
      final byTitle = await db.tracksDao.watchSongs(sort: TrackSort.title).first;
      expect(byTitle.map((t) => t.id), ['c', 'a', 'b']);
      final byPlays = await db.tracksDao.watchSongs(sort: TrackSort.playCount, descending: true).first;
      expect(byPlays.first.id, 'c');
    });

    test('search matches partial Latin and Kannada text and applies filters', () async {
      await insertTrack(db, makeTrack(title: 'ಬೊಂಬೆ ಹೇಳುತೈತೆ', artist: 'ಪುನೀತ್', language: 'Kannada'));
      await insertTrack(
        db,
        makeTrack(title: 'Shape of You', artist: 'Ed Sheeran', language: 'English', durationMs: 230000),
      );
      expect((await db.tracksDao.searchTracks(normalizeKey('ಬೊಂಬೆ'))).single.language, 'Kannada');
      expect((await db.tracksDao.searchTracks(normalizeKey('  SHAPE   of '))).single.title, 'Shape of You');
      expect(await db.tracksDao.searchTracks('shape', filter: const TrackFilter(language: 'Kannada')), isEmpty);
      expect(await db.tracksDao.searchTracks('shape', filter: const TrackFilter(maxDurationMs: 100000)), isEmpty);
      expect((await db.tracksDao.searchArtists('sheeran')).single.name, 'Ed Sheeran');
      expect(await db.tracksDao.searchTracks('100%'), isEmpty, reason: 'LIKE wildcards are escaped');
    });

    test('multi-artist credits appear under each artist', () async {
      await insertTrack(db, makeTrack(title: 'Duet', artist: 'Asha feat. Kishore'));
      final artists = await db.tracksDao.watchArtists().first;
      expect(artists.map((a) => a.name), containsAll(['Asha', 'Kishore']));
      expect(await db.tracksDao.watchByArtist('kishore').first, hasLength(1));
    });

    test('language and year groups come only from metadata', () async {
      await insertTrack(db, makeTrack(language: 'Kannada', year: 2026));
      await insertTrack(db, makeTrack(language: null, year: null));
      expect((await db.tracksDao.watchColumnGroups('language').first).map((g) => g.name), ['Kannada']);
      expect((await db.tracksDao.watchYears().first).map((g) => g.name), ['2026']);
    });

    test('clearing history resets counts but keeps tracks', () async {
      final t = await insertTrack(db, makeTrack(playCount: 3));
      final id = await db.historyDao.startRecord(t.id, DateTime(2026, 1, 1));
      await db.historyDao.updateRecord(id, listenedMs: 50000, endedAt: DateTime(2026, 1, 1), counted: true);
      await db.historyDao.clearAll();
      expect(await db.historyDao.allRecords(), isEmpty);
      expect((await db.tracksDao.byId(t.id))!.playCount, 0);
    });
  });

  group('metadata edits', () {
    test('edits are local overrides that can be reverted', () async {
      final paths = tempPaths();
      final repo = LibraryRepository(db, paths, ArtworkService(db, paths));
      final t = await insertTrack(db, makeTrack(title: 'Original', artist: 'Tag Artist'));
      final edited = await repo.saveEdits(
        t,
        const TrackEdit(
          title: 'Original',
          artist: 'Fixed Artist',
          language: 'Kannada',
          releaseYear: 2025,
          genre: 'Folk',
        ),
      );
      expect(edited.artist, 'Fixed Artist');
      expect(edited.artistKey, 'fixed artist');
      expect(edited.overriddenFields.split(','), containsAll(['artist', 'language', 'releaseYear', 'genre']));
      expect(edited.overriddenFields.split(','), isNot(contains('title')));
      expect((await db.tracksDao.searchTracks('fixed')).single.id, t.id);

      await repo.revertToEmbedded(edited);
      final reverted = (await db.tracksDao.byId(t.id))!;
      expect(reverted.artist, 'Tag Artist');
      expect(reverted.language, isNull);
      expect(reverted.overriddenFields, isEmpty);
    });

    test('mood exclusions override genre suggestions', () async {
      final paths = tempPaths();
      final repo = LibraryRepository(db, paths, ArtworkService(db, paths));
      final t = await insertTrack(db, makeTrack(genre: 'Ambient'));
      await repo.setMood(t.id, Mood.chill, member: false);
      final memberships = await db.tagsDao.allMemberships();
      expect(memberships.single.excluded, isTrue);
      await repo.addUserTag(t.id, '  TV ');
      expect((await db.tagsDao.watchTagsForTrack(t.id).first).map((g) => g.name), contains('TV'));
    });
  });
}
