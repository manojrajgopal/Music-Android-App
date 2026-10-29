import 'package:drift/drift.dart';

import '../app_database.dart';

part 'misc_dao.g.dart';

@DriftAccessor(tables: [SearchHistory, ArtworkCache, ImportJobs])
class MiscDao extends DatabaseAccessor<AppDatabase> with _$MiscDaoMixin {
  MiscDao(super.attachedDatabase);

  // ---- Search history ----

  Stream<List<SearchEntry>> watchRecentSearches({int limit = 12}) =>
      (select(searchHistory)
            ..orderBy([(s) => OrderingTerm.desc(s.searchedAt)])
            ..limit(limit))
          .watch();

  Future<void> addSearch(String query) => into(searchHistory).insert(
    SearchHistoryCompanion.insert(query: query, searchedAt: DateTime.now()),
    onConflict: DoUpdate(
      (_) => SearchHistoryCompanion(searchedAt: Value(DateTime.now())),
      target: [searchHistory.query],
    ),
  );

  Future<void> removeSearch(int id) => (delete(searchHistory)..where((s) => s.id.equals(id))).go();

  Future<void> clearSearches() => delete(searchHistory).go();

  // ---- Artwork cache ----

  Future<ArtworkEntry?> artwork(String key) =>
      (select(artworkCache)..where((a) => a.key.equals(key))).getSingleOrNull();

  Future<void> putArtwork(ArtworkCacheCompanion entry) => into(artworkCache).insertOnConflictUpdate(entry);

  Future<List<ArtworkEntry>> allArtwork() => select(artworkCache).get();

  Future<void> deleteArtwork(String key) => (delete(artworkCache)..where((a) => a.key.equals(key))).go();

  // ---- Import jobs ----

  Future<int> startJob(String source, ImportJobType type) => into(importJobs).insert(
    ImportJobsCompanion.insert(
      source: source,
      jobType: type,
      status: ImportJobStatus.running,
      startedAt: DateTime.now(),
    ),
  );

  Future<void> finishJob(int id, ImportJobStatus status, {String? error, String? trackId}) =>
      (update(importJobs)..where((j) => j.id.equals(id))).write(
        ImportJobsCompanion(
          status: Value(status),
          progress: const Value(1),
          completedAt: Value(DateTime.now()),
          error: Value(error),
          trackId: Value(trackId),
        ),
      );

  /// Jobs left "running" by a terminated process are marked failed on launch.
  Future<void> failInterruptedJobs() =>
      (update(importJobs)..where((j) => j.status.equalsValue(ImportJobStatus.running))).write(
        ImportJobsCompanion(
          status: const Value(ImportJobStatus.failed),
          error: const Value('Interrupted before completion'),
          completedAt: Value(DateTime.now()),
        ),
      );
}
