import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../audio/playback_controller.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/artwork_image.dart';
import '../../core/widgets/now_playing_bars.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/track_widgets.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/settings_repository.dart';
import '../import_music/import_hub.dart';
import '../library/library_providers.dart';
import '../shell/app_shell.dart';
import 'home_providers.dart';
import 'home_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(trackCountProvider);
    final sections = ref.watch(settingsProvider.select((s) => s.homeSections));
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: _HomeHeader()),
          ...switch (count) {
            AsyncData(value: 0) => [
              SliverToBoxAdapter(
                child: EmptyState(
                  icon: Icons.library_music_rounded,
                  title: 'Your library is empty',
                  message: 'Import songs stored on this device. Everything stays offline and private.',
                  action: Consumer(
                    builder: (context, ref, _) => FilledButton.icon(
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Import music'),
                      onPressed: () => startFileImport(context, ref),
                    ),
                  ),
                ),
              ),
            ],
            AsyncData() => [
              for (final s in sections)
                if (s.visible) SliverToBoxAdapter(child: _sectionFor(s.id)),
            ],
            _ => [const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))],
          },
          const ShellBottomSpacer(),
        ],
      ),
    );
  }

  Widget _sectionFor(HomeSectionId id) => switch (id) {
    HomeSectionId.continueListening => const _ContinueListening(),
    HomeSectionId.heavyRotation => const _HeavyRotation(),
    HomeSectionId.topPicks => const _TopPicks(),
    HomeSectionId.recentlyPlayed => const _RecentlyPlayed(),
    HomeSectionId.moods => const _Moods(),
    HomeSectionId.moreLikeThis => const _MoreLikeThis(),
    HomeSectionId.bestOfArtists => const _BestOfArtists(),
    HomeSectionId.languages => const _Languages(),
    HomeSectionId.yearHits => const _YearHits(),
    HomeSectionId.favorites => const _Favorites(),
    HomeSectionId.pinned => const _Pinned(),
  };
}

class _HomeHeader extends ConsumerWidget {
  const _HomeHeader();

  String _greeting(DateTime now) {
    final h = now.hour;
    if (h < 5) return 'Good night';
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(settingsProvider.select((s) => s.userName));
    final greeting = _greeting(DateTime.now());
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Spacing.page, Spacing.lg, Spacing.sm, 0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatDate(DateTime.now()).toUpperCase(),
                    style: context.text.labelMedium?.copyWith(color: context.surfaces.muted, letterSpacing: 1.2),
                  ),
                  Semantics(
                    header: true,
                    child: Text(name == null ? greeting : '$greeting, $name', style: context.text.headlineMedium),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Replay: your top music',
              icon: const Icon(Icons.insights_rounded),
              onPressed: () => context.push(Routes.replay),
            ),
            IconButton(
              tooltip: 'Settings',
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push(Routes.settings),
            ),
          ],
        ),
      ),
    );
  }
}

void _openGenerated(BuildContext context, String id) => context.push(Routes.collection(CollectionType.generated, id));

class _ContinueListening extends ConsumerWidget {
  const _ContinueListening();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracks = ref.watch(continueListeningProvider);
    return HomeSection(
      title: 'Continue Listening',
      isEmpty: tracks.isEmpty,
      onSeeAll: () => _openGenerated(context, 'continue'),
      child: SizedBox(
        height: 92,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
          itemCount: tracks.length,
          separatorBuilder: (_, _) => const SizedBox(width: Spacing.md),
          itemBuilder: (context, i) => _ResumeCard(track: tracks[i]),
        ),
      ),
    );
  }
}

class _ResumeCard extends ConsumerWidget {
  const _ResumeCard({required this.track});

  final Track track;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playback = ref.read(playbackControllerProvider);
    final progress = (track.lastPositionMs ?? 0) / (track.durationMs ?? 1);
    // The song that is playing shows animated bars instead of resume controls.
    final isCurrent = ref.watch(currentTrackIdProvider) == track.id;
    final art = ArtworkImage(artworkKey: track.artworkKey, size: 76, radius: Radii.md, seed: track.title);
    return Container(
      width: 280,
      decoration: BoxDecoration(color: context.surfaces.raised, borderRadius: BorderRadius.circular(Radii.lg)),
      padding: const EdgeInsets.all(Spacing.sm),
      child: Row(
        children: [
          isCurrent ? NowPlayingOverlay(radius: Radii.md, barSize: 26, child: art) : art,
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  track.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.titleSmall?.copyWith(color: isCurrent ? context.colors.primary : null),
                ),
                if (isCurrent)
                  Text('Playing now', style: context.text.bodySmall?.copyWith(color: context.colors.primary))
                else ...[
                  Text(
                    '${formatMs(track.lastPositionMs)} of ${formatMs(track.durationMs)}',
                    style: context.text.bodySmall?.copyWith(color: context.surfaces.muted),
                  ),
                  const SizedBox(height: Spacing.sm),
                  LinearProgressIndicator(value: progress.clamp(0, 1), borderRadius: BorderRadius.circular(2)),
                ],
              ],
            ),
          ),
          if (!isCurrent) ...[
            PopupMenuButton<String>(
              tooltip: 'Resume options',
              onSelected: (v) {
                switch (v) {
                  case 'resume':
                    playback.resume(track);
                  case 'restart':
                    playback.playTracks([track]);
                  case 'remove':
                    ref.read(libraryRepositoryProvider).tracks.setLastPosition(track.id, null);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'resume', child: Text('Resume')),
                PopupMenuItem(value: 'restart', child: Text('Play from start')),
                PopupMenuItem(value: 'remove', child: Text('Remove from Continue Listening')),
              ],
              icon: const Icon(Icons.more_vert_rounded),
            ),
            IconButton.filledTonal(
              tooltip: 'Resume ${track.title}',
              icon: const Icon(Icons.play_arrow_rounded),
              onPressed: () => playback.resume(track),
            ),
          ],
        ],
      ),
    );
  }
}

