import 'package:drift/drift.dart';

enum TrackSourceType { localFile, download }

enum Availability { available, missing, unreadable }

/// Metadata fields that a user can override locally.
abstract final class TrackField {
  static const title = 'title';
  static const artist = 'artist';
  static const album = 'album';
  static const albumArtist = 'albumArtist';
  static const genre = 'genre';
  static const releaseYear = 'releaseYear';
  static const composer = 'composer';
  static const language = 'language';
  static const artwork = 'artwork';
  static const compilation = 'compilation';
}

/// Effective (displayed) track metadata. Embedded file tags are kept
/// separately in [EmbeddedTags] so local edits never overwrite the file and
/// can be reverted.
@DataClassName('Track')
@TableIndex(name: 'idx_tracks_title', columns: {#titleKey})
@TableIndex(name: 'idx_tracks_artist', columns: {#artistKey})
@TableIndex(name: 'idx_tracks_album', columns: {#albumKey})
@TableIndex(name: 'idx_tracks_genre', columns: {#genre})
@TableIndex(name: 'idx_tracks_language', columns: {#language})
@TableIndex(name: 'idx_tracks_date_added', columns: {#dateAdded})
@TableIndex(name: 'idx_tracks_play_count', columns: {#playCount})
@TableIndex(name: 'idx_tracks_hash', columns: {#fileHash})
class Tracks extends Table {
  TextColumn get id => text()();
  TextColumn get sourceUri => text()();
  IntColumn get sourceType => intEnum<TrackSourceType>()();
  TextColumn get originalFileName => text().nullable()();
  TextColumn get title => text()();
  TextColumn get artist => text().nullable()();
  TextColumn get album => text().nullable()();
  TextColumn get albumArtist => text().nullable()();
  TextColumn get genre => text().nullable()();
  TextColumn get language => text().nullable()();
  TextColumn get composer => text().nullable()();
  IntColumn get releaseYear => integer().nullable()();
  IntColumn get durationMs => integer().nullable()();
  IntColumn get trackNumber => integer().nullable()();
  IntColumn get discNumber => integer().nullable()();
  TextColumn get artworkKey => text().nullable()();
  IntColumn get fileSizeBytes => integer().nullable()();
  TextColumn get fileHash => text()();
  DateTimeColumn get dateAdded => dateTime()();
  DateTimeColumn get lastModified => dateTime().nullable()();
  DateTimeColumn get lastPlayedAt => dateTime().nullable()();
  IntColumn get playCount => integer().withDefault(const Constant(0))();
  IntColumn get skipCount => integer().withDefault(const Constant(0))();
  IntColumn get rating => integer().nullable()();
  TextColumn get metadataSource => text().withDefault(const Constant('embedded'))();
  IntColumn get availability => intEnum<Availability>().withDefault(const Constant(0))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get isCompilation => boolean().withDefault(const Constant(false))();
  IntColumn get lastPositionMs => integer().nullable()();

  /// Comma separated [TrackField] names edited by the user.
  TextColumn get overriddenFields => text().withDefault(const Constant(''))();

  TextColumn get titleKey => text()();
  TextColumn get artistKey => text()();
  TextColumn get albumKey => text()();
  TextColumn get searchText => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Values read from the file itself, used for revert and rescans.
class EmbeddedTags extends Table {
  TextColumn get trackId => text().references(Tracks, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text().nullable()();
  TextColumn get artist => text().nullable()();
  TextColumn get album => text().nullable()();
  TextColumn get albumArtist => text().nullable()();
  TextColumn get genre => text().nullable()();
  TextColumn get language => text().nullable()();
  IntColumn get releaseYear => integer().nullable()();
  TextColumn get artworkKey => text().nullable()();

  @override
  Set<Column> get primaryKey => {trackId};
}

/// Individual artist credits, so multi-artist tracks appear under each artist.
@TableIndex(name: 'idx_track_artists_key', columns: {#artistKey})
class TrackArtists extends Table {
  TextColumn get trackId => text().references(Tracks, #id, onDelete: KeyAction.cascade)();
  TextColumn get artistKey => text()();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {trackId, artistKey};
}

class FavoriteAlbums extends Table {
  TextColumn get albumKey => text()();
  TextColumn get artistKey => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {albumKey, artistKey};
}

class Playlists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get description => text().nullable()();
  TextColumn get artworkKey => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
}

/// Ordered playlist entries. Duplicate tracks are allowed on purpose.
@DataClassName('PlaylistEntry')
@TableIndex(name: 'idx_playlist_tracks_order', columns: {#playlistId, #position})
class PlaylistTracks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get playlistId => integer().references(Playlists, #id, onDelete: KeyAction.cascade)();
  TextColumn get trackId => text().references(Tracks, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  DateTimeColumn get addedAt => dateTime()();
}

@DataClassName('PlaybackRecord')
@TableIndex(name: 'idx_history_started', columns: {#startedAt})
@TableIndex(name: 'idx_history_track', columns: {#trackId})
class PlaybackHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get trackId => text().references(Tracks, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get listenedMs => integer().withDefault(const Constant(0))();

  /// Listening passed [ListeningRules.meaningfulPlayMs]; counts as a play.
  BoolColumn get counted => boolean().withDefault(const Constant(false))();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  BoolColumn get skipped => boolean().withDefault(const Constant(false))();
  TextColumn get context => text().nullable()();
}

@DataClassName('ListeningSession')
class ListeningSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();
  IntColumn get totalListeningMs => integer().withDefault(const Constant(0))();
}

enum TagKind { user, mood }

class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 60)();
  IntColumn get kind => intEnum<TagKind>()();
  IntColumn get color => integer().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {name, kind},
  ];
}

/// Track/tag membership. [excluded] records that a user removed a track
/// from an automatically suggested mood collection.
class TrackTags extends Table {
  TextColumn get trackId => text().references(Tracks, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId => integer().references(Tags, #id, onDelete: KeyAction.cascade)();
  BoolColumn get excluded => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {trackId, tagId};
}

@DataClassName('SearchEntry')
class SearchHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get query => text().unique()();
  DateTimeColumn get searchedAt => dateTime()();
}

@DataClassName('ArtworkEntry')
class ArtworkCache extends Table {
  TextColumn get key => text()();
  TextColumn get path => text()();
  IntColumn get primaryColor => integer().nullable()();
  IntColumn get secondaryColor => integer().nullable()();
  IntColumn get width => integer().nullable()();
  IntColumn get height => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}

enum ImportJobType { file, url, rescan }

enum ImportJobStatus { running, succeeded, failed, cancelled, duplicate }

class ImportJobs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get source => text()();
  IntColumn get jobType => intEnum<ImportJobType>()();
  IntColumn get status => intEnum<ImportJobStatus>()();
  RealColumn get progress => real().withDefault(const Constant(0))();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get error => text().nullable()();
  TextColumn get trackId => text().nullable()();
}
