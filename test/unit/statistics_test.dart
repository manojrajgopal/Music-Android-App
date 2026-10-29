import 'package:cadence/audio/listening_tracker.dart';
import 'package:cadence/features/statistics/stats_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

class FakeSink implements ListeningSink {
  final records = <int, Map<String, Object?>>{};
  final plays = <String>[];
  final skips = <String>[];
  final sessions = <int>[];
  var _id = 0;

  @override
  Future<int> startRecord(String trackId, DateTime startedAt, String? context) async {
    records[++_id] = {'track': trackId, 'listened': 0, 'counted': false};
    return _id;
  }

  @override
  Future<void> updateRecord(
    int id, {
    required int listenedMs,
    required DateTime endedAt,
    required bool counted,
    bool? completed,
    bool? skipped,
  }) async {
    records[id]!
      ..['listened'] = listenedMs
      ..['counted'] = counted
      ..['completed'] = completed ?? records[id]!['completed']
      ..['skipped'] = skipped ?? records[id]!['skipped'];
  }

  @override
  Future<void> deleteRecord(int id) async => records.remove(id);

  @override
  Future<void> countPlay(String trackId, DateTime at) async => plays.add(trackId);

  @override
  Future<void> countSkip(String trackId) async => skips.add(trackId);

  @override
  Future<void> addSessionTime(DateTime start, DateTime end, int listenedMs) async => sessions.add(listenedMs);
}

void main() {
  group('ListeningTracker', () {
    late FakeSink sink;
    late Duration mono;
    late ListeningTracker tracker;

    setUp(() {
      sink = FakeSink();
      mono = Duration.zero;
      tracker = ListeningTracker(sink, monotonic: () => mono, clock: () => DateTime(2026, 10, 1, 12));
    });

    test('counts only time spent playing, not paused time', () async {
      await tracker.begin('a', durationMs: 240000, playing: true);
      mono += const Duration(seconds: 20);
      tracker.setPlaying(false);
      mono += const Duration(minutes: 10); // paused
      tracker.setPlaying(true);
      mono += const Duration(seconds: 15);
      await tracker.stop();
      final r = sink.records.values.single;
      expect(r['listened'], 35000);
      expect(r['counted'], isTrue);
      expect(sink.plays, ['a']);
    });

    test('a play is counted once even across many checkpoints', () async {
      await tracker.begin('a', durationMs: 240000, playing: true);
      for (var i = 0; i < 5; i++) {
        mono += const Duration(seconds: 15);
        await tracker.checkpoint();
      }
      await tracker.stop();
      expect(sink.plays, ['a']);
    });

    test('short tracks count after half their length', () async {
      await tracker.begin('short', durationMs: 20000, playing: true);
      mono += const Duration(seconds: 11);
      await tracker.stop();
      expect(sink.plays, ['short']);
    });

    test('an accidental tap leaves no history but a skip is recorded', () async {
      await tracker.begin('a', durationMs: 200000, playing: true);
      mono += const Duration(milliseconds: 400);
      await tracker.begin('b', durationMs: 200000, playing: true);
      await tracker.stop();
      expect(sink.records.values.where((r) => r['track'] == 'a'), isEmpty);
      expect(sink.skips, contains('a'));
      expect(sink.plays, isEmpty);
    });

    test('reaching the end marks completion and is not a skip', () async {
      await tracker.begin('a', durationMs: 100000, playing: true);
      mono += const Duration(seconds: 95);
      tracker.updatePosition(95000);
      await tracker.begin('b', durationMs: 100000, playing: true);
      await tracker.stop();
      final a = sink.records.values.firstWhere((r) => r['track'] == 'a');
      expect(a['completed'], isTrue);
      expect(a['skipped'], isFalse);
      expect(sink.skips, isEmpty);
    });

    test('a wall-clock change does not affect measured listening', () async {
      var wall = DateTime(2026, 10, 1, 12);
      tracker = ListeningTracker(sink, monotonic: () => mono, clock: () => wall);
      await tracker.begin('a', durationMs: 300000, playing: true);
      mono += const Duration(seconds: 40);
      wall = wall.subtract(const Duration(hours: 5)); // user changes the clock
      await tracker.stop();
      expect(sink.records.values.single['listened'], 40000);
    });
  });

  group('StatsCalculator', () {
    const calc = StatsCalculator();

    test('streaks use local calendar days with a minimum of listening', () {
      final now = DateTime(2026, 10, 29, 20);
      final records = [
        record('a', DateTime(2026, 10, 29, 9)),
        record('a', DateTime(2026, 10, 28, 9)),
        record('a', DateTime(2026, 10, 27, 9)),
        record('a', DateTime(2026, 10, 25, 9)), // gap on the 26th
        record('a', DateTime(2026, 10, 24, 9)),
        record('a', DateTime(2026, 10, 23, 9)),
        record('a', DateTime(2026, 10, 22, 9)),
        record('a', DateTime(2026, 10, 20, 9), listenedMs: 10000), // too short
      ];
      final s = calc.streaks(records, now: now);
      expect(s.current, 3);
      expect(s.longest, 4);
    });

    test('current streak may end yesterday but not earlier', () {
      final now = DateTime(2026, 10, 29, 8);
      expect(calc.streaks([record('a', DateTime(2026, 10, 28, 22))], now: now).current, 1);
      expect(calc.streaks([record('a', DateTime(2026, 10, 26, 22))], now: now).current, 0);
    });

    test('summaries total real listening and rank by counted plays', () {
      final a = makeTrack(title: 'A', artist: 'X', genre: 'Pop');
      final b = makeTrack(title: 'B', artist: 'Y', genre: 'Rock');
      final records = [
        record(a.id, DateTime(2026, 10, 2), listenedMs: 100000),
        record(a.id, DateTime(2026, 10, 3), listenedMs: 100000),
        record(b.id, DateTime(2026, 10, 3), listenedMs: 300000),
        record(b.id, DateTime(2026, 10, 4), listenedMs: 5000, counted: false),
        record(b.id, DateTime(2026, 9, 30), listenedMs: 999999), // outside range
      ];
      final s = calc.summarize(records, {a.id: a, b.id: b}, from: DateTime(2026, 10), to: DateTime(2026, 11));
      expect(s.totalListenedMs, 505000);
      expect(s.plays, 3);
      expect(s.distinctTracks, 2);
      expect(s.topTracks.first.label, 'A');
      expect(s.topArtists.map((i) => i.label), ['X', 'Y']);
      expect(s.topGenres.first.label, 'Pop');
      expect(s.daily[DateTime(2026, 10, 3)], 400000);
      expect(s.daily[DateTime(2026, 10, 1)], 0, reason: 'silent days exist but are zero');
    });

    test('an empty history produces an empty summary, not invented numbers', () {
      final s = calc.summarize(const [], const {}, from: DateTime(2026, 10), to: DateTime(2026, 11));
      expect(s.isEmpty, isTrue);
      expect(s.topTracks, isEmpty);
      expect(
        calc.milestones(totalMs: 0, plays: 0, distinctTracks: 0, streak: const StreakInfo(current: 0, longest: 0)),
        isEmpty,
      );
    });
  });
}
