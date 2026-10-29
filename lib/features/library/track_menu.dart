import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../audio/playback_controller.dart';
import '../../core/errors/app_exception.dart';
import '../../core/utils/text_normalize.dart';
import '../../core/widgets/artwork_image.dart';
import '../../core/widgets/common.dart';
import '../../data/database/app_database.dart';
import '../playlists/playlist_actions.dart';
import 'library_providers.dart';

/// Context menu for a track, shared by every list and carousel.
Future<void> showTrackMenu(BuildContext context, WidgetRef ref, Track track, {VoidCallback? onRemoveFromPlaylist}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => _TrackMenu(track: track, onRemoveFromPlaylist: onRemoveFromPlaylist, parent: context),
  );
}

class _TrackMenu extends ConsumerWidget {
  const _TrackMenu({required this.track, required this.parent, this.onRemoveFromPlaylist});

  final Track track;
  final BuildContext parent;
  final VoidCallback? onRemoveFromPlaylist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final live = ref.watch(trackProvider(track.id)).value ?? track;
    final playback = ref.read(playbackControllerProvider);
    final library = ref.read(libraryRepositoryProvider);
    final unavailable = live.availability != Availability.available;

    void close() => Navigator.pop(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.62,
      maxChildSize: 0.95,
      builder: (context, controller) => ListView(
        controller: controller,
        children: [
          ListTile(
            leading: ArtworkImage(artworkKey: live.artworkKey, size: 52, radius: Radii.sm, seed: live.title),
            title: Text(live.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: context.text.titleMedium),
            subtitle: Text([live.artist ?? 'Unknown artist', ?live.album].join(' · ')),
          ),
          const Divider(),
          if (unavailable)
            ListTile(
              leading: Icon(Icons.link_rounded, color: context.colors.error),
              title: const Text('Relink file'),
              subtitle: const Text('This file is missing. Choose its new location.'),
              onTap: () async {
                close();
                await relinkFlow(parent, ref, live);
              },
            ),
          ListTile(
            leading: const Icon(Icons.play_arrow_rounded),
            title: const Text('Play'),
            onTap: () {
              close();
              playback.playTracks([live]);
            },
          ),
          ListTile(
            leading: const Icon(Icons.playlist_play_rounded),
            title: const Text('Play next'),
            onTap: () {
              close();
              playback.playNext([live]);
            },
          ),
          ListTile(
            leading: const Icon(Icons.queue_music_rounded),
            title: const Text('Add to queue'),
            onTap: () {
              close();
              playback.addToQueue([live]);
            },
          ),
          ListTile(
            leading: const Icon(Icons.playlist_add_rounded),
            title: const Text('Add to playlist'),
            onTap: () {
              close();
              showAddToPlaylistSheet(parent, [live.id]);
            },
          ),
          if (onRemoveFromPlaylist != null)
            ListTile(
              leading: const Icon(Icons.playlist_remove_rounded),
              title: const Text('Remove from this playlist'),
              onTap: () {
                close();
                onRemoveFromPlaylist!();
              },
            ),
          ListTile(
            leading: Icon(live.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded),
            title: Text(live.isFavorite ? 'Remove from favorites' : 'Add to favorites'),
            onTap: () => library.toggleFavorite(live),
          ),
          ListTile(
            leading: const Icon(Icons.auto_awesome_rounded),
            title: const Text('More like this'),
            onTap: () {
              close();
              parent.push(Routes.similar(live.id));
            },
          ),
          if (live.artist != null)
            ListTile(
              leading: const Icon(Icons.person_rounded),
              title: const Text('Go to artist'),
              onTap: () {
                close();
                final first = splitArtists(live.artist).firstOrNull ?? live.artist!;
                parent.push(Routes.collection(CollectionType.artist, normalizeKey(first)));
              },
            ),
          if (live.album != null)
            ListTile(
              leading: const Icon(Icons.album_rounded),
              title: const Text('Go to album'),
              onTap: () {
                close();
                parent.push(Routes.collection(CollectionType.album, live.albumKey));
              },
            ),
          ListTile(
            leading: const Icon(Icons.mood_rounded),
            title: const Text('Moods and tags'),
            onTap: () {
              close();
              showTagSheet(parent, live);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_rounded),
            title: const Text('Edit info'),
            onTap: () {
              close();
              parent.push(Routes.editTrack(live.id));
            },
          ),
          ListTile(
            leading: const Icon(Icons.remove_circle_outline_rounded),
            title: const Text('Remove from library'),
            subtitle: const Text('Keeps the audio file'),
            onTap: () async {
              close();
              final ok = await confirm(
                parent,
                title: 'Remove from library?',
                message:
                    '"${live.title}" will be removed from your library, playlists and statistics. The audio file is kept.',
                confirmLabel: 'Remove',
                destructive: true,
              );
              if (ok) await library.remove(live);
            },
          ),
          if (!unavailable)
            ListTile(
              leading: Icon(Icons.delete_forever_rounded, color: context.colors.error),
              title: Text('Delete file', style: TextStyle(color: context.colors.error)),
              subtitle: const Text("Deletes the app's copy of this audio file"),
              onTap: () async {
                close();
                final ok = await confirm(
                  parent,
                  title: 'Delete audio file?',
                  message:
                      'This permanently deletes the copy of "${live.title}" stored by Cadence and removes it from your library. '
                      'Original files elsewhere on your device are not touched. This cannot be undone.',
                  confirmLabel: 'Delete',
                  destructive: true,
                );
                if (ok) await library.remove(live, deleteFile: true);
              },
            ),
          const SizedBox(height: Spacing.lg),
        ],
      ),
    );
  }
}

