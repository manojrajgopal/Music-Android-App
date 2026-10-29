import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

import '../../core/constants/app_constants.dart';
import '../../core/errors/app_exception.dart';
import 'metadata_service.dart';
import 'storage_paths.dart';

enum LinkKind { directAudio, youtube, streamingService, invalid }

class LinkCheck {
  const LinkCheck(this.kind, {this.uri, this.message, this.youtubeVideoId});

  final LinkKind kind;
  final Uri? uri;
  final String? message;
  final String? youtubeVideoId;
}

/// Services whose content may not be downloaded as files. Links to them are
/// recognised and refused instead of being fetched.
const _streamingHosts = {
  'spotify.com',
  'open.spotify.com',
  'soundcloud.com',
  'music.apple.com',
  'deezer.com',
  'tidal.com',
  'music.amazon.com',
  'jiosaavn.com',
  'gaana.com',
  'wynk.in',
  'pandora.com',
  'bandcamp.com',
  'audiomack.com',
  'vimeo.com',
  'instagram.com',
  'facebook.com',
  'tiktok.com',
};

final _ytId = RegExp(r'^[A-Za-z0-9_-]{11}$');

/// Recognises YouTube URLs (www, m., music., youtu.be, shorts, embed).
String? youtubeVideoId(Uri uri) {
  final host = uri.host.toLowerCase().replaceFirst(RegExp(r'^(www|m|music)\.'), '');
  String? id;
  if (host == 'youtu.be') {
    id = uri.pathSegments.firstOrNull;
  } else if (host == 'youtube.com' || host == 'youtube-nocookie.com') {
    if (uri.path == '/watch') {
      id = uri.queryParameters['v'];
    } else if (uri.pathSegments.length >= 2 &&
        const {'shorts', 'embed', 'live', 'v'}.contains(uri.pathSegments.first)) {
      id = uri.pathSegments[1];
    } else {
      return '';
    }
  } else {
    return null;
  }
  return id != null && _ytId.hasMatch(id) ? id : '';
}

bool _isStreamingHost(String host) {
  final h = host.toLowerCase();
  return _streamingHosts.any((s) => h == s || h.endsWith('.$s'));
}

/// Classifies a pasted link before any network access.
LinkCheck checkLink(String input) {
  final uri = Uri.tryParse(input.trim());
  if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
    return const LinkCheck(LinkKind.invalid, message: 'Enter a complete link starting with https://');
  }
  final yt = youtubeVideoId(uri);
  if (yt != null) {
    return LinkCheck(LinkKind.youtube, uri: uri, youtubeVideoId: yt.isEmpty ? null : yt);
  }
  if (uri.scheme != 'https') {
    return LinkCheck(LinkKind.invalid, uri: uri, message: 'Only secure https:// links are supported.');
  }
  if (_isStreamingHost(uri.host)) {
    return LinkCheck(
      LinkKind.streamingService,
      uri: uri,
      message: 'This is a streaming service link. Music cannot download from streaming services.',
    );
  }
  if (uri.userInfo.isNotEmpty) {
    return LinkCheck(LinkKind.invalid, uri: uri, message: 'Links containing credentials are not supported.');
  }
  return LinkCheck(LinkKind.directAudio, uri: uri);
}

/// True for loopback, private, link-local, CGNAT, multicast and unspecified
/// addresses, which a download must never reach.
bool isPrivateAddress(InternetAddress a) {
  if (a.isLoopback || a.isLinkLocal || a.isMulticast) return true;
  final b = a.rawAddress;
  if (a.type == InternetAddressType.IPv4) {
    return b[0] == 0 ||
        b[0] == 10 ||
        (b[0] == 100 && b[1] >= 64 && b[1] <= 127) ||
        (b[0] == 172 && b[1] >= 16 && b[1] <= 31) ||
        (b[0] == 192 && b[1] == 168) ||
        (b[0] == 169 && b[1] == 254) ||
        (b[0] == 198 && (b[1] == 18 || b[1] == 19)) ||
        b[0] >= 224;
  }
  if (b.every((x) => x == 0)) return true;
  if ((b[0] & 0xFE) == 0xFC) return true; // fc00::/7 unique local
  // IPv4-mapped (::ffff:a.b.c.d)
  if (b.sublist(0, 10).every((x) => x == 0) && b[10] == 0xFF && b[11] == 0xFF) {
    return isPrivateAddress(InternetAddress.fromRawAddress(Uint8List.fromList(b.sublist(12))));
  }
  return false;
}

