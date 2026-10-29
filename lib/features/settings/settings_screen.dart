import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/common.dart';
import '../../data/repositories/settings_repository.dart';
import '../import_music/import_hub.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final ctrl = ref.read(settingsProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _Header('Appearance'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.page, vertical: Spacing.sm),
            child: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode_rounded)),
                ButtonSegment(value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode_rounded)),
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text('System'),
                  icon: Icon(Icons.brightness_auto_rounded),
                ),
              ],
              selected: {s.themeMode},
              onSelectionChanged: (v) => ctrl.setThemeMode(v.first),
            ),
          ),
          SwitchListTile(
            title: const Text('Reduce motion'),
            subtitle: const Text('Minimise animations (the system setting is also respected)'),
            value: s.reduceMotion,
            onChanged: (v) => ctrl.update((s) => s.copyWith(reduceMotion: v)),
          ),
          ListTile(
            leading: const Icon(Icons.badge_outlined),
            title: const Text('Your name'),
            subtitle: Text(s.userName ?? 'Used only for the Home greeting'),
            onTap: () async {
              final name = await promptText(
                context,
                title: 'Your name',
                initial: s.userName,
                hint: 'Optional',
                maxLength: 40,
              );
              await ctrl.update((s) => s.copyWith(userName: name));
            },
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_customize_outlined),
            title: const Text('Customize Home'),
            subtitle: const Text('Show, hide and reorder sections'),
            onTap: () => context.push(Routes.customizeHome),
          ),
          const _Header('Library'),
          ListTile(
            leading: const Icon(Icons.sync_rounded),
            title: const Text('Rescan library'),
            subtitle: const Text('Detect changed, missing or restored files'),
            onTap: () => startRescan(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.cleaning_services_outlined),
            title: const Text('Clean artwork cache'),
            subtitle: const Text('Remove artwork no longer used by any song'),
            onTap: () async {
              final removed = await ref.read(artworkServiceProvider).cleanOrphans();
              if (context.mounted) showMessage(context, 'Removed $removed unused image${removed == 1 ? '' : 's'}');
            },
          ),
          ListTile(
            leading: const Icon(Icons.save_alt_rounded),
            title: const Text('Backup and restore'),
            subtitle: const Text('Playlists, edits, favorites, settings and history'),
            onTap: () => context.push(Routes.backup),
          ),
          const _Header('Listening'),
          ListTile(
            leading: const Icon(Icons.insights_rounded),
            title: const Text('Replay: Your Top Music'),
            onTap: () => context.push(Routes.replay),
          ),
          ListTile(
            leading: Icon(Icons.delete_sweep_outlined, color: context.colors.error),
            title: const Text('Clear listening history'),
            subtitle: const Text('Resets play counts, statistics and Replay'),
            onTap: () async {
              final ok = await confirm(
                context,
                title: 'Clear listening history?',
                message: 'All play counts, listening statistics and Replay data on this device will be permanently deleted. Songs and playlists are kept.',
                confirmLabel: 'Clear history',
                destructive: true,
              );
              if (!ok) return;
              await ref.read(databaseProvider).historyDao.clearAll();
              if (context.mounted) showMessage(context, 'Listening history cleared');
            },
          ),
          const _Header('Privacy and network'),
          SwitchListTile(
            title: const Text('Online metadata lookups'),
            subtitle: const Text(
              'Lets you search MusicBrainz and Cover Art Archive from the song editor, and show YouTube video titles. '
              'Requires internet. Only the song title and artist you look up are sent — never your listening history.',
            ),
            value: s.onlineLookups,
            onChanged: (v) => ctrl.update((s) => s.copyWith(onlineLookups: v)),
          ),
          const ListTile(
            leading: Icon(Icons.shield_outlined),
            title: Text('Your data stays on this device'),
            subtitle: Text(
              'No account, no ads, no analytics and no cloud sync. Imported music, playlists and statistics are stored locally. '
              'The network is used only for downloads you start and lookups you enable.',
            ),
          ),
          const _Header('About'),
          const _StorageTile(),
          const ListTile(title: Text('Music'), subtitle: Text('Version 1.0.0')),
          const SizedBox(height: Spacing.xxl),
        ],
      ),
    );
  }
}

class _StorageTile extends ConsumerWidget {
  const _StorageTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paths = ref.watch(storagePathsProvider);
    var bytes = 0;
    var files = 0;
    try {
      for (final f in paths.musicDir.listSync().whereType<File>()) {
        bytes += f.statSync().size;
        files++;
      }
    } catch (_) {}
    return ListTile(
      leading: const Icon(Icons.sd_storage_outlined),
      title: const Text('Songs stored by Music'),
      subtitle: Text('$files files · ${formatBytes(bytes)}'),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(Spacing.page, Spacing.xl, Spacing.page, Spacing.sm),
    child: Text(
      text.toUpperCase(),
      style: context.text.labelMedium?.copyWith(color: context.colors.primary, letterSpacing: 1.2),
    ),
  );
}

class CustomizeHomeScreen extends ConsumerWidget {
  const CustomizeHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = ref.watch(settingsProvider.select((s) => s.homeSections));
    final ctrl = ref.read(settingsProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize Home'),
        actions: [
          TextButton(
            onPressed: () async {
              if (await confirm(
                context,
                title: 'Restore default layout?',
                message: 'Section order, visibility and pins will be reset.',
                confirmLabel: 'Restore',
              )) {
                await ctrl.resetHome();
              }
            },
            child: const Text('Reset'),
          ),
        ],
      ),
      body: ReorderableListView.builder(
        header: const Padding(
          padding: EdgeInsets.all(Spacing.page),
          child: Text('Drag to reorder. Pin playlists and artists from their pages to show them in "Pinned".'),
        ),
        itemCount: sections.length,
        onReorderItem: (from, to) {
          final next = [...sections];
          next.insert(to, next.removeAt(from));
          ctrl.update((s) => s.copyWith(homeSections: next));
        },
        itemBuilder: (context, i) {
          final section = sections[i];
          return SwitchListTile(
            key: ValueKey(section.id),
            title: Text(section.id.label),
            secondary: const Icon(Icons.drag_indicator_rounded),
            value: section.visible,
            onChanged: (v) {
              final next = [...sections]..[i] = HomeSectionConfig(section.id, v);
              ctrl.update((s) => s.copyWith(homeSections: next));
            },
          );
        },
      ),
    );
  }
}
