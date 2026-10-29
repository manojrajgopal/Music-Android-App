import 'package:drift/drift.dart';

import '../../../core/utils/text_normalize.dart';
import '../app_database.dart';

part 'tracks_dao.g.dart';

enum TrackSort {
  title('Title'),
  artist('Artist'),
  album('Album'),
  dateAdded('Date added'),
  duration('Duration'),
  playCount('Play count');

  const TrackSort(this.label);
  final String label;
}

/// A named group of tracks (artist, album, genre, composer, language, year).
class TrackGroup {
  const TrackGroup({
    required this.key,
    required this.name,
    required this.trackCount,
    this.subtitle,
    this.artworkKey,
    this.plays = 0,
  });

  final String key;
  final String name;
  final String? subtitle;
  final int trackCount;
  final String? artworkKey;
  final int plays;
}

/// Filters shared by Search and the New page.
class TrackFilter {
  const TrackFilter({this.language, this.year, this.artistKey, this.genre, this.maxDurationMs, this.minDurationMs});

  final String? language;
  final int? year;
  final String? artistKey;
  final String? genre;
  final int? minDurationMs;
  final int? maxDurationMs;

  bool get isEmpty =>
      language == null &&
      year == null &&
      artistKey == null &&
      genre == null &&
      minDurationMs == null &&
      maxDurationMs == null;

  TrackFilter copyWith({
    Object? language = _keep,
    Object? year = _keep,
    Object? artistKey = _keep,
    Object? genre = _keep,
    Object? minDurationMs = _keep,
    Object? maxDurationMs = _keep,
  }) => TrackFilter(
    language: language == _keep ? this.language : language as String?,
    year: year == _keep ? this.year : year as int?,
    artistKey: artistKey == _keep ? this.artistKey : artistKey as String?,
    genre: genre == _keep ? this.genre : genre as String?,
    minDurationMs: minDurationMs == _keep ? this.minDurationMs : minDurationMs as int?,
    maxDurationMs: maxDurationMs == _keep ? this.maxDurationMs : maxDurationMs as int?,
  );

  bool matches(Track t) =>
      (language == null || t.language == language) &&
      (year == null || t.releaseYear == year) &&
      (artistKey == null || t.artistKey == artistKey) &&
      (genre == null || t.genre == genre) &&
      (minDurationMs == null || (t.durationMs ?? 0) >= minDurationMs!) &&
      (maxDurationMs == null || (t.durationMs ?? 0) <= maxDurationMs!);
}

const _keep = Object();

@DriftAccessor(tables: [Tracks, EmbeddedTags, TrackArtists, FavoriteAlbums])
class TracksDao extends DatabaseAccessor<AppDatabase> with _$TracksDaoMixin {
  TracksDao(super.attachedDatabase);

  List<OrderingTerm> _ordering(TrackSort sort, bool descending) {
    final mode = descending ? OrderingMode.desc : OrderingMode.asc;
    // Every ordering ends with the id so equal keys sort stably.
    final primary = switch (sort) {
      TrackSort.title => OrderingTerm(expression: tracks.titleKey, mode: mode),
      TrackSort.artist => OrderingTerm(expression: tracks.artistKey, mode: mode),
      TrackSort.album => OrderingTerm(expression: tracks.albumKey, mode: mode),
      TrackSort.dateAdded => OrderingTerm(expression: tracks.dateAdded, mode: mode),
      TrackSort.duration => OrderingTerm(expression: tracks.durationMs, mode: mode),
      TrackSort.playCount => OrderingTerm(expression: tracks.playCount, mode: mode),
    };
    return [primary, if (sort != TrackSort.title) OrderingTerm.asc(tracks.titleKey), OrderingTerm.asc(tracks.id)];
  }

  Stream<List<Track>> watchSongs({required TrackSort sort, bool descending = false, int? limit}) {
    final q = select(tracks)
      ..orderBy(
        _ordering(sort, descending)
            .map(
              (o) =>
                  (_) => o,
            )
            .toList(),
      );
    if (limit != null) q.limit(limit);
    return q.watch();
  }

  Stream<int> watchCount() {
    final count = tracks.id.count();
    return (selectOnly(tracks)..addColumns([count])).map((r) => r.read(count) ?? 0).watchSingle();
  }

  Future<List<Track>> allTracks() => select(tracks).get();

  Stream<List<Track>> watchAllTracks() => select(tracks).watch();

  Stream<List<Track>> watchRecentlyAdded({int limit = 50, DateTime? since}) {
    final q = select(tracks)
      ..orderBy([(t) => OrderingTerm.desc(t.dateAdded), (t) => OrderingTerm.asc(t.id)])
      ..limit(limit);
    if (since != null) q.where((t) => t.dateAdded.isBiggerOrEqualValue(since));
    return q.watch();
  }

