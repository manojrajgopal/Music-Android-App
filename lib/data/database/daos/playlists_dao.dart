import 'package:drift/drift.dart';

import '../app_database.dart';

part 'playlists_dao.g.dart';

class PlaylistSummary {
  const PlaylistSummary({required this.playlist, required this.trackCount, this.coverKeys = const []});

  final Playlist playlist;
  final int trackCount;

  /// Up to four artwork keys for a mosaic cover.
  final List<String> coverKeys;
}

class PlaylistItem {
  const PlaylistItem({required this.entry, required this.track});

  final PlaylistEntry entry;
  final Track track;
}

@DriftAccessor(tables: [Playlists, PlaylistTracks, Tracks])
class PlaylistsDao extends DatabaseAccessor<AppDatabase> with _$PlaylistsDaoMixin {
  PlaylistsDao(super.attachedDatabase);

  Stream<List<PlaylistSummary>> watchSummaries() {
    final count = playlistTracks.id.count();
    final query =
        select(playlists).join([leftOuterJoin(playlistTracks, playlistTracks.playlistId.equalsExp(playlists.id))])
          ..addColumns([count])
          ..groupBy([playlists.id])
          ..orderBy([OrderingTerm.desc(playlists.updatedAt)]);
    return query.watch().asyncMap((rows) async {
      final covers = await _coverKeys();
      return [
        for (final r in rows)
          PlaylistSummary(
            playlist: r.readTable(playlists),
            trackCount: r.read(count) ?? 0,
            coverKeys: covers[r.readTable(playlists).id] ?? const [],
          ),
      ];
    });
  }

  Future<Map<int, List<String>>> _coverKeys() async {
    final rows = await customSelect(
      'SELECT pt.playlist_id AS p, t.artwork_key AS a FROM playlist_tracks pt '
      'JOIN tracks t ON t.id = pt.track_id WHERE t.artwork_key IS NOT NULL '
      'ORDER BY pt.playlist_id, pt.position',
      readsFrom: {playlistTracks, tracks},
    ).get();
    final result = <int, List<String>>{};
    for (final r in rows) {
      final list = result.putIfAbsent(r.read<int>('p'), () => []);
      final key = r.read<String>('a');
      if (list.length < 4 && !list.contains(key)) list.add(key);
    }
    return result;
  }

  Stream<Playlist?> watchPlaylist(int id) => (select(playlists)..where((p) => p.id.equals(id))).watchSingleOrNull();

  Future<Playlist?> playlistById(int id) => (select(playlists)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<List<Playlist>> allPlaylists() => (select(playlists)..orderBy([(p) => OrderingTerm.asc(p.name)])).get();

  Stream<List<PlaylistItem>> watchItems(int playlistId) {
    final query = select(playlistTracks).join([innerJoin(tracks, tracks.id.equalsExp(playlistTracks.trackId))])
      ..where(playlistTracks.playlistId.equals(playlistId))
      ..orderBy([OrderingTerm.asc(playlistTracks.position), OrderingTerm.asc(playlistTracks.id)]);
    return query.map((r) => PlaylistItem(entry: r.readTable(playlistTracks), track: r.readTable(tracks))).watch();
  }

  Future<List<PlaylistItem>> items(int playlistId) =>
      (select(playlistTracks).join([innerJoin(tracks, tracks.id.equalsExp(playlistTracks.trackId))])
            ..where(playlistTracks.playlistId.equals(playlistId))
            ..orderBy([OrderingTerm.asc(playlistTracks.position), OrderingTerm.asc(playlistTracks.id)]))
          .map((r) => PlaylistItem(entry: r.readTable(playlistTracks), track: r.readTable(tracks)))
          .get();

  Future<int> createPlaylist(String name, {String? description}) {
    final now = DateTime.now();
    return into(playlists)
        .insert(PlaylistsCompanion.insert(name: name, description: Value(description), createdAt: now, updatedAt: now));
  }

  Future<void> renamePlaylist(int id, String name, {String? description}) =>
      (update(playlists)..where((p) => p.id.equals(id))).write(
        PlaylistsCompanion(name: Value(name), description: Value(description), updatedAt: Value(DateTime.now())),
      );

  Future<void> _touch(int id) =>
      (update(playlists)..where((p) => p.id.equals(id))).write(PlaylistsCompanion(updatedAt: Value(DateTime.now())));

  /// Deletes only the playlist rows; tracks and files are untouched.
  Future<void> deletePlaylist(int id) => (delete(playlists)..where((p) => p.id.equals(id))).go();

  Future<int> duplicatePlaylist(int id, String newName) => transaction(() async {
    final source = await playlistById(id);
    final newId = await createPlaylist(newName, description: source?.description);
    final rows = await items(id);
    await batch((b) {
      b.insertAll(playlistTracks, [
        for (var i = 0; i < rows.length; i++)
          PlaylistTracksCompanion.insert(
            playlistId: newId,
            trackId: rows[i].track.id,
            position: i,
            addedAt: DateTime.now(),
          ),
      ]);
    });
    return newId;
  });

  Future<int> _nextPosition(int playlistId) async {
    final max = playlistTracks.position.max();
    final row =
        await (selectOnly(playlistTracks)
              ..addColumns([max])
              ..where(playlistTracks.playlistId.equals(playlistId)))
            .getSingle();
    final value = row.read(max);
    return value == null ? 0 : value + 1;
  }

  /// Appends tracks. Duplicates are intentional and therefore allowed.
  Future<void> addTracks(int playlistId, List<String> trackIds) => transaction(() async {
    var position = await _nextPosition(playlistId);
    final now = DateTime.now();
    for (final trackId in trackIds) {
      await into(playlistTracks).insert(
        PlaylistTracksCompanion.insert(playlistId: playlistId, trackId: trackId, position: position++, addedAt: now),
      );
    }
    await _touch(playlistId);
  });

  Future<void> removeEntry(int playlistId, int entryId) => transaction(() async {
    await (delete(playlistTracks)..where((e) => e.id.equals(entryId))).go();
    await _renumber(playlistId);
    await _touch(playlistId);
  });

  /// Moves an entry from [oldIndex] to [newIndex] (indices after removal,
  /// as produced by ReorderableListView once adjusted) in one transaction.
  Future<void> moveEntry(int playlistId, int oldIndex, int newIndex) => transaction(() async {
    final rows = await items(playlistId);
    if (oldIndex < 0 || oldIndex >= rows.length) return;
    final ids = rows.map((r) => r.entry.id).toList();
    final moved = ids.removeAt(oldIndex);
    ids.insert(newIndex.clamp(0, ids.length), moved);
    await _writeOrder(ids);
    await _touch(playlistId);
  });

  Future<void> _renumber(int playlistId) async {
    final rows = await items(playlistId);
    await _writeOrder(rows.map((r) => r.entry.id).toList());
  }

  Future<void> _writeOrder(List<int> entryIds) async {
    for (var i = 0; i < entryIds.length; i++) {
      await (update(
        playlistTracks,
      )..where((e) => e.id.equals(entryIds[i]))).write(PlaylistTracksCompanion(position: Value(i)));
    }
  }

  Future<List<PlaylistEntry>> allEntries() => select(playlistTracks).get();
}
