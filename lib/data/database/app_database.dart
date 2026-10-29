import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/history_dao.dart';
import 'daos/misc_dao.dart';
import 'daos/playlists_dao.dart';
import 'daos/tags_dao.dart';
import 'daos/tracks_dao.dart';
import 'tables.dart';

export 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Tracks,
    EmbeddedTags,
    TrackArtists,
    FavoriteAlbums,
    Playlists,
    PlaylistTracks,
    PlaybackHistory,
    ListeningSessions,
    Tags,
    TrackTags,
    SearchHistory,
    ArtworkCache,
    ImportJobs,
  ],
  daos: [TracksDao, PlaylistsDao, HistoryDao, TagsDao, MiscDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  static QueryExecutor _openConnection() => driftDatabase(name: 'cadence');

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // Add one step per schema version. Never drop user tables here:
      // migrations must preserve playlists, history and metadata edits.
      await customStatement('PRAGMA foreign_keys = OFF');
      for (var version = from; version < to; version++) {
        switch (version) {
          // case 1: await m.addColumn(tracks, tracks.someNewColumn);
          default:
            break;
        }
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      if (details.wasCreated) {
        await _seedMoods();
      }
    },
  );

  Future<void> _seedMoods() async {
    await batch((b) {
      b.insertAll(tags, [
        for (final mood in Mood.values) TagsCompanion.insert(name: mood.label, kind: TagKind.mood),
      ], mode: InsertMode.insertOrIgnore);
    });
  }
}

/// Mood collections offered on Home and New. Membership comes from user tags
/// plus transparent genre rules; audio content is never analysed.
enum Mood {
  chill('Chill', ['chill', 'ambient', 'lofi', 'lo fi', 'acoustic', 'jazz', 'downtempo', 'chillout']),
  focus('Focus', ['classical', 'instrumental', 'ambient', 'piano', 'soundtrack', 'post rock']),
  workout('Workout', ['edm', 'dance', 'hip hop', 'rap', 'rock', 'metal', 'electronic', 'drum and bass']),
  party('Party', ['party', 'dance', 'pop', 'edm', 'house', 'disco', 'reggaeton']),
  sad('Sad', ['sad', 'blues', 'melancholy']),
  romantic('Romantic', ['romance', 'romantic', 'love', 'r b', 'rnb', 'soul', 'ghazal']),
  feelGood('Feel Good', ['feel good', 'funk', 'pop', 'reggae', 'happy']);

  const Mood(this.label, this.genreHints);

  final String label;
  final List<String> genreHints;
}
