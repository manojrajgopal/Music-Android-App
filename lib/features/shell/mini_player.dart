import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../audio/playback_controller.dart';
import '../../core/widgets/artwork_image.dart';

/// Compact player shown above the navigation while a track is loaded.
class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(currentMediaItemProvider).value;
    if (item == null) return const SizedBox.shrink();
    final track = ref.watch(currentTrackProvider).value;
    final playing = ref.watch(isPlayingProvider).value ?? false;
    final title = track?.title ?? item.title;
    final artist = track?.artist ?? item.artist ?? 'Unknown artist';

    return Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.md, 0, Spacing.md, Spacing.xs),
      child: Material(
        color: context.surfaces.overlay,
        elevation: 6,
        shadowColor: Colors.black54,
        borderRadius: BorderRadius.circular(Radii.lg),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => context.push(Routes.player),
              child: SizedBox(
                height: 60,
                child: Row(
                  children: [
                    const SizedBox(width: Spacing.sm),
                    Hero(
                      tag: 'now-playing-art',
                      child: ArtworkImage(artworkKey: track?.artworkKey, size: 44, radius: Radii.sm, seed: title),
                    ),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      child: Semantics(
                        label: 'Now playing: $title by $artist. Open player',
                        button: true,
                        excludeSemantics: true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.text.titleSmall),
                            Text(
                              artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.bodySmall?.copyWith(color: context.surfaces.muted),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: playing ? 'Pause' : 'Play',
                      iconSize: 32,
                      icon: Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
                      onPressed: () => ref.read(playbackControllerProvider).togglePlay(),
                    ),
                    IconButton(
                      tooltip: 'Next track',
                      icon: const Icon(Icons.skip_next_rounded),
                      onPressed: () => ref.read(playbackControllerProvider).next(),
                    ),
                    const SizedBox(width: Spacing.xs),
                  ],
                ),
              ),
            ),
            const _MiniProgress(),
          ],
        ),
      ),
    );
  }
}

/// Isolated so position ticks rebuild only this bar.
class _MiniProgress extends ConsumerWidget {
  const _MiniProgress();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = ref.watch(positionProvider).value ?? Duration.zero;
    final duration = ref.watch(durationProvider).value;
    final value = duration == null || duration.inMilliseconds == 0
        ? 0.0
        : (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
    return LinearProgressIndicator(
      value: value,
      minHeight: 2,
      backgroundColor: Colors.transparent,
      semanticsLabel: 'Playback progress',
    );
  }
}
