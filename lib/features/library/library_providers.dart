import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/database/app_database.dart';
import '../../data/database/daos/playlists_dao.dart';
import '../../data/database/daos/tracks_dao.dart';
import '../home/recommendations.dart';

final allTracksProvider = StreamProvider<List<Track>>((ref) => ref.watch(databaseProvider).tracksDao.watchAllTracks());

final trackCountProvider = StreamProvider<int>((ref) => ref.watch(databaseProvider).tracksDao.watchCount());

typedef SongsQuery = ({TrackSort sort, bool descending, int limit});

/// Paged song list: the UI grows [SongsQuery.limit] while scrolling.
final songsProvider = StreamProvider.family<List<Track>, SongsQuery>(
  (ref, q) => ref.watch(databaseProvider).tracksDao.watchSongs(sort: q.sort, descending: q.descending, limit: q.limit),
);

final recentlyAddedProvider = StreamProvider<List<Track>>(
  (ref) => ref.watch(databaseProvider).tracksDao.watchRecentlyAdded(limit: 30),
);

final trackProvider = StreamProvider.family<Track?, String>(
  (ref, id) => ref.watch(databaseProvider).tracksDao.watchById(id),
);

final artistsProvider = StreamProvider<List<TrackGroup>>((ref) => ref.watch(databaseProvider).tracksDao.watchArtists());

final albumsProvider = StreamProvider<List<TrackGroup>>((ref) => ref.watch(databaseProvider).tracksDao.watchAlbums());

final compilationsProvider = StreamProvider<List<TrackGroup>>(
  (ref) => ref.watch(databaseProvider).tracksDao.watchAlbums(compilationsOnly: true),
);

final genresProvider = StreamProvider<List<TrackGroup>>(
  (ref) => ref.watch(databaseProvider).tracksDao.watchColumnGroups('genre'),
);

final composersProvider = StreamProvider<List<TrackGroup>>(
  (ref) => ref.watch(databaseProvider).tracksDao.watchColumnGroups('composer'),
);

final languagesProvider = StreamProvider<List<TrackGroup>>(
  (ref) => ref.watch(databaseProvider).tracksDao.watchColumnGroups('language'),
);

final yearsProvider = StreamProvider<List<TrackGroup>>((ref) => ref.watch(databaseProvider).tracksDao.watchYears());

final favoritesProvider = StreamProvider<List<Track>>((ref) => ref.watch(databaseProvider).tracksDao.watchFavorites());

final favoriteAlbumKeysProvider = StreamProvider<Set<String>>(
  (ref) => ref.watch(databaseProvider).tracksDao.watchFavoriteAlbumKeys(),
);

final playlistsProvider = StreamProvider<List<PlaylistSummary>>(
  (ref) => ref.watch(databaseProvider).playlistsDao.watchSummaries(),
);

final playlistProvider = StreamProvider.family<Playlist?, int>(
  (ref, id) => ref.watch(databaseProvider).playlistsDao.watchPlaylist(id),
);

final playlistItemsProvider = StreamProvider.family<List<PlaylistItem>, int>(
  (ref, id) => ref.watch(databaseProvider).playlistsDao.watchItems(id),
);

final recentlyPlayedIdsProvider = StreamProvider<List<String>>(
  (ref) => ref.watch(databaseProvider).historyDao.watchRecentlyPlayedIds(limit: 30),
);

final recentlyPlayedProvider = StreamProvider<List<Track>>((ref) {
  final ids = ref.watch(recentlyPlayedIdsProvider).value ?? const [];
  return ref.watch(databaseProvider).tracksDao.watchByIds(ids);
});

/// Playback records from the last 90 days, used by rankings.
final recentHistoryProvider = StreamProvider<List<PlaybackRecord>>((ref) {
  final from = DateTime.now().subtract(const Duration(days: 90));
  return ref.watch(databaseProvider).historyDao.watchRecordsSince(from);
});

final userTagsProvider = StreamProvider<List<Tag>>(
  (ref) => ref.watch(databaseProvider).tagsDao.watchTags(TagKind.user),
);

final moodTagsProvider = StreamProvider<List<Tag>>(
  (ref) => ref.watch(databaseProvider).tagsDao.watchTags(TagKind.mood),
);

final tagsForTrackProvider = StreamProvider.family<List<Tag>, String>(
  (ref, id) => ref.watch(databaseProvider).tagsDao.watchTagsForTrack(id),
);

final membershipsProvider = StreamProvider<List<TrackTag>>(
  (ref) => ref.watch(databaseProvider).tagsDao.watchMemberships(),
);

/// Explicit include/exclude choices per mood: mood → trackId → included.
final moodChoicesProvider = Provider<Map<Mood, Map<String, bool>>>((ref) {
  final tags = ref.watch(moodTagsProvider).value ?? const [];
  final memberships = ref.watch(membershipsProvider).value ?? const [];
  final result = <Mood, Map<String, bool>>{};
  for (final mood in Mood.values) {
    final tag = tags.where((t) => t.name == mood.label).firstOrNull;
    if (tag == null) continue;
    result[mood] = {
      for (final m in memberships)
        if (m.tagId == tag.id) m.trackId: !m.excluded,
    };
  }
  return result;
});

final moodTracksProvider = Provider.family<List<Track>, Mood>((ref, mood) {
  final tracks = ref.watch(allTracksProvider).value ?? const [];
  final choices = ref.watch(moodChoicesProvider)[mood] ?? const {};
  return moodTracks(mood, tracks, choices);
});

/// trackId → set of tag ids, for similarity.
final tagsByTrackProvider = Provider<Map<String, Set<int>>>((ref) {
  final memberships = ref.watch(membershipsProvider).value ?? const [];
  final map = <String, Set<int>>{};
  for (final m in memberships) {
    if (!m.excluded) map.putIfAbsent(m.trackId, () => {}).add(m.tagId);
  }
  return map;
});

final tracksWithTagProvider = StreamProvider.family<List<Track>, int>(
  (ref, tagId) => ref.watch(databaseProvider).tagsDao.watchTracksWithTag(tagId),
);
