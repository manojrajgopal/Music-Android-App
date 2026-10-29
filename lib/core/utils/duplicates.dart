import '../constants/app_constants.dart';

enum DuplicateKind { none, exactFile, similarMetadata }

/// Minimal identity used for duplicate comparison.
class TrackIdentity {
  const TrackIdentity({
    required this.fileHash,
    required this.titleKey,
    required this.artistKey,
    required this.albumKey,
    this.durationMs,
  });

  final String fileHash;
  final String titleKey;
  final String artistKey;
  final String albumKey;
  final int? durationMs;
}

/// Layered duplicate check: identical bytes first, then normalized metadata
/// with a duration tolerance. A similarity match is only a suggestion — the
/// user must confirm any merge or removal.
DuplicateKind compareTracks(TrackIdentity a, TrackIdentity b) {
  if (a.fileHash.isNotEmpty && a.fileHash == b.fileHash) return DuplicateKind.exactFile;
  if (a.titleKey.isEmpty || a.titleKey != b.titleKey) return DuplicateKind.none;
  if (a.artistKey != b.artistKey) return DuplicateKind.none;
  if (a.albumKey.isNotEmpty && b.albumKey.isNotEmpty && a.albumKey != b.albumKey) {
    return DuplicateKind.none;
  }
  final da = a.durationMs;
  final db = b.durationMs;
  if (da == null || db == null) return DuplicateKind.none;
  return (da - db).abs() <= ImportRules.duplicateDurationToleranceMs
      ? DuplicateKind.similarMetadata
      : DuplicateKind.none;
}