class _HeavyRotation extends ConsumerWidget {
  const _HeavyRotation();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracks = ref.watch(heavyRotationProvider);
    return HomeSection(
      title: 'Heavy Rotation',
      subtitle: 'Your most played lately',
      isEmpty: tracks.isEmpty,
      empty: const _Hint('Play some music and your favorites will gather here.'),
      onSeeAll: () => _openGenerated(context, 'heavy-rotation'),
      child: TrackCarousel(tracks: tracks.take(15).toList(), size: 168, context: 'heavy-rotation'),
    );
  }
}

class _TopPicks extends ConsumerWidget {
  const _TopPicks();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final picks = ref.watch(topPicksProvider);
    return HomeSection(
      title: 'Top Picks for You',
      subtitle: 'Built from your plays, favorites and tags',
      isEmpty: picks.isEmpty,
      empty: const _Hint('Not enough listening history yet. Favorite and play songs to get personal picks.'),
      child: CollectionCarousel(collections: picks),
    );
  }
}

class _RecentlyPlayed extends ConsumerWidget {
  const _RecentlyPlayed();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracks = ref.watch(recentlyPlayedProvider).value ?? const [];
    return HomeSection(
      title: 'Recently Played',
      isEmpty: tracks.isEmpty,
      onSeeAll: () => _openGenerated(context, 'recently-played'),
      child: TrackCarousel(tracks: tracks.take(20).toList(), size: 132, context: 'recently-played'),
    );
  }
}

class _Moods extends ConsumerWidget {
  const _Moods();

