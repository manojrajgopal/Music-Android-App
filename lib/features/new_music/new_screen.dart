import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../audio/playback_controller.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/artwork_image.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/track_widgets.dart';
import '../../data/database/app_database.dart';
import '../../data/database/daos/tracks_dao.dart';
import '../home/home_providers.dart';
import '../home/home_widgets.dart';
import '../import_music/import_hub.dart';
import '../library/library_providers.dart';
import '../library/track_menu.dart';
import '../shell/app_shell.dart';
import 'rankings.dart';

class NewFilterController extends Notifier<TrackFilter> {
  @override
  TrackFilter build() => const TrackFilter();

  void set(TrackFilter f) => state = f;
  void clear() => state = const TrackFilter();
}

final newFilterProvider = NotifierProvider<NewFilterController, TrackFilter>(NewFilterController.new);

List<Track> _filter(List<Track> tracks, TrackFilter f) => f.isEmpty ? tracks : tracks.where(f.matches).toList();

/// Discovery inside the user's own library. "New" means newly added to this
/// device unless release-year tags say otherwise; rankings are local.
class NewScreen extends ConsumerWidget {
  const NewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(trackCountProvider).value;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: const Text('New'),
            actions: [
              IconButton(
                tooltip: 'About these sections',
                icon: const Icon(Icons.info_outline_rounded),
                onPressed: () => _explain(context),
              ),
            ],
          ),
          if (count == 0)
            SliverToBoxAdapter(
              child: EmptyState(
                icon: Icons.auto_awesome_rounded,
                title: 'Nothing new yet',
                message: 'Songs you import appear here, along with charts calculated from your own listening.',
                action: Consumer(
                  builder: (context, ref, _) =>
                      FilledButton(onPressed: () => startFileImport(context, ref), child: const Text('Import music')),
                ),
              ),
            )
          else ...const [
            SliverToBoxAdapter(child: _Filters()),
            SliverToBoxAdapter(child: _HuddleUp()),
            SliverToBoxAdapter(child: _BestNew()),
            SliverToBoxAdapter(child: _NewThisWeek()),
            SliverToBoxAdapter(child: _RecentReleases()),
            SliverToBoxAdapter(child: _Trending()),
            SliverToBoxAdapter(child: _FeelGood()),
            SliverToBoxAdapter(child: _DailyTop()),
            SliverToBoxAdapter(child: _DjMixes()),
          ],
          const ShellBottomSpacer(),
        ],
      ),
    );
  }

  void _explain(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    builder: (_) => const Padding(
      padding: EdgeInsets.fromLTRB(Spacing.page, 0, Spacing.page, Spacing.xl),
      child: Text(
        '• "New" means newly added to your library on this device.\n'
        '• Recent Releases uses the release year stored in song tags only.\n'
        '• Trending and Daily Top 100 are calculated from your own listening — '
        'they are not global or official charts.\n'
        '• Short taps under 30 seconds never count as plays.',
      ),
    ),
  );
}

class _Filters extends ConsumerWidget {
  const _Filters();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(newFilterProvider);
    final ctrl = ref.read(newFilterProvider.notifier);
    final languages = ref.watch(languagesProvider).value ?? const [];
    final years = ref.watch(yearsProvider).value ?? const [];
    final genres = ref.watch(genresProvider).value ?? const [];
    final artists = ref.watch(artistsProvider).value ?? const [];

    Future<void> pick<T>(String title, List<(String, T)> options, void Function(T?) apply) async {
      final result = await showModalBottomSheet<(bool, T?)>(
        context: context,
        isScrollControlled: true,
        builder: (context) => DraggableScrollableSheet(
          expand: false,
          builder: (context, controller) => ListView(
            controller: controller,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
                child: Text(title, style: context.text.titleLarge),
              ),
              ListTile(title: const Text('Any'), onTap: () => Navigator.pop(context, (true, null))),
              for (final (label, value) in options)
                ListTile(title: Text(label), onTap: () => Navigator.pop(context, (true, value))),
            ],
          ),
        ),
      );
      if (result != null) apply(result.$2);
    }

    Widget chip(String label, String? value, VoidCallback onTap) => Padding(
      padding: const EdgeInsets.only(right: Spacing.sm),
      child: FilterChip(
        label: Text(value ?? label),
        selected: value != null,
        onSelected: (_) => onTap(),
        avatar: value != null ? null : const Icon(Icons.expand_more_rounded, size: 18),
      ),
    );

    final artistName = artists.where((a) => a.key == filter.artistKey).firstOrNull?.name;
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
        children: [
          chip(
            'Language',
            filter.language,
            () => pick('Language', [
              for (final g in languages) (g.name, g.name),
            ], (v) => ctrl.set(filter.copyWith(language: v))),
          ),
          chip(
            'Year',
            filter.year?.toString(),
            () => pick('Release year', [
              for (final g in years) (g.name, int.parse(g.key)),
            ], (v) => ctrl.set(filter.copyWith(year: v))),
          ),
          chip(
            'Artist',
            artistName,
            () => pick('Artist', [
              for (final g in artists) (g.name, g.key),
            ], (v) => ctrl.set(filter.copyWith(artistKey: v))),
          ),
          chip(
            'Genre',
            filter.genre,
            () => pick('Genre', [for (final g in genres) (g.name, g.name)], (v) => ctrl.set(filter.copyWith(genre: v))),
          ),
          if (!filter.isEmpty)
            ActionChip(
              avatar: const Icon(Icons.close_rounded, size: 18),
              label: const Text('Clear'),
              onPressed: ctrl.clear,
            ),
        ],
      ),
    );
  }
}

