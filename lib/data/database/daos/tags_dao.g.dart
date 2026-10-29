// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tags_dao.dart';

// ignore_for_file: type=lint
mixin _$TagsDaoMixin on DatabaseAccessor<AppDatabase> {
  $TagsTable get tags => attachedDatabase.tags;
  $TracksTable get tracks => attachedDatabase.tracks;
  $TrackTagsTable get trackTags => attachedDatabase.trackTags;
  TagsDaoManager get managers => TagsDaoManager(this);
}

class TagsDaoManager {
  final _$TagsDaoMixin _db;
  TagsDaoManager(this._db);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db.attachedDatabase, _db.tags);
  $$TracksTableTableManager get tracks => $$TracksTableTableManager(_db.attachedDatabase, _db.tracks);
  $$TrackTagsTableTableManager get trackTags => $$TrackTagsTableTableManager(_db.attachedDatabase, _db.trackTags);
}
