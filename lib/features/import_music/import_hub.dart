import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/widgets/common.dart';
import '../../data/services/import_service.dart';
import '../playlists/playlist_actions.dart';
import 'import_controller.dart';

/// The center action: import, create and maintenance shortcuts.
Future<void> showImportHub(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  builder: (_) => _ImportHub(parent: context),
);

class _ImportHub extends ConsumerWidget {
  const _ImportHub({required this.parent});

  final BuildContext parent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void close() => Navigator.pop(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Spacing.lg, 0, Spacing.lg, Spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
              child: Text('Add music', style: context.text.headlineSmall),
            ),
            const SizedBox(height: Spacing.lg),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: Spacing.md,
              crossAxisSpacing: Spacing.md,
              childAspectRatio: 1.45,
              children: [
                _HubTile(
                  icon: Icons.library_music_rounded,
                  title: 'Import files',
                  subtitle: 'MP3, M4A, FLAC, WAV, Ogg',
                  highlighted: true,
                  onTap: () {
                    close();
                    startFileImport(parent, ref);
                  },
                ),
                _HubTile(
                  icon: Icons.link_rounded,
                  title: 'From a URL',
                  subtitle: 'Direct audio links you may download',
                  onTap: () {
                    close();
                    parent.push(Routes.urlImport);
                  },
                ),
                _HubTile(
                  icon: Icons.playlist_add_rounded,
                  title: 'New playlist',
                  subtitle: 'Start a collection',
                  onTap: () {
                    close();
                    createPlaylistFlow(parent, ref);
                  },
                ),
                _HubTile(
                  icon: Icons.sync_rounded,
                  title: 'Rescan library',
                  subtitle: 'Find changes and missing files',
                  onTap: () {
                    close();
                    startRescan(parent, ref);
                  },
                ),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
              leading: const Icon(Icons.queue_music_rounded),
              title: const Text('Open queue'),
              onTap: () {
                close();
                parent.push(Routes.queue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HubTile extends StatelessWidget {
  const _HubTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final accent = context.colors.primary;
    return Material(
      color: highlighted ? accent.withValues(alpha: 0.16) : context.surfaces.overlay,
      borderRadius: BorderRadius.circular(Radii.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: highlighted ? accent : null),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodySmall?.copyWith(color: context.surfaces.muted),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Explains the storage policy once, then opens the system file picker.
Future<void> startFileImport(BuildContext context, WidgetRef ref) async {
  final settings = ref.read(settingsProvider);
  if (!settings.copyConsent) {
    final ok = await confirm(
      context,
      title: 'Keep a copy in Cadence?',
      message:
          'Files chosen with the system picker only grant temporary access, so Cadence stores a private copy '
          'of each imported song on this device for reliable playback. Copies use storage space; you can delete '
          'them from the song menu at any time. Nothing is uploaded.',
      confirmLabel: 'Agree and choose files',
    );
    if (!ok) return;
    await ref.read(settingsProvider.notifier).update((s) => s.copyWith(copyConsent: true));
  }
  if (!context.mounted) return;
  final picked = await ref.read(importControllerProvider.notifier).pickAndImport().catchError((_) => false);
  if (picked && context.mounted) showImportProgress(context);
}

Future<void> startRescan(BuildContext context, WidgetRef ref) async {
  showMessage(context, 'Rescanning library…');
  final report = await ref.read(importControllerProvider.notifier).rescan();
  if (!context.mounted) return;
  final parts = [
    '${report.checked} checked',
    if (report.added > 0) '${report.added} added',
    if (report.updated > 0) '${report.updated} updated',
    if (report.missing > 0) '${report.missing} missing',
    if (report.restored > 0) '${report.restored} available again',
  ];
  showMessage(context, 'Rescan complete: ${parts.join(', ')}');
}

void showImportProgress(BuildContext context) =>
    showModalBottomSheet<void>(context: context, isScrollControlled: true, builder: (_) => const ImportProgressSheet());

class ImportProgressSheet extends ConsumerWidget {
  const ImportProgressSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(importControllerProvider);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.92,
      builder: (context, controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(state.running ? 'Importing…' : 'Import finished', style: context.text.titleLarge),
                const SizedBox(height: Spacing.sm),
                LinearProgressIndicator(value: state.progress, semanticsLabel: 'Import progress'),
                const SizedBox(height: Spacing.sm),
                Text(
                  '${state.completed} of ${state.items.length} · '
                  '${state.count(ImportOutcome.imported) + state.count(ImportOutcome.possibleDuplicate)} added · '
                  '${state.count(ImportOutcome.duplicate)} already in library · '
                  '${state.count(ImportOutcome.failed)} failed',
                  style: context.text.bodySmall?.copyWith(color: context.surfaces.muted),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: controller,
              itemCount: state.items.length,
              itemBuilder: (context, i) {
                final item = state.items[i];
                final outcome = item.result?.outcome;
                final (icon, color) = switch (outcome) {
                  ImportOutcome.imported => (Icons.check_circle_rounded, Colors.green),
                  ImportOutcome.possibleDuplicate => (Icons.content_copy_rounded, Colors.orange),
                  ImportOutcome.duplicate => (Icons.copy_all_rounded, context.surfaces.muted),
                  ImportOutcome.failed => (Icons.error_rounded, context.colors.error),
                  null => (Icons.hourglass_top_rounded, context.surfaces.muted),
                };
                return ListTile(
                  leading: item.status == ImportItemStatus.working
                      ? const SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2))
                      : Icon(icon, color: color),
                  title: Text(item.result?.track?.title ?? item.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: item.result?.message == null ? null : Text(item.result!.message!),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(Spacing.lg),
              child: FilledButton(
                onPressed: state.running ? null : () => Navigator.pop(context),
                child: Text(state.running ? 'Importing…' : 'Done'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
