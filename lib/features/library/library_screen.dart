import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../audio/playback_controller.dart';
import '../../core/widgets/artwork_image.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/track_widgets.dart';
import '../../data/database/app_database.dart';
import '../../data/database/daos/tracks_dao.dart';
import '../home/home_providers.dart';
import '../home/recommendations.dart';
import '../import_music/import_hub.dart';
import '../playlists/playlist_actions.dart';
import '../shell/app_shell.dart';
import 'library_providers.dart';
import 'track_menu.dart';

/// Library categories, in the required order.
enum LibraryCategory {
  playlists('Playlists', Icons.queue_music_rounded),
  artists('Artists', Icons.mic_external_on_rounded),
  albums('Albums', Icons.album_rounded),
  songs('Songs', Icons.music_note_rounded),
  madeForYou('Made for You', Icons.auto_awesome_rounded),
  tv('TV', Icons.tv_rounded),
  genres('Genres', Icons.category_rounded),
  compilations('Compilations', Icons.library_books_rounded),
  composers('Composers', Icons.edit_note_rounded);

  const LibraryCategory(this.label, this.icon);
  final String label;
  final IconData icon;
}

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recent = ref.watch(recentlyAddedProvider);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(pinned: true, title: Text('Library')),
          SliverList.list(
            children: [
              for (final c in LibraryCategory.values)
                ListTile(
                  leading: Icon(c.icon, color: context.colors.primary),
                  title: Text(c.label, style: context.text.titleMedium),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('${Routes.library}/${c.name}'),
                ),
            ],
          ),
          const SliverToBoxAdapter(
            child: SectionHeader(title: 'Recently Added', subtitle: 'By date imported'),
          ),
          AsyncView(
            sliver: true,
            value: recent,
            data: (tracks) => tracks.isEmpty
                ? EmptyState(
                    icon: Icons.library_add_rounded,
                    title: 'No music yet',
                    message: 'Imported songs appear here.',
                    action: FilledButton(
                      onPressed: () => startFileImport(context, ref),
                      child: const Text('Import music'),
                    ),
                  )
                : Column(
                    children: [
                      for (var i = 0; i < tracks.length; i++)
                        SongRow(
                          track: tracks[i],
                          onTap: () => ref
                              .read(playbackControllerProvider)
                              .playTracks(tracks, startIndex: i, context: 'recently-added'),
                          onMore: () => showTrackMenu(context, ref, tracks[i]),
                        ),
                    ],
                  ),
          ),
          const ShellBottomSpacer(),
        ],
      ),
    );
  }
}

/// A category page with the category switcher pinned on top.
class LibraryCategoryScreen extends ConsumerWidget {
  const LibraryCategoryScreen({super.key, required this.category});

