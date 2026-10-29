// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracks_dao.dart';

// ignore_for_file: type=lint
mixin _$TracksDaoMixin on DatabaseAccessor<AppDatabase> {
  $TracksTable get tracks => attachedDatabase.tracks;
  $EmbeddedTagsTable get embeddedTags => attachedDatabase.embeddedTags;
  $TrackArtistsTable get trackArtists => attachedDatabase.trackArtists;
  $FavoriteAlbumsTable get favoriteAlbums => attachedDatabase.favoriteAlbums;
  TracksDaoManager get managers => TracksDaoManager(this);
}

class TracksDaoManager {
  final _$TracksDaoMixin _db;
  TracksDaoManager(this._db);
  $$TracksTableTableManager get tracks => $$TracksTableTableManager(_db.attachedDatabase, _db.tracks);
  $$EmbeddedTagsTableTableManager get embeddedTags =>
      $$EmbeddedTagsTableTableManager(_db.attachedDatabase, _db.embeddedTags);
  $$TrackArtistsTableTableManager get trackArtists =>
      $$TrackArtistsTableTableManager(_db.attachedDatabase, _db.trackArtists);
  $$FavoriteAlbumsTableTableManager get favoriteAlbums =>
      $$FavoriteAlbumsTableTableManager(_db.attachedDatabase, _db.favoriteAlbums);
}
