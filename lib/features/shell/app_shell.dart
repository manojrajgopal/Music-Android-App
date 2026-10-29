import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../audio/playback_controller.dart';
import '../../audio/sleep_timer.dart';
import '../../core/widgets/common.dart';
import '../import_music/import_hub.dart';
import 'mini_player.dart';

/// Holds the tab shell so the outer shell (which also hosts detail pages)
/// can switch tabs.
abstract final class TabShell {
  static StatefulNavigationShell? current;
  static int lastIndex = 0;

  static int indexFor(String path) {
    if (path.startsWith(Routes.home)) return 0;
    if (path.startsWith(Routes.newMusic)) return 1;
    if (path.startsWith(Routes.library)) return 2;
    if (path.startsWith(Routes.search)) return 3;
    return lastIndex;
  }
}

/// Persistent chrome: floating navigation and mini-player over every tab and
/// detail page.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> with WidgetsBindingObserver {
  StreamSubscription<String>? _messages;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _messages = ref.read(playbackControllerProvider).messages.listen((m) {
      if (mounted) showMessage(context, m);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messages?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final playback = ref.read(playbackControllerProvider);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      playback.tracker.checkpoint();
      playback.saveQueueNow();
    }
    if (state == AppLifecycleState.resumed) ref.read(sleepTimerProvider.notifier).check();
  }

  void _onTab(int tab) {
    final shell = TabShell.current;
    if (shell == null) return;
    final atTabRoot =
        TabShell.indexFor(widget.location) == tab &&
        const [Routes.home, Routes.newMusic, Routes.library, Routes.search].contains(widget.location);
    shell.goBranch(tab, initialLocation: atTabRoot && tab == shell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final index = TabShell.indexFor(widget.location);
    TabShell.lastIndex = index;
    final hasTrack = ref.watch(currentMediaItemProvider.select((v) => v.value != null));
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      body: widget.child,
      bottomNavigationBar: keyboardOpen
          ? null
          : SafeArea(
              top: false,
              minimum: const EdgeInsets.only(bottom: Spacing.sm),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSize(
                    duration: reduceMotionOf(context, ref.watch(settingsProvider))
                        ? Duration.zero
                        : const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    child: hasTrack ? const MiniPlayer() : const SizedBox(width: double.infinity),
                  ),
                  FloatingNavBar(index: index, onTab: _onTab, onCenter: () => showImportHub(context)),
                ],
              ),
            ),
    );
  }
}

/// Icon-only floating navigation with a distinct center action.
class FloatingNavBar extends ConsumerWidget {
  const FloatingNavBar({super.key, required this.index, required this.onTab, required this.onCenter});

  final int index;
  final ValueChanged<int> onTab;
  final VoidCallback onCenter;

  static const destinations = [
    (Icons.home_outlined, Icons.home_rounded, 'Home'),
    (Icons.auto_awesome_outlined, Icons.auto_awesome, 'New'),
    (Icons.library_music_outlined, Icons.library_music_rounded, 'Library'),
    (Icons.search_rounded, Icons.manage_search_rounded, 'Search'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reduce = reduceMotionOf(context, ref.watch(settingsProvider));
    Widget tab(int i) {
      final (icon, active, label) = destinations[i];
      return Expanded(
        child: _NavIcon(
          icon: icon,
          activeIcon: active,
          label: label,
          selected: index == i,
          reduceMotion: reduce,
          onTap: () => onTab(i),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.xs, Spacing.lg, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Radii.xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: context.surfaces.navBar,
              borderRadius: BorderRadius.circular(Radii.xl),
              border: Border.all(color: context.surfaces.divider.withValues(alpha: 0.6), width: 0.5),
            ),
            child: Row(
              children: [
                tab(0),
                tab(1),
                Expanded(
                  child: Center(
                    child: Semantics(
                      button: true,
                      label: 'Add music and more',
                      child: Tooltip(
                        message: 'Add music',
                        child: InkResponse(
                          onTap: onCenter,
                          radius: 30,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.colors.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: context.colors.primary.withValues(alpha: 0.45),
                                  blurRadius: 16,
                                  spreadRadius: -2,
                                ),
                              ],
                            ),
                            child: Icon(Icons.add_rounded, color: context.colors.onPrimary, size: 28),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                tab(2),
                tab(3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.reduceMotion,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final bool reduceMotion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final duration = reduceMotion ? Duration.zero : const Duration(milliseconds: 280);
    final color = selected ? context.colors.primary : context.surfaces.muted;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: Tooltip(
        message: label,
        child: InkResponse(
          onTap: onTap,
          radius: 28,
          child: SizedBox(
            height: 64,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: selected ? 1.12 : 1,
                  duration: duration,
                  curve: Curves.easeOutBack,
                  child: AnimatedSwitcher(
                    duration: duration,
                    child: Icon(selected ? activeIcon : icon, key: ValueKey(selected), color: color, size: 26),
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: duration,
                  curve: Curves.easeOutCubic,
                  width: selected ? 16 : 0,
                  height: 3,
                  decoration: BoxDecoration(color: context.colors.primary, borderRadius: BorderRadius.circular(2)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Bottom spacer so scrolling content clears the floating navigation.
class ShellBottomSpacer extends StatelessWidget {
  const ShellBottomSpacer({super.key, this.sliver = true});

  final bool sliver;

  @override
  Widget build(BuildContext context) {
    final box = SizedBox(height: MediaQuery.paddingOf(context).bottom + Spacing.xl);
    return sliver ? SliverToBoxAdapter(child: box) : box;
  }
}
