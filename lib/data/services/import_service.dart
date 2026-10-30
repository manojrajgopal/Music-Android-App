import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/app_exception.dart';
import '../../core/utils/duplicates.dart';
import '../../core/utils/text_normalize.dart';
import '../database/app_database.dart';
import 'artwork_service.dart';
import 'metadata_service.dart';
import 'storage_paths.dart';

enum ImportOutcome { imported, possibleDuplicate, duplicate, failed }

class ImportResult {
  const ImportResult({required this.name, required this.outcome, this.track, this.message, this.duplicateOf});

  final String name;
  final ImportOutcome outcome;
  final Track? track;
  final String? message;
  final Track? duplicateOf;
}

/// Details known from where a file came from (e.g. a download's page), used
/// when the file's own tags lack them.
class ImportHints {
  const ImportHints({this.title, this.artist, this.album, this.artwork});

  final String? title;
  final String? artist;
  final String? album;
  final Uint8List? artwork;
}

class RescanReport {
  RescanReport();

  int checked = 0;
  int updated = 0;
  int missing = 0;
  int restored = 0;
  int added = 0;
  int failed = 0;
}

/// Imports audio into the app-managed music folder and indexes it.
///
/// Files chosen with the system picker are delivered as temporary copies or
/// content URIs without durable access, so a reliable library keeps its own
/// copy (with the user's consent, given in the import hub).
class ImportService {
  ImportService(this._db, this._paths, this._artwork, [this._metadata = const MetadataService()]);

  final AppDatabase _db;
  final StoragePaths _paths;
  final ArtworkService _artwork;
  final MetadataService _metadata;
  final _uuid = const Uuid();

  /// Copies [source] into the library and indexes it.
  Future<ImportResult> importFile(
    File source, {
    required String displayName,
    TrackSourceType sourceType = TrackSourceType.localFile,
    bool moveInsteadOfCopy = false,
    ImportHints? hints,
  }) async {
    final jobId = await _db.miscDao.startJob(
      displayName,
      sourceType == TrackSourceType.download ? ImportJobType.url : ImportJobType.file,
    );
    File? managed;
    try {
      final ext = p.extension(displayName).replaceFirst('.', '').toLowerCase();
      if (ext.isNotEmpty && !ImportRules.supportedExtensions.contains(ext)) {
        throw AppException('unsupported', 'Unsupported format ".$ext".');
      }
      if (!source.existsSync()) throw const AppException('missing', 'The file could not be opened.');
      final format = await sniffFile(source);
      if (format == null) {
        throw const AppException('not_audio', 'This file is not a supported audio file or is corrupt.');
      }

      final hash = await hashFile(source.path);
      final exact = await _db.tracksDao.byHash(hash);
      if (exact.isNotEmpty) {
        if (moveInsteadOfCopy && source.existsSync()) await source.delete();
        await _db.miscDao.finishJob(jobId, ImportJobStatus.duplicate, trackId: exact.first.id);
        return ImportResult(
          name: displayName,
          outcome: ImportOutcome.duplicate,
          duplicateOf: exact.first,
          message: 'Already in your library',
        );
      }

      final target = _paths.uniqueMusicFile(displayName);
      try {
        managed = moveInsteadOfCopy ? await source.rename(target.path) : await source.copy(target.path);
      } on FileSystemException catch (e) {
        if (moveInsteadOfCopy) {
          managed = await source.copy(target.path);
          await source.delete();
        } else {
          throw _storageError(e);
        }
      }

      final track = await indexFile(
        managed,
        displayName: displayName,
        hash: hash,
        sourceType: sourceType,
        hints: hints,
      );
      final similar = await _findSimilar(track);
      await _db.miscDao.finishJob(jobId, ImportJobStatus.succeeded, trackId: track.id);
      return ImportResult(
        name: displayName,
        outcome: similar == null ? ImportOutcome.imported : ImportOutcome.possibleDuplicate,
        track: track,
        duplicateOf: similar,
        message: similar == null ? null : 'Looks similar to "${similar.title}"',
      );
    } catch (e) {
      if (managed != null && managed.existsSync()) {
        await managed.delete().catchError((_) => managed!);
      }
      final message = friendlyError(e is FileSystemException ? _storageError(e) : e);
      await _db.miscDao.finishJob(jobId, ImportJobStatus.failed, error: message);
      return ImportResult(name: displayName, outcome: ImportOutcome.failed, message: message);
    }
  }