  final LibraryCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.label),
        actions: [
          if (category == LibraryCategory.songs) const _SortButton(view: 'songs'),
          if (category == LibraryCategory.playlists)
            IconButton(
              tooltip: 'New playlist',
              icon: const Icon(Icons.add_rounded),
              onPressed: () => createPlaylistFlow(context, ref),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: Spacing.page, vertical: Spacing.sm),
              children: [
                for (final c in LibraryCategory.values)
                  Padding(
                    padding: const EdgeInsets.only(right: Spacing.sm),
                    child: ChoiceChip(
                      label: Text(c.label),
                      selected: c == category,
                      onSelected: (_) => context.pushReplacement('${Routes.library}/${c.name}'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: switch (category) {
        LibraryCategory.playlists => const _PlaylistsView(),
        LibraryCategory.artists => _GroupList(
          provider: artistsProvider,
          type: CollectionType.artist,
          circle: true,
          emptyMessage: 'Artists come from song tags. Edit a song to add its artist.',
        ),
        LibraryCategory.albums => _GroupGrid(provider: albumsProvider, emptyMessage: 'Albums come from song tags.'),
        LibraryCategory.songs => const _SongsView(),
        LibraryCategory.madeForYou => const _MadeForYouView(),
        LibraryCategory.tv => const _TvView(),
        LibraryCategory.genres => _GroupList(
          provider: genresProvider,
          type: CollectionType.genre,
          emptyMessage: 'No genres found in your song tags. You can set a genre by editing a song.',
        ),
        LibraryCategory.compilations => _GroupGrid(
          provider: compilationsProvider,
          emptyMessage:
              'Compilations are albums marked as compilations or credited to "Various Artists". '
              'Mark an album as a compilation by editing one of its songs.',
        ),
        LibraryCategory.composers => _GroupList(
          provider: composersProvider,
          type: CollectionType.composer,
          emptyMessage: 'No composer information yet. Most files do not include it — add it by editing a song.',
        ),
      },
    );
  }
}

class _SortButton extends ConsumerWidget {
  const _SortButton({required this.view});

  final String view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pref = ref.watch(settingsProvider.select((s) => s.sortFor(view)));
    return PopupMenuButton<TrackSort>(
      tooltip: 'Sort',
      icon: const Icon(Icons.sort_rounded),
      onSelected: (sort) {
        final descending = sort == pref.sort
            ? !pref.descending
            : (sort == TrackSort.dateAdded || sort == TrackSort.playCount);
        ref.read(settingsProvider.notifier).setSort(view, sort, descending);
      },
      itemBuilder: (_) => [
        for (final s in TrackSort.values)
          PopupMenuItem(
            value: s,
            child: Row(
              children: [
                Expanded(child: Text(s.label)),
                if (s == pref.sort)
                  Icon(pref.descending ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded, size: 18),
              ],
            ),
          ),
      ],
    );
  }
}

/// Songs list loaded in growing pages as the user scrolls.
class _SongsView extends ConsumerStatefulWidget {
  const _SongsView();

  @override
  ConsumerState<_SongsView> createState() => _SongsViewState();
}

class _SongsViewState extends ConsumerState<_SongsView> {
  static const _page = 100;
  int _limit = _page;

  @override
  Widget build(BuildContext context) {
    final pref = ref.watch(settingsProvider.select((s) => s.sortFor('songs')));
    final total = ref.watch(trackCountProvider).value ?? 0;
    final songs = ref.watch(songsProvider((sort: pref.sort, descending: pref.descending, limit: _limit)));
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n.metrics.extentAfter < 800 && _limit < total) setState(() => _limit += _page);
        return false;
      },
      child: AsyncView(
        value: songs,
        data: (tracks) {
          if (tracks.isEmpty) {
            return const EmptyState(
              icon: Icons.music_note_rounded,
              title: 'No songs',
              message: 'Import music to fill your library.',
            );
          }
          return ListView.builder(
            itemCount: tracks.length + 2,
            itemBuilder: (context, i) {
              if (i == 0) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(Spacing.page, Spacing.sm, Spacing.page, Spacing.sm),
                  child: Row(
                    children: [
                      Text('$total songs', style: context.text.bodySmall?.copyWith(color: context.surfaces.muted)),
                      const Spacer(),
                      FilledButton.tonalIcon(
                        icon: const Icon(Icons.shuffle_rounded),
                        label: const Text('Shuffle all'),
                        onPressed: () async {
                          final all = await ref.read(databaseProvider).tracksDao.allTracks();
                          await ref.read(playbackControllerProvider).shuffleTracks(all, context: 'songs');
                        },
                      ),
                    ],
                  ),
                );
              }
              if (i == tracks.length + 1) return const ShellBottomSpacer(sliver: false);
              final t = tracks[i - 1];
              return SongRow(
                track: t,
                onTap: () =>
                    ref.read(playbackControllerProvider).playTracks(tracks, startIndex: i - 1, context: 'songs'),
                onMore: () => showTrackMenu(context, ref, t),
              );
            },
          );
        },
      ),
    );
  }
}

