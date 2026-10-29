import 'dart:async';

import '../core/constants/app_constants.dart';
import '../data/database/app_database.dart';

/// Persistence used by [ListeningTracker]; implemented over the database and
/// faked in tests.
abstract class ListeningSink {
  Future<int> startRecord(String trackId, DateTime startedAt, String? context);
  Future<void> updateRecord(
    int id, {
    required int listenedMs,
    required DateTime endedAt,
    required bool counted,
    bool? completed,
    bool? skipped,
  });
  Future<void> deleteRecord(int id);
  Future<void> countPlay(String trackId, DateTime at);
  Future<void> countSkip(String trackId);
  Future<void> addSessionTime(DateTime start, DateTime end, int listenedMs);
}

class DatabaseListeningSink implements ListeningSink {
  DatabaseListeningSink(this._db);

  final AppDatabase _db;

  @override
  Future<int> startRecord(String trackId, DateTime startedAt, String? context) =>
      _db.historyDao.startRecord(trackId, startedAt, context: context);

  @override
  Future<void> updateRecord(
    int id, {
    required int listenedMs,
    required DateTime endedAt,
    required bool counted,
    bool? completed,
    bool? skipped,
  }) => _db.historyDao.updateRecord(
    id,
    listenedMs: listenedMs,
    endedAt: endedAt,
    counted: counted,
    completed: completed,
    skipped: skipped,
  );

  @override
  Future<void> deleteRecord(int id) => _db.historyDao.deleteRecord(id);

  @override
  Future<void> countPlay(String trackId, DateTime at) => _db.tracksDao.recordCountedPlay(trackId, at);

  @override
  Future<void> countSkip(String trackId) => _db.tracksDao.recordSkip(trackId);

  @override
  Future<void> addSessionTime(DateTime start, DateTime end, int listenedMs) => _db.transaction(() async {
    final last = await _db.historyDao.latestSession();
    if (last != null && start.difference(last.endedAt) <= ListeningRules.sessionGap) {
      await _db.historyDao.extendSession(last.id, end, listenedMs);
    } else {
      await _db.historyDao.insertSession(start, end, listenedMs);
    }
  });
}

/// Measures actual listening time for the current track.
///
/// Elapsed time comes from a monotonic clock, so wall-clock changes cannot
/// distort durations; paused time is never counted. One record exists per
/// playback of a track, checkpointed periodically so a terminated process
/// loses at most one checkpoint interval.
class ListeningTracker {
  ListeningTracker(this._sink, {Duration Function()? monotonic, DateTime Function()? clock})
    : _monotonic = monotonic ?? _defaultMonotonic,
      _clock = clock ?? DateTime.now;

  static final Stopwatch _stopwatch = Stopwatch()..start();
  static Duration _defaultMonotonic() => _stopwatch.elapsed;

  final ListeningSink _sink;
  final Duration Function() _monotonic;
  final DateTime Function() _clock;

  _Current? _current;
  Future<void> _queue = Future.value();

  String? get currentTrackId => _current?.trackId;
  int get currentListenedMs => _current?.listened(_monotonic()) ?? 0;

  /// Serializes database writes so records are never updated out of order.
  Future<void> _enqueue(Future<void> Function() op) => _queue = _queue.then((_) => op()).catchError((_) {});

  /// Starts tracking a new track; finalizes the previous one as skipped or
  /// completed according to how far it was played.
  Future<void> begin(String trackId, {int? durationMs, bool playing = false, String? context}) {
    final previous = _current;
    if (previous != null) _finalize(previous, skipped: !previous.reachedEnd);
    final now = _clock();
    final current = _Current(trackId, durationMs, now);
    _current = current;
    if (playing) current.resume(_monotonic());
    return _enqueue(() async {
      current.recordId = await _sink.startRecord(trackId, now, context);
    });
  }

  void setPlaying(bool playing) {
    final c = _current;
    if (c == null) return;
    final now = _monotonic();
    if (playing) {
      c.resume(now);
    } else {
      c.pause(now);
      checkpoint();
    }
  }

  void updateDuration(int durationMs) => _current?.durationMs ??= durationMs;

  /// Called on a timer while playing and whenever playback pauses.
  Future<void> checkpoint() {
    final c = _current;
    if (c == null) return Future.value();
    final listened = c.listened(_monotonic());
    final at = _clock();
    final crossed = !c.counted && listened >= ListeningRules.meaningfulThresholdFor(c.durationMs);
    if (crossed) c.counted = true;
    return _enqueue(() async {
      if (c.recordId == null) return;
      await _sink.updateRecord(c.recordId!, listenedMs: listened, endedAt: at, counted: c.counted);
      if (crossed) await _sink.countPlay(c.trackId, at);
    });
  }

  /// Marks that the track reached its end naturally.
  void markCompleted() => _current?.reachedEnd = true;

  /// Records the position for completion checks.
  void updatePosition(int positionMs) {
    final c = _current;
    if (c == null || c.durationMs == null || c.durationMs == 0) return;
    if (positionMs >= c.durationMs! * ListeningRules.completedFraction) c.reachedEnd = true;
  }

  Future<void> stop() {
    final c = _current;
    _current = null;
    if (c == null) return _queue;
    _finalize(c, skipped: false);
    return _queue;
  }

  void _finalize(_Current c, {required bool skipped}) {
    c.pause(_monotonic());
    final listened = c.listened(_monotonic());
    final at = _clock();
    final threshold = ListeningRules.meaningfulThresholdFor(c.durationMs);
    final newlyCounted = !c.counted && listened >= threshold;
    final counted = c.counted || newlyCounted;
    final completed = c.reachedEnd;
    final isSkip = skipped && !completed && !counted;
    _enqueue(() async {
      final id = c.recordId;
      if (id == null) return;
      if (listened < 1000 && !counted) {
        // An accidental tap: keep no history, but remember explicit skips.
        await _sink.deleteRecord(id);
        if (isSkip) await _sink.countSkip(c.trackId);
        return;
      }
      await _sink.updateRecord(
        id,
        listenedMs: listened,
        endedAt: at,
        counted: counted,
        completed: completed,
        skipped: isSkip,
      );
      if (newlyCounted) await _sink.countPlay(c.trackId, at);
      if (isSkip) await _sink.countSkip(c.trackId);
      if (listened > 0) await _sink.addSessionTime(c.startedAt, at, listened);
    });
  }
}

class _Current {
  _Current(this.trackId, this.durationMs, this.startedAt);

  final String trackId;
  final DateTime startedAt;
  int? durationMs;
  int? recordId;
  bool counted = false;
  bool reachedEnd = false;
  Duration _accumulated = Duration.zero;
  Duration? _resumedAt;

  void resume(Duration now) => _resumedAt ??= now;

  void pause(Duration now) {
    final r = _resumedAt;
    if (r == null) return;
    _accumulated += now - r;
    _resumedAt = null;
  }

  int listened(Duration now) {
    final r = _resumedAt;
    return (_accumulated + (r == null ? Duration.zero : now - r)).inMilliseconds;
  }
}
