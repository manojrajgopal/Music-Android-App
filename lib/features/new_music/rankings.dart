import 'dart:math' as math;

import '../../data/database/app_database.dart';

/// A track with a transparent score used by local rankings.
class RankedTrack {
  const RankedTrack(this.track, this.score, {this.recentPlays = 0, this.earlierPlays = 0});

  final Track track;
  final double score;
  final int recentPlays;
  final int earlierPlays;
}

/// Counts meaningful plays per track inside [from, to).
Map<String, int> countedPlays(Iterable<PlaybackRecord> history, DateTime from, DateTime to) {
  final counts = <String, int>{};
  for (final r in history) {
    if (!r.counted) continue;
    if (r.startedAt.isBefore(from) || !r.startedAt.isBefore(to)) continue;
    counts[r.trackId] = (counts[r.trackId] ?? 0) + 1;
  }
  return counts;
}

/// Local trending: plays in the last 7 days compared with the 21 days before.
/// Only meaningful plays count, so repeated short taps cannot inflate a rank.
List<RankedTrack> localTrending(
  List<Track> tracks,
  List<PlaybackRecord> history, {
  required DateTime now,
  int limit = 20,
}) {
  final recentFrom = now.subtract(const Duration(days: 7));
  final earlierFrom = now.subtract(const Duration(days: 28));
  final recent = countedPlays(history, recentFrom, now);
  final earlier = countedPlays(history, earlierFrom, recentFrom);
  final byId = {for (final t in tracks) t.id: t};
  final ranked = <RankedTrack>[];
  recent.forEach((id, plays) {
    final track = byId[id];
    if (track == null || plays < 2) return;
    final before = earlier[id] ?? 0;
    // Weekly average of the earlier window is before / 3.
    final score = plays / (1 + before / 3);
    if (score <= 1) return;
    ranked.add(RankedTrack(track, score, recentPlays: plays, earlierPlays: before));
  });
  ranked.sort(_byScoreThenTitle);
  return ranked.take(limit).toList();
}

/// Daily Top 100 for the local library.
/// Score = 3 × plays (7 days) + 1 × plays (30 days) + 0.25 × all-time plays.
List<RankedTrack> dailyTop(List<Track> tracks, List<PlaybackRecord> history, {required DateTime now, int limit = 100}) {
  final week = countedPlays(history, now.subtract(const Duration(days: 7)), now);
  final month = countedPlays(history, now.subtract(const Duration(days: 30)), now);
  final ranked = <RankedTrack>[];
  for (final t in tracks) {
    final score = 3 * (week[t.id] ?? 0) + (month[t.id] ?? 0) + 0.25 * t.playCount;
    if (score <= 0) continue;
    ranked.add(RankedTrack(t, score, recentPlays: week[t.id] ?? 0));
  }
  ranked.sort(_byScoreThenTitle);
  return ranked.take(limit).toList();
}

/// Heavy rotation: frequent recent plays plus a boost for favorites.
List<Track> heavyRotation(List<Track> tracks, List<PlaybackRecord> history, {required DateTime now, int limit = 20}) {
  final plays = countedPlays(history, now.subtract(const Duration(days: 90)), now);
  final ranked = <RankedTrack>[];
  for (final t in tracks) {
    final p = plays[t.id] ?? 0;
    if (p == 0) continue;
    ranked.add(RankedTrack(t, p + (t.isFavorite ? 3 : 0) + math.log(1 + t.playCount)));
  }
  ranked.sort(_byScoreThenTitle);
  return ranked.take(limit).map((r) => r.track).toList();
}

int _byScoreThenTitle(RankedTrack a, RankedTrack b) {
  final c = b.score.compareTo(a.score);
  return c != 0 ? c : a.track.titleKey.compareTo(b.track.titleKey);
}

/// DJ mixes and long-form audio: long duration, mix-like genre or a tag.
bool isLongFormMix(Track t, {Set<String> taggedIds = const {}}) {
  if (taggedIds.contains(t.id)) return true;
  final genre = (t.genre ?? '').toLowerCase();
  if (genre.contains('mix') || genre.contains('dj')) return true;
  final title = t.titleKey;
  if ((t.durationMs ?? 0) >= 20 * 60000) return true;
  return title.contains('dj mix') || title.contains('mixtape') || title.contains('continuous mix');
}
