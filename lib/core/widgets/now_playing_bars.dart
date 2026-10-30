import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../audio/playback_controller.dart';

/// Equalizer-style bars marking the song that is playing. They bounce while
/// audio plays and settle low when it is paused.
class NowPlayingBars extends ConsumerStatefulWidget {
  const NowPlayingBars({super.key, this.size = 18, this.color});

  final double size;
  final Color? color;

  @override
  ConsumerState<NowPlayingBars> createState() => _NowPlayingBarsState();
}

class _NowPlayingBarsState extends ConsumerState<NowPlayingBars> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));

  // Each bar runs its own wave so the motion never looks mechanical.
  static const _speeds = [2.0, 3.0, 1.0, 2.0];
  static const _phases = [0.0, 1.7, 3.1, 4.4];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playing = ref.watch(isPlayingProvider).value ?? false;
    final animate = playing && !reduceMotionOf(context, ref.watch(settingsProvider));
    if (animate && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!animate && _controller.isAnimating) {
      _controller.stop();
    }
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    return Semantics(
      label: playing ? 'Playing' : 'Paused',
      child: SizedBox.square(
        dimension: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            painter: _BarsPainter(
              color: color,
              heights: [
                for (var i = 0; i < _speeds.length; i++)
                  animate
                      ? 0.3 + 0.7 * (0.5 + 0.5 * math.sin(_controller.value * 2 * math.pi * _speeds[i] + _phases[i]))
                      : const [0.35, 0.6, 0.25, 0.45][i],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BarsPainter extends CustomPainter {
  _BarsPainter({required this.color, required this.heights});

  final Color color;
  final List<double> heights;

  @override
  void paint(Canvas canvas, Size size) {
    final gap = size.width / (heights.length * 3 - 1);
    final width = gap * 2;
    final paint = Paint()..color = color;
    for (var i = 0; i < heights.length; i++) {
      final h = size.height * heights[i];
      final left = i * (width + gap);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(left, size.height - h, width, h), Radius.circular(width / 2)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_BarsPainter old) => old.color != color || old.heights != heights;
}

/// Darkens artwork and shows [NowPlayingBars] over it.
class NowPlayingOverlay extends StatelessWidget {
  const NowPlayingOverlay({super.key, required this.child, required this.radius, this.barSize = 20});

  final Widget child;
  final double radius;
  final double barSize;

  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.center,
    children: [
      child,
      Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
      NowPlayingBars(size: barSize, color: Colors.white),
    ],
  );
}