Future<void> relinkFlow(BuildContext context, WidgetRef ref, Track track) async {
  try {
    final picked = await FilePicker.pickFile(type: FileType.audio);
    if (picked == null) return;
    final path = picked.path;
    if (path == null) throw const AppException('no_path', 'That file cannot be accessed.');
    await ref.read(importServiceProvider).relink(track, File(path), displayName: picked.name);
    if (context.mounted) showMessage(context, 'Relinked "${track.title}"');
  } catch (e) {
    if (context.mounted) showMessage(context, friendlyError(e));
  }
}

/// Moods and user tags for a track.
Future<void> showTagSheet(BuildContext context, Track track) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  builder: (_) => _TagSheet(track: track),
);

class _TagSheet extends ConsumerWidget {
  const _TagSheet({required this.track});

  final Track track;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final library = ref.read(libraryRepositoryProvider);
    final tags = ref.watch(tagsForTrackProvider(track.id)).value ?? const [];
    final userTags = tags.where((t) => t.kind == TagKind.user).toList();
    return Padding(
      padding: EdgeInsets.fromLTRB(Spacing.page, 0, Spacing.page, Spacing.xl + MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Moods', style: context.text.titleLarge),
          const SizedBox(height: Spacing.xs),
          Text(
            'Moods are your choice. Genre-based suggestions can be removed here.',
            style: context.text.bodySmall?.copyWith(color: context.surfaces.muted),
          ),
          const SizedBox(height: Spacing.md),
          Wrap(
            spacing: Spacing.sm,
            runSpacing: Spacing.sm,
            children: [
              for (final mood in Mood.values)
                Consumer(
                  builder: (context, ref, _) {
                    final inMood = ref.watch(moodTracksProvider(mood)).any((t) => t.id == track.id);
                    return FilterChip(
                      label: Text(mood.label),
                      selected: inMood,
                      onSelected: (v) => library.setMood(track.id, mood, member: v),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: Spacing.xl),
          Row(
            children: [
              Expanded(child: Text('Tags', style: context.text.titleLarge)),
              TextButton.icon(
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add tag'),
                onPressed: () async {
                  final name = await promptText(
                    context,
                    title: 'Add tag',
                    hint: 'e.g. TV, DJ Mix, Road trip',
                    maxLength: 60,
                  );
                  if (name != null) await library.addUserTag(track.id, name);
                },
              ),
            ],
          ),
          if (userTags.isEmpty)
            Text('No tags yet. Tag "TV" for TV music or "DJ Mix" for long mixes.', style: context.text.bodySmall)
          else
            Wrap(
              spacing: Spacing.sm,
              children: [
                for (final t in userTags)
                  InputChip(label: Text(t.name), onDeleted: () => library.removeTag(track.id, t.id)),
              ],
            ),
        ],
      ),
    );
  }
}
