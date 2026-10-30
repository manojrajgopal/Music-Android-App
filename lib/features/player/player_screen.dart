import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../app/theme/artwork_color_controller.dart';
import '../../audio/playback_controller.dart';
import '../../audio/sleep_timer.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/artwork_image.dart';
import '../library/track_menu.dart';
import '../playlists/playlist_actions.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final track = ref.watch(currentTrackProvider).value;
    final item = ref.watch(currentMediaItemProvider).value;
    final brightness = Theme.of(context).brightness;
    final palette = ref.watch(currentPaletteProvider(brightness));
    final reduce = reduceMotionOf(context, ref.watch(settingsProvider));
    final duration = reduce ? Duration.zero : const Duration(milliseconds: 700);

    if (item == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Nothing is playing')),
      );
    }

    final title = track?.title ?? item.title;
    final artist = track?.artist ?? item.artist ?? 'Unknown artist';
    final album = track?.album ?? item.album;

    // Accent derived from artwork drives controls; the theme is rebuilt so
    // sliders, buttons and focus states all pick it up consistently.
    final themed = brightness == Brightness.dark ? AppTheme.dark(palette.accent) : AppTheme.light(palette.accent);

    return Theme(
      data: themed,
      child: TweenAnimationBuilder<Color?>(
        tween: ColorTween(end: palette.backgroundTop),
        duration: duration,
        builder: (context, top, child) => TweenAnimationBuilder<Color?>(
          tween: ColorTween(end: palette.backgroundBottom),
          duration: duration,
          builder: (context, bottom, _) => DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [top ?? palette.backgroundTop, bottom ?? palette.backgroundBottom],
              ),
            ),
            child: child,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              tooltip: 'Close player',
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32),
              onPressed: () => context.pop(),
            ),
            title: Text('Now Playing', style: context.text.labelLarge),
            centerTitle: true,
            actions: [
              if (track != null)
                IconButton(
                  tooltip: 'More options',
                  icon: const Icon(Icons.more_horiz_rounded),
                  onPressed: () => showTrackMenu(context, ref, track),
                ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (context, c) {
                final wide = c.maxWidth > c.maxHeight && c.maxWidth > 600;
                final artSize = wide
                    ? (c.maxHeight * 0.75).clamp(160.0, 420.0)
                    : (c.maxWidth - 64).clamp(160.0, c.maxHeight * 0.45);
                final art = Hero(
                  tag: 'now-playing-art',
                  child: AnimatedSwitcher(
                    duration: duration,
                    child: Container(
                      key: ValueKey(track?.artworkKey ?? item.id),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Radii.lg),
                        boxShadow: [
                          BoxShadow(
                            color: palette.accent.withValues(alpha: 0.25),
                            blurRadius: 40,
                            offset: const Offset(0, 16),
                          ),
                        ],
                      ),
                      child: ArtworkImage(artworkKey: track?.artworkKey, size: artSize, radius: Radii.lg, seed: title),
                    ),
                  ),
                );
                final controls = _Controls(title: title, artist: artist, album: album);
                if (wide) {
                  return Row(
                    children: [
                      Expanded(child: Center(child: art)),
                      Expanded(
                        child: SingleChildScrollView(padding: const EdgeInsets.all(Spacing.xl), child: controls),
                      ),
                    ],
                  );
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(Spacing.xl, Spacing.lg, Spacing.xl, Spacing.lg),
                  child: Column(
                    children: [
                      Center(child: art),
                      const SizedBox(height: Spacing.xl),
                      controls,
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Controls extends ConsumerWidget {
  const _Controls({required this.title, required this.artist, this.album});

  final String title;
  final String artist;
  final String? album;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final track = ref.watch(currentTrackProvider).value;
    final playback = ref.read(playbackControllerProvider);
    final playing = ref.watch(isPlayingProvider).value ?? false;
    final loop = ref.watch(loopModeProvider).value ?? LoopMode.off;
    final shuffle = ref.watch(shuffleProvider);
    final sleep = ref.watch(sleepTimerProvider);
    final speed = ref.watch(speedProvider).value ?? 1.0;
    final muted = context.surfaces.muted;
    final accent = context.colors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.text.headlineSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(
                    [artist, ?album].join(' — '),
                    style: context.text.titleMedium?.copyWith(color: muted, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (track != null)
              IconButton(
                tooltip: track.isFavorite ? 'Remove from favorites' : 'Add to favorites',
                iconSize: 30,
                icon: Icon(
                  track.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: track.isFavorite ? accent : null,
                ),
                onPressed: () => ref.read(libraryRepositoryProvider).toggleFavorite(track),
              ),
          ],
        ),
        const SizedBox(height: Spacing.md),
        const _SeekBar(),
        const SizedBox(height: Spacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              tooltip: shuffle ? 'Shuffle on' : 'Shuffle off',
              isSelected: shuffle,
              icon: Icon(Icons.shuffle_rounded, color: shuffle ? accent : muted),
              onPressed: playback.toggleShuffle,
            ),
            IconButton(
              tooltip: 'Previous',
              iconSize: 44,
              icon: const Icon(Icons.skip_previous_rounded),
              onPressed: playback.previous,
            ),
            SizedBox.square(
              dimension: 76,
              child: IconButton.filled(
                tooltip: playing ? 'Pause' : 'Play',
                iconSize: 44,
                style: IconButton.styleFrom(backgroundColor: accent, foregroundColor: context.colors.onPrimary),
                icon: Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
                onPressed: playback.togglePlay,
              ),
            ),
            IconButton(
              tooltip: 'Next',
              iconSize: 44,
              icon: const Icon(Icons.skip_next_rounded),
              onPressed: playback.next,
            ),
            IconButton(
              tooltip: switch (loop) {
                LoopMode.off => 'Repeat off',
                LoopMode.all => 'Repeat all',
                LoopMode.one => 'Repeat one',
              },
              icon: Icon(
                loop == LoopMode.one ? Icons.repeat_one_rounded : Icons.repeat_rounded,
                color: loop == LoopMode.off ? muted : accent,
              ),
              onPressed: playback.cycleRepeat,
            ),
          ],
        ),
        const SizedBox(height: Spacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _SmallAction(
              icon: Icons.bedtime_outlined,
              label: sleep.active ? _sleepLabel(sleep) : 'Sleep',
              active: sleep.active,
              onTap: () => showSleepTimerSheet(context),
            ),
            _SmallAction(icon: Icons.queue_music_rounded, label: 'Queue', onTap: () => context.push(Routes.queue)),
            _SmallAction(
              icon: Icons.speed_rounded,
              label: speed == 1.0 ? 'Speed' : '${_speedText(speed)}×',
              active: speed != 1.0,
              onTap: () => showSpeedSheet(context),
            ),
            if (track != null)
              _SmallAction(
                icon: Icons.playlist_add_rounded,
                label: 'Add',
                onTap: () => showAddToPlaylistSheet(context, [track.id]),
              ),
            if (track != null)
              _SmallAction(icon: Icons.sell_outlined, label: 'Tags', onTap: () => showTagSheet(context, track)),
            if (track != null)
              _SmallAction(
                icon: Icons.edit_outlined,
                label: 'Edit',
                onTap: () => context.push(Routes.editTrack(track.id)),
              ),
          ],
        ),
      ],
    );
  }

  String _sleepLabel(SleepTimerState s) {
    if (s.endOfTrack) return 'End of song';
    final left = s.remaining(DateTime.now());
    return left == null ? 'Sleep' : '${left.inMinutes + 1} min';
  }
}