  Future<Track?> byId(String id) => (select(tracks)..where((t) => t.id.equals(id))).getSingleOrNull();

  Stream<Track?> watchById(String id) => (select(tracks)..where((t) => t.id.equals(id))).watchSingleOrNull();

  /// Loads tracks and returns them in the order of [ids], skipping missing ones.
  Future<List<Track>> byIds(List<String> ids) async {
    if (ids.isEmpty) return const [];
    final rows = await (select(tracks)..where((t) => t.id.isIn(ids.toSet()))).get();
    final map = {for (final r in rows) r.id: r};
    return [for (final id in ids) ?map[id]];
  }

  Stream<List<Track>> watchByIds(List<String> ids) {
    if (ids.isEmpty) return Stream.value(const []);
    return (select(tracks)..where((t) => t.id.isIn(ids.toSet()))).watch().map((rows) {
      final map = {for (final r in rows) r.id: r};
      return [for (final id in ids) ?map[id]];
    });
  }

  Future<List<Track>> byHash(String hash) => (select(tracks)..where((t) => t.fileHash.equals(hash))).get();

  Future<List<Track>> byTitleArtist(String titleKey, String artistKey) =>
      (select(tracks)..where((t) => t.titleKey.equals(titleKey) & t.artistKey.equals(artistKey))).get();

  Future<Track?> bySourceUri(String uri) => (select(tracks)..where((t) => t.sourceUri.equals(uri))).getSingleOrNull();

  Future<void> insertTrack(TracksCompanion track, EmbeddedTagsCompanion embedded) => transaction(() async {
    await into(tracks).insert(track);
    await into(embeddedTags).insert(embedded);
    await _replaceArtists(track.id.value, track.artist.value);
  });