typedef HostResolver = Future<List<InternetAddress>> Function(String host);

class RemoteFileInfo {
  const RemoteFileInfo({required this.finalUri, required this.fileName, this.contentType, this.sizeBytes, this.format});

  final Uri finalUri;
  final String fileName;
  final String? contentType;
  final int? sizeBytes;
  final AudioFormat? format;
}

const _audioMime = {
  'audio/mpeg',
  'audio/mp3',
  'audio/mp4',
  'audio/x-m4a',
  'audio/m4a',
  'audio/aac',
  'audio/flac',
  'audio/x-flac',
  'audio/wav',
  'audio/x-wav',
  'audio/wave',
  'audio/ogg',
  'audio/opus',
  'application/ogg',
  'application/octet-stream',
  'binary/octet-stream',
};

/// Downloads directly-linked audio files with strict validation:
/// https only, no private-network destinations (checked on every redirect),
/// content sniffed from bytes, size and time limits, temporary file with
/// atomic rename on success.
class UrlImportService {
  UrlImportService(this._paths, {Dio? dio, HostResolver? resolver})
    : _dio = dio ?? Dio(),
      _resolve = resolver ?? InternetAddress.lookup {
    _dio.options
      ..followRedirects = false
      ..connectTimeout = ImportRules.connectTimeout
      ..receiveTimeout = const Duration(seconds: 30)
      ..validateStatus = ((_) => true)
      ..headers = {'User-Agent': 'Cadence/1.0 (offline music player)'};
  }

  final StoragePaths _paths;
  final Dio _dio;
  final HostResolver _resolve;

  Future<void> _assertPublic(Uri uri) async {
    if (uri.scheme != 'https') {
      throw const AppException('insecure', 'The link redirected to an insecure (non-https) address.');
    }
    final host = uri.host;
    final literal = InternetAddress.tryParse(host);
    final addresses = literal != null
        ? [literal]
        : await _resolve(host).catchError(
            (_) =>
                throw const AppException('dns', 'The server could not be found. Check the link and your connection.'),
          );
    if (addresses.isEmpty || addresses.any(isPrivateAddress)) {
      throw const AppException('private', 'Links to local or private network addresses are not allowed.');
    }
    if (_isStreamingHost(host) || youtubeVideoId(uri) != null) {
      throw const AppException('streaming', 'The link redirected to a streaming service, which cannot be downloaded.');
    }
  }

  /// Follows redirects manually, validating every hop.
  Future<Response<ResponseBody>> _open(Uri start, {CancelToken? cancel, Map<String, String>? headers}) async {
    var uri = start;
    for (var hop = 0; hop <= ImportRules.maxRedirects; hop++) {
      await _assertPublic(uri);
      final res = await _dio.getUri<ResponseBody>(
        uri,
        options: Options(responseType: ResponseType.stream, headers: headers),
        cancelToken: cancel,
      );
      final code = res.statusCode ?? 0;
      if (code >= 300 && code < 400) {
        final location = res.headers.value('location');
        await res.data?.stream.drain<void>().catchError((_) {});
        if (location == null) throw const AppException('redirect', 'The server sent an invalid redirect.');
        uri = uri.resolve(location);
        continue;
      }
      if (code == 401 || code == 403) {
        await res.data?.stream.drain<void>().catchError((_) {});
        throw const AppException(
          'forbidden',
          'The server refused access. You may not have permission to download this file.',
        );
      }
      if (code == 404 || code == 410) {
        throw const AppException('gone', 'The file was not found. The link may have expired.');
      }
      if (code < 200 || code >= 300) {
        throw AppException('http', 'The server returned an error ($code). Try again later.');
      }
      return res..requestOptions.extra['finalUri'] = uri;
    }
    throw const AppException('redirects', 'Too many redirects.');
  }

