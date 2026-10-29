import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// App-managed directories. Track and artwork references are stored relative
/// to these roots (e.g. `app://music/abc.mp3`) because iOS may move the app
/// container between launches and updates.
class StoragePaths {
  StoragePaths({required this.musicDir, required this.artworkDir, required this.tempDir});

  static const managedScheme = 'app://music/';

  final Directory musicDir;
  final Directory artworkDir;
  final Directory tempDir;

  static Future<StoragePaths> create() async {
    final docs = await getApplicationDocumentsDirectory();
    final support = await getApplicationSupportDirectory();
    final temp = await getTemporaryDirectory();
    return StoragePaths.at(
      musicDir: Directory(p.join(docs.path, 'Music')),
      artworkDir: Directory(p.join(support.path, 'artwork')),
      tempDir: Directory(p.join(temp.path, 'cadence')),
    );
  }

  /// Used directly by tests with temporary directories.
  static StoragePaths at({required Directory musicDir, required Directory artworkDir, required Directory tempDir}) {
    for (final d in [musicDir, artworkDir, tempDir]) {
      d.createSync(recursive: true);
    }
    return StoragePaths(musicDir: musicDir, artworkDir: artworkDir, tempDir: tempDir);
  }

  String managedUriFor(File file) => '$managedScheme${p.basename(file.path)}';

  /// Resolves a stored source reference to an absolute file path.
  String resolveSource(String sourceUri) {
    if (sourceUri.startsWith(managedScheme)) {
      final name = p.basename(sourceUri.substring(managedScheme.length));
      return p.join(musicDir.path, name);
    }
    if (sourceUri.startsWith('file://')) return Uri.parse(sourceUri).toFilePath();
    return sourceUri;
  }

  String artworkPath(String key) => p.join(artworkDir.path, '$key.jpg');

  /// Picks a non-colliding, sanitized filename inside the music directory.
  File uniqueMusicFile(String suggestedName) {
    final safe = sanitizeFileName(suggestedName);
    final ext = p.extension(safe);
    final base = p.basenameWithoutExtension(safe);
    var candidate = File(p.join(musicDir.path, safe));
    var i = 1;
    while (candidate.existsSync()) {
      candidate = File(p.join(musicDir.path, '$base ($i)$ext'));
      i++;
    }
    return candidate;
  }
}

final _unsafeChars = RegExp(r'[\\/:*?"<>|\x00-\x1F]');

/// Removes path separators, traversal and control characters from a name.
String sanitizeFileName(String name) {
  var cleaned = p.basename(name.replaceAll('\\', '/')).replaceAll(_unsafeChars, '_').trim();
  while (cleaned.startsWith('.')) {
    cleaned = cleaned.substring(1);
  }
  if (cleaned.isEmpty) cleaned = 'audio';
  if (cleaned.length > 120) {
    final ext = p.extension(cleaned);
    cleaned = cleaned.substring(0, 120 - ext.length) + ext;
  }
  return cleaned;
}