  Future<void> _replaceArtists(String trackId, String? credit) async {
    await (delete(trackArtists)..where((a) => a.trackId.equals(trackId))).go();
    for (final name in splitArtists(credit)) {
      await into(trackArtists).insert(
        TrackArtistsCompanion.insert(trackId: trackId, artistKey: normalizeKey(name), name: name),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  /// Writes updated metadata and refreshes derived keys and artist credits.
  Future<void> updateTrack(Track updated) => transaction(() async {
    final refreshed = updated.copyWith(
      titleKey: normalizeKey(updated.title),
      artistKey: normalizeKey(updated.artist),
      albumKey: normalizeKey(updated.album),
      searchText: buildSearchText([
        updated.title,
        updated.artist,
        updated.album,
        updated.albumArtist,
        updated.genre,
        updated.composer,
        updated.language,
      ]),
    );
    await update(tracks).replace(refreshed);
    await _replaceArtists(updated.id, updated.artist);
  });

  Future<EmbeddedTag?> embeddedFor(String trackId) =>
      (select(embeddedTags)..where((e) => e.trackId.equals(trackId))).getSingleOrNull();

  Future<void> upsertEmbedded(EmbeddedTagsCompanion row) => into(embeddedTags).insertOnConflictUpdate(row);

  Future<void> setFavorite(String id, bool value) =>
      (update(tracks)..where((t) => t.id.equals(id))).write(TracksCompanion(isFavorite: Value(value)));

  Future<void> setRating(String id, int? rating) =>
      (update(tracks)..where((t) => t.id.equals(id))).write(TracksCompanion(rating: Value(rating)));

  Future<void> setAvailability(String id, Availability value) =>
      (update(tracks)..where((t) => t.id.equals(id))).write(TracksCompanion(availability: Value(value)));

  Future<void> setLastPosition(String id, int? positionMs) =>
      (update(tracks)..where((t) => t.id.equals(id))).write(TracksCompanion(lastPositionMs: Value(positionMs)));

  Future<void> recordCountedPlay(String id, DateTime at) => customUpdate(
    'UPDATE tracks SET play_count = play_count + 1, last_played_at = ? WHERE id = ?',
    variables: [Variable(at), Variable(id)],
    updates: {tracks},
  );

  Future<void> recordSkip(String id) => customUpdate(
    'UPDATE tracks SET skip_count = skip_count + 1 WHERE id = ?',
    variables: [Variable(id)],
    updates: {tracks},
  );

  Future<int> deleteTrack(String id) => (delete(tracks)..where((t) => t.id.equals(id))).go();

  Stream<List<Track>> watchFavorites() =>
      (select(tracks)
            ..where((t) => t.isFavorite.equals(true))
            ..orderBy([(t) => OrderingTerm.asc(t.titleKey)]))
          .watch();

  Stream<List<Track>> watchWhere(
    Expression<bool> Function($TracksTable t) filter, {
    TrackSort sort = TrackSort.title,
    bool descending = false,
  }) =>
      (select(tracks)
            ..where(filter)
            ..orderBy(
              _ordering(sort, descending)
                  .map(
                    (o) =>
                        (_) => o,
                  )
                  .toList(),
            ))
          .watch();

  Stream<List<Track>> watchByArtist(String artistKey) {
    final query = select(tracks).join([innerJoin(trackArtists, trackArtists.trackId.equalsExp(tracks.id))])
      ..where(trackArtists.artistKey.equals(artistKey))
      ..orderBy([OrderingTerm.desc(tracks.playCount), OrderingTerm.asc(tracks.titleKey)]);
    return query.map((r) => r.readTable(tracks)).watch();
  }

  /// Albums group on the normalized album title.
  Stream<List<Track>> watchAlbum(String albumKey) =>
      (select(tracks)
            ..where((t) => t.albumKey.equals(albumKey))
            ..orderBy([
              (t) => OrderingTerm.asc(t.discNumber),
              (t) => OrderingTerm.asc(t.trackNumber),
              (t) => OrderingTerm.asc(t.titleKey),
            ]))
          .watch();

  // ---- Groupings --------------------------------------------------------

  Stream<List<TrackGroup>> watchArtists() =>
      customSelect(
        'SELECT a.artist_key AS k, MIN(a.name) AS n, COUNT(*) AS c, '
        'MAX(t.artwork_key) AS art, SUM(t.play_count) AS p '
        'FROM track_artists a JOIN tracks t ON t.id = a.track_id '
        'GROUP BY a.artist_key ORDER BY a.artist_key',
        readsFrom: {trackArtists, tracks},
      ).watch().map(
        (rows) => [
          for (final r in rows)
            TrackGroup(
              key: r.read<String>('k'),
              name: r.read<String>('n'),
              trackCount: r.read<int>('c'),
              artworkKey: r.readNullable<String>('art'),
              plays: r.readNullable<int>('p') ?? 0,
            ),
        ],
      );

  Stream<List<TrackGroup>> watchAlbums({bool compilationsOnly = false}) =>
      customSelect(
        'SELECT album_key AS k, MIN(album) AS n, '
        "MIN(coalesce(nullif(trim(album_artist), ''), artist)) AS sub, "
        'COUNT(*) AS c, MAX(artwork_key) AS art, SUM(play_count) AS p, '
        'MAX(is_compilation) AS comp, COUNT(DISTINCT artist_key) AS artists '
        "FROM tracks WHERE album_key <> '' GROUP BY album_key "
        '${compilationsOnly ? "HAVING comp = 1 OR (artists > 1 AND lower(coalesce(MIN(album_artist), '')) IN ('various artists', 'various', 'va')) " : ''}'
        'ORDER BY album_key',
        readsFrom: {tracks},
      ).watch().map(
        (rows) => [
          for (final r in rows)
            TrackGroup(
              key: r.read<String>('k'),
              name: r.read<String>('n'),
              subtitle: r.readNullable<String>('sub'),
              trackCount: r.read<int>('c'),
              artworkKey: r.readNullable<String>('art'),
              plays: r.readNullable<int>('p') ?? 0,
            ),
        ],
      );

  /// Groups by a plain text column (genre, composer, language).
  Stream<List<TrackGroup>> watchColumnGroups(String column) {
    assert(const {'genre', 'composer', 'language'}.contains(column));
    return customSelect(
      'SELECT $column AS n, COUNT(*) AS c, MAX(artwork_key) AS art, SUM(play_count) AS p '
      "FROM tracks WHERE coalesce(trim($column), '') <> '' "
      'GROUP BY $column ORDER BY lower($column)',
      readsFrom: {tracks},
    ).watch().map(
      (rows) => [
        for (final r in rows)
          TrackGroup(
            key: r.read<String>('n'),
            name: r.read<String>('n'),
            trackCount: r.read<int>('c'),
            artworkKey: r.readNullable<String>('art'),
            plays: r.readNullable<int>('p') ?? 0,
          ),
      ],
    );
  }

  Stream<List<TrackGroup>> watchYears() =>
      customSelect(
        'SELECT release_year AS y, COUNT(*) AS c, MAX(artwork_key) AS art, SUM(play_count) AS p '
        'FROM tracks WHERE release_year IS NOT NULL GROUP BY release_year ORDER BY release_year DESC',
        readsFrom: {tracks},
      ).watch().map(
        (rows) => [
          for (final r in rows)
            TrackGroup(
              key: '${r.read<int>('y')}',
              name: '${r.read<int>('y')}',
              trackCount: r.read<int>('c'),
              artworkKey: r.readNullable<String>('art'),
              plays: r.readNullable<int>('p') ?? 0,
            ),
        ],
      );

  // ---- Search -------------------------------------------------------------

  Future<List<Track>> searchTracks(
    String normalizedQuery, {
    TrackFilter filter = const TrackFilter(),
    int limit = 100,
  }) {
    final pattern = '%${_escapeLike(normalizedQuery)}%';
    final q = select(tracks)
      ..where((t) {
        Expression<bool> e = t.searchText.like(pattern, escapeChar: r'\');
        if (filter.language != null) e = e & t.language.equals(filter.language!);
        if (filter.year != null) e = e & t.releaseYear.equals(filter.year!);
        if (filter.artistKey != null) e = e & t.artistKey.equals(filter.artistKey!);
        if (filter.genre != null) e = e & t.genre.equals(filter.genre!);
        if (filter.minDurationMs != null) e = e & t.durationMs.isBiggerOrEqualValue(filter.minDurationMs!);
        if (filter.maxDurationMs != null) e = e & t.durationMs.isSmallerOrEqualValue(filter.maxDurationMs!);
        return e;
      })
      ..orderBy([
        // Titles that start with the query rank first.
        (t) => OrderingTerm.desc(t.titleKey.like('${_escapeLike(normalizedQuery)}%', escapeChar: r'\')),
        (t) => OrderingTerm.desc(t.playCount),
        (t) => OrderingTerm.asc(t.titleKey),
      ])
      ..limit(limit);
    return q.get();
  }

  Future<List<TrackGroup>> searchArtists(String normalizedQuery, {int limit = 20}) =>
      customSelect(
        'SELECT a.artist_key AS k, MIN(a.name) AS n, COUNT(*) AS c, MAX(t.artwork_key) AS art '
        "FROM track_artists a JOIN tracks t ON t.id = a.track_id WHERE a.artist_key LIKE ? ESCAPE '\\' "
        'GROUP BY a.artist_key ORDER BY COUNT(*) DESC LIMIT ?',
        variables: [Variable('%${_escapeLike(normalizedQuery)}%'), Variable(limit)],
        readsFrom: {trackArtists, tracks},
      ).get().then(
        (rows) => [
          for (final r in rows)
            TrackGroup(
              key: r.read<String>('k'),
              name: r.read<String>('n'),
              trackCount: r.read<int>('c'),
              artworkKey: r.readNullable<String>('art'),
            ),
        ],
      );

  Future<List<TrackGroup>> searchAlbums(String normalizedQuery, {int limit = 20}) =>
      customSelect(
        "SELECT album_key AS k, MIN(album) AS n, MIN(coalesce(nullif(trim(album_artist), ''), artist)) AS sub, "
        'COUNT(*) AS c, MAX(artwork_key) AS art FROM tracks '
        "WHERE album_key <> '' AND album_key LIKE ? ESCAPE '\\' GROUP BY album_key ORDER BY album_key LIMIT ?",
        variables: [Variable('%${_escapeLike(normalizedQuery)}%'), Variable(limit)],
        readsFrom: {tracks},
      ).get().then(
        (rows) => [
          for (final r in rows)
            TrackGroup(
              key: r.read<String>('k'),
              name: r.read<String>('n'),
              subtitle: r.readNullable<String>('sub'),
              trackCount: r.read<int>('c'),
              artworkKey: r.readNullable<String>('art'),
            ),
        ],
      );

  Future<List<TrackGroup>> searchGenres(String normalizedQuery, {int limit = 10}) async {
    final rows = await customSelect(
      'SELECT genre AS n, COUNT(*) AS c, MAX(artwork_key) AS art FROM tracks '
      "WHERE coalesce(genre, '') <> '' GROUP BY genre",
      readsFrom: {tracks},
    ).get();
    return [
      for (final r in rows)
        if (normalizeKey(r.read<String>('n')).contains(normalizedQuery))
          TrackGroup(
            key: r.read<String>('n'),
            name: r.read<String>('n'),
            trackCount: r.read<int>('c'),
            artworkKey: r.readNullable<String>('art'),
          ),
    ].take(limit).toList();
  }

  // ---- Favorite albums -------------------------------------------------------

  Stream<Set<String>> watchFavoriteAlbumKeys() =>
      select(favoriteAlbums).watch().map((rows) => {for (final r in rows) r.albumKey});

  Future<List<FavoriteAlbum>> favoriteAlbumRows() => select(favoriteAlbums).get();

  Future<void> setAlbumFavorite(String albumKey, String artistKey, bool value) async {
    if (value) {
      await into(favoriteAlbums).insertOnConflictUpdate(
        FavoriteAlbumsCompanion.insert(albumKey: albumKey, artistKey: artistKey, createdAt: DateTime.now()),
      );
    } else {
      await (delete(favoriteAlbums)..where((f) => f.albumKey.equals(albumKey))).go();
    }
  }
}

String _escapeLike(String input) => input.replaceAll(r'\', r'\\').replaceAll('%', r'\%').replaceAll('_', r'\_');
