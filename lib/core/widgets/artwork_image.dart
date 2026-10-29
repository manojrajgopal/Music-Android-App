import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme/app_theme.dart';

/// Artwork from the local cache, decoded at display size. Missing or broken
/// artwork falls back to a tasteful placeholder — never an error.
class ArtworkImage extends ConsumerWidget {
  const ArtworkImage({
    super.key,
    required this.artworkKey,
    required this.size,
    this.radius = Radii.md,
    this.circle = false,
    this.icon = Icons.music_note_rounded,
    this.seed,
  });

  final String? artworkKey;
  final double size;
  final double radius;
  final bool circle;
  final IconData icon;

  /// Varies the placeholder gradient so neighbouring placeholders differ.
  final String? seed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = artworkKey;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final placeholder = _Placeholder(size: size, icon: icon, seed: seed ?? key ?? '');
    Widget child = placeholder;
    if (key != null) {
      final path = ref.watch(storagePathsProvider).artworkPath(key);
      child = Image.file(
        File(path),
        width: size,
        height: size,
        fit: BoxFit.cover,
        cacheWidth: (size * dpr).round(),
        gaplessPlayback: true,
        filterQuality: FilterQuality.medium,
        errorBuilder: (_, _, _) => placeholder,
      );
    }
    final border = circle ? BorderRadius.circular(size) : BorderRadius.circular(radius);
    return ClipRRect(
      borderRadius: border,
      child: SizedBox.square(dimension: size, child: child),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.size, required this.icon, required this.seed});

  final double size;
  final IconData icon;
  final String seed;

  @override
  Widget build(BuildContext context) {
    final hue = (seed.hashCode % 360).abs().toDouble();
    final dark = Theme.of(context).brightness == Brightness.dark;
    final a = HSLColor.fromAHSL(1, hue, 0.35, dark ? 0.22 : 0.82).toColor();
    final b = HSLColor.fromAHSL(1, (hue + 40) % 360, 0.30, dark ? 0.12 : 0.92).toColor();
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [a, b]),
      ),
      child: Center(
        child: Icon(icon, size: size * 0.36, color: context.colors.onSurface.withValues(alpha: 0.45)),
      ),
    );
  }
}

/// 2×2 mosaic for playlist covers.
class MosaicCover extends StatelessWidget {
  const MosaicCover({super.key, required this.keys, required this.size, this.radius = Radii.md, this.seed});

  final List<String> keys;
  final double size;
  final double radius;
  final String? seed;

  @override
  Widget build(BuildContext context) {
    if (keys.length < 4) {
      return ArtworkImage(
        artworkKey: keys.firstOrNull,
        size: size,
        radius: radius,
        icon: Icons.queue_music_rounded,
        seed: seed,
      );
    }
    final half = size / 2;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox.square(
        dimension: size,
        child: Wrap(
          children: [for (final k in keys.take(4)) ArtworkImage(artworkKey: k, size: half, radius: 0)],
        ),
      ),
    );
  }
}
