import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../core/errors/app_exception.dart';

/// Candidate metadata from MusicBrainz. Nothing is applied automatically —
/// the user chooses a candidate or ignores the results.
class MetadataCandidate {
  const MetadataCandidate({required this.title, this.artist, this.album, this.year, this.releaseId, this.score = 0});

  final String title;
  final String? artist;
  final String? album;
  final int? year;
  final String? releaseId;
  final int score;
}

class YoutubeInfo {
  const YoutubeInfo({required this.title, this.author, this.thumbnailUrl});

  final String title;
  final String? author;
  final String? thumbnailUrl;
}

/// Optional, user-enabled lookups made directly from the device to public
/// APIs (MusicBrainz, Cover Art Archive, YouTube oEmbed). No listening
/// history or library contents are sent — only the fields being looked up.
class OnlineMetadataService {
  OnlineMetadataService({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options
      ..connectTimeout = const Duration(seconds: 15)
      ..receiveTimeout = const Duration(seconds: 20)
      // MusicBrainz requires an identifying User-Agent. Release builds should
      // add a contact URL here as described in the README.
      ..headers = {'User-Agent': 'Cadence/1.0.0 (offline music player)', 'Accept': 'application/json'};
  }

  final Dio _dio;

  Future<List<MetadataCandidate>> searchRecording({required String title, String? artist}) async {
    String esc(String s) => s.replaceAll(RegExp(r'([+\-&|!(){}\[\]^"~*?:\\/])'), r'\$1');
    final query = [
      'recording:"${esc(title)}"',
      if (artist != null && artist.isNotEmpty) 'artist:"${esc(artist)}"',
    ].join(' AND ');
    try {
      final res = await _dio.getUri<Map<String, dynamic>>(
        Uri.https('musicbrainz.org', '/ws/2/recording', {'query': query, 'fmt': 'json', 'limit': '8'}),
      );
      final recordings = (res.data?['recordings'] as List?) ?? const [];
      return [
        for (final r in recordings.cast<Map<String, dynamic>>())
          () {
            final releases = (r['releases'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
            final release = releases.firstOrNull;
            final credits = (r['artist-credit'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
            final date = (release?['date'] ?? r['first-release-date']) as String?;
            return MetadataCandidate(
              title: r['title'] as String? ?? title,
              artist: credits.isEmpty ? null : credits.map((c) => '${c['name']}${c['joinphrase'] ?? ''}').join(),
              album: release?['title'] as String?,
              year: date == null || date.length < 4 ? null : int.tryParse(date.substring(0, 4)),
              releaseId: release?['id'] as String?,
              score: (r['score'] as num?)?.toInt() ?? 0,
            );
          }(),
      ];
    } on DioException {
      throw const AppException(
        'offline',
        'Online lookup failed. Check your connection — your library still works offline.',
      );
    }
  }

  /// Front cover for a release, if Cover Art Archive has one.
  Future<Uint8List?> coverArt(String releaseId) async {
    try {
      final res = await _dio.getUri<List<int>>(
        Uri.https('coverartarchive.org', '/release/$releaseId/front-500'),
        options: Options(responseType: ResponseType.bytes, validateStatus: (s) => s == 200),
      );
      final bytes = res.data;
      if (bytes == null || bytes.length > 10 * 1024 * 1024) return null;
      return Uint8List.fromList(bytes);
    } on DioException {
      return null;
    }
  }

  /// Public YouTube oEmbed endpoint: title and channel only.
  Future<YoutubeInfo?> youtubeInfo(Uri videoUrl) async {
    try {
      final res = await _dio.getUri<Map<String, dynamic>>(
        Uri.https('www.youtube.com', '/oembed', {'url': videoUrl.toString(), 'format': 'json'}),
      );
      final data = res.data;
      if (data == null) return null;
      return YoutubeInfo(
        title: data['title'] as String? ?? 'YouTube video',
        author: data['author_name'] as String?,
        thumbnailUrl: data['thumbnail_url'] as String?,
      );
    } on DioException {
      return null;
    }
  }
}
