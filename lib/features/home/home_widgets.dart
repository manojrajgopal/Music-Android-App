import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../audio/playback_controller.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/track_widgets.dart';
import '../../data/database/app_database.dart';
import '../library/track_menu.dart';
import 'recommendations.dart';

/// Horizontal song carousel; tapping plays the row as a queue.
class TrackCarousel extends ConsumerWidget {
  const TrackCarousel({super.key, required this.tracks, this.size = 148, this.context, this.ranked = false});

  final List<Track> tracks;
  final double size;
  final String? context;
  final bool ranked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scale = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.6);
    final currentId = ref.watch(currentTrackIdProvider);
    return HorizontalCarousel(
      height: size + 52 * scale,
      itemCount: tracks.length,
      itemBuilder: (_, i) {
        final t = tracks[i];
        return ArtworkCard(
          artworkKey: t.artworkKey,
          title: t.title,
          subtitle: t.artist ?? 'Unknown artist',
          size: size,
          badge: ranked ? RankBadge(i + 1) : null,
          playing: t.id == currentId,
          onTap: () => ref.read(playbackControllerProvider).playTracks(tracks, startIndex: i, context: this.context),
          onLongPress: () => showTrackMenu(context, ref, t),
        );
      },
    );
  }
}

class CollectionCarousel extends StatelessWidget {
  const CollectionCarousel({super.key, required this.collections, this.size = 164});

  final List<Collection> collections;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.6);
    return HorizontalCarousel(
      height: size + 52 * scale,
      itemCount: collections.length,
      itemBuilder: (_, i) {
        final c = collections[i];
        return ArtworkCard(
          artworkKey: c.coverKey,
          title: c.title,
          subtitle: c.reason,
          size: size,
          icon: Icons.auto_awesome_rounded,
          onTap: () => context.push(Routes.collection(CollectionType.generated, c.id)),
        );
      },
    );
  }
}

/// A titled section that hides itself when it has nothing to show, unless an
/// [empty] widget explains why.
class HomeSection extends StatelessWidget {
  const HomeSection({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.onSeeAll,
    this.isEmpty = false,
    this.empty,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;
  final Widget child;
  final bool isEmpty;
  final Widget? empty;

  @override
  Widget build(BuildContext context) {
    if (isEmpty && empty == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: title, subtitle: subtitle, onSeeAll: isEmpty ? null : onSeeAll),
        isEmpty ? empty! : child,
      ],
    );
  }
}