  /// Fetches headers and the first bytes to confirm the link is audio.
  Future<RemoteFileInfo> inspect(Uri uri, {CancelToken? cancel}) async {
    final res = await _open(uri, cancel: cancel, headers: {'Range': 'bytes=0-4095'});
    final finalUri = res.requestOptions.extra['finalUri'] as Uri;
    final head = BytesBuilder();
    try {
      await for (final chunk in res.data!.stream) {
        head.add(chunk);
        if (head.length >= 4096) break;
      }
    } catch (_) {}
    final contentType = res.headers.value(Headers.contentTypeHeader)?.split(';').first.trim().toLowerCase();
    if (contentType != null && !_audioMime.contains(contentType)) {
      throw AppException('not_audio', 'The link points to "$contentType", not an audio file.');
    }
    final format = sniffAudioFormat(head.takeBytes());
    if (format == null) throw const AppException('not_audio', 'The link does not contain a supported audio file.');
    final size = _totalSize(res.headers);
    if (size != null && size > ImportRules.maxDownloadBytes) {
      throw const AppException('too_large', 'The file is larger than the 300 MB limit.');
    }
    return RemoteFileInfo(
      finalUri: finalUri,
      fileName: _fileName(res.headers, finalUri, format),
      contentType: contentType,
      sizeBytes: size,
      format: format,
    );
  }

  int? _totalSize(Headers headers) {
    final range = headers.value('content-range');
    if (range != null && range.contains('/')) return int.tryParse(range.split('/').last);
    return int.tryParse(headers.value(Headers.contentLengthHeader) ?? '');
  }

  String _fileName(Headers headers, Uri uri, AudioFormat format) {
    final disposition = headers.value('content-disposition');
    String? name;
    if (disposition != null) {
      final m = RegExp(r'''filename\*?=(?:UTF-8'')?"?([^";]+)"?''', caseSensitive: false).firstMatch(disposition);
      name = m == null ? null : Uri.decodeComponent(m.group(1)!);
    }
    name ??= uri.pathSegments.where((s) => s.isNotEmpty).lastOrNull;
    final ext = switch (format) {
      AudioFormat.mp3 => 'mp3',
      AudioFormat.m4a => 'm4a',
      AudioFormat.flac => 'flac',
      AudioFormat.wav => 'wav',
      AudioFormat.ogg => 'ogg',
    };
    var safe = sanitizeFileName(name ?? 'download');
    if (p.extension(safe).replaceFirst('.', '').toLowerCase() != ext) safe = '${p.basenameWithoutExtension(safe)}.$ext';
    return safe;
  }

  /// Downloads to a temporary file, verifies it, and returns it. The caller
  /// imports (moves) it into the library.
  Future<File> download(
    RemoteFileInfo info, {
    CancelToken? cancel,
    void Function(int received, int? total)? onProgress,
  }) async {
    final temp = File(p.join(_paths.tempDir.path, '${DateTime.now().microsecondsSinceEpoch}.part'));
    IOSink? sink;
    try {
      final res = await _open(info.finalUri, cancel: cancel);
      final total = _totalSize(res.headers) ?? info.sizeBytes;
      sink = temp.openWrite();
      var received = 0;
      final deadline = DateTime.now().add(ImportRules.downloadTimeout);
      await for (final chunk in res.data!.stream) {
        received += chunk.length;
        if (received > ImportRules.maxDownloadBytes) {
          throw const AppException('too_large', 'The file is larger than the 300 MB limit.');
        }
        if (DateTime.now().isAfter(deadline)) {
          throw const AppException('timeout', 'The download took too long and was stopped.');
        }
        sink.add(chunk);
        onProgress?.call(received, total);
      }
      await sink.flush();
      await sink.close();
      sink = null;
      if (total != null && received != total) {
        throw const AppException('incomplete', 'The download was interrupted. Please retry.');
      }
      if (await sniffFile(temp) == null) {
        throw const AppException('not_audio', 'The downloaded file is not valid audio.');
      }
      final named = File(p.join(_paths.tempDir.path, info.fileName));
      if (named.existsSync()) await named.delete();
      return await temp.rename(named.path);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) throw const AppException('cancelled', 'Download cancelled.');
      throw switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.receiveTimeout => const AppException('timeout', 'The connection timed out. Please retry.'),
        DioExceptionType.connectionError => const AppException(
          'offline',
          'Could not connect. Check your internet connection and retry.',
        ),
        _ => const AppException('network', 'A network error interrupted the download. Please retry.'),
      };
    } on FileSystemException catch (e) {
      final code = e.osError?.errorCode;
      throw (code == 28 || code == 112)
          ? const AppException('no_space', 'Not enough storage space for this download.')
          : const AppException('io', 'The file could not be saved.');
    } finally {
      await sink?.close().catchError((_) {});
      if (temp.existsSync()) await temp.delete().catchError((_) => temp);
    }
  }
}
