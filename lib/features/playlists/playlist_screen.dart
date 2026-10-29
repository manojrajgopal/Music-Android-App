import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import '../library/library_providers.dart';
import '../library/track_menu.dart';
import '../shell/app_shell.dart';

class PlaylistScreen extends ConsumerWidget {
  const PlaylistScreen({super.key, required this.playlistId});

  final int playlistId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlist = ref.watch(playlistProvider(playlistId));
    final items = ref.watch(playlistItemsProvider(playlistId));
    final dao = ref.read(databaseProvider).playlistsDao;
    final playback = ref.read(playbackControllerProvider);

    final p = playlist.value;
    if (playlist.hasValue && p == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyState(
          icon: Icons.queue_music_rounded,
          title: 'Playlist not found',
          message: 'It may have been deleted.',
        ),
      );
    }
    final list = items.value ?? const [];
    final tracks = [for (final i in list) i.track];
    final pinned = ref.watch(settingsProvider.select((s) => s.pinnedPlaylists.contains(playlistId)));

    Future<void> onMenu(String action) async {
      switch (action) {
        case 'rename':
          final name = await promptText(context, title: 'Rename playlist', initial: p?.name);
          if (name != null) await dao.renamePlaylist(playlistId, name, description: p?.description);
        case 'describe':
          final d = await promptText(context, title: 'Description', initial: p?.description, maxLength: 300);
          await dao.renamePlaylist(playlistId, p!.name, description: d);
        case 'duplicate':
          final id = await dao.duplicatePlaylist(playlistId, '${p?.name ?? 'Playlist'} copy');
          if (context.mounted) context.pushReplacement(Routes.playlist(id));
        case 'pin':
          await ref
              .read(settingsProvider.notifier)
              .update(
                (s) => s.copyWith(
                  pinnedPlaylists: pinned
                      ? s.pinnedPlaylists.where((id) => id != playlistId).toList()
                      : [...s.pinnedPlaylists, playlistId],
                ),
              );
        case 'delete':
          final ok = await confirm(
            context,
            title: 'Delete playlist?',
            message: '"${p?.name}" will be deleted. The songs stay in your library.',
            confirmLabel: 'Delete',
            destructive: true,
          );
          if (ok) {
            await dao.deletePlaylist(playlistId);
            if (context.mounted) context.pop();
          }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(p?.name ?? ''),
        actions: [
          IconButton(
            tooltip: 'Add songs',
            icon: const Icon(Icons.add_rounded),
            onPressed: () async {
              final ids = await pickTracks(context);
              if (ids != null && ids.isNotEmpty) await dao.addTracks(playlistId, ids);
            },
          ),
          PopupMenuButton<String>(
            tooltip: 'Playlist options',
            onSelected: onMenu,
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'rename', child: Text('Rename')),
              const PopupMenuItem(value: 'describe', child: Text('Edit description')),
              const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
              PopupMenuItem(value: 'pin', child: Text(pinned ? 'Unpin from Home' : 'Pin to Home')),
              const PopupMenuItem(value: 'delete', child: Text('Delete playlist')),
            ],
          ),
        ],
      ),
      body: AsyncView(
        value: items,
        data: (_) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.page),
                child: Column(
                  children: [
                    MosaicCover(
                      keys: tracks.map((t) => t.artworkKey).whereType<String>().toSet().take(4).toList(),
                      size: 200,
                      radius: Radii.lg,
                      seed: p?.name,
                    ),
                    const SizedBox(height: Spacing.lg),
                    Text(p?.name ?? '', style: context.text.headlineSmall, textAlign: TextAlign.center),
                    if (p?.description != null)
                      Text(
                        p!.description!,
                        textAlign: TextAlign.center,
                        style: context.text.bodyMedium?.copyWith(color: context.surfaces.muted),
                      ),
                    Text(
                      '${tracks.length} songs · ${formatListening(tracks.fold(0, (s, t) => s + (t.durationMs ?? 0)))}',
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
                              onPressed: () => playback.playTracks(tracks, context: 'playlist:$playlistId'),
                            ),
                          ),
                          const SizedBox(width: Spacing.md),
                          Expanded(
                            child: FilledButton.tonalIcon(
                              icon: const Icon(Icons.shuffle_rounded),
                              label: const Text('Shuffle'),
                              onPressed: () => playback.shuffleTracks(tracks, context: 'playlist:$playlistId'),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            if (list.isEmpty)
              SliverToBoxAdapter(
                child: EmptyState(
                  icon: Icons.playlist_add_rounded,
                  title: 'This playlist is empty',
                  message: 'Add songs here or from any song menu.',
                  action: FilledButton(
                    onPressed: () async {
                      final ids = await pickTracks(context);
                      if (ids != null && ids.isNotEmpty) await dao.addTracks(playlistId, ids);
                    },
                    child: const Text('Add songs'),
                  ),
                ),
              ),
            SliverReorderableList(
              itemCount: list.length,
              onReorderItem: (from, to) => dao.moveEntry(playlistId, from, to),
              itemBuilder: (context, i) {
                final item = list[i];
                return ReorderableDelayedDragStartListener(
                  key: ValueKey(item.entry.id),
                  index: i,
                  child: Material(
                    color: Colors.transparent,
                    child: SongRow(
                      track: item.track,
                      onTap: () => playback.playTracks(tracks, startIndex: i, context: 'playlist:$playlistId'),
                      onMore: () => showTrackMenu(
                        context,
                        ref,
                        item.track,
                        onRemoveFromPlaylist: () => dao.removeEntry(playlistId, item.entry.id),
                      ),
                      trailing: ReorderableDragStartListener(
                        index: i,
                        child: const Padding(
                          padding: EdgeInsets.all(Spacing.sm),
                          child: Icon(Icons.drag_handle_rounded, semanticLabel: 'Drag to reorder'),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const ShellBottomSpacer(),
          ],
        ),
      ),
    );
  }
}

/// Multi-select song picker with local filtering.
Future<List<String>?> pickTracks(BuildContext context) => showModalBottomSheet<List<String>>(
  context: context,
  isScrollControlled: true,
  builder: (_) => const _TrackPicker(),
);

class _TrackPicker extends ConsumerStatefulWidget {
  const _TrackPicker();

  @override
  ConsumerState<_TrackPicker> createState() => _TrackPickerState();
}

class _TrackPickerState extends ConsumerState<_TrackPicker> {
  final _selected = <String>[];
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(allTracksProvider).value ?? const <Track>[];
    final q = normalizeKey(_query);
    final shown = q.isEmpty
        ? ([...all]..sort((a, b) => a.titleKey.compareTo(b.titleKey)))
        : all.where((t) => t.searchText.contains(q)).toList();
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (context, controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
            child: Row(
              children: [
                Expanded(child: Text('Add songs', style: context.text.titleLarge)),
                FilledButton(
                  onPressed: _selected.isEmpty ? null : () => Navigator.pop(context, _selected),
                  child: Text(_selected.isEmpty ? 'Add' : 'Add ${_selected.length}'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Spacing.page),
            child: TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search_rounded), hintText: 'Filter songs'),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: controller,
              itemCount: shown.length,
              itemBuilder: (context, i) {
                final t = shown[i];
                final selected = _selected.contains(t.id);
                return CheckboxListTile(
                  value: selected,
                  onChanged: (v) => setState(() => v! ? _selected.add(t.id) : _selected.remove(t.id)),
                  secondary: ArtworkImage(artworkKey: t.artworkKey, size: 44, radius: Radii.sm, seed: t.title),
                  title: Text(t.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(t.artist ?? 'Unknown artist', maxLines: 1),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