  AppException _storageError(FileSystemException e) {
    final code = e.osError?.errorCode;
    // ENOSPC (28) on Android/iOS, ERROR_DISK_FULL (112) on Windows.
    if (code == 28 || code == 112) {
      return const AppException('no_space', 'Not enough storage space to import this file.');
    }
    return const AppException('io', 'The file could not be read or copied.');
  }

  /// Reads tags/artwork for a managed file and inserts the track row.
  Future<Track> indexFile(
    File file, {
    required String displayName,
    required String hash,
    required TrackSourceType sourceType,
    ImportHints? hints,
  }) async {
    final read = await _metadata.read(file.path, displayName: displayName);
    final tags = hints == null
        ? read
        : read.withFallbacks(title: hints.title, artist: hints.artist, album: hints.album, artwork: hints.artwork);
    final artworkKey = tags.artwork == null ? null : await _artwork.store(tags.artwork!);
    final id = _uuid.v4();
    final now = DateTime.now();
    final stat = file.statSync();
    final row = TracksCompanion.insert(
      id: id,
      sourceUri: _paths.managedUriFor(file),
      sourceType: sourceType,
      originalFileName: Value(displayName),
      title: tags.title,
      artist: Value(tags.artist),
      album: Value(tags.album),
      albumArtist: Value(tags.albumArtist),
      genre: Value(tags.genre),
      language: Value(tags.language),
      releaseYear: Value(tags.releaseYear),
      durationMs: Value(tags.durationMs),
      trackNumber: Value(tags.trackNumber),
      discNumber: Value(tags.discNumber),
      artworkKey: Value(artworkKey),
      fileSizeBytes: Value(stat.size),
      fileHash: hash,
      dateAdded: now,
      lastModified: Value(stat.modified),
      metadataSource: Value(tags.titleFromFileName ? 'filename' : 'embedded'),
      isCompilation: Value(normalizeKey(tags.albumArtist) == 'various artists'),
      titleKey: normalizeKey(tags.title),
      artistKey: normalizeKey(tags.artist),
      albumKey: normalizeKey(tags.album),
      searchText: buildSearchText([tags.title, tags.artist, tags.album, tags.albumArtist, tags.genre, tags.language]),
    );
    await _db.tracksDao.insertTrack(
      row,
      EmbeddedTagsCompanion.insert(
        trackId: id,
        title: Value(tags.titleFromFileName ? null : tags.title),
        artist: Value(tags.artist),
        album: Value(tags.album),
        albumArtist: Value(tags.albumArtist),
        genre: Value(tags.genre),
        language: Value(tags.language),
        releaseYear: Value(tags.releaseYear),
        artworkKey: Value(artworkKey),
      ),
    );
    return (await _db.tracksDao.byId(id))!;
  }

  Future<Track?> _findSimilar(Track track) async {
    final candidates = await _db.tracksDao.byTitleArtist(track.titleKey, track.artistKey);
    for (final other in candidates) {
      if (other.id == track.id) continue;
      if (compareTracks(identityOf(track), identityOf(other)) != DuplicateKind.none) return other;
    }
    return null;
  }

  static TrackIdentity identityOf(Track t) => TrackIdentity(
    fileHash: t.fileHash,
    titleKey: t.titleKey,
    artistKey: t.artistKey,
    albumKey: t.albumKey,
    durationMs: t.durationMs,
  );