class _PlaylistsView extends ConsumerWidget {
  const _PlaylistsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncView(
      value: ref.watch(playlistsProvider),
      data: (list) => ListView(
        children: [
          const FavouriteSongsTile(),
          ListTile(
            leading: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: context.surfaces.overlay, borderRadius: BorderRadius.circular(Radii.md)),
              child: Icon(Icons.add_rounded, color: context.colors.primary),
            ),
            title: const Text('New playlist'),
            onTap: () => createPlaylistFlow(context, ref),
          ),
          if (list.isEmpty)
            const EmptyState(
              icon: Icons.queue_music_rounded,
              title: 'No playlists',
              message: 'Create one to organise your music.',
              compact: true,
            ),
          for (final p in list)
            ListTile(
              minTileHeight: 72,
              leading: MosaicCover(keys: p.coverKeys, size: 56, seed: p.playlist.name),
              title: Text(p.playlist.name, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text('${p.trackCount} songs'),
              onTap: () => context.push(Routes.playlist(p.playlist.id)),
            ),
          const ShellBottomSpacer(sliver: false),
        ],
      ),
    );
  }
}

/// The built-in "Favourite Songs" playlist: every song with a heart, always
/// first, and never sorted or reordered by hand.
class FavouriteSongsTile extends ConsumerWidget {
  const FavouriteSongsTile({super.key});

  static const title = 'Favourite Songs';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(favoritesProvider).value?.length ?? 0;
    return ListTile(
      minTileHeight: 72,
      leading: const FavouriteSongsCover(size: 56),
      title: const Text(title),
      subtitle: Text(count == 0 ? 'Tap the heart on a song to add it' : '$count song${count == 1 ? '' : 's'}'),
      onTap: () => context.push(Routes.collection(CollectionType.favorites, 'all')),
    );
  }
}

class FavouriteSongsCover extends StatelessWidget {
  const FavouriteSongsCover({super.key, required this.size, this.radius = Radii.md});

  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [context.colors.primary, context.colors.tertiary],
      ),
    ),
    child: Icon(Icons.favorite_rounded, color: Colors.white, size: size * 0.45),
  );
}

class _GroupList extends ConsumerWidget {
  const _GroupList({required this.provider, required this.type, required this.emptyMessage, this.circle = false});

  final StreamProvider<List<TrackGroup>> provider;
  final CollectionType type;
  final String emptyMessage;
  final bool circle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncView(
      value: ref.watch(provider),
      data: (groups) => groups.isEmpty
          ? EmptyState(icon: Icons.info_outline_rounded, title: 'Nothing here yet', message: emptyMessage)
          : ListView.builder(
              itemCount: groups.length + 1,
              itemBuilder: (context, i) {
                if (i == groups.length) return const ShellBottomSpacer(sliver: false);
                final g = groups[i];
                return ListTile(
                  minTileHeight: 68,
                  leading: ArtworkImage(
                    artworkKey: g.artworkKey,
                    size: 52,
                    circle: circle,
                    icon: circle ? Icons.person_rounded : Icons.category_rounded,
                    seed: g.name,
                  ),
                  title: Text(g.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('${g.trackCount} song${g.trackCount == 1 ? '' : 's'}'),
                  onTap: () => context.push(Routes.collection(type, g.key)),
                );
              },
            ),
    );
  }
}

class _GroupGrid extends ConsumerWidget {
  const _GroupGrid({required this.provider, required this.emptyMessage});

  final StreamProvider<List<TrackGroup>> provider;
  final String emptyMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncView(
      value: ref.watch(provider),
      data: (groups) => groups.isEmpty
          ? EmptyState(icon: Icons.album_outlined, title: 'Nothing here yet', message: emptyMessage)
          : LayoutBuilder(
              builder: (context, c) {
                final columns = (c.maxWidth / 190).floor().clamp(2, 6);
                final size = (c.maxWidth - Spacing.page * 2 - Spacing.lg * (columns - 1)) / columns;
                final scale = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.6);
                return GridView.builder(
                  padding: EdgeInsets.fromLTRB(
                    Spacing.page,
                    Spacing.md,
                    Spacing.page,
                    MediaQuery.paddingOf(context).bottom + Spacing.xl,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: Spacing.lg,
                    mainAxisSpacing: Spacing.lg,
                    mainAxisExtent: size + 52 * scale,
                  ),
                  itemCount: groups.length,
                  itemBuilder: (context, i) => ArtworkCard(
                    artworkKey: groups[i].artworkKey,
                    title: groups[i].name,
                    subtitle: groups[i].subtitle ?? '${groups[i].trackCount} songs',
                    size: size,
                    icon: Icons.album_rounded,
                    onTap: () => context.push(Routes.collection(CollectionType.album, groups[i].key)),
                  ),
                );
              },
            ),
    );
  }
}

