import 'dart:io';
import 'dart:isolate';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:image/image.dart' as img;
import 'package:material_color_utilities/material_color_utilities.dart';

import '../database/app_database.dart';
import 'storage_paths.dart';

class ArtworkColors {
  const ArtworkColors(this.primary, this.secondary);

  final int primary;
  final int secondary;
}

class _Processed {
  _Processed(this.jpeg, this.width, this.height, this.pixels);

  final Uint8List jpeg;
  final int width;
  final int height;
  final List<int> pixels;
}

/// Stores embedded artwork as resized JPEG files and caches accent colors.
/// Identical artwork (e.g. every track of an album) is stored once.
class ArtworkService {
  ArtworkService(this._db, this._paths);

  final AppDatabase _db;
  final StoragePaths _paths;

  static const maxEdge = 720;

  /// Saves artwork bytes and returns the cache key, or null when the image
  /// cannot be decoded.
  Future<String?> store(Uint8List bytes) async {
    if (bytes.isEmpty) return null;
    final key = sha1.convert(bytes).toString();
    final existing = await _db.miscDao.artwork(key);
    if (existing != null && File(_paths.artworkPath(key)).existsSync()) return key;

    final processed = await Isolate.run(() => _process(bytes));
    if (processed == null) return null;
    await File(_paths.artworkPath(key)).writeAsBytes(processed.jpeg, flush: true);
    final colors = await extractColors(processed.pixels);
    await _db.miscDao.putArtwork(
      ArtworkCacheCompanion.insert(
        key: key,
        path: '$key.jpg',
        primaryColor: Value(colors?.primary),
        secondaryColor: Value(colors?.secondary),
        width: Value(processed.width),
        height: Value(processed.height),
        createdAt: DateTime.now(),
      ),
    );
    return key;
  }

  static _Processed? _process(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return null;
    final longest = decoded.width > decoded.height ? decoded.width : decoded.height;
    final resized = longest > maxEdge
        ? img.copyResize(
            decoded,
            width: decoded.width >= decoded.height ? maxEdge : null,
            height: decoded.height > decoded.width ? maxEdge : null,
            interpolation: img.Interpolation.average,
          )
        : decoded;
    final sample = img.copyResize(resized, width: 48, height: 48);
    final pixels = <int>[
      for (final px in sample) (0xFF << 24) | (px.r.toInt() << 16) | (px.g.toInt() << 8) | px.b.toInt(),
    ];
    return _Processed(img.encodeJpg(resized, quality: 88), resized.width, resized.height, pixels);
  }

  /// Picks a dominant and a complementary color with Material's scoring,
  /// which already favours colorful, representative hues.
  static Future<ArtworkColors?> extractColors(List<int> pixels) async {
    if (pixels.isEmpty) return null;
    final quantized = await QuantizerCelebi().quantize(pixels, 64);
    final ranked = Score.score(quantized.colorToCount, desired: 2, filter: true);
    if (ranked.isEmpty) return null;
    final primary = ranked.first;
    final secondary = ranked.length > 1 ? ranked[1] : _shiftHue(primary, 40);
    return ArtworkColors(primary, secondary);
  }

  static int _shiftHue(int argb, double degrees) {
    final hct = Hct.fromInt(argb);
    return Hct.from((hct.hue + degrees) % 360, hct.chroma, hct.tone).toInt();
  }

  Future<ArtworkColors?> colorsFor(String key) async {
    final row = await _db.miscDao.artwork(key);
    if (row?.primaryColor == null) return null;
    return ArtworkColors(row!.primaryColor!, row.secondaryColor ?? row.primaryColor!);
  }

  String pathFor(String key) => _paths.artworkPath(key);

  /// Deletes cached artwork no longer referenced by any track or playlist.
  /// Only app-managed cache files are removed — never user files.
  Future<int> cleanOrphans() async {
    final used = <String>{};
    for (final t in await _db.tracksDao.allTracks()) {
      if (t.artworkKey != null) used.add(t.artworkKey!);
    }
    final embedded = await _db.select(_db.embeddedTags).get();
    for (final e in embedded) {
      if (e.artworkKey != null) used.add(e.artworkKey!);
    }
    var removed = 0;
    for (final entry in await _db.miscDao.allArtwork()) {
      if (used.contains(entry.key)) continue;
      final file = File(_paths.artworkPath(entry.key));
      if (file.existsSync()) file.deleteSync();
      await _db.miscDao.deleteArtwork(entry.key);
      removed++;
    }
    return removed;
  }
}
