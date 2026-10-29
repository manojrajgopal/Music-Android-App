import '../../core/constants/app_constants.dart';
import '../../core/utils/format.dart';
import '../../data/database/app_database.dart';

class RankedItem {
  const RankedItem({
    required this.key,
    required this.label,
    required this.listenedMs,
    required this.plays,
    this.artworkKey,
    this.subtitle,
  });

  final String key;
  final String label;
  final String? subtitle;
  final int listenedMs;
  final int plays;
  final String? artworkKey;
}

class StreakInfo {
  const StreakInfo({required this.current, required this.longest});

  final int current;
  final int longest;
}

class Milestone {
  const Milestone(this.title, this.detail);

  final String title;
  final String detail;
}

/// Summary for a period, computed only from stored playback records.
class ReplaySummary {
  const ReplaySummary({
    required this.from,
    required this.to,
    required this.totalListenedMs,
    required this.plays,
    required this.distinctTracks,
    required this.topTracks,
    required this.topArtists,
    required this.topAlbums,
    required this.topGenres,
    required this.daily,
  });

  final DateTime from;
  final DateTime to;
  final int totalListenedMs;
  final int plays;
  final int distinctTracks;
  final List<RankedItem> topTracks;
  final List<RankedItem> topArtists;
  final List<RankedItem> topAlbums;
  final List<RankedItem> topGenres;

  /// Listening per local day, in ascending order, including silent days.
  final Map<DateTime, int> daily;

  bool get isEmpty => totalListenedMs == 0;
}

class StatsCalculator {
  const StatsCalculator();

  ReplaySummary summarize(
    List<PlaybackRecord> records,
    Map<String, Track> tracks, {
    required DateTime from,
    required DateTime to,
    int top = 10,
  }) {
    final inRange = records.where((r) => !r.startedAt.isBefore(from) && r.startedAt.isBefore(to)).toList();
    var total = 0;
    var plays = 0;
    final distinct = <String>{};
    final byTrack = <String, _Acc>{};
    final byArtist = <String, _Acc>{};
    final byAlbum = <String, _Acc>{};
    final byGenre = <String, _Acc>{};
    final daily = <DateTime, int>{};

    for (final r in inRange) {
      final ms = r.listenedMs < 0 ? 0 : r.listenedMs;
      total += ms;
      final day = localDay(r.startedAt);
      daily[day] = (daily[day] ?? 0) + ms;
      final t = tracks[r.trackId];
      if (r.counted) {
        plays++;
        distinct.add(r.trackId);
      }
      if (t == null) continue;
      byTrack.putIfAbsent(t.id, () => _Acc(t.title, t.artist, t.artworkKey)).add(ms, r.counted);
      if (t.artist != null) {
        byArtist.putIfAbsent(t.artistKey, () => _Acc(t.artist!, null, t.artworkKey)).add(ms, r.counted);
      }
      if (t.album != null) {
        byAlbum
            .putIfAbsent(t.albumKey, () => _Acc(t.album!, t.albumArtist ?? t.artist, t.artworkKey))
            .add(ms, r.counted);
      }
      if (t.genre != null) {
        byGenre.putIfAbsent(t.genre!, () => _Acc(t.genre!, null, t.artworkKey)).add(ms, r.counted);
      }
    }

    final filledDaily = <DateTime, int>{};
    for (
      var d = localDay(from);
      d.isBefore(to) && !d.isAfter(localDay(DateTime.now()));
      d = DateTime(d.year, d.month, d.day + 1)
    ) {
      filledDaily[d] = daily[d] ?? 0;
    }

    return ReplaySummary(
      from: from,
      to: to,
      totalListenedMs: total,
      plays: plays,
      distinctTracks: distinct.length,
      topTracks: _rank(byTrack, top),
      topArtists: _rank(byArtist, top),
      topAlbums: _rank(byAlbum, top),
      topGenres: _rank(byGenre, top),
      daily: filledDaily,
    );
  }

  List<RankedItem> _rank(Map<String, _Acc> map, int top) {
    final entries = map.entries.where((e) => e.value.ms > 0).toList()
      ..sort((a, b) {
        final c = b.value.plays.compareTo(a.value.plays);
        return c != 0 ? c : b.value.ms.compareTo(a.value.ms);
      });
    return [
      for (final e in entries.take(top))
        RankedItem(
          key: e.key,
          label: e.value.label,
          subtitle: e.value.subtitle,
          listenedMs: e.value.ms,
          plays: e.value.plays,
          artworkKey: e.value.art,
        ),
    ];
  }

  /// Streaks use local calendar days with at least
  /// [ListeningRules.streakDayMinMs] of listening. The current streak may
  /// end yesterday (today is still in progress).
  StreakInfo streaks(List<PlaybackRecord> records, {required DateTime now}) {
    final perDay = <DateTime, int>{};
    for (final r in records) {
      final d = localDay(r.startedAt);
      perDay[d] = (perDay[d] ?? 0) + r.listenedMs;
    }
    final days = perDay.entries.where((e) => e.value >= ListeningRules.streakDayMinMs).map((e) => e.key).toList()
      ..sort();
    if (days.isEmpty) return const StreakInfo(current: 0, longest: 0);

    var longest = 1;
    var run = 1;
    for (var i = 1; i < days.length; i++) {
      run = _isNextDay(days[i - 1], days[i]) ? run + 1 : 1;
      if (run > longest) longest = run;
    }

    final today = localDay(now);
    final yesterday = DateTime(today.year, today.month, today.day - 1);
    final set = days.toSet();
    var cursor = set.contains(today) ? today : (set.contains(yesterday) ? yesterday : null);
    var current = 0;
    while (cursor != null && set.contains(cursor)) {
      current++;
      cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
    }
    return StreakInfo(current: current, longest: longest);
  }

  bool _isNextDay(DateTime a, DateTime b) => DateTime(a.year, a.month, a.day + 1) == b;

  List<Milestone> milestones({
    required int totalMs,
    required int plays,
    required int distinctTracks,
    required StreakInfo streak,
  }) {
    final result = <Milestone>[];
    final hours = totalMs ~/ 3600000;
    for (final h in const [1000, 500, 100, 50, 10, 1]) {
      if (hours >= h) {
        result.add(
          Milestone('$h hour${h == 1 ? '' : 's'} of listening', 'You have listened for ${formatListening(totalMs)}'),
        );
        break;
      }
    }
    for (final p in const [10000, 5000, 1000, 500, 100, 10]) {
      if (plays >= p) {
        result.add(Milestone('$p plays', 'Counted plays across your library'));
        break;
      }
    }
    for (final n in const [1000, 500, 100, 50, 10]) {
      if (distinctTracks >= n) {
        result.add(Milestone('$n different songs', 'Variety in your listening'));
        break;
      }
    }
    if (streak.longest >= 7) {
      result.add(Milestone('${streak.longest}-day streak', 'Your longest run of listening days'));
    }
    return result;
  }
}

class _Acc {
  _Acc(this.label, this.subtitle, this.art);

  final String label;
  final String? subtitle;
  final String? art;
  int ms = 0;
  int plays = 0;

  void add(int value, bool counted) {
    ms += value;
    if (counted) plays++;
  }
}
