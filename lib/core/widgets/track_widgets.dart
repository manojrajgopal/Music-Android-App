import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_theme.dart';
import '../../audio/playback_controller.dart';
import '../../data/database/app_database.dart';
import '../utils/format.dart';
import 'artwork_image.dart';
import 'now_playing_bars.dart';

/// Square artwork card with title and subtitle, used in carousels.
class ArtworkCard extends StatelessWidget {
  const ArtworkCard({
    super.key,
    required this.artworkKey,
    required this.title,
    this.subtitle,
    this.size = 148,
    this.onTap,
    this.onLongPress,
    this.circle = false,
    this.mosaic,
    this.icon = Icons.music_note_rounded,
    this.badge,
    this.playing = false,
  });

  final String? artworkKey;
  final String title;
  final String? subtitle;
  final double size;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool circle;
  final List<String>? mosaic;
  final IconData icon;
  final Widget? badge;

  /// Marks the song that is playing with animated bars over its artwork.
  final bool playing;

  @override
  Widget build(BuildContext context) {
    final art = mosaic != null
        ? MosaicCover(keys: mosaic!, size: size, seed: title)
        : ArtworkImage(artworkKey: artworkKey, size: size, circle: circle, icon: icon, seed: title);
    final shown = playing ? NowPlayingOverlay(radius: circle ? size : Radii.md, barSize: size * 0.22, child: art) : art;
    return Semantics(
      button: onTap != null,
      label: [title, ?subtitle].join(', '),
      excludeSemantics: true,
      child: SizedBox(
        width: size,
        child: InkWell(
          borderRadius: BorderRadius.circular(Radii.md),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Column(
            crossAxisAlignment: circle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  shown,
                  if (badge != null) Positioned(left: 8, top: 8, child: badge!),
                ],
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: circle ? TextAlign.center : TextAlign.start,
                style: context.text.titleSmall,
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: circle ? TextAlign.center : TextAlign.start,
                  style: context.text.bodySmall?.copyWith(color: context.surfaces.muted),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact song row. Highlights the playing track and flags missing files.
class SongRow extends ConsumerWidget {
  const SongRow({
    super.key,
    required this.track,
    required this.onTap,
    this.onMore,
    this.leadingIndex,
    this.trailing,
    this.showArtwork = true,
  });

  final Track track;
  final VoidCallback onTap;
  final VoidCallback? onMore;
  final int? leadingIndex;
  final Widget? trailing;
  final bool showArtwork;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCurrent = ref.watch(currentTrackIdProvider) == track.id;
    final unavailable = track.availability != Availability.available;
    final accent = context.colors.primary;
    final subtitle = [track.artist ?? 'Unknown artist', if (track.album != null) track.album!].join(' · ');
    return Opacity(
      opacity: unavailable ? 0.5 : 1,
      child: ListTile(
        onTap: onTap,
        onLongPress: onMore,
        minTileHeight: 64,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIndex != null)
              SizedBox(
                width: 32,
                child: isCurrent && !showArtwork
                    ? const Center(child: NowPlayingBars())
                    : Text(
                        '$leadingIndex',
                        textAlign: TextAlign.center,
                        style: context.text.titleMedium?.copyWith(color: context.surfaces.muted),
                      ),
              ),
            if (showArtwork)
              isCurrent
                  ? NowPlayingOverlay(
                      radius: Radii.sm,
                      child: ArtworkImage(artworkKey: track.artworkKey, size: 48, radius: Radii.sm, seed: track.title),
                    )
                  : ArtworkImage(artworkKey: track.artworkKey, size: 48, radius: Radii.sm, seed: track.title),
            if (!showArtwork && leadingIndex == null && isCurrent) const NowPlayingBars(),
          ],
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                track.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.titleSmall?.copyWith(color: isCurrent ? accent : null),
              ),
            ),
            if (track.isFavorite)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(Icons.favorite_rounded, size: 13, color: accent),
              ),
          ],
        ),
        subtitle: Text(
          unavailable ? 'File unavailable · $subtitle' : subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.text.bodySmall?.copyWith(color: unavailable ? context.colors.error : context.surfaces.muted),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ?trailing,
            if (trailing == null && track.durationMs != null)
              Text(formatMs(track.durationMs), style: context.text.bodySmall?.copyWith(color: context.surfaces.muted)),
            if (onMore != null)
              IconButton(
                tooltip: 'More options for ${track.title}',
                icon: const Icon(Icons.more_vert_rounded),
                onPressed: onMore,
              ),
          ],
        ),
      ),
    );
  }
}

/// Small "rank" badge for charts.
class RankBadge extends StatelessWidget {
  const RankBadge(this.rank, {super.key});

  final int rank;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(Radii.sm),
    ),
    child: Text(
      '#$rank',
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
    ),
  );
}
