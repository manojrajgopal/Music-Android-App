import 'package:drift/drift.dart';

import '../app_database.dart';

part 'history_dao.g.dart';

@DriftAccessor(tables: [PlaybackHistory, ListeningSessions, Tracks])
class HistoryDao extends DatabaseAccessor<AppDatabase> with _$HistoryDaoMixin {
  HistoryDao(super.attachedDatabase);

  Future<int> startRecord(String trackId, DateTime startedAt, {String? context}) =>
      into(playbackHistory)
          .insert(PlaybackHistoryCompanion.insert(trackId: trackId, startedAt: startedAt, context: Value(context)));

  Future<void> updateRecord(
    int id, {
    required int listenedMs,
    required DateTime endedAt,
    required bool counted,
    bool? completed,
    bool? skipped,
  }) => (update(playbackHistory)..where((h) => h.id.equals(id))).write(
    PlaybackHistoryCompanion(
      listenedMs: Value(listenedMs),
      endedAt: Value(endedAt),
      counted: Value(counted),
      completed: completed == null ? const Value.absent() : Value(completed),
      skipped: skipped == null ? const Value.absent() : Value(skipped),
    ),
  );

  /// Removes empty records left behind by accidental taps.
  Future<void> deleteRecord(int id) => (delete(playbackHistory)..where((h) => h.id.equals(id))).go();

  Future<List<PlaybackRecord>> recordsBetween(DateTime from, DateTime to) =>
      (select(playbackHistory)
            ..where((h) => h.startedAt.isBetweenValues(from, to))
            ..orderBy([(h) => OrderingTerm.asc(h.startedAt)]))
          .get();

  Stream<List<PlaybackRecord>> watchRecordsSince(DateTime from) =>
      (select(playbackHistory)
            ..where((h) => h.startedAt.isBiggerOrEqualValue(from))
            ..orderBy([(h) => OrderingTerm.asc(h.startedAt)]))
          .watch();

  Future<List<PlaybackRecord>> allRecords() =>
      (select(playbackHistory)..orderBy([(h) => OrderingTerm.asc(h.startedAt)])).get();

  Stream<List<PlaybackRecord>> watchAllRecords() =>
      (select(playbackHistory)..orderBy([(h) => OrderingTerm.asc(h.startedAt)])).watch();

  /// Track ids ordered by their latest meaningful play.
  Stream<List<String>> watchRecentlyPlayedIds({int limit = 30}) => customSelect(
    'SELECT track_id AS t, MAX(started_at) AS last FROM playback_history '
    'WHERE counted = 1 GROUP BY track_id ORDER BY last DESC LIMIT ?',
    variables: [Variable(limit)],
    readsFrom: {playbackHistory},
  ).watch().map((rows) => [for (final r in rows) r.read<String>('t')]);

  Future<ListeningSession?> latestSession() =>
      (select(listeningSessions)
            ..orderBy([(s) => OrderingTerm.desc(s.endedAt)])
            ..limit(1))
          .getSingleOrNull();

  Future<int> insertSession(DateTime start, DateTime end, int totalMs) =>
      into(listeningSessions)
          .insert(ListeningSessionsCompanion.insert(startedAt: start, endedAt: end, totalListeningMs: Value(totalMs)));

  Future<void> extendSession(int id, DateTime end, int addMs) => customUpdate(
    'UPDATE listening_sessions SET ended_at = ?, total_listening_ms = total_listening_ms + ? WHERE id = ?',
    variables: [Variable(end), Variable(addMs), Variable(id)],
    updates: {listeningSessions},
  );

  Future<List<ListeningSession>> allSessions() => select(listeningSessions).get();

  Future<void> clearAll() => transaction(() async {
    await delete(playbackHistory).go();
    await delete(listeningSessions).go();
    await customUpdate(
      'UPDATE tracks SET play_count = 0, skip_count = 0, last_played_at = NULL, last_position_ms = NULL',
      updates: {tracks},
    );
  });
}