class _MadeForYouView extends ConsumerWidget {
  const _MadeForYouView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = <Collection>[
      ...ref.watch(topPicksProvider),
      for (final id in const ['heavy-rotation', 'daily-top', 'trending'])
        if (ref.watch(generatedCollectionsProvider)[id] case final c? when c.tracks.isNotEmpty) c,
    ];
    final moods = [
      for (final m in Mood.values)
        if (ref.watch(moodTracksProvider(m)).isNotEmpty) m,
    ];
    if (collections.isEmpty && moods.isEmpty) {
      return const EmptyState(
        icon: Icons.auto_awesome_rounded,
        title: 'Nothing made for you yet',
        message: 'Personal collections are generated from your listening, favorites, tags and song details. Play and favorite songs to get started.',
      );
    }
    return ListView(
      children: [
        for (final c in collections)
          ListTile(
            minTileHeight: 72,
            leading: ArtworkImage(artworkKey: c.coverKey, size: 56, seed: c.title, icon: Icons.auto_awesome_rounded),
            title: Text(c.title),
            subtitle: Text('${c.reason} · ${c.tracks.length} songs'),
            onTap: () => context.push(Routes.collection(CollectionType.generated, c.id)),
          ),
        for (final m in moods)
          ListTile(
            minTileHeight: 72,
            leading: ArtworkImage(
              artworkKey: ref.watch(moodTracksProvider(m)).first.artworkKey,
              size: 56,
              seed: m.label,
            ),
            title: Text('${m.label} Mix'),
            subtitle: const Text('From your mood tags and genres'),
            onTap: () => context.push(Routes.collection(CollectionType.mood, m.name)),
          ),
        const ShellBottomSpacer(sliver: false),
      ],
    );
  }
}

/// TV: imported TV soundtracks and songs the user tags "TV". Never filled
/// with content the user did not import.
class _TvView extends ConsumerWidget {
  const _TvView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracks = ref.watch(tvTracksProvider);
    if (tracks.isEmpty) {
      return const EmptyState(
        icon: Icons.tv_rounded,
        title: 'TV music',
        message:
            'This collects TV soundtracks and theme songs from your own library: songs with a TV or soundtrack genre, '
            'or songs you tag "TV" from the song menu → Moods and tags.',
      );
    }
    return ListView.builder(
      itemCount: tracks.length,
      itemBuilder: (context, i) => SongRow(
        track: tracks[i],
        onTap: () => ref.read(playbackControllerProvider).playTracks(tracks, startIndex: i, context: 'tv'),
        onMore: () => showTrackMenu(context, ref, tracks[i]),
      ),
    );
  }
}

final tvTracksProvider = Provider<List<Track>>((ref) {
  final tracks = ref.watch(allTracksProvider).value ?? const [];
  final tags = ref.watch(userTagsProvider).value ?? const [];
  final memberships = ref.watch(membershipsProvider).value ?? const [];
  final tvTagIds = tags.where((t) => t.name.toLowerCase() == 'tv').map((t) => t.id).toSet();
  final tagged = {
    for (final m in memberships)
      if (tvTagIds.contains(m.tagId) && !m.excluded) m.trackId,
  };
  return tracks.where((t) {
    if (tagged.contains(t.id)) return true;
    final g = (t.genre ?? '').toLowerCase();
    return g.contains('tv') || g.contains('television') || g.contains('soundtrack');
  }).toList()..sort((a, b) => a.titleKey.compareTo(b.titleKey));
});
