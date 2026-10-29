// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misc_dao.dart';

// ignore_for_file: type=lint
mixin _$MiscDaoMixin on DatabaseAccessor<AppDatabase> {
  $SearchHistoryTable get searchHistory => attachedDatabase.searchHistory;
  $ArtworkCacheTable get artworkCache => attachedDatabase.artworkCache;
  $ImportJobsTable get importJobs => attachedDatabase.importJobs;
  MiscDaoManager get managers => MiscDaoManager(this);
}

class MiscDaoManager {
  final _$MiscDaoMixin _db;
  MiscDaoManager(this._db);
  $$SearchHistoryTableTableManager get searchHistory =>
      $$SearchHistoryTableTableManager(_db.attachedDatabase, _db.searchHistory);
  $$ArtworkCacheTableTableManager get artworkCache =>
      $$ArtworkCacheTableTableManager(_db.attachedDatabase, _db.artworkCache);
  $$ImportJobsTableTableManager get importJobs => $$ImportJobsTableTableManager(_db.attachedDatabase, _db.importJobs);
}