class _SmallAction extends StatelessWidget {
  const _SmallAction({required this.icon, required this.label, required this.onTap, this.active = false});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? context.colors.primary : context.colors.onSurface;
    return InkResponse(
      onTap: onTap,
      radius: 32,
      child: Semantics(
        button: true,
        label: label,
        excludeSemantics: true,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 56, minHeight: 56),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 4),
              Text(label, style: context.text.labelSmall?.copyWith(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Seek bar isolated so only it rebuilds on position ticks.
class _SeekBar extends ConsumerStatefulWidget {
  const _SeekBar();

  @override
  ConsumerState<_SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends ConsumerState<_SeekBar> {
  double? _dragging;

  @override
  Widget build(BuildContext context) {
    final position = ref.watch(positionProvider).value ?? Duration.zero;
    final duration = ref.watch(durationProvider).value ?? Duration.zero;
    final max = duration.inMilliseconds.toDouble();
    final value = (_dragging ?? position.inMilliseconds.toDouble()).clamp(0.0, max <= 0 ? 0.0 : max);
    final style = context.text.labelSmall?.copyWith(
      color: context.surfaces.muted,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    return Column(
      children: [
        SizedBox(
          height: 32,
          child: Slider(
            value: value,
            max: max <= 0 ? 1 : max,
            semanticFormatterCallback: (v) => '${formatMs(v.round())} of ${formatDuration(duration)}',
            onChanged: max <= 0 ? null : (v) => setState(() => _dragging = v),
            onChangeEnd: (v) {
              ref.read(playbackControllerProvider).seek(Duration(milliseconds: v.round()));
              setState(() => _dragging = null);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(formatMs(value.round()), style: style),
            Text('-${formatDuration(duration - Duration(milliseconds: value.round()))}', style: style),
          ],
        ),
      ],
    );
  }
}

String _speedText(double speed) =>
    speed.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');

Future<void> showSpeedSheet(BuildContext context) =>
    showModalBottomSheet<void>(context: context, builder: (_) => const _SpeedSheet());

class _SpeedSheet extends ConsumerWidget {
  const _SpeedSheet();

  static const _speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speed = ref.watch(speedProvider).value ?? 1.0;
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
            child: Text('Playback speed', style: context.text.titleLarge),
          ),
          for (final s in _speeds)
            ListTile(
              title: Text(s == 1.0 ? 'Normal' : '${_speedText(s)}×'),
              trailing: s == speed ? Icon(Icons.check_rounded, color: context.colors.primary) : null,
              onTap: () {
                ref.read(playbackControllerProvider).setSpeed(s);
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}

Future<void> showSleepTimerSheet(BuildContext context) =>
    showModalBottomSheet<void>(context: context, builder: (_) => const _SleepSheet());

class _SleepSheet extends ConsumerWidget {
  const _SleepSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sleepTimerProvider);
    final ctrl = ref.read(sleepTimerProvider.notifier);
    void start(Duration d) {
      ctrl.start(d);
      Navigator.pop(context);
    }

    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
            child: Text('Sleep timer', style: context.text.titleLarge),
          ),
          if (state.active)
            StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, _) {
                final left = state.remaining(DateTime.now());
                return ListTile(
                  leading: Icon(Icons.timer_rounded, color: context.colors.primary),
                  title: Text(
                    state.endOfTrack ? 'Pausing at the end of this song' : 'Pausing in ${formatDuration(left)}',
                  ),
                  trailing: TextButton(onPressed: ctrl.cancel, child: const Text('Cancel')),
                );
              },
            ),
          for (final m in const [5, 15, 30, 45, 60, 90])
            ListTile(
              title: Text('$m minutes'),
              onTap: () => start(Duration(minutes: m)),
            ),
          ListTile(
            title: const Text('End of current song'),
            onTap: () {
              ctrl.untilEndOfTrack();
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Custom…'),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 0, minute: 20),
                initialEntryMode: TimePickerEntryMode.input,
                helpText: 'Hours and minutes from now',
                builder: (context, child) =>
                    MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child!),
              );
              if (picked == null) return;
              final d = Duration(hours: picked.hour, minutes: picked.minute);
              if (d > Duration.zero) start(d);
            },
          ),
        ],
      ),
    );
  }
}