class _HuddleUp extends ConsumerWidget {
  const _HuddleUp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(newFilterProvider);
    final playlists = ref.watch(playlistsProvider).value ?? const [];
    final featuredPlaylist = playlists.where((p) => p.trackCount > 0).firstOrNull;
    final recent = _filter(ref.watch(recentlyPlayedProvider).value ?? const [], filter);
    final added = _filter(ref.watch(bestNewSongsProvider), filter);

    final String title;
    final String reason;
    final VoidCallback onOpen;
    final String? cover;
    List<String> mosaic = const [];
    if (featuredPlaylist != null && filter.isEmpty) {
      title = featuredPlaylist.playlist.name;
      reason = 'Your most recently updated playlist';
      mosaic = featuredPlaylist.coverKeys;
      cover = mosaic.firstOrNull;
      onOpen = () => context.push(Routes.playlist(featuredPlaylist.playlist.id));
    } else if (recent.length >= 3) {
      title = 'Back in the Huddle';
      reason = 'A mix of what you played recently';
      cover = recent.first.artworkKey;
      onOpen = () => ref.read(playbackControllerProvider).playTracks(recent, context: 'huddle');
    } else if (added.isNotEmpty) {
      title = 'Fresh in Your Library';
      reason = 'Songs you added recently';
      cover = added.first.artworkKey;
      onOpen = () => ref.read(playbackControllerProvider).playTracks(added, context: 'huddle');
    } else {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.page, Spacing.lg, Spacing.page, 0),
      child: Semantics(
        button: true,
        label: 'Huddle Up: $title. $reason',
        excludeSemantics: true,
        child: InkWell(
          onTap: onOpen,
          borderRadius: BorderRadius.circular(Radii.xl),
          child: Container(
            height: 200,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Radii.xl), color: context.surfaces.raised),
            child: Stack(
              fit: StackFit.expand,
              children: [
                LayoutBuilder(
                  builder: (context, c) => mosaic.length >= 4
                      ? MosaicCover(keys: mosaic, size: c.maxWidth, radius: 0)
                      : ArtworkImage(artworkKey: cover, size: c.maxWidth, radius: 0, seed: title),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xE6000000)],
                    ),
                  ),
                ),
                Positioned(
                  left: Spacing.lg,
                  right: Spacing.lg,
                  bottom: Spacing.lg,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HUDDLE UP',
                        style: context.text.labelSmall?.copyWith(color: Colors.white70, letterSpacing: 1.6),
                      ),
                      Text(title, style: context.text.headlineSmall?.copyWith(color: Colors.white)),
                      Text(reason, style: context.text.bodySmall?.copyWith(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BestNew extends ConsumerWidget {
  const _BestNew();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracks = _filter(ref.watch(bestNewSongsProvider), ref.watch(newFilterProvider));
    if (tracks.isEmpty) {
      return const HomeSection(
        title: 'Best New Songs',
        isEmpty: true,
        empty: EmptyState(
          icon: Icons.new_releases_outlined,
          title: 'No recent additions',
          message: 'Songs added in the last 30 days appear here.',
          compact: true,
        ),
        child: SizedBox.shrink(),
      );
    }
    final shown = tracks.take(12).toList();
    return HomeSection(
      title: 'Best New Songs',
      subtitle: 'Newly added to your library',
      onSeeAll: () => context.push(Routes.collection(CollectionType.generated, 'best-new')),
      child: LayoutBuilder(
        builder: (context, c) {
          final columns = c.maxWidth >= 840 ? 4 : (c.maxWidth >= 560 ? 3 : 2);
          const gap = Spacing.md;
          final width = (c.maxWidth - Spacing.page * 2 - gap * (columns - 1)) / columns;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
            child: Wrap(
              spacing: gap,
              runSpacing: Spacing.lg,
              children: [
                for (var i = 0; i < shown.length; i++)
                  ArtworkCard(
                    artworkKey: shown[i].artworkKey,
                    title: shown[i].title,
                    subtitle: '${shown[i].artist ?? 'Unknown artist'} · added ${formatDate(shown[i].dateAdded)}',
                    size: width,
                    playing: shown[i].id == ref.watch(currentTrackIdProvider),
                    onTap: () =>
                        ref.read(playbackControllerProvider).playTracks(shown, startIndex: i, context: 'best-new'),
                    onLongPress: () => showTrackMenu(context, ref, shown[i]),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NewThisWeek extends ConsumerWidget {
  const _NewThisWeek();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracks = _filter(ref.watch(newThisWeekProvider), ref.watch(newFilterProvider));
    return HomeSection(
      title: 'New This Week',
      subtitle: 'Imported since Monday',
      isEmpty: tracks.isEmpty,
      onSeeAll: () => context.push(Routes.collection(CollectionType.generated, 'new-this-week')),
      child: TrackCarousel(tracks: tracks.take(20).toList(), size: 132, context: 'new-this-week'),
    );
  }
}

class _RecentReleases extends ConsumerWidget {
  const _RecentReleases();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = DateTime.now().year;
    final tracks =
        _filter(
          ref.watch(allTracksProvider).value ?? const [],
          ref.watch(newFilterProvider),
        ).where((t) => t.releaseYear != null && t.releaseYear! >= year - 1).toList()..sort((a, b) {
          final c = b.releaseYear!.compareTo(a.releaseYear!);
          return c != 0 ? c : b.dateAdded.compareTo(a.dateAdded);
        });
    return HomeSection(
      title: 'Recent Releases',
      subtitle: 'Release year $year or ${year - 1}, from song tags',
      isEmpty: tracks.isEmpty,
      onSeeAll: () => context.push(Routes.collection(CollectionType.year, '$year')),
      child: TrackCarousel(tracks: tracks.take(20).toList(), context: 'recent-releases'),
    );
  }
}

class _Trending extends ConsumerWidget {
  const _Trending();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(newFilterProvider);
    final ranked = ref.watch(trendingProvider).where((r) => filter.isEmpty || filter.matches(r.track)).toList();
    return HomeSection(
      title: 'Trending in Your Library',
      subtitle: 'Local trend: last 7 days vs. the 3 weeks before',
      isEmpty: ranked.isEmpty,
      empty: const _Note('Trends appear once you have played songs repeatedly this week.'),
      onSeeAll: () => context.push(Routes.collection(CollectionType.generated, 'trending')),
      child: TrackCarousel(tracks: [for (final r in ranked) r.track], ranked: true, context: 'trending'),
    );
  }
}

class _FeelGood extends ConsumerWidget {
  const _FeelGood();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracks = _filter(ref.watch(moodTracksProvider(Mood.feelGood)), ref.watch(newFilterProvider));
    return HomeSection(
      title: 'Feel Good',
      subtitle: 'From your mood tags, genres and favorites — edit from any song menu',
      isEmpty: tracks.isEmpty,
      empty: const _Note('Add songs to the Feel Good mood from a song\'s menu → Moods and tags.'),
      onSeeAll: () => context.push(Routes.collection(CollectionType.mood, Mood.feelGood.name)),
      child: TrackCarousel(tracks: tracks.take(20).toList(), context: 'feel-good'),
    );
  }
}

class _DailyTop extends ConsumerWidget {
  const _DailyTop();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(newFilterProvider);
    final ranked = ref.watch(dailyTopProvider).where((r) => filter.isEmpty || filter.matches(r.track)).toList();
    final shown = ranked.take(5).toList();
    return HomeSection(
      title: 'Daily Top 100',
      subtitle: 'Your library only · 3 × weekly plays + monthly plays + ¼ all-time plays',
      isEmpty: ranked.isEmpty,
      empty: const _Note('Play some songs to build your personal chart.'),
      onSeeAll: () => context.push(Routes.collection(CollectionType.generated, 'daily-top')),
      child: Column(
        children: [
          for (var i = 0; i < shown.length; i++)
            SongRow(
              track: shown[i].track,
              leadingIndex: i + 1,
              trailing: Text('${shown[i].score.toStringAsFixed(1)} pts', style: context.text.bodySmall),
              onTap: () => ref
                  .read(playbackControllerProvider)
                  .playTracks([for (final r in ranked) r.track], startIndex: i, context: 'daily-top'),
              onMore: () => showTrackMenu(context, ref, shown[i].track),
            ),
        ],
      ),
    );
  }
}

class _DjMixes extends ConsumerWidget {
  const _DjMixes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(userTagsProvider).value ?? const [];
    final memberships = ref.watch(membershipsProvider).value ?? const [];
    final mixTagIds = tags.where((t) => t.name.toLowerCase().contains('mix')).map((t) => t.id).toSet();
    final tagged = {
      for (final m in memberships)
        if (mixTagIds.contains(m.tagId) && !m.excluded) m.trackId,
    };
    final tracks = _filter(
      ref.watch(allTracksProvider).value ?? const [],
      ref.watch(newFilterProvider),
    ).where((t) => isLongFormMix(t, taggedIds: tagged)).toList()..sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    return HomeSection(
      title: 'Latest DJ Mixes',
      subtitle: 'Long-form audio, mix genres or your "DJ Mix" tag · by date added',
      isEmpty: tracks.isEmpty,
      child: TrackCarousel(tracks: tracks.take(20).toList(), context: 'dj-mixes'),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
    child: Text(text, style: context.text.bodyMedium?.copyWith(color: context.surfaces.muted)),
  );
}
