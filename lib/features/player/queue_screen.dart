import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_theme.dart';
import '../../audio/playback_controller.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/common.dart';

/// Up Next: reorder, remove, jump, shuffle and clear.
class QueueScreen extends ConsumerWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(queueProvider).value ?? const [];
    final current = ref.watch(playbackStateProvider).value?.queueIndex ?? 0;
    final playback = ref.read(playbackControllerProvider);
    final upcoming = queue.length - current - 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Queue'),
        actions: [
          IconButton(
            tooltip: 'Shuffle queue',
            icon: const Icon(Icons.shuffle_rounded),
            onPressed: queue.length < 2 ? null : playback.shuffleQueue,
          ),
          IconButton(
            tooltip: 'Clear queue',
            icon: const Icon(Icons.clear_all_rounded),
            onPressed: queue.length < 2
                ? null
                : () async {
                    final ok = await confirm(
                      context,
                      title: 'Clear queue?',
                      message: 'All songs except the one playing will be removed from the queue.',
                      confirmLabel: 'Clear',
                    );
                    if (ok) await playback.clearUpcoming();
                  },
          ),
        ],
      ),
      body: queue.isEmpty
          ? const EmptyState(
              icon: Icons.queue_music_rounded,
              title: 'Queue is empty',
              message: 'Play a song or add songs to the queue.',
            )
          : ReorderableListView.builder(
              padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + Spacing.xl),
              header: Padding(
                padding: const EdgeInsets.fromLTRB(Spacing.page, Spacing.sm, Spacing.page, Spacing.sm),
                child: Text(
                  upcoming <= 0 ? 'Nothing up next' : '$upcoming up next',
                  style: context.text.bodySmall?.copyWith(color: context.surfaces.muted),
                ),
              ),
              itemCount: queue.length,
              buildDefaultDragHandles: false,
              onReorderItem: playback.move,
              itemBuilder: (context, i) {
                final item = queue[i];
                final isCurrent = i == current;
                final played = i < current;
                return Dismissible(
                  key: ValueKey(item.id),
                  direction: isCurrent ? DismissDirection.none : DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: Spacing.xl),
                    color: context.colors.errorContainer,
                    child: Icon(Icons.delete_outline_rounded, color: context.colors.onErrorContainer),
                  ),
                  onDismissed: (_) => playback.removeAt(i),
                  child: Opacity(
                    opacity: played ? 0.5 : 1,
                    child: ListTile(
                      onTap: () => playback.jumpTo(i),
                      leading: isCurrent
                          ? Icon(Icons.graphic_eq_rounded, color: context.colors.primary)
                          : Text('${i + 1}', style: context.text.bodySmall),
                      title: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isCurrent ? context.colors.primary : null,
                          fontWeight: isCurrent ? FontWeight.w700 : null,
                        ),
                      ),
                      subtitle: Text(
                        '${item.artist ?? 'Unknown artist'} · ${formatDuration(item.duration)}',
                        maxLines: 1,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!isCurrent)
                            PopupMenuButton<String>(
                              tooltip: 'Queue options',
                              onSelected: (v) {
                                if (v == 'next') playback.move(i, i < current ? current : current + 1);
                                if (v == 'remove') playback.removeAt(i);
                              },
                              itemBuilder: (_) => const [
                                PopupMenuItem(value: 'next', child: Text('Play next')),
                                PopupMenuItem(value: 'remove', child: Text('Remove from queue')),
                              ],
                            ),
                          ReorderableDragStartListener(
                            index: i,
                            child: const Padding(
                              padding: EdgeInsets.all(Spacing.sm),
                              child: Icon(Icons.drag_handle_rounded, semanticLabel: 'Drag to reorder'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
