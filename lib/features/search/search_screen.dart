import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../audio/playback_controller.dart';
import '../../core/widgets/artwork_image.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/track_widgets.dart';
import '../../data/database/daos/tracks_dao.dart';
import '../library/library_providers.dart';
import '../library/track_menu.dart';
import '../shell/app_shell.dart';
import 'search_controller.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  final _speech = SpeechToText();
  bool _listening = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _speech.cancel();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _setQuery(String q, {bool immediate = false}) {
    _controller.value = TextEditingValue(
      text: q,
      selection: TextSelection.collapsed(offset: q.length),
    );
    final search = ref.read(searchControllerProvider.notifier);
    immediate ? search.runNow(q) : search.setQuery(q);
  }

  /// Asks for permission only when the user taps the microphone.
  Future<void> _voice() async {
    if (_listening) {
      await _speech.stop();
      setState(() => _listening = false);
      return;
    }
    // On iOS, speech_to_text requests microphone and speech permissions
    // itself during initialize(); Android needs the runtime mic permission.
    final mic = Platform.isAndroid ? await Permission.microphone.request() : PermissionStatus.granted;
    if (!mic.isGranted) {
      if (mounted) {
        showMessage(
          context,
          mic.isPermanentlyDenied
              ? 'Microphone access is off. Enable it in system settings to use voice search, or type instead.'
              : 'Voice search needs microphone access. You can type instead.',
        );
      }
      return;
    }
    final available = await _speech
        .initialize(
          onError: (_) {
            if (mounted) setState(() => _listening = false);
          },
          onStatus: (s) {
            if (mounted && (s == 'done' || s == 'notListening')) setState(() => _listening = false);
          },
        )
        .catchError((_) => false);
    if (!available) {
      if (mounted) {
        showMessage(context, 'Voice search is unavailable or permission was denied. Please type your search.');
      }
      return;
    }
    setState(() => _listening = true);
    await _speech.listen(
      listenOptions: SpeechListenOptions(listenMode: ListenMode.search, partialResults: true),
      onResult: (r) {
        _setQuery(r.recognizedWords, immediate: r.finalResult);
        if (r.finalResult) ref.read(searchControllerProvider.notifier).remember();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchControllerProvider);
    final hasQuery = _controller.text.trim().isNotEmpty;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Spacing.page, Spacing.lg, Spacing.page, Spacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focus,
                      textInputAction: TextInputAction.search,
                      onChanged: (v) => _setQuery(v),
                      onSubmitted: (v) {
                        ref.read(searchControllerProvider.notifier)
                          ..runNow(v)
                          ..remember();
                      },
                      decoration: InputDecoration(
                        hintText: 'Songs, artists, albums, playlists',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: hasQuery
                            ? IconButton(
                                tooltip: 'Clear search',
                                icon: const Icon(Icons.close_rounded),
                                onPressed: () => setState(() => _setQuery('')),
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  IconButton.filledTonal(
                    tooltip: _listening ? 'Stop voice search' : 'Voice search',
                    isSelected: _listening,
                    icon: Icon(_listening ? Icons.mic_rounded : Icons.mic_none_rounded),
                    onPressed: _voice,
                  ),
                ],
              ),
            ),
            if (_listening)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
                child: Text(
                  'Listening… Recognition may use your device\'s speech service, which can require an internet connection.',
                  style: context.text.bodySmall?.copyWith(color: context.surfaces.muted),
                ),
              ),
            if (hasQuery) const _FilterBar(),
            Expanded(
              child: hasQuery
                  ? _Results(results: results)
                  : _RecentSearches(onPick: (q) => _setQuery(q, immediate: true)),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterBar extends ConsumerStatefulWidget {
  const _FilterBar();

  @override
  ConsumerState<_FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends ConsumerState<_FilterBar> {
  TrackFilter _filter = const TrackFilter();

  void _apply(TrackFilter f) {
    setState(() => _filter = f);
    ref.read(searchControllerProvider.notifier).setFilter(f);
  }

  Future<void> _choose<T>(String title, List<(String, T)> options, TrackFilter Function(T?) build) async {
    final picked = await showModalBottomSheet<(T?,)>(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        builder: (context, c) => ListView(
          controller: c,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
              child: Text(title, style: context.text.titleLarge),
            ),
            ListTile(title: const Text('Any'), onTap: () => Navigator.pop(context, (null,))),
            for (final (label, v) in options) ListTile(title: Text(label), onTap: () => Navigator.pop(context, (v,))),
          ],
        ),
      ),
    );
    if (picked != null) _apply(build(picked.$1));
  }

  @override
  Widget build(BuildContext context) {
    final artists = ref.watch(artistsProvider).value ?? const [];
    final genres = ref.watch(genresProvider).value ?? const [];
    final languages = ref.watch(languagesProvider).value ?? const [];
    final albums = ref.watch(albumsProvider).value ?? const [];
    Widget chip(String label, String? value, VoidCallback onTap) => Padding(
      padding: const EdgeInsets.only(right: Spacing.sm),
      child: FilterChip(label: Text(value ?? label), selected: value != null, onSelected: (_) => onTap()),
    );
    final durationLabel = switch ((_filter.minDurationMs, _filter.maxDurationMs)) {
      (null, null) => null,
      (_, 240000) => 'Under 4 min',
      (240000, 600000) => '4–10 min',
      _ => 'Over 10 min',
    };
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
        children: [
          chip(
            'Artist',
            artists.where((a) => a.key == _filter.artistKey).firstOrNull?.name,
            () => _choose('Artist', [for (final a in artists) (a.name, a.key)], (v) => _filter.copyWith(artistKey: v)),
          ),
          chip('Album', null, () async {
            final picked = await showModalBottomSheet<String>(
              context: context,
              isScrollControlled: true,
              builder: (context) => DraggableScrollableSheet(
                expand: false,
                builder: (context, c) => ListView(
                  controller: c,
                  children: [
                    for (final a in albums)
                      ListTile(
                        title: Text(a.name),
                        subtitle: Text(a.subtitle ?? ''),
                        onTap: () => Navigator.pop(context, a.key),
                      ),
                  ],
                ),
              ),
            );
            if (picked != null && context.mounted) context.push(Routes.collection(CollectionType.album, picked));
          }),
          chip(
            'Genre',
            _filter.genre,
            () => _choose('Genre', [for (final g in genres) (g.name, g.name)], (v) => _filter.copyWith(genre: v)),
          ),
          chip(
            'Language',
            _filter.language,
            () => _choose('Language', [
              for (final g in languages) (g.name, g.name),
            ], (v) => _filter.copyWith(language: v)),
          ),
          chip(
            'Duration',
            durationLabel,
            () => _choose<(int?, int?)>('Duration', const [
              ('Under 4 minutes', (null, 240000)),
              ('4 to 10 minutes', (240000, 600000)),
              ('Over 10 minutes', (600000, null)),
            ], (v) => _filter.copyWith(minDurationMs: v?.$1, maxDurationMs: v?.$2)),
          ),
          if (!_filter.isEmpty)
            ActionChip(
              label: const Text('Clear'),
              avatar: const Icon(Icons.close_rounded, size: 18),
              onPressed: () => _apply(const TrackFilter()),
            ),
        ],
      ),
    );
  }
}