  static const _icons = {
    Mood.chill: Icons.spa_rounded,
    Mood.focus: Icons.center_focus_strong_rounded,
    Mood.workout: Icons.fitness_center_rounded,
    Mood.party: Icons.celebration_rounded,
    Mood.sad: Icons.water_drop_rounded,
    Mood.romantic: Icons.favorite_rounded,
    Mood.feelGood: Icons.wb_sunny_rounded,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moods = Mood.values.where((m) => m != Mood.feelGood).toList();
    return HomeSection(
      title: 'Find Your Mood',
      subtitle: 'From your mood tags and song genres',
      child: SizedBox(
        height: 104,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
          itemCount: moods.length,
          separatorBuilder: (_, _) => const SizedBox(width: Spacing.md),
          itemBuilder: (context, i) {
            final mood = moods[i];
            final count = ref.watch(moodTracksProvider(mood)).length;
            final hue = (i * 47 + 330) % 360;
            final dark = context.theme.brightness == Brightness.dark;
            return Semantics(
              button: true,
              label: '${mood.label}, $count songs',
              excludeSemantics: true,
              child: InkWell(
                borderRadius: BorderRadius.circular(Radii.lg),
                onTap: () => context.push(Routes.collection(CollectionType.mood, mood.name)),
                child: Container(
                  width: 150,
                  padding: const EdgeInsets.all(Spacing.md),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Radii.lg),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        HSLColor.fromAHSL(1, hue.toDouble(), 0.55, dark ? 0.32 : 0.7).toColor(),
                        HSLColor.fromAHSL(1, (hue + 35) % 360, 0.5, dark ? 0.16 : 0.85).toColor(),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(_icons[mood]),
                      Text(mood.label, style: context.text.titleMedium),
                      Text('$count songs', style: context.text.bodySmall),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MoreLikeThis extends ConsumerWidget {
  const _MoreLikeThis();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seed = ref.watch(moreLikeThisSeedProvider);
    if (seed == null) return const SizedBox.shrink();
    final similar = ref.watch(similarToProvider(seed.id));
    return HomeSection(
      title: 'More Like ${seed.title}',
      subtitle: similar.isEmpty ? null : 'Shared artist, genre, language and tags',
      isEmpty: similar.isEmpty,
      onSeeAll: () => context.push(Routes.similar(seed.id)),
      child: TrackCarousel(tracks: [for (final s in similar) s.track], context: 'similar'),
    );
  }
}

class _BestOfArtists extends ConsumerWidget {
  const _BestOfArtists();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artists = ref.watch(bestOfArtistsProvider);
    return HomeSection(
      title: 'Best of Your Artists',
      isEmpty: artists.isEmpty,
      child: HorizontalCarousel(
        height: 196,
        itemCount: artists.length,
        itemBuilder: (context, i) {
          final a = artists[i];
          return ArtworkCard(
            artworkKey: a.coverKey,
            title: 'Best of ${a.name}',
            subtitle: '${a.tracks.length} songs',
            size: 140,
            circle: true,
            icon: Icons.person_rounded,
            onTap: () => _openGenerated(context, 'best-of-${a.artistKey}'),
          );
        },
      ),
    );
  }
}

class _Languages extends ConsumerWidget {
  const _Languages();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(languagesProvider).value ?? const [];
    return HomeSection(
      title: 'By Language',
      subtitle: 'From song tags or your edits',
      isEmpty: groups.isEmpty,
      child: HorizontalCarousel(
        height: 196,
        itemCount: groups.length,
        itemBuilder: (context, i) {
          final g = groups[i];
          return ArtworkCard(
            artworkKey: g.artworkKey,
            title: '${g.name} Music',
            subtitle: '${g.trackCount} songs',
            size: 140,
            icon: Icons.translate_rounded,
            onTap: () => context.push(Routes.collection(CollectionType.language, g.key)),
          );
        },
      ),
    );
  }
}

class _YearHits extends ConsumerWidget {
  const _YearHits();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final years = (ref.watch(yearsProvider).value ?? const []).where((g) => g.trackCount >= 3).toList();
    return HomeSection(
      title: 'Year Hits',
      subtitle: 'By release year in the song tags',
      isEmpty: years.isEmpty,
      child: HorizontalCarousel(
        height: 196,
        itemCount: years.length,
        itemBuilder: (context, i) {
          final g = years[i];
          return ArtworkCard(
            artworkKey: g.artworkKey,
            title: '${g.name} Hits',
            subtitle: '${g.trackCount} songs',
            size: 140,
            icon: Icons.calendar_month_rounded,
            onTap: () => context.push(Routes.collection(CollectionType.year, g.key)),
          );
        },
      ),
    );
  }
}

class _Favorites extends ConsumerWidget {
  const _Favorites();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracks = ref.watch(favoritesProvider).value ?? const [];
    final albumKeys = ref.watch(favoriteAlbumKeysProvider).value ?? const {};
    final albums = (ref.watch(albumsProvider).value ?? const []).where((a) => albumKeys.contains(a.key)).toList();
    return HomeSection(
      title: 'Favorites',
      isEmpty: tracks.isEmpty && albums.isEmpty,
      empty: const _Hint('Tap the heart on any song to keep it here.'),
      onSeeAll: () => context.push(Routes.collection(CollectionType.favorites, 'all')),
      child: Column(
        children: [
          if (tracks.isNotEmpty) TrackCarousel(tracks: tracks, size: 132, context: 'favorites'),
          if (albums.isNotEmpty) ...[
            const SizedBox(height: Spacing.md),
            HorizontalCarousel(
              height: 184,
              itemCount: albums.length,
              itemBuilder: (context, i) => ArtworkCard(
                artworkKey: albums[i].artworkKey,
                title: albums[i].name,
                subtitle: albums[i].subtitle,
                size: 132,
                icon: Icons.album_rounded,
                onTap: () => context.push(Routes.collection(CollectionType.album, albums[i].key)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Pinned extends ConsumerWidget {
  const _Pinned();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final playlists = (ref.watch(playlistsProvider).value ?? const [])
        .where((p) => settings.pinnedPlaylists.contains(p.playlist.id))
        .toList();
    final artists = (ref.watch(artistsProvider).value ?? const [])
        .where((a) => settings.pinnedArtists.contains(a.key))
        .toList();
    final count = playlists.length + artists.length;
    return HomeSection(
      title: 'Pinned',
      isEmpty: count == 0,
      child: HorizontalCarousel(
        height: 196,
        itemCount: count,
        itemBuilder: (context, i) {
          if (i < playlists.length) {
            final p = playlists[i];
            return ArtworkCard(
              artworkKey: null,
              mosaic: p.coverKeys,
              title: p.playlist.name,
              subtitle: '${p.trackCount} songs',
              size: 140,
              onTap: () => context.push(Routes.playlist(p.playlist.id)),
            );
          }
          final a = artists[i - playlists.length];
          return ArtworkCard(
            artworkKey: a.artworkKey,
            title: a.name,
            subtitle: '${a.trackCount} songs',
            size: 140,
            circle: true,
            icon: Icons.person_rounded,
            onTap: () => context.push(Routes.collection(CollectionType.artist, a.key)),
          );
        },
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
    child: Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(color: context.surfaces.raised, borderRadius: BorderRadius.circular(Radii.lg)),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline_rounded, color: context.surfaces.muted),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Text(text, style: context.text.bodyMedium?.copyWith(color: context.surfaces.muted)),
          ),
        ],
      ),
    ),
  );
}
