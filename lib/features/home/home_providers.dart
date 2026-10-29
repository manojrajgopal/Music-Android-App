import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../audio/playback_controller.dart';
import '../../core/utils/format.dart';
import '../../data/database/app_database.dart';
import '../library/library_providers.dart';
import '../new_music/rankings.dart';
import 'recommendations.dart';

/// Recomputed when tracks or history change, not on playback position ticks.
final _now = Provider<DateTime>((ref) {
  ref.watch(allTracksProvider);
  ref.watch(recentHistoryProvider);
  return DateTime.now();
});

final heavyRotationProvider = Provider<List<Track>>((ref) {
  final tracks = ref.watch(allTracksProvider).value ?? const [];
  final history = ref.watch(recentHistoryProvider).value ?? const [];
  return heavyRotation(tracks, history, now: ref.watch(_now));
});

final topPicksProvider = Provider<List<Collection>>((ref) {
  final tracks = ref.watch(allTracksProvider).value ?? const [];
  return topPicks(tracks, now: ref.watch(_now));
});

final bestOfArtistsProvider = Provider<List<ArtistCollection>>((ref) {
  final tracks = ref.watch(allTracksProvider).value ?? const [];
  return bestOfArtists(tracks);
});

final continueListeningProvider = Provider<List<Track>>((ref) {
  final tracks = ref.watch(allTracksProvider).value ?? const [];
  return continueListening(tracks, now: ref.watch(_now));
});

/// Seed for "More Like This": the current track, else the last played one.
final moreLikeThisSeedProvider = Provider<Track?>((ref) {
  final current = ref.watch(currentTrackProvider).value;
  if (current != null) return current;
  return ref.watch(recentlyPlayedProvider).value?.firstOrNull;
});

final similarToProvider = Provider.family<List<Similar>, String>((ref, trackId) {
  final tracks = ref.watch(allTracksProvider).value ?? const [];
  final seed = tracks.where((t) => t.id == trackId).firstOrNull;
  if (seed == null) return const [];
  return moreLikeThis(seed, tracks, tagsByTrack: ref.watch(tagsByTrackProvider));
});

final trendingProvider = Provider<List<RankedTrack>>((ref) {
  final tracks = ref.watch(allTracksProvider).value ?? const [];
  final history = ref.watch(recentHistoryProvider).value ?? const [];
  return localTrending(tracks, history, now: ref.watch(_now));
});

final dailyTopProvider = Provider<List<RankedTrack>>((ref) {
  final tracks = ref.watch(allTracksProvider).value ?? const [];
  final history = ref.watch(recentHistoryProvider).value ?? const [];
  return dailyTop(tracks, history, now: ref.watch(_now));
});

final newThisWeekProvider = Provider<List<Track>>((ref) {
  final tracks = ref.watch(allTracksProvider).value ?? const [];
  final start = startOfLocalWeek(ref.watch(_now));
  return tracks.where((t) => !t.dateAdded.toLocal().isBefore(start)).toList()
    ..sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
});

final bestNewSongsProvider = Provider<List<Track>>((ref) {
  final tracks = ref.watch(allTracksProvider).value ?? const [];
  final from = ref.watch(_now).subtract(const Duration(days: 30));
  return tracks.where((t) => t.dateAdded.isAfter(from)).toList()..sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
});

/// Every generated collection, addressable by id for "See All" pages.
final generatedCollectionsProvider = Provider<Map<String, Collection>>((ref) {
  final result = <String, Collection>{};
  void add(Collection c) => result[c.id] = c;
  add(
    Collection(
      id: 'heavy-rotation',
      title: 'Heavy Rotation',
      reason: 'Your most played songs in the last 90 days',
      tracks: ref.watch(heavyRotationProvider),
    ),
  );
  add(
    Collection(
      id: 'recently-played',
      title: 'Recently Played',
      reason: 'Ordered by when you last listened',
      tracks: ref.watch(recentlyPlayedProvider).value ?? const [],
    ),
  );
  add(
    Collection(
      id: 'continue',
      title: 'Continue Listening',
      reason: 'Songs you stopped partway through',
      tracks: ref.watch(continueListeningProvider),
    ),
  );
  add(
    Collection(
      id: 'best-new',
      title: 'Best New Songs',
      reason: 'Added to your library in the last 30 days',
      tracks: ref.watch(bestNewSongsProvider),
    ),
  );
  add(
    Collection(
      id: 'new-this-week',
      title: 'New This Week',
      reason: 'Added since Monday',
      tracks: ref.watch(newThisWeekProvider),
    ),
  );
  add(
    Collection(
      id: 'trending',
      title: 'Trending in Your Library',
      reason: 'Plays in the last 7 days vs. the 3 weeks before',
      tracks: [for (final r in ref.watch(trendingProvider)) r.track],
    ),
  );
  add(
    Collection(
      id: 'daily-top',
      title: 'Daily Top 100 · Your Library',
      reason: 'Ranked by your recent and all-time plays',
      tracks: [for (final r in ref.watch(dailyTopProvider)) r.track],
    ),
  );
  for (final c in ref.watch(topPicksProvider)) {
    add(c);
  }
  for (final a in ref.watch(bestOfArtistsProvider)) {
    add(
      Collection(
        id: 'best-of-${a.artistKey}',
        title: 'Best of ${a.name}',
        reason: 'Your top ${a.name} songs',
        tracks: a.tracks,
      ),
    );
  }
  return result;
});
