import 'dart:io';

import 'package:drift/drift.dart';

import '../../core/utils/text_normalize.dart';
import '../database/app_database.dart';
import '../database/daos/tracks_dao.dart';
import '../services/artwork_service.dart';
import '../services/storage_paths.dart';

/// User edits from the metadata editor. Null means "no value".
class TrackEdit {
  const TrackEdit({
    required this.title,
    this.artist,
    this.album,
    this.albumArtist,
    this.genre,
    this.releaseYear,
    this.composer,
    this.language,
    this.isCompilation = false,
    this.newArtwork,
  });

  final String title;
  final String? artist;
  final String? album;
  final String? albumArtist;
  final String? genre;
  final int? releaseYear;
  final String? composer;
  final String? language;
  final bool isCompilation;
  final Uint8List? newArtwork;
}

/// Access layer for tracks and their local-only metadata. Nothing here
/// writes to the original audio files.
class LibraryRepository {
  LibraryRepository(this._db, this._paths, this._artwork);

  final AppDatabase _db;
  final StoragePaths _paths;
  final ArtworkService _artwork;

  TracksDao get tracks => _db.tracksDao;

  String resolvePath(Track t) => _paths.resolveSource(t.sourceUri);

  bool fileExists(Track t) => File(resolvePath(t)).existsSync();

  Future<void> toggleFavorite(Track t) => tracks.setFavorite(t.id, !t.isFavorite);

  Future<void> setFavorite(String id, bool value) => tracks.setFavorite(id, value);

  Future<void> setRating(String id, int? rating) {
    assert(rating == null || (rating >= 1 && rating <= 5));
    return tracks.setRating(id, rating);
  }

  /// Applies edits to the local database and records which fields now differ
  /// from the embedded tags, so rescans keep them and they can be reverted.
  Future<Track> saveEdits(Track original, TrackEdit edit) async {
    final embedded = await tracks.embeddedFor(original.id);
    var artworkKey = original.artworkKey;
    final overridden = original.overriddenFields.split(',').where((f) => f.isNotEmpty).toSet();
    if (edit.newArtwork != null) {
      artworkKey = await _artwork.store(edit.newArtwork!) ?? artworkKey;
      overridden.add(TrackField.artwork);
    }

    void mark(String field, Object? value, Object? embeddedValue) {
      if (value != embeddedValue) {
        overridden.add(field);
      } else {
        overridden.remove(field);
      }
    }

    final title = cleanDisplay(edit.title) ?? original.title;
    final artist = cleanDisplay(edit.artist);
    final album = cleanDisplay(edit.album);
    final albumArtist = cleanDisplay(edit.albumArtist);
    final genre = cleanDisplay(edit.genre);
    final composer = cleanDisplay(edit.composer);
    final language = cleanDisplay(edit.language);
    final year = validReleaseYear(edit.releaseYear);

    mark(TrackField.title, title, embedded?.title ?? original.title);
    mark(TrackField.artist, artist, embedded?.artist);
    mark(TrackField.album, album, embedded?.album);
    mark(TrackField.albumArtist, albumArtist, embedded?.albumArtist);
    mark(TrackField.genre, genre, embedded?.genre);
    mark(TrackField.language, language, embedded?.language);
    mark(TrackField.releaseYear, year, embedded?.releaseYear);
    if (composer != null) overridden.add(TrackField.composer);
    if (edit.isCompilation != original.isCompilation) overridden.add(TrackField.compilation);

    final updated = original.copyWith(
      title: title,
      artist: Value(artist),
      album: Value(album),
      albumArtist: Value(albumArtist),
      genre: Value(genre),
      composer: Value(composer),
      language: Value(language),
      releaseYear: Value(year),
      isCompilation: edit.isCompilation,
      artworkKey: Value(artworkKey),
      metadataSource: overridden.isEmpty ? original.metadataSource : 'user',
      overriddenFields: overridden.join(','),
    );
    await tracks.updateTrack(updated);
    return (await tracks.byId(original.id))!;
  }

  /// Restores every field to the embedded tag values.
  Future<void> revertToEmbedded(Track t) async {
    final e = await tracks.embeddedFor(t.id);
    if (e == null) return;
    await tracks.updateTrack(
      t.copyWith(
        title: e.title ?? t.title,
        artist: Value(e.artist),
        album: Value(e.album),
        albumArtist: Value(e.albumArtist),
        genre: Value(e.genre),
        language: Value(e.language),
        releaseYear: Value(e.releaseYear),
        artworkKey: Value(e.artworkKey),
        composer: const Value(null),
        overriddenFields: '',
        metadataSource: 'embedded',
      ),
    );
  }

  /// Removes the track record (and its playlist entries/history via
  /// cascades). The audio file stays on disk unless [deleteFile] is true,
  /// which the UI only passes after explicit confirmation.
  Future<void> remove(Track t, {bool deleteFile = false}) async {
    await tracks.deleteTrack(t.id);
    if (deleteFile) {
      final path = resolvePath(t);
      // Only files inside the app-managed music folder may be deleted.
      if (t.sourceUri.startsWith(StoragePaths.managedScheme)) {
        final file = File(path);
        if (file.existsSync()) await file.delete();
      }
    }
  }

  // ---- Tags and moods ----

  Future<void> addUserTag(String trackId, String name) async {
    final clean = cleanDisplay(name);
    if (clean == null) return;
    final tag = await _db.tagsDao.ensureTag(clean, TagKind.user);
    await _db.tagsDao.setMembership(trackId, tag.id, member: true);
  }

  Future<void> removeTag(String trackId, int tagId) => _db.tagsDao.clearMembership(trackId, tagId);

  /// Adds or removes a track from a mood. Removing records an exclusion so
  /// genre-based suggestions do not bring it back.
  Future<void> setMood(String trackId, Mood mood, {required bool member}) async {
    final tag = await _db.tagsDao.ensureTag(mood.label, TagKind.mood);
    await _db.tagsDao.setMembership(trackId, tag.id, member: member);
  }
}
