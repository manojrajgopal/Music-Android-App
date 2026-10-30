import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme/app_theme.dart';
import '../../core/errors/app_exception.dart';
import '../../data/database/app_database.dart';
import '../../data/services/import_service.dart';
import '../../data/services/media_download_service.dart';
import '../../data/services/online_metadata_service.dart';
import '../../data/services/url_import_service.dart';

final urlImportServiceProvider = Provider<UrlImportService>((ref) => UrlImportService(ref.watch(storagePathsProvider)));
final mediaDownloadServiceProvider = Provider<MediaDownloadService>(
  (ref) => MediaDownloadService(ref.watch(storagePathsProvider), ref.watch(urlImportServiceProvider)),
);
final onlineMetadataProvider = Provider<OnlineMetadataService>((ref) => OnlineMetadataService());

enum _Stage { idle, downloading, done, failed }

/// Paste a link, get the song: the best audio the link offers is downloaded
/// and added to the library.
class UrlImportScreen extends ConsumerStatefulWidget {
  const UrlImportScreen({super.key});

  @override
  ConsumerState<UrlImportScreen> createState() => _UrlImportScreenState();
}

class _UrlImportScreenState extends ConsumerState<UrlImportScreen> {
  final _url = TextEditingController();
  _Stage _stage = _Stage.idle;
  Uri? _link;
  double? _progress;
  DownloadTask? _task;
  ImportResult? _result;

  @override
  void initState() {
    super.initState();
    ref.read(mediaDownloadServiceProvider).warmUp();
    _url.addListener(() {
      final link = extractLink(_url.text);
      if (link != _link) setState(() => _link = link);
    });
  }

  @override
  void dispose() {
    // A running download is left to finish and import in the background.
    _url.dispose();
    super.dispose();
  }

  Future<void> _download() async {
    final link = _link;
    if (link == null || _stage == _Stage.downloading) return;
    FocusScope.of(context).unfocus();
    final downloader = ref.read(mediaDownloadServiceProvider);
    final importer = ref.read(importServiceProvider);
    final settings = ref.read(settingsRepositoryProvider);
    final key = linkKey(link);

    // A link saved before is not downloaded again while its song is still in
    // the library.
    final knownId = settings.downloadedTrack(key);
    final known = knownId == null ? null : await ref.read(databaseProvider).tracksDao.byId(knownId);
    if (!mounted) return;
    if (known != null) {
      setState(() {
        _result = ImportResult(name: known.title, outcome: ImportOutcome.duplicate, duplicateOf: known);
        _stage = _Stage.done;
      });
      _url.clear();
      return;
    }

    setState(() => (_stage = _Stage.downloading, _progress = null, _result = null));
    final task = downloader.start(
      link,
      onProgress: (value) {
        if (mounted && _stage == _Stage.downloading) setState(() => _progress = value);
      },
    );
    _task = task;
    try {
      final audio = await task.result;
      final cover = audio.cover;
      final result = await importer.importFile(
        audio.file,
        displayName: audio.fileName,
        sourceType: TrackSourceType.download,
        moveInsteadOfCopy: true,
        hints: ImportHints(
          title: audio.title,
          artist: audio.artist,
          album: audio.album,
          artwork: cover != null && cover.existsSync() ? await cover.readAsBytes() : null,
        ),
      );
      await downloader.cleanUp(audio);
      final saved = result.track ?? result.duplicateOf;
      if (saved != null) await settings.rememberDownload(key, saved.id);
      if (!mounted || _task != task) return;
      final ok = result.outcome != ImportOutcome.failed;
      setState(() => (_result = result, _stage = ok ? _Stage.done : _Stage.failed));
      if (ok) _url.clear();
    } on AppException catch (e) {
      if (!mounted || _task != task) return;
      setState(() => _stage = e.code == 'cancelled' ? _Stage.idle : _Stage.failed);
    } catch (_) {
      if (mounted && _task == task) setState(() => _stage = _Stage.failed);
    }
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();
    if (text == null || text.isEmpty) return;
    _url.text = extractLink(text)?.toString() ?? text;
    if (_link != null && _stage != _Stage.downloading) await _download();
  }

  @override
  Widget build(BuildContext context) {
    final busy = _stage == _Stage.downloading;
    return Scaffold(
      appBar: AppBar(title: const Text('Download from a link')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Spacing.page),
          children: [
            Text(
              'Paste a link from YouTube, YouTube Music, Instagram, SoundCloud, TikTok and more. '
              'Music saves the best-quality audio straight to your library.',
              style: context.text.bodyMedium?.copyWith(color: context.surfaces.muted),
            ),
            const SizedBox(height: Spacing.lg),
            TextField(
              controller: _url,
              enabled: !busy,
              keyboardType: TextInputType.url,
              autocorrect: false,
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                hintText: 'https://youtu.be/…',
                prefixIcon: const Icon(Icons.link_rounded),
                suffixIcon: IconButton(
                  tooltip: 'Paste',
                  icon: const Icon(Icons.content_paste_rounded),
                  onPressed: busy ? null : _paste,
                ),
              ),
              onSubmitted: (_) => _download(),
            ),
            const SizedBox(height: Spacing.md),
            FilledButton.icon(
              icon: const Icon(Icons.download_rounded),
              label: const Text('Download audio'),
              onPressed: busy || _link == null ? null : _download,
            ),
            const SizedBox(height: Spacing.xl),
            if (busy) ...[
              LinearProgressIndicator(value: _progress),
              const SizedBox(height: Spacing.sm),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _progress == null ? 'Getting the best audio…' : 'Downloading ${(_progress! * 100).round()}%',
                    ),
                  ),
                  TextButton(onPressed: () => _task?.cancel(), child: const Text('Cancel')),
                ],
              ),
            ],
            if (_stage == _Stage.done && _result != null) _SuccessCard(result: _result!),
            if (_stage == _Stage.failed)
              Card(
                child: ListTile(
                  leading: Icon(Icons.refresh_rounded, color: context.colors.primary),
                  title: const Text('That didn\'t finish. Tap to try again.'),
                  onTap: _download,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SuccessCard extends StatelessWidget {
  const _SuccessCard({required this.result});

  final ImportResult result;

  @override
  Widget build(BuildContext context) {
    final track = result.track ?? result.duplicateOf;
    return Card(
      child: ListTile(
        leading: Icon(Icons.check_circle_rounded, color: context.colors.primary),
        title: Text(
          result.outcome == ImportOutcome.duplicate
              ? 'Already in your library'
              : 'Downloaded "${track?.title ?? result.name}"',
        ),
        subtitle: track?.artist == null ? null : Text(track!.artist!),
      ),
    );
  }
}
