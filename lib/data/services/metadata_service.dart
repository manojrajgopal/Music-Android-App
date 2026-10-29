import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

import '../../core/utils/text_normalize.dart';

/// Tags read from an audio file. All fields are optional; the title falls
/// back to the file name so a track is never untitled.
class ParsedTags {
  const ParsedTags({
    required this.title,
    this.artist,
    this.album,
    this.albumArtist,
    this.genre,
    this.language,
    this.releaseYear,
    this.durationMs,
    this.trackNumber,
    this.discNumber,
    this.artwork,
    this.titleFromFileName = false,
  });

  final String title;
  final String? artist;
  final String? album;
  final String? albumArtist;
  final String? genre;
  final String? language;
  final int? releaseYear;
  final int? durationMs;
  final int? trackNumber;
  final int? discNumber;
  final Uint8List? artwork;
  final bool titleFromFileName;
}

enum AudioFormat { mp3, m4a, flac, wav, ogg }

/// Identifies audio content from its first bytes. File extensions and HTTP
/// headers alone are never trusted.
AudioFormat? sniffAudioFormat(Uint8List head) {
  bool at(int offset, List<int> sig) {
    if (head.length < offset + sig.length) return false;
    for (var i = 0; i < sig.length; i++) {
      if (head[offset + i] != sig[i]) return false;
    }
    return true;
  }

  if (at(0, 'ID3'.codeUnits)) return AudioFormat.mp3;
  if (at(0, 'fLaC'.codeUnits)) return AudioFormat.flac;
  if (at(0, 'OggS'.codeUnits)) return AudioFormat.ogg;
  if (at(0, 'RIFF'.codeUnits) && at(8, 'WAVE'.codeUnits)) return AudioFormat.wav;
  if (at(4, 'ftyp'.codeUnits)) {
    final brand = head.length >= 12 ? String.fromCharCodes(head.sublist(8, 12)) : '';
    // Exclude video-only brands; M4A/M4B/MP4 audio and ISO base media pass.
    if (const {'M4A ', 'M4B ', 'M4P ', 'mp42', 'isom', 'iso2', 'mp41', 'dash'}.contains(brand)) {
      return AudioFormat.m4a;
    }
    return null;
  }
  // Raw MPEG audio / ADTS AAC frame sync.
  if (head.length >= 2 && head[0] == 0xFF && (head[1] & 0xE0) == 0xE0) return AudioFormat.mp3;
  return null;
}

Future<AudioFormat?> sniffFile(File file) async {
  final raf = await file.open();
  try {
    return sniffAudioFormat(await raf.read(64));
  } finally {
    await raf.close();
  }
}

/// SHA-256 of a file, streamed in a background isolate.
Future<String> hashFile(String path) => Isolate.run(() async {
  final digest = await sha256.bind(File(path).openRead()).first;
  return digest.toString();
});

class MetadataService {
  const MetadataService();

  Future<ParsedTags> read(String path, {String? displayName}) =>
      Isolate.run(() => parseTags(path, displayName: displayName));

  /// Synchronous parser, run inside an isolate. Missing or unreadable tags
  /// produce a file-name title rather than an error.
  static ParsedTags parseTags(String path, {String? displayName}) {
    final fallbackTitle = p.basenameWithoutExtension(displayName ?? path);
    AudioMetadata? meta;
    try {
      meta = readMetadata(File(path), getImage: true);
    } catch (_) {
      meta = null;
    }
    if (meta == null) return ParsedTags(title: fallbackTitle, titleFromFileName: true);

    final title = cleanDisplay(meta.title);
    final genres = meta.genres.map(cleanDisplay).whereType<String>().toList();
    final picture = meta.pictures.isEmpty
        ? null
        : (meta.pictures.firstWhere(
            (pic) => pic.pictureType == PictureType.coverFront,
            orElse: () => meta!.pictures.first,
          ));
    return ParsedTags(
      title: title ?? fallbackTitle,
      titleFromFileName: title == null,
      artist: cleanDisplay(meta.artist),
      album: cleanDisplay(meta.album),
      albumArtist: cleanDisplay(meta.albumArtist),
      genre: genres.isEmpty ? null : genres.first,
      language: normalizeLanguage(meta.language),
      releaseYear: validReleaseYear(meta.year?.year),
      durationMs: (meta.duration?.inMilliseconds ?? 0) > 0 ? meta.duration!.inMilliseconds : null,
      trackNumber: (meta.trackNumber ?? 0) > 0 ? meta.trackNumber : null,
      discNumber: (meta.discNumber ?? 0) > 0 ? meta.discNumber : null,
      artwork: picture?.bytes,
    );
  }
}