  /// Re-checks every track and indexes music files that have no record
  /// (e.g. after restoring an app backup on the same device). Never deletes
  /// files and keeps track ids stable so playlists and history survive.
  Future<RescanReport> rescan() async {
    final report = RescanReport();
    final jobId = await _db.miscDao.startJob('Library rescan', ImportJobType.rescan);
    final known = <String>{};
    for (final track in await _db.tracksDao.allTracks()) {
      report.checked++;
      final path = _paths.resolveSource(track.sourceUri);
      known.add(p.normalize(path));
      final file = File(path);
      if (!file.existsSync()) {
        if (track.availability != Availability.missing) {
          await _db.tracksDao.setAvailability(track.id, Availability.missing);
        }
        report.missing++;
        continue;
      }
      if (track.availability != Availability.available) {
        await _db.tracksDao.setAvailability(track.id, Availability.available);
        report.restored++;
      }
      final modified = file.statSync().modified;
      final changed = track.lastModified == null || modified.difference(track.lastModified!).inSeconds.abs() > 1;
      if (changed) {
        try {
          await refreshEmbedded(track, file);
          report.updated++;
        } catch (_) {
          report.failed++;
        }
      }
    }
    if (_paths.musicDir.existsSync()) {
      for (final entity in _paths.musicDir.listSync()) {
        if (entity is! File || known.contains(p.normalize(entity.path))) continue;
        final ext = p.extension(entity.path).replaceFirst('.', '').toLowerCase();
        if (!ImportRules.supportedExtensions.contains(ext)) continue;
        try {
          final hash = await hashFile(entity.path);
          if ((await _db.tracksDao.byHash(hash)).isNotEmpty) continue;
          await indexFile(
            entity,
            displayName: p.basename(entity.path),
            hash: hash,
            sourceType: TrackSourceType.localFile,
          );
          report.added++;
        } catch (_) {
          report.failed++;
        }
      }
    }
    await _db.miscDao.finishJob(jobId, ImportJobStatus.succeeded);
    return report;
  }

  /// Re-reads file tags. Fields the user edited locally keep their values.
  Future<void> refreshEmbedded(Track track, File file) async {
    final tags = await _metadata.read(file.path, displayName: track.originalFileName);
    final artworkKey = tags.artwork == null ? null : await _artwork.store(tags.artwork!);
    final edited = track.overriddenFields.split(',').toSet();
    String? keep(String field, String? current, String? fresh) => edited.contains(field) ? current : fresh;
    final stat = file.statSync();
    final updated = track.copyWith(
      title: edited.contains(TrackField.title) ? track.title : tags.title,
      artist: Value(keep(TrackField.artist, track.artist, tags.artist)),
      album: Value(keep(TrackField.album, track.album, tags.album)),
      albumArtist: Value(keep(TrackField.albumArtist, track.albumArtist, tags.albumArtist)),
      genre: Value(keep(TrackField.genre, track.genre, tags.genre)),
      language: Value(keep(TrackField.language, track.language, tags.language)),
      releaseYear: Value(edited.contains(TrackField.releaseYear) ? track.releaseYear : tags.releaseYear),
      artworkKey: Value(edited.contains(TrackField.artwork) ? track.artworkKey : artworkKey),
      durationMs: Value(tags.durationMs ?? track.durationMs),
      trackNumber: Value(tags.trackNumber),
      discNumber: Value(tags.discNumber),
      fileSizeBytes: Value(stat.size),
      lastModified: Value(stat.modified),
      fileHash: await hashFile(file.path),
    );
    await _db.tracksDao.updateTrack(updated);
    await _db.tracksDao.upsertEmbedded(
      EmbeddedTagsCompanion.insert(
        trackId: track.id,
        title: Value(tags.titleFromFileName ? null : tags.title),
        artist: Value(tags.artist),
        album: Value(tags.album),
        albumArtist: Value(tags.albumArtist),
        genre: Value(tags.genre),
        language: Value(tags.language),
        releaseYear: Value(tags.releaseYear),
        artworkKey: Value(artworkKey),
      ),
    );
  }

  /// Points an unavailable track at a replacement file while keeping its id,
  /// playlists, statistics and edits.
  Future<Track> relink(Track track, File replacement, {required String displayName}) async {
    final format = await sniffFile(replacement);
    if (format == null) throw const AppException('not_audio', 'That file is not a supported audio file.');
    final target = _paths.uniqueMusicFile(displayName);
    final managed = await replacement.copy(target.path);
    final hash = await hashFile(managed.path);
    final relinked = track.copyWith(
      sourceUri: _paths.managedUriFor(managed),
      fileHash: hash,
      availability: Availability.available,
      originalFileName: Value(displayName),
      lastModified: const Value(null),
    );
    await _db.tracksDao.updateTrack(relinked);
    await refreshEmbedded(relinked, managed);
    return (await _db.tracksDao.byId(track.id))!;
  }
}
