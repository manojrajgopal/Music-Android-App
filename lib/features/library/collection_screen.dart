import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../audio/playback_controller.dart';
import '../../core/utils/format.dart';
import '../../core/utils/text_normalize.dart';
import '../../core/widgets/artwork_image.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/track_widgets.dart';
import '../../data/database/app_database.dart';
import '../home/home_providers.dart';
import '../playlists/playlist_actions.dart';
import '../shell/app_shell.dart';
import 'library_providers.dart';
import 'library_screen.dart';
import 'track_menu.dart';

typedef CollectionArgs = ({CollectionType type, String key});

class CollectionData {
  const CollectionData({required this.title, required this.tracks, this.subtitle});

  final String title;
  final String? subtitle;
  final List<Track> tracks;
}

final _artistTracks = StreamProvider.family<List<Track>, String>(
  (ref, key) => ref.watch(databaseProvider).tracksDao.watchByArtist(key),
);
final _albumTracks = StreamProvider.family<List<Track>, String>(
  (ref, key) => ref.watch(databaseProvider).tracksDao.watchAlbum(key),
);
final _columnTracks = StreamProvider.family<List<Track>, CollectionArgs>((ref, args) {
  final dao = ref.watch(databaseProvider).tracksDao;
  return switch (args.type) {
    CollectionType.genre => dao.watchWhere((t) => t.genre.equals(args.key)),
    CollectionType.composer => dao.watchWhere((t) => t.composer.equals(args.key)),
    CollectionType.language => dao.watchWhere((t) => t.language.equals(args.key)),
    _ => dao.watchWhere((t) => t.releaseYear.equals(int.tryParse(args.key) ?? -1)),
  };
});

/// Resolves any collection to its tracks; null while loading.
final collectionProvider = Provider.family<CollectionData?, CollectionArgs>((ref, args) {
  List<Track>? v(AsyncValue<List<Track>> a) => a.value;
  switch (args.type) {
    case CollectionType.artist:
      final tracks = v(ref.watch(_artistTracks(args.key)));
      if (tracks == null) return null;
      final name =
          tracks.expand((t) => splitArtists(t.artist)).where((n) => normalizeKey(n) == args.key).firstOrNull ??
          'Artist';
      return CollectionData(title: name, tracks: tracks);
    case CollectionType.album:
      final tracks = v(ref.watch(_albumTracks(args.key)));
      if (tracks == null) return null;
      final first = tracks.firstOrNull;
      return CollectionData(
        title: first?.album ?? 'Album',
        subtitle: [first?.albumArtist ?? first?.artist, first?.releaseYear?.toString()].whereType<String>().join(' · '),
        tracks: tracks,
      );
    case CollectionType.genre || CollectionType.composer || CollectionType.language || CollectionType.year:
      final tracks = v(ref.watch(_columnTracks(args)));
      if (tracks == null) return null;
      final title = switch (args.type) {
        CollectionType.language => '${args.key} Music',
        CollectionType.year => '${args.key} Hits',
        _ => args.key,
      };
      final subtitle = switch (args.type) {
        CollectionType.year => 'Release year from song tags',
        CollectionType.composer => 'Composer',
        CollectionType.genre => 'Genre',
        _ => 'Language from song tags or your edits',
      };
      return CollectionData(title: title, subtitle: subtitle, tracks: tracks);
    case CollectionType.mood:
      final mood = Mood.values.where((m) => m.name == args.key).firstOrNull ?? Mood.chill;
      return CollectionData(
        title: mood.label,
        subtitle: 'Your mood tags plus songs with matching genres. Remove songs from their menu.',
        tracks: ref.watch(moodTracksProvider(mood)),
      );
    case CollectionType.tag:
      final tracks = v(ref.watch(tracksWithTagProvider(int.tryParse(args.key) ?? -1)));
      return tracks == null ? null : CollectionData(title: 'Tag', tracks: tracks);
    case CollectionType.favorites:
      final tracks = v(ref.watch(favoritesProvider));
      return tracks == null ? null : CollectionData(title: 'Favorite Songs', tracks: tracks);
    case CollectionType.tv:
      return CollectionData(title: 'TV', tracks: ref.watch(tvTracksProvider));
    case CollectionType.generated:
      final c = ref.watch(generatedCollectionsProvider)[args.key];
      return CollectionData(title: c?.title ?? 'Collection', subtitle: c?.reason, tracks: c?.tracks ?? const []);
  }
});

class CollectionScreen extends ConsumerWidget {
  const CollectionScreen({super.key, required this.type, required this.collectionKey});

