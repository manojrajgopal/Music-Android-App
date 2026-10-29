import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../app/theme/app_theme.dart';
import '../../core/errors/app_exception.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/common.dart';
import '../../data/services/backup_service.dart';

final backupServiceProvider = Provider<BackupService>(
  (ref) => BackupService(ref.watch(databaseProvider), ref.watch(settingsRepositoryProvider)),
);

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _includeHistory = true;
  bool _busy = false;

  Future<void> _create() async {
    setState(() => _busy = true);
    try {
      final bytes = await ref.read(backupServiceProvider).create(includeHistory: _includeHistory);
      final name = 'cadence-backup-${DateFormat('yyyyMMdd-HHmm').format(DateTime.now())}.zip';
      final saved = await FilePicker.saveFile(
        fileName: name,
        bytes: bytes,
        mimeType: 'application/zip',
        dialogTitle: 'Save backup',
      );
      if (mounted) {
        showMessage(context, saved == null ? 'Backup not saved' : 'Backup saved (${formatBytes(bytes.length)})');
      }
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    final service = ref.read(backupServiceProvider);
    setState(() => _busy = true);
    try {
      final file = await FilePicker.pickFile(type: FileType.custom, allowedExtensions: const ['zip']);
      if (file == null) return;
      final size = await file.length();
      if (size != null && size > BackupService.maxBackupBytes) {
        throw const AppException('too_large', 'This backup is too large.');
      }
      final parsed = service.parse(await file.readAsBytes());
      final preview = await service.preview(parsed);
      if (!mounted) return;
      final options = await showModalBottomSheet<_RestoreOptions>(
        context: context,
        isScrollControlled: true,
        builder: (_) => _PreviewSheet(preview: preview),
      );
      if (options == null) return;
      final report = await service.restore(
        parsed,
        conflict: options.conflict,
        restoreSettings: options.settings,
        restoreHistory: options.history,
      );
      ref.invalidate(settingsProvider);
      if (mounted) {
        showMessage(
          context,
          'Restored ${report.playlistsCreated} playlists, updated ${report.tracksUpdated} songs'
          '${report.historyAdded > 0 ? ', added ${report.historyAdded} history records' : ''}'
          '${report.entriesSkipped > 0 ? '. ${report.entriesSkipped} playlist songs were not found on this device' : ''}.',
        );
      }
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backup and restore')),
      body: AbsorbPointer(
        absorbing: _busy,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.page),
          children: [
            if (_busy) const LinearProgressIndicator(),
            Text(
              'A backup saves your library organisation: playlists and their order, metadata edits, favorites, ratings, '
              'tags, Home layout and settings — and optionally your listening history. It does not include the audio files '
              'themselves; keep your music files separately.',
              style: context.text.bodyMedium,
            ),
            const SizedBox(height: Spacing.lg),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Include listening history'),
              value: _includeHistory,
              onChanged: (v) => setState(() => _includeHistory = v),
            ),
            FilledButton.icon(
              icon: const Icon(Icons.save_alt_rounded),
              label: const Text('Create backup'),
              onPressed: _create,
            ),
            const SizedBox(height: Spacing.xxl),
            Text('Restore', style: context.text.titleLarge),
            const SizedBox(height: Spacing.sm),
            Text(
              'Restoring merges a backup into this library. You will see a preview first. Nothing on this device is deleted: '
              'restored playlists are added next to your current ones, and songs are matched by file fingerprint or by title, artist and length.',
              style: context.text.bodyMedium?.copyWith(color: context.surfaces.muted),
            ),
            const SizedBox(height: Spacing.lg),
            OutlinedButton.icon(
              icon: const Icon(Icons.restore_rounded),
              label: const Text('Choose a backup…'),
              onPressed: _restore,
            ),
          ],
        ),
      ),
    );
  }
}

class _RestoreOptions {
  const _RestoreOptions(this.conflict, this.settings, this.history);

  final RestoreConflict conflict;
  final bool settings;
  final bool history;
}

class _PreviewSheet extends StatefulWidget {
  const _PreviewSheet({required this.preview});

  final BackupPreview preview;

  @override
  State<_PreviewSheet> createState() => _PreviewSheetState();
}

class _PreviewSheetState extends State<_PreviewSheet> {
  RestoreConflict _conflict = RestoreConflict.keepLocal;
  late bool _settings = widget.preview.hasSettings;
  late bool _history = widget.preview.historyRecords > 0;

  @override
  Widget build(BuildContext context) {
    final p = widget.preview;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(Spacing.page, 0, Spacing.page, Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Backup from ${formatDate(p.createdAt)}', style: context.text.titleLarge),
            const SizedBox(height: Spacing.md),
            Text('• ${p.matchedTracks} of ${p.tracks} songs found on this device'),
            Text(
              '• ${p.playlists} playlists (${p.playlistEntries} entries'
              '${p.unmatchedPlaylistEntries > 0 ? ', ${p.unmatchedPlaylistEntries} unavailable' : ''})',
            ),
            Text('• ${p.favorites} favorites · ${p.edits} songs with edited info'),
            Text('• ${p.historyRecords} listening history records'),
            if (p.matchedTracks < p.tracks)
              Padding(
                padding: const EdgeInsets.only(top: Spacing.sm),
                child: Text(
                  'Songs not on this device are skipped. Import their files and restore again to include them.',
                  style: context.text.bodySmall?.copyWith(color: context.surfaces.muted),
                ),
              ),
            const SizedBox(height: Spacing.lg),
            Text('When both have a value', style: context.text.titleSmall),
            RadioGroup<RestoreConflict>(
              groupValue: _conflict,
              onChanged: (v) => setState(() => _conflict = v!),
              child: const Column(
                children: [
                  RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    value: RestoreConflict.keepLocal,
                    title: Text('Keep this device\'s values'),
                    subtitle: Text('Only fill in what is missing'),
                  ),
                  RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    value: RestoreConflict.preferBackup,
                    title: Text('Use the backup\'s values'),
                    subtitle: Text('For ratings and edited song info'),
                  ),
                ],
              ),
            ),
            if (p.hasSettings)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Restore settings and Home layout'),
                value: _settings,
                onChanged: (v) => setState(() => _settings = v),
              ),
            if (p.historyRecords > 0)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Restore listening history'),
                subtitle: const Text('Records already on this device are not duplicated'),
                value: _history,
                onChanged: (v) => setState(() => _history = v),
              ),
            const SizedBox(height: Spacing.md),
            FilledButton(
              onPressed: () => Navigator.pop(context, _RestoreOptions(_conflict, _settings, _history)),
              child: const Text('Restore'),
            ),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ],
        ),
      ),
    );
  }
}
