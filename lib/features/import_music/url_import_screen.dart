import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/providers.dart';
import '../../app/theme/app_theme.dart';
import '../../core/errors/app_exception.dart';
import '../../core/utils/format.dart';
import '../../data/database/app_database.dart';
import '../../data/services/import_service.dart';
import '../../data/services/online_metadata_service.dart';
import '../../data/services/url_import_service.dart';

final urlImportServiceProvider = Provider<UrlImportService>((ref) => UrlImportService(ref.watch(storagePathsProvider)));
final onlineMetadataProvider = Provider<OnlineMetadataService>((ref) => OnlineMetadataService());

enum _Stage { idle, checking, ready, downloading, done, failed }

class UrlImportScreen extends ConsumerStatefulWidget {
  const UrlImportScreen({super.key});

  @override
  ConsumerState<UrlImportScreen> createState() => _UrlImportScreenState();
}

class _UrlImportScreenState extends ConsumerState<UrlImportScreen> {
  final _url = TextEditingController();
  _Stage _stage = _Stage.idle;
  LinkCheck? _link;
  RemoteFileInfo? _info;
  YoutubeInfo? _youtube;
  String? _error;
  bool _retryable = false;
  bool _rightsConfirmed = false;
  int _received = 0;
  int? _total;
  CancelToken? _cancel;
  ImportResult? _result;

  @override
  void dispose() {
    _cancel?.cancel();
    _url.dispose();
    super.dispose();
  }

  Future<void> _validate() async {
    FocusScope.of(context).unfocus();
    final link = checkLink(_url.text);
    setState(() {
      _link = link;
      _info = null;
      _youtube = null;
      _error = link.message;
      _result = null;
      _rightsConfirmed = false;
      _stage = link.kind == LinkKind.directAudio ? _Stage.checking : _Stage.idle;
    });
    if (link.kind == LinkKind.youtube) {
      if (ref.read(settingsProvider).onlineLookups && link.uri != null) {
        final info = await ref.read(onlineMetadataProvider).youtubeInfo(link.uri!);
        if (mounted) setState(() => _youtube = info);
      }
      return;
    }
    if (link.kind != LinkKind.directAudio) return;
    _cancel = CancelToken();
    try {
      final info = await ref.read(urlImportServiceProvider).inspect(link.uri!, cancel: _cancel);
      if (mounted) setState(() => (_info = info, _stage = _Stage.ready));
    } catch (e) {
      if (mounted) setState(() => (_error = friendlyError(e), _stage = _Stage.failed, _retryable = _isRetryable(e)));
    }
  }

  bool _isRetryable(Object e) =>
      e is AppException && const {'timeout', 'offline', 'network', 'incomplete', 'http', 'dns'}.contains(e.code);