  final CollectionType type;
  final String collectionKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(collectionProvider((type: type, key: collectionKey)));
    if (data == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final tracks = data.tracks;
    final playback = ref.read(playbackControllerProvider);
    final totalMs = tracks.fold<int>(0, (s, t) => s + (t.durationMs ?? 0));
    final cover = tracks.map((t) => t.artworkKey).whereType<String>().firstOrNull;
    final ranked = type == CollectionType.generated && (collectionKey == 'daily-top' || collectionKey == 'trending');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(data.title),
            actions: [
              if (type == CollectionType.artist) _PinArtistButton(artistKey: collectionKey),
              if (type == CollectionType.album) _FavoriteAlbumButton(albumKey: collectionKey, tracks: tracks),
              if (tracks.isNotEmpty)
                IconButton(
                  tooltip: 'Add all to a playlist',
                  icon: const Icon(Icons.playlist_add_rounded),
                  onPressed: () => showAddToPlaylistSheet(context, [for (final t in tracks) t.id]),
                ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.page),
              child: Column(
                children: [
                  ArtworkImage(
                    artworkKey: cover,
                    size: 200,
                    radius: Radii.lg,
                    circle: type == CollectionType.artist,
                    seed: data.title,
                    icon: type == CollectionType.artist ? Icons.person_rounded : Icons.album_rounded,
                  ),
                  const SizedBox(height: Spacing.lg),
                  Text(data.title, style: context.text.headlineSmall, textAlign: TextAlign.center),
                  if (data.subtitle?.isNotEmpty ?? false)
                    Padding(
                      padding: const EdgeInsets.only(top: Spacing.xs),
                      child: Text(
                        data.subtitle!,
                        textAlign: TextAlign.center,
                        style: context.text.bodyMedium?.copyWith(color: context.surfaces.muted),
                      ),
                    ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    '${tracks.length} song${tracks.length == 1 ? '' : 's'} · ${formatListening(totalMs)}',
                    style: context.text.bodySmall?.copyWith(color: context.surfaces.muted),
                  ),
                  const SizedBox(height: Spacing.lg),
                  if (tracks.isNotEmpty)
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('Play'),
                            onPressed: () => playback.playTracks(tracks, context: '${type.name}:$collectionKey'),
                          ),
                        ),
                        const SizedBox(width: Spacing.md),
                        Expanded(
                          child: FilledButton.tonalIcon(
                            icon: const Icon(Icons.shuffle_rounded),
                            label: const Text('Shuffle'),
                            onPressed: () => playback.shuffleTracks(tracks, context: '${type.name}:$collectionKey'),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          if (tracks.isEmpty)
            const SliverToBoxAdapter(
              child: EmptyState(
                icon: Icons.music_off_rounded,
                title: 'No songs here yet',
                message: 'Songs appear once your library has matching music.',
                compact: true,
              ),
            ),
          SliverList.builder(
            itemCount: tracks.length,
            itemBuilder: (context, i) => SongRow(
              track: tracks[i],
              leadingIndex: ranked || type == CollectionType.album
                  ? (type == CollectionType.album ? tracks[i].trackNumber ?? i + 1 : i + 1)
                  : null,
              showArtwork: type != CollectionType.album,
              onTap: () => playback.playTracks(tracks, startIndex: i, context: '${type.name}:$collectionKey'),
              onMore: () => showTrackMenu(context, ref, tracks[i]),
            ),
          ),
          const ShellBottomSpacer(),
        ],
      ),
    );
  }
}

class _PinArtistButton extends ConsumerWidget {
  const _PinArtistButton({required this.artistKey});

  final String artistKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinned = ref.watch(settingsProvider.select((s) => s.pinnedArtists.contains(artistKey)));
    return IconButton(
      tooltip: pinned ? 'Unpin from Home' : 'Pin to Home',
      icon: Icon(pinned ? Icons.push_pin_rounded : Icons.push_pin_outlined),
      onPressed: () => ref
          .read(settingsProvider.notifier)
          .update(
            (s) => s.copyWith(
              pinnedArtists: pinned
                  ? (s.pinnedArtists.where((k) => k != artistKey).toList())
                  : [...s.pinnedArtists, artistKey],
            ),
          ),
    );
  }
}

class _FavoriteAlbumButton extends ConsumerWidget {
  const _FavoriteAlbumButton({required this.albumKey, required this.tracks});

  final String albumKey;
  final List<Track> tracks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorite = ref.watch(favoriteAlbumKeysProvider).value?.contains(albumKey) ?? false;
    return IconButton(
      tooltip: favorite ? 'Remove album from favorites' : 'Add album to favorites',
      icon: Icon(
        favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        color: favorite ? context.colors.primary : null,
      ),
      onPressed: () => ref
          .read(databaseProvider)
          .tracksDao
          .setAlbumFavorite(albumKey, tracks.firstOrNull?.artistKey ?? '', !favorite),
    );
  }
}

/// "More like this" for a chosen song, with the reasons shown.
class SimilarScreen extends ConsumerWidget {
  const SimilarScreen({super.key, required this.trackId});

  final String trackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seed = ref.watch(trackProvider(trackId)).value;
    final similar = ref.watch(similarToProvider(trackId));
    final tracks = [for (final s in similar) s.track];
    return Scaffold(
      appBar: AppBar(title: Text(seed == null ? 'More like this' : 'More like ${seed.title}')),
      body: similar.isEmpty
          ? const EmptyState(
              icon: Icons.auto_awesome_rounded,
              title: 'No similar songs found',
              message: 'Recommendations use shared artist, album, genre, language and tags. Add details to your songs to improve them.',
            )
          : ListView.builder(
              itemCount: similar.length + 1,
              itemBuilder: (context, i) {
                if (i == similar.length) return const ShellBottomSpacer(sliver: false);
                return SongRow(
                  track: similar[i].track,
                  trailing: Text(similar[i].reasons.join(', '), style: context.text.bodySmall),
                  onTap: () =>
                      ref.read(playbackControllerProvider).playTracks(tracks, startIndex: i, context: 'similar'),
                  onMore: () => showTrackMenu(context, ref, similar[i].track),
                );
              },
            ),
    );
  }
}
