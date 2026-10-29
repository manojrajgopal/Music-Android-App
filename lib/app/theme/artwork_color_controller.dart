import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

import '../../audio/playback_controller.dart';
import '../providers.dart';
import 'app_theme.dart';

/// Colors derived from artwork, adjusted for readability.
///
/// Raw extracted colors are re-toned in HCT space: backgrounds become very
/// dark (or very light) and accents land at a tone that keeps contrast with
/// the surface, so a pale or muddy cover can never make controls unreadable.
class ArtworkPalette {
  const ArtworkPalette({
    required this.accent,
    required this.backgroundTop,
    required this.backgroundBottom,
    required this.onBackground,
  });

  final Color accent;
  final Color backgroundTop;
  final Color backgroundBottom;
  final Color onBackground;

  static ArtworkPalette fromSeeds(int primary, int secondary, Brightness brightness) {
    final p = Hct.fromInt(primary);
    final s = Hct.fromInt(secondary);
    final dark = brightness == Brightness.dark;
    final chroma = p.chroma.clamp(8.0, 48.0);
    return ArtworkPalette(
      accent: Color(Hct.from(p.hue, p.chroma.clamp(36.0, 90.0), dark ? 72 : 42).toInt()),
      backgroundTop: Color(Hct.from(p.hue, chroma, dark ? 24 : 88).toInt()),
      backgroundBottom: Color(Hct.from(s.hue, s.chroma.clamp(4.0, 30.0), dark ? 6 : 96).toInt()),
      onBackground: dark ? Colors.white : const Color(0xFF111114),
    );
  }

  static ArtworkPalette fallback(Brightness brightness) => fromSeeds(brandAccent.toARGB32(), 0xFF3A3A48, brightness);
}

/// Cached accent colors for an artwork key (read from the artwork cache).
final artworkSeedsProvider = FutureProvider.family<(int, int)?, String>((ref, key) async {
  final colors = await ref.watch(artworkServiceProvider).colorsFor(key);
  return colors == null ? null : (colors.primary, colors.secondary);
});

/// Palette for the current track. Screens animate between palettes so a
/// track change never flashes the background.
final currentPaletteProvider = Provider.family<ArtworkPalette, Brightness>((ref, brightness) {
  final track = ref.watch(currentTrackProvider).value;
  final key = track?.artworkKey;
  if (key == null) return ArtworkPalette.fallback(brightness);
  final seeds = ref.watch(artworkSeedsProvider(key));
  final value = seeds.value;
  if (value == null) return ArtworkPalette.fallback(brightness);
  return ArtworkPalette.fromSeeds(value.$1, value.$2, brightness);
});