  Future<void> _download() async {
    final info = _info;
    if (info == null) return;
    _cancel = CancelToken();
    setState(() => (_stage = _Stage.downloading, _received = 0, _total = info.sizeBytes, _error = null));
    try {
      final file = await ref
          .read(urlImportServiceProvider)
          .download(
            info,
            cancel: _cancel,
            onProgress: (r, t) {
              if (mounted) setState(() => (_received = r, _total = t));
            },
          );
      final result = await ref
          .read(importServiceProvider)
          .importFile(file, displayName: info.fileName, sourceType: TrackSourceType.download, moveInsteadOfCopy: true);
      if (!mounted) return;
      setState(() {
        _result = result;
        _stage = result.outcome == ImportOutcome.failed ? _Stage.failed : _Stage.done;
        _error = result.outcome == ImportOutcome.failed ? result.message : null;
      });
    } catch (e) {
      if (mounted) setState(() => (_error = friendlyError(e), _stage = _Stage.failed, _retryable = _isRetryable(e)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final busy = _stage == _Stage.checking || _stage == _Stage.downloading;
    return Scaffold(
      appBar: AppBar(title: const Text('Import from URL')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Spacing.page),
          children: [
            Text(
              'Paste a direct link to an audio file you have the right to download — for example, a file you own, '
              'a Creative Commons release, or a download offered by the artist.',
              style: context.text.bodyMedium?.copyWith(color: context.surfaces.muted),
            ),
            const SizedBox(height: Spacing.lg),
            TextField(
              controller: _url,
              enabled: !busy,
              keyboardType: TextInputType.url,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'https://example.com/song.mp3',
                prefixIcon: const Icon(Icons.link_rounded),
                suffixIcon: IconButton(
                  tooltip: 'Paste',
                  icon: const Icon(Icons.content_paste_rounded),
                  onPressed: () async {
                    final data = await Clipboard.getData(Clipboard.kTextPlain);
                    if (data?.text != null) _url.text = data!.text!.trim();
                  },
                ),
              ),
              onSubmitted: (_) => _validate(),
            ),
            const SizedBox(height: Spacing.md),
            FilledButton.tonal(onPressed: busy ? null : _validate, child: const Text('Validate link')),
            const SizedBox(height: Spacing.xl),
            if (_stage == _Stage.checking) const Center(child: CircularProgressIndicator()),
            if (_link?.kind == LinkKind.youtube) _YoutubeCard(link: _link!, info: _youtube),
            if (_info != null && _stage != _Stage.failed) _infoCard(context),
            if (_stage == _Stage.downloading) ...[
              const SizedBox(height: Spacing.lg),
              LinearProgressIndicator(value: _total == null || _total == 0 ? null : _received / _total!),
              const SizedBox(height: Spacing.sm),
              Row(
                children: [
                  Expanded(
                    child: Text('${formatBytes(_received)}${_total == null ? '' : ' of ${formatBytes(_total)}'}'),
                  ),
                  TextButton(onPressed: () => _cancel?.cancel(), child: const Text('Cancel')),
                ],
              ),
            ],
            if (_error != null && _link?.kind != LinkKind.youtube)
              Card(
                color: context.colors.errorContainer,
                child: ListTile(
                  leading: Icon(Icons.error_outline_rounded, color: context.colors.onErrorContainer),
                  title: Text(_error!, style: TextStyle(color: context.colors.onErrorContainer)),
                  trailing: _retryable && _stage == _Stage.failed
                      ? TextButton(onPressed: _info == null ? _validate : _download, child: const Text('Retry'))
                      : null,
                ),
              ),
            if (_stage == _Stage.done && _result != null)
              Card(
                child: ListTile(
                  leading: Icon(Icons.check_circle_rounded, color: context.colors.primary),
                  title: Text(
                    _result!.outcome == ImportOutcome.duplicate
                        ? 'Already in your library'
                        : 'Imported "${_result!.track?.title}"',
                  ),
                  subtitle: _result!.message == null ? null : Text(_result!.message!),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(BuildContext context) {
    final info = _info!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(info.fileName, style: context.text.titleMedium),
            const SizedBox(height: Spacing.xs),
            Text('Source: ${info.finalUri.host}', style: context.text.bodySmall),
            Text(
              'Type: ${info.format?.name.toUpperCase() ?? 'audio'}${info.contentType == null ? '' : ' (${info.contentType})'}',
              style: context.text.bodySmall,
            ),
            Text('Size: ${formatBytes(info.sizeBytes)}', style: context.text.bodySmall),
            const SizedBox(height: Spacing.md),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _rightsConfirmed,
              onChanged: _stage == _Stage.ready ? (v) => setState(() => _rightsConfirmed = v ?? false) : null,
              title: const Text('I have permission to download and keep this file.'),
            ),
            FilledButton.icon(
              icon: const Icon(Icons.download_rounded),
              label: const Text('Download and import'),
              onPressed: _stage == _Stage.ready && _rightsConfirmed ? _download : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _YoutubeCard extends StatelessWidget {
  const _YoutubeCard({required this.link, this.info});

  final LinkCheck link;
  final YoutubeInfo? info;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.smart_display_rounded, color: Colors.red),
                const SizedBox(width: Spacing.sm),
                Text('YouTube link', style: context.text.titleMedium),
              ],
            ),
            if (info != null) ...[
              const SizedBox(height: Spacing.sm),
              Text(info!.title, style: context.text.bodyLarge),
              if (info!.author != null) Text(info!.author!, style: context.text.bodySmall),
            ],
            const SizedBox(height: Spacing.sm),
            Text(
              link.youtubeVideoId == null
                  ? 'This YouTube link does not point to a single video.'
                  : 'Music does not download or extract audio from YouTube. Open it in YouTube instead, '
                        'or import an audio file you are allowed to keep.',
              style: context.text.bodyMedium,
            ),
            if (info == null)
              Padding(
                padding: const EdgeInsets.only(top: Spacing.xs),
                child: Text(
                  'Video details are shown only when online lookups are enabled in Settings.',
                  style: context.text.bodySmall?.copyWith(color: context.surfaces.muted),
                ),
              ),
            const SizedBox(height: Spacing.md),
            OutlinedButton.icon(
              icon: const Icon(Icons.open_in_new_rounded),
              label: const Text('Open in YouTube'),
              onPressed: () => launchUrl(link.uri!, mode: LaunchMode.externalApplication),
            ),
          ],
        ),
      ),
    );
  }
}
