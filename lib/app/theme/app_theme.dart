import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

/// Design tokens shared by every screen.
abstract final class Spacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const page = 20.0;
}

abstract final class Radii {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 18.0;
  static const xl = 28.0;
}

const brandAccent = Color(0xFFFF4D6D);

/// Extra semantic colors not covered by [ColorScheme].
@immutable
class SurfaceColors extends ThemeExtension<SurfaceColors> {
  const SurfaceColors({
    required this.base,
    required this.raised,
    required this.overlay,
    required this.muted,
    required this.divider,
    required this.navBar,
  });

  final Color base;
  final Color raised;
  final Color overlay;
  final Color muted;
  final Color divider;
  final Color navBar;

  @override
  SurfaceColors copyWith({Color? base, Color? raised, Color? overlay, Color? muted, Color? divider, Color? navBar}) =>
      SurfaceColors(
        base: base ?? this.base,
        raised: raised ?? this.raised,
        overlay: overlay ?? this.overlay,
        muted: muted ?? this.muted,
        divider: divider ?? this.divider,
        navBar: navBar ?? this.navBar,
      );

  @override
  SurfaceColors lerp(SurfaceColors? other, double t) {
    if (other == null) return this;
    return SurfaceColors(
      base: Color.lerp(base, other.base, t)!,
      raised: Color.lerp(raised, other.raised, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      navBar: Color.lerp(navBar, other.navBar, t)!,
    );
  }
}

extension ThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
  SurfaceColors get surfaces => Theme.of(this).extension<SurfaceColors>()!;
}

abstract final class AppTheme {
  static const _dark = SurfaceColors(
    base: Color(0xFF070708),
    raised: Color(0xFF141416),
    overlay: Color(0xFF1E1E22),
    muted: Color(0xFF9A9AA3),
    divider: Color(0xFF26262B),
    navBar: Color(0xE61A1A1D),
  );

  static const _light = SurfaceColors(
    base: Color(0xFFF6F4F1),
    raised: Color(0xFFFFFFFF),
    overlay: Color(0xFFECE9E4),
    muted: Color(0xFF6B6B72),
    divider: Color(0xFFDCD8D2),
    navBar: Color(0xEFFFFFFF),
  );

  static ThemeData dark([Color accent = brandAccent]) => _build(Brightness.dark, _dark, accent);

  static ThemeData light([Color accent = brandAccent]) => _build(Brightness.light, _light, accent);

  static ThemeData _build(Brightness brightness, SurfaceColors s, Color accent) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(seedColor: accent, brightness: brightness, primary: accent, surface: s.base)
        .copyWith(
          surfaceContainerLowest: s.base,
          surfaceContainerLow: s.raised,
          surfaceContainer: s.raised,
          surfaceContainerHigh: s.overlay,
          onSurface: isDark ? Colors.white : const Color(0xFF111114),
          onSurfaceVariant: s.muted,
          outlineVariant: s.divider,
        );
    final base = ThemeData(useMaterial3: true, colorScheme: scheme, brightness: brightness);
    final text = base.textTheme.copyWith(
      displaySmall: base.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -1),
      headlineMedium: base.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.8),
      headlineSmall: base.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.5),
      titleLarge: base.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.3),
      titleMedium: base.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      labelLarge: base.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
    return base.copyWith(
      scaffoldBackgroundColor: s.base,
      textTheme: text.apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface),
      extensions: [s],
      appBarTheme: AppBarTheme(
        backgroundColor: s.base,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(color: scheme.onSurface),
      ),
      cardTheme: CardThemeData(
        color: s.raised,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.lg)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: s.raised,
        selectedColor: accent.withValues(alpha: isDark ? 0.28 : 0.18),
        side: BorderSide(color: s.divider),
        shape: const StadiumBorder(),
        labelStyle: text.labelLarge,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: s.raised,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.xl))),
      ),
      dialogTheme: DialogThemeData(backgroundColor: s.overlay, surfaceTintColor: Colors.transparent),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: s.raised,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.md), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.md),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: s.muted,
        contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.page),
      ),
      dividerTheme: DividerThemeData(color: s.divider, space: 1, thickness: 0.5),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: s.overlay,
        contentTextStyle: TextStyle(color: scheme.onSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.md)),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: accent,
        thumbColor: accent,
        inactiveTrackColor: s.divider,
        trackHeight: 3,
        overlayShape: SliderComponentShape.noOverlay,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
