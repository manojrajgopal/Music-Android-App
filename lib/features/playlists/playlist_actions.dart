import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/widgets/artwork_image.dart';
import '../../core/widgets/common.dart';
import '../library/library_providers.dart';
import '../library/library_screen.dart';

Future<int?> createPlaylistFlow(BuildContext context, WidgetRef ref, {bool open = true}) async {
  final name = await promptText(context, title: 'New playlist', hint: 'Playlist name', confirmLabel: 'Create');
  if (name == null) return null;
  final id = await ref.read(databaseProvider).playlistsDao.createPlaylist(name);
  if (open && context.mounted) context.push(Routes.playlist(id));
  return id;
}

/// Adds tracks to one or more playlists chosen by the user.
Future<void> showAddToPlaylistSheet(BuildContext context, List<String> trackIds) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _AddToPlaylistSheet(trackIds: trackIds),
  );
}

class _AddToPlaylistSheet extends ConsumerStatefulWidget {
  const _AddToPlaylistSheet({required this.trackIds});

  final List<String> trackIds;

  @override
  ConsumerState<_AddToPlaylistSheet> createState() => _AddToPlaylistSheetState();
}

class _AddToPlaylistSheetState extends ConsumerState<_AddToPlaylistSheet> {
  final _selected = <int>{};
  bool _favourite = false;

  Future<void> _save() async {
    final dao = ref.read(databaseProvider).playlistsDao;
    for (final id in _selected) {
      await dao.addTracks(id, widget.trackIds);
    }
    if (_favourite) {
      final library = ref.read(libraryRepositoryProvider);
      for (final id in widget.trackIds) {
        await library.setFavorite(id, true);
      }
    }
    if (!mounted) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    Navigator.pop(context);
    final count = _selected.length + (_favourite ? 1 : 0);
    messenger?.showSnackBar(SnackBar(content: Text('Added to $count playlist${count == 1 ? '' : 's'}')));
  }

  @override
  Widget build(BuildContext context) {
    final playlists = ref.watch(playlistsProvider);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.92,
      builder: (context, controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
            child: Row(
              children: [
                Expanded(child: Text('Add to playlist', style: context.text.titleLarge)),
                FilledButton(onPressed: _selected.isEmpty && !_favourite ? null : _save, child: const Text('Add')),
              ],
            ),
          ),
          CheckboxListTile(
            value: _favourite,
            onChanged: (v) => setState(() => _favourite = v!),
            secondary: const FavouriteSongsCover(size: 44, radius: Radii.sm),
            title: const Text(FavouriteSongsTile.title),
          ),
          ListTile(
            leading: const Icon(Icons.add_rounded),
            title: const Text('New playlist'),
            onTap: () async {
              final id = await createPlaylistFlow(context, ref, open: false);
              if (id != null) setState(() => _selected.add(id));
            },
          ),
          Expanded(
            child: AsyncView(
              value: playlists,
              data: (list) => ListView.builder(
                controller: controller,
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final p = list[i];
                  return CheckboxListTile(
                    value: _selected.contains(p.playlist.id),
                    onChanged: (v) =>
                        setState(() => v! ? _selected.add(p.playlist.id) : _selected.remove(p.playlist.id)),
                    secondary: MosaicCover(keys: p.coverKeys, size: 44, radius: Radii.sm, seed: p.playlist.name),
                    title: Text(p.playlist.name),
                    subtitle: Text('${p.trackCount} songs'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
