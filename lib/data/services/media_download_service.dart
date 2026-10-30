import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

import '../../core/errors/app_exception.dart';
import 'storage_paths.dart';
import 'url_import_service.dart';

/// Audio saved from a link, ready to be imported into the library.
class DownloadedAudio {
  const DownloadedAudio({required this.file, required this.fileName, this.title, this.artist, this.album, this.cover});

  final File file;

  /// Sanitized `<title>.<ext>` used as the library file name.
  final String fileName;
  final String? title;
  final String? artist;
  final String? album;
  final File? cover;
}

/// Finds the first web link in pasted or shared text ("Listen: https://…").
/// A bare `youtu.be/…` or `www.…` gets `https://` added.
Uri? extractLink(String text) {
  final match = RegExp(
    r'''(?:https?://|www\.)[^\s<>"']+|\b[a-z0-9-]+(?:\.[a-z0-9-]+)+/[^\s<>"']*''',
    caseSensitive: false,
  ).firstMatch(text.trim());
  if (match == null) return null;
  var raw = match.group(0)!;
  if (!raw.toLowerCase().startsWith('http')) raw = 'https://$raw';
  final uri = Uri.tryParse(raw);
  return uri == null || uri.host.isEmpty || !uri.host.contains('.') ? null : uri;
}

/// A stable name for what a link points at, so the same song shared twice
/// (with different tracking parameters or link styles) is recognised.
String linkKey(Uri link) {
  final host = link.host.toLowerCase().replaceFirst(RegExp(r'^(www|m|music)\.'), '');
  final segments = link.pathSegments.where((s) => s.isNotEmpty).toList();
  if (host == 'youtu.be' && segments.isNotEmpty) return 'youtube:${segments.first}';
  if (host == 'youtube.com') {
    final v = link.queryParameters['v'];
    if (v != null && v.isNotEmpty) return 'youtube:$v';
    if (segments.length >= 2 && const {'shorts', 'live', 'embed'}.contains(segments.first)) {
      return 'youtube:${segments[1]}';
    }
  }
  return '$host/${segments.join('/')}';
}

/// Saves the best available audio from a link — YouTube, YouTube Music,
/// Instagram, TikTok, X, Facebook, SoundCloud and the other sites yt-dlp
/// reads — always audio only, always the highest-bitrate stream.
///
/// yt-dlp and ffmpeg run on the device (android/.../MediaDownloader.kt). If
/// that path fails, or the platform has no extractor, a direct audio-file link
/// is fetched with [UrlImportService] instead.
class MediaDownloadService {
  MediaDownloadService(this._paths, this._direct, {MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('cadence/media_downloader') {
    _channel.setMethodCallHandler(_onCall);
  }

  final StoragePaths _paths;
  final UrlImportService _direct;
  final MethodChannel _channel;
  final _listeners = <String, void Function(double?)>{};
  var _counter = 0;

  Future<dynamic> _onCall(MethodCall call) async {
    if (call.method != 'progress') return;
    final args = Map<String, Object?>.from(call.arguments as Map);
    _listeners[args['id']]?.call((args['progress'] as num?)?.toDouble());
  }

  /// Unpacks the extractor and refreshes it in the background, so the first
  /// download starts sooner.
  Future<void> warmUp() async {
    try {
      await _channel.invokeMethod<void>('warmUp');
    } catch (_) {}
  }

  /// Starts a download. Progress is 0–1, or null while converting.
  DownloadTask start(Uri url, {void Function(double? progress)? onProgress}) {
    final id = '${DateTime.now().microsecondsSinceEpoch}-${_counter++}';
    return DownloadTask._(id, this, _run(url, id, onProgress));
  }

  Future<DownloadedAudio> _run(Uri url, String id, void Function(double?)? onProgress) async {
    if (onProgress != null) _listeners[id] = onProgress;
    final dir = Directory(p.join(_paths.tempDir.path, 'dl-$id'));
    try {
      final result = await _channel.invokeMapMethod<String, Object?>('download', {
        'url': url.toString(),
        'id': id,
        'dir': dir.path,
      });
      return _fromNative(result!);
    } on PlatformException catch (e) {
      if (e.code == 'cancelled') throw const AppException('cancelled', 'Download cancelled.');
      return _directFallback(url, onProgress);
    } on MissingPluginException {
      return _directFallback(url, onProgress);
    } finally {
      _listeners.remove(id);
    }
  }

  DownloadedAudio _fromNative(Map<String, Object?> r) {
    final file = File(r['path']! as String);
    final title = r['title'] as String?;
    final cover = r['cover'] as String?;
    return DownloadedAudio(
      file: file,
      fileName: sanitizeFileName('${title ?? 'Download'}.${r['ext']}'),
      title: title,
      artist: r['artist'] as String?,
      album: r['album'] as String?,
      cover: cover == null ? null : File(cover),
    );
  }

  /// The direct engine: a plain https link to an audio file.
  Future<DownloadedAudio> _directFallback(Uri url, void Function(double?)? onProgress) async {
    try {
      final info = await _direct.inspect(url);
      final file = await _direct.download(
        info,
        onProgress: (received, total) => onProgress?.call(total == null || total == 0 ? null : received / total),
      );
      return DownloadedAudio(file: file, fileName: info.fileName);
    } catch (_) {
      throw const AppException('download_failed', 'Could not download this link.');
    }
  }

  Future<void> _cancel(String id) async {
    try {
      await _channel.invokeMethod<void>('cancel', {'id': id});
    } catch (_) {}
  }

  /// Removes the per-download working folder once its file has been imported.
  Future<void> cleanUp(DownloadedAudio audio) async {
    final dir = audio.file.parent;
    if (p.basename(dir.path).startsWith('dl-') && dir.existsSync()) {
      await dir.delete(recursive: true).catchError((_) => dir);
    }
  }
}

class DownloadTask {
  DownloadTask._(this._id, this._service, this.result);

  final String _id;
  final MediaDownloadService _service;
  final Future<DownloadedAudio> result;

  Future<void> cancel() => _service._cancel(_id);
}