class _RecentSearches extends ConsumerWidget {
  const _RecentSearches({required this.onPick});

  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recent = ref.watch(recentSearchesProvider).value ?? const [];
    final dao = ref.read(databaseProvider).miscDao;
    if (recent.isEmpty) {
      return const EmptyState(
        icon: Icons.search_rounded,
        title: 'Search your library',
        message: 'Find songs, artists, albums, playlists and genres. Works offline, in any language.',
      );
    }
    return ListView(
      children: [
        SectionHeader(
          title: 'Recent searches',
          trailing: TextButton(
            onPressed: () async {
              if (await confirm(
                context,
                title: 'Clear recent searches?',
                message: 'Your search history on this device will be removed.',
                confirmLabel: 'Clear',
              )) {
                await dao.clearSearches();
              }
            },
            child: const Text('Clear'),
          ),
        ),
        for (final s in recent)
          ListTile(
            leading: const Icon(Icons.history_rounded),
            title: Text(s.query),
            onTap: () => onPick(s.query),
            trailing: IconButton(
              tooltip: 'Remove ${s.query}',
              icon: const Icon(Icons.close_rounded),
              onPressed: () => dao.removeSearch(s.id),
            ),
          ),
        const ShellBottomSpacer(sliver: false),
      ],
    );
  }
}

class _Results extends ConsumerWidget {
  const _Results({required this.results});

  final SearchResults results;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (results.isEmpty) {
      return results.loading
          ? const Center(child: CircularProgressIndicator())
          : EmptyState(
              icon: Icons.search_off_rounded,
              title: 'No results',
              message: 'Nothing in your library matches "${results.query}".',
            );
    }
    void remember() => ref.read(searchControllerProvider.notifier).remember();
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        if (results.artists.isNotEmpty) ...[
          const SectionHeader(title: 'Artists'),
          HorizontalCarousel(
            height: 150,
            itemCount: results.artists.length,
            itemBuilder: (context, i) {
              final a = results.artists[i];
              return ArtworkCard(
                artworkKey: a.artworkKey,
                title: a.name,
                subtitle: '${a.trackCount} songs',
                size: 96,
                circle: true,
                icon: Icons.person_rounded,
                onTap: () {
                  remember();
                  context.push(Routes.collection(CollectionType.artist, a.key));
                },
              );
            },
          ),
        ],
        if (results.songs.isNotEmpty) ...[
          const SectionHeader(title: 'Songs'),
          for (var i = 0; i < results.songs.length; i++)
            SongRow(
              track: results.songs[i],
              onTap: () {
                remember();
                ref.read(playbackControllerProvider).playTracks(results.songs, startIndex: i, context: 'search');
              },
              onMore: () => showTrackMenu(context, ref, results.songs[i]),
            ),
        ],
        if (results.albums.isNotEmpty) ...[
          const SectionHeader(title: 'Albums'),
          for (final a in results.albums)
            ListTile(
              leading: ArtworkImage(artworkKey: a.artworkKey, size: 48, radius: Radii.sm, seed: a.name),
              title: Text(a.name),
              subtitle: Text(a.subtitle ?? '${a.trackCount} songs'),
              onTap: () {
                remember();
                context.push(Routes.collection(CollectionType.album, a.key));
              },
            ),
        ],
        if (results.playlists.isNotEmpty) ...[
          const SectionHeader(title: 'Playlists'),
          for (final p in results.playlists)
            ListTile(
              leading: const Icon(Icons.queue_music_rounded),
              title: Text(p.playlist.name),
              onTap: () {
                remember();
                context.push(Routes.playlist(p.playlist.id));
              },
            ),
        ],
        if (results.genres.isNotEmpty) ...[
          const SectionHeader(title: 'Genres'),
          for (final g in results.genres)
            ListTile(
              leading: const Icon(Icons.category_rounded),
              title: Text(g.name),
              subtitle: Text('${g.trackCount} songs'),
              onTap: () {
                remember();
                context.push(Routes.collection(CollectionType.genre, g.key));
              },
            ),
        ],
        const ShellBottomSpacer(sliver: false),
      ],
    );
  }
}
