import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/app_exception.dart';
import '../../core/utils/duplicates.dart';
import '../../core/utils/text_normalize.dart';
import '../database/app_database.dart';
import '../repositories/settings_repository.dart';
import 'import_service.dart';

/// What a backup contains, shown before anything is restored.
class BackupPreview {
  const BackupPreview({
    required this.createdAt,
    required this.tracks,
    required this.matchedTracks,
    required this.playlists,
    required this.playlistEntries,
    required this.unmatchedPlaylistEntries,
    required this.favorites,
    required this.historyRecords,
    required this.hasSettings,
    required this.edits,
  });

  final DateTime createdAt;
  final int tracks;
  final int matchedTracks;
  final int playlists;
  final int playlistEntries;
  final int unmatchedPlaylistEntries;
  final int favorites;
  final int historyRecords;
  final bool hasSettings;
  final int edits;
}

enum RestoreConflict {
  /// Keep values already on this device; fill gaps from the backup.
  keepLocal,

  /// Backup values win where both exist.
  preferBackup,
}

class RestoreReport {
  int playlistsCreated = 0;
  int entriesAdded = 0;
  int entriesSkipped = 0;
  int tracksUpdated = 0;
  int historyAdded = 0;
}

/// Versioned ZIP backups: `manifest.json` + `data.json`. Audio files are not
/// included. Archives are parsed in memory and only those two named entries
/// are read, so archive paths can never write to the filesystem.
class BackupService {
  BackupService(this._db, this._settings);

  final AppDatabase _db;
  final SettingsRepository _settings;

  static const maxBackupBytes = 100 * 1024 * 1024;

  Future<Uint8List> create({bool includeHistory = true}) async {
    final tracks = await _db.tracksDao.allTracks();
    final tags = {for (final t in await _db.tagsDao.allTags()) t.id: t};
    final memberships = await _db.tagsDao.allMemberships();
    final tagsByTrack = <String, List<Map<String, Object?>>>{};
    for (final m in memberships) {
      final tag = tags[m.tagId];
      if (tag == null) continue;
      tagsByTrack.putIfAbsent(m.trackId, () => []).add({
        'name': tag.name,
        'kind': tag.kind.name,
        'excluded': m.excluded,
      });
    }

    final trackJson = [
      for (final t in tracks)
        {
          'ref': t.id,
          'hash': t.fileHash,
          'title': t.title,
          'artist': t.artist,
          'album': t.album,
          'durationMs': t.durationMs,
          'overridden': t.overriddenFields,
          'edits': {
            'title': t.title,
            'artist': t.artist,
            'album': t.album,
            'albumArtist': t.albumArtist,
            'genre': t.genre,
            'language': t.language,
            'composer': t.composer,
            'releaseYear': t.releaseYear,
            'isCompilation': t.isCompilation,
          },
          'isFavorite': t.isFavorite,
          'rating': t.rating,
          'playCount': t.playCount,
          'skipCount': t.skipCount,
          'lastPlayedAt': t.lastPlayedAt?.toIso8601String(),
          'tags': tagsByTrack[t.id] ?? const [],
        },
    ];

    final playlists = <Map<String, Object?>>[];
    for (final p in await _db.playlistsDao.allPlaylists()) {
      final items = await _db.playlistsDao.items(p.id);
      playlists.add({
        'id': p.id,
        'name': p.name,
        'description': p.description,
        'createdAt': p.createdAt.toIso8601String(),
        'entries': [for (final i in items) i.track.id],
      });
    }

    final history = includeHistory
        ? [
            for (final r in await _db.historyDao.allRecords())
              {
                'ref': r.trackId,
                'startedAt': r.startedAt.toIso8601String(),
                'endedAt': r.endedAt?.toIso8601String(),
                'listenedMs': r.listenedMs,
                'counted': r.counted,
                'completed': r.completed,
                'skipped': r.skipped,
              },
          ]
        : const [];

    final data = {
      'tracks': trackJson,
      'playlists': playlists,
      'favoriteAlbums': [
        for (final f in await _db.tracksDao.favoriteAlbumRows()) {'album': f.albumKey, 'artist': f.artistKey},
      ],
      'settings': _settings.load().toJson(),
      'history': history,
    };
    final manifest = {
      'format': AppInfo.backupFormat,
      'version': AppInfo.backupVersion,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'includesHistory': includeHistory,
      'includesAudio': false,
    };
    final archive = Archive()
      ..addFile(ArchiveFile.string('manifest.json', jsonEncode(manifest)))
      ..addFile(ArchiveFile.string('data.json', jsonEncode(data)));
    return ZipEncoder().encodeBytes(archive);
  }

  /// Validates structure and version. Throws [AppException] when invalid.
  ParsedBackup parse(Uint8List bytes) {
    if (bytes.length > maxBackupBytes) throw const AppException('too_large', 'This backup is too large.');
    final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes);
    } catch (_) {
      throw const AppException('invalid', 'This file is not a Music app backup.');
    }
    Map<String, Object?> readJson(String name) {
      final file = archive.findFile(name);
      if (file == null || !file.isFile) throw AppException('invalid', 'The backup is missing $name.');
      try {
        return (jsonDecode(utf8.decode(file.content)) as Map).cast<String, Object?>();
      } catch (_) {
        throw AppException('invalid', 'The backup file $name is damaged.');
      }
    }

    final manifest = readJson('manifest.json');
    if (manifest['format'] != AppInfo.backupFormat) {
      throw const AppException('invalid', 'This file is not a Music app backup.');
    }
    final version = manifest['version'];
    if (version is! int || version < 1) throw const AppException('invalid', 'The backup version is not recognised.');
    if (version > AppInfo.backupVersion) {
      throw const AppException(
        'newer',
        'This backup was made by a newer version of Music. Update the app to restore it.',
      );
    }
    final data = readJson('data.json');
    List<Map<String, Object?>> list(String key) {
      final v = data[key];
      if (v == null) return const [];
      if (v is! List) throw AppException('invalid', 'The backup section "$key" is damaged.');
      return v.whereType<Map>().map((m) => m.cast<String, Object?>()).toList();
    }

    return ParsedBackup(
      createdAt: DateTime.tryParse(manifest['createdAt'] as String? ?? '')?.toLocal() ?? DateTime.now(),
      tracks: list('tracks'),
      playlists: list('playlists'),
      favoriteAlbums: list('favoriteAlbums'),
      history: list('history'),
      settings: data['settings'] is Map ? (data['settings'] as Map).cast<String, Object?>() : null,
    );
  }

  /// Maps backup track refs to local tracks by file hash, then by
  /// normalized title/artist/album and duration.
  Future<Map<String, Track>> matchTracks(ParsedBackup backup) async {
    final local = await _db.tracksDao.allTracks();
    final byHash = <String, Track>{for (final t in local) t.fileHash: t};
    final result = <String, Track>{};
    for (final b in backup.tracks) {
      final ref = b['ref'];
      if (ref is! String) continue;
      final hash = b['hash'];
      final match =
          (hash is String ? byHash[hash] : null) ??
          local.where((t) {
            final identity = TrackIdentity(
              fileHash: '',
              titleKey: normalizeKey(b['title'] as String?),
              artistKey: normalizeKey(b['artist'] as String?),
              albumKey: normalizeKey(b['album'] as String?),
              durationMs: b['durationMs'] as int?,
            );
            return compareTracks(identity, ImportService.identityOf(t)) == DuplicateKind.similarMetadata;
          }).firstOrNull;
      if (match != null) result[ref] = match;
    }
    return result;
  }

  Future<BackupPreview> preview(ParsedBackup backup) async {
    final matches = await matchTracks(backup);
    var entries = 0;
    var unmatched = 0;
    for (final p in backup.playlists) {
      for (final e in (p['entries'] as List? ?? const [])) {
        entries++;
        if (!matches.containsKey(e)) unmatched++;
      }
    }
    return BackupPreview(
      createdAt: backup.createdAt,
      tracks: backup.tracks.length,
      matchedTracks: matches.length,
      playlists: backup.playlists.length,
      playlistEntries: entries,
      unmatchedPlaylistEntries: unmatched,
      favorites: backup.tracks.where((t) => t['isFavorite'] == true).length,
      historyRecords: backup.history.length,
      hasSettings: backup.settings != null,
      edits: backup.tracks.where((t) => (t['overridden'] as String? ?? '').isNotEmpty).length,
    );
  }

  /// Merges a backup into the library in one transaction. Existing playlists,
  /// history and tracks are never deleted; restored playlists are added
  /// alongside existing ones.
  Future<RestoreReport> restore(
    ParsedBackup backup, {
    required RestoreConflict conflict,
    bool restoreSettings = true,
    bool restoreHistory = true,
  }) async {
    final report = RestoreReport();
    final matches = await matchTracks(backup);
    final playlistIdMap = <int, int>{};
    await _db.transaction(() async {
      for (final b in backup.tracks) {
        final local = matches[b['ref']];
        if (local == null) continue;
        if (await _restoreTrack(local, b, conflict)) report.tracksUpdated++;
      }

      final existingNames = {for (final p in await _db.playlistsDao.allPlaylists()) p.name};
      for (final p in backup.playlists) {
        var name = cleanDisplay(p['name'] as String?) ?? 'Restored playlist';
        if (existingNames.contains(name)) name = '$name (restored)';
        existingNames.add(name);
        final id = await _db.playlistsDao.createPlaylist(name, description: p['description'] as String?);
        if (p['id'] is int) playlistIdMap[p['id'] as int] = id;
        report.playlistsCreated++;
        final ids = <String>[];
        for (final e in (p['entries'] as List? ?? const [])) {
          final t = matches[e];
          if (t == null) {
            report.entriesSkipped++;
          } else {
            ids.add(t.id);
          }
        }
        if (ids.isNotEmpty) await _db.playlistsDao.addTracks(id, ids);
        report.entriesAdded += ids.length;
      }

      for (final f in backup.favoriteAlbums) {
        final album = f['album'];
        if (album is String && album.isNotEmpty) {
          await _db.tracksDao.setAlbumFavorite(album, f['artist'] as String? ?? '', true);
        }
      }

      if (restoreHistory) report.historyAdded = await _restoreHistory(backup, matches);
    });

    if (restoreSettings && backup.settings != null) {
      final restored = AppSettings.fromJson(backup.settings!);
      final current = _settings.load();
      await _settings.save(
        restored.copyWith(
          // Playlist ids differ on this device; remap pins to restored copies.
          pinnedPlaylists: {
            ...current.pinnedPlaylists,
            for (final id in restored.pinnedPlaylists) ?playlistIdMap[id],
          }.toList(),
          copyConsent: current.copyConsent,
        ),
      );
    }
    return report;
  }

  Future<bool> _restoreTrack(Track local, Map<String, Object?> b, RestoreConflict conflict) async {
    final preferBackup = conflict == RestoreConflict.preferBackup;
    var t = local;
    var changed = false;

    final overridden = (b['overridden'] as String? ?? '').split(',').where((f) => f.isNotEmpty).toSet();
    final edits = b['edits'] is Map ? (b['edits'] as Map).cast<String, Object?>() : const <String, Object?>{};
    final localOverrides = local.overriddenFields.split(',').where((f) => f.isNotEmpty).toSet();
    if (overridden.isNotEmpty && (preferBackup || localOverrides.isEmpty)) {
      String? s(String k) => cleanDisplay(edits[k] as String?);
      t = t.copyWith(
        title: overridden.contains(TrackField.title) ? (s('title') ?? t.title) : t.title,
        artist: overridden.contains(TrackField.artist) ? Value(s('artist')) : Value(t.artist),
        album: overridden.contains(TrackField.album) ? Value(s('album')) : Value(t.album),
        albumArtist: overridden.contains(TrackField.albumArtist) ? Value(s('albumArtist')) : Value(t.albumArtist),
        genre: overridden.contains(TrackField.genre) ? Value(s('genre')) : Value(t.genre),
        language: overridden.contains(TrackField.language) ? Value(s('language')) : Value(t.language),
        composer: overridden.contains(TrackField.composer) ? Value(s('composer')) : Value(t.composer),
        releaseYear: overridden.contains(TrackField.releaseYear)
            ? Value(validReleaseYear(edits['releaseYear'] as int?))
            : Value(t.releaseYear),
        isCompilation: overridden.contains(TrackField.compilation) ? edits['isCompilation'] == true : t.isCompilation,
        overriddenFields: {...localOverrides, ...overridden}.where((f) => f != TrackField.artwork).join(','),
        metadataSource: 'user',
      );
      changed = true;
    }
    if (b['isFavorite'] == true && !t.isFavorite) {
      t = t.copyWith(isFavorite: true);
      changed = true;
    }
    final rating = b['rating'];
    if (rating is int && rating >= 1 && rating <= 5 && (t.rating == null || preferBackup) && t.rating != rating) {
      t = t.copyWith(rating: Value(rating));
      changed = true;
    }
    // Counts take the larger value so restoring twice never double counts.
    final plays = b['playCount'];
    if (plays is int && plays > t.playCount) {
      t = t.copyWith(playCount: plays);
      changed = true;
    }
    final last = DateTime.tryParse(b['lastPlayedAt'] as String? ?? '');
    if (last != null && (t.lastPlayedAt == null || last.isAfter(t.lastPlayedAt!))) {
      t = t.copyWith(lastPlayedAt: Value(last));
      changed = true;
    }
    if (changed) await _db.tracksDao.updateTrack(t);

    for (final tag in (b['tags'] as List? ?? const []).whereType<Map>()) {
      final name = cleanDisplay(tag['name'] as String?);
      if (name == null) continue;
      final kind = tag['kind'] == TagKind.mood.name ? TagKind.mood : TagKind.user;
      final created = await _db.tagsDao.ensureTag(name, kind);
      await _db.tagsDao.setMembership(local.id, created.id, member: tag['excluded'] != true);
    }
    return changed;
  }

  Future<int> _restoreHistory(ParsedBackup backup, Map<String, Track> matches) async {
    final existing = {
      for (final r in await _db.historyDao.allRecords()) '${r.trackId}|${r.startedAt.millisecondsSinceEpoch ~/ 1000}',
    };
    var added = 0;
    for (final h in backup.history) {
      final track = matches[h['ref']];
      final started = DateTime.tryParse(h['startedAt'] as String? ?? '');
      final listened = h['listenedMs'];
      if (track == null || started == null || listened is! int || listened < 0) continue;
      final key = '${track.id}|${started.millisecondsSinceEpoch ~/ 1000}';
      if (!existing.add(key)) continue;
      await _db
          .into(_db.playbackHistory)
          .insert(
            PlaybackHistoryCompanion.insert(
              trackId: track.id,
              startedAt: started,
              endedAt: Value(DateTime.tryParse(h['endedAt'] as String? ?? '')),
              listenedMs: Value(listened),
              counted: Value(h['counted'] == true),
              completed: Value(h['completed'] == true),
              skipped: Value(h['skipped'] == true),
              context: const Value('restored'),
            ),
          );
      added++;
    }
    return added;
  }
}

class ParsedBackup {
  const ParsedBackup({
    required this.createdAt,
    required this.tracks,
    required this.playlists,
    required this.favoriteAlbums,
    required this.history,
    required this.settings,
  });

  final DateTime createdAt;
  final List<Map<String, Object?>> tracks;
  final List<Map<String, Object?>> playlists;
  final List<Map<String, Object?>> favoriteAlbums;
  final List<Map<String, Object?>> history;
  final Map<String, Object?>? settings;
}
