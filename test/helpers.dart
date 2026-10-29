import 'dart:io';
import 'dart:typed_data';

import 'package:cadence/core/utils/text_normalize.dart';
import 'package:cadence/data/database/app_database.dart';
import 'package:cadence/data/services/storage_paths.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

AppDatabase memoryDb() {
  // Tests intentionally open several independent in-memory databases.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(NativeDatabase.memory());
}

StoragePaths tempPaths() {
  final root = Directory.systemTemp.createTempSync('cadence_test_');
  return StoragePaths.at(
    musicDir: Directory('${root.path}/music'),
    artworkDir: Directory('${root.path}/art'),
    tempDir: Directory('${root.path}/tmp'),
  );
}

var _seq = 0;

/// Builds an in-memory track row without touching the filesystem.
Track makeTrack({
  String? id,
  String title = 'Song',
  String? artist = 'Artist',
  String? album,
  String? genre,
  String? language,
  int? year,
  int? durationMs = 200000,
  int playCount = 0,
  bool favorite = false,
  int? rating,
  DateTime? dateAdded,
  DateTime? lastPlayedAt,
  int? lastPositionMs,
  String? hash,
}) {
  final n = _seq++;
  return Track(
    id: id ?? 't$n',
    sourceUri: '${StoragePaths.managedScheme}t$n.mp3',
    sourceType: TrackSourceType.localFile,
    originalFileName: 't$n.mp3',
    title: title,
    artist: artist,
    album: album,
    albumArtist: null,
    genre: genre,
    language: language,
    composer: null,
    releaseYear: year,
    durationMs: durationMs,
    trackNumber: null,
    discNumber: null,
    artworkKey: null,
    fileSizeBytes: 1000,
    fileHash: hash ?? 'hash$n',
    dateAdded: dateAdded ?? DateTime(2026, 1, 1),
    lastModified: null,
    lastPlayedAt: lastPlayedAt,
    playCount: playCount,
    skipCount: 0,
    rating: rating,
    metadataSource: 'embedded',
    availability: Availability.available,
    isFavorite: favorite,
    isCompilation: false,
    lastPositionMs: lastPositionMs,
    overriddenFields: '',
    titleKey: normalizeKey(title),
    artistKey: normalizeKey(artist),
    albumKey: normalizeKey(album),
    searchText: buildSearchText([title, artist, album, genre, language]),
  );
}

Future<Track> insertTrack(AppDatabase db, Track t) async {
  await db.tracksDao.insertTrack(
    t.toCompanion(true),
    EmbeddedTagsCompanion.insert(trackId: t.id, title: Value(t.title), artist: Value(t.artist), album: Value(t.album)),
  );
  return t;
}

PlaybackRecord record(String trackId, DateTime at, {int listenedMs = 60000, bool counted = true}) => PlaybackRecord(
  id: _seq++,
  trackId: trackId,
  startedAt: at,
  endedAt: at.add(Duration(milliseconds: listenedMs)),
  listenedMs: listenedMs,
  counted: counted,
  completed: false,
  skipped: false,
  context: null,
);

/// A tiny valid PCM WAV file (silence), usable as an audio fixture.
File writeWav(Directory dir, String name, {int seconds = 1, int seed = 0}) {
  const rate = 8000;
  final samples = rate * seconds;
  final data = Uint8List(samples);
  for (var i = 0; i < samples; i++) {
    data[i] = 128 + ((i + seed) % 3);
  }
  final header = BytesBuilder()
    ..add('RIFF'.codeUnits)
    ..add(_u32(36 + samples))
    ..add('WAVE'.codeUnits)
    ..add('fmt '.codeUnits)
    ..add(_u32(16))
    ..add(_u16(1))
    ..add(_u16(1))
    ..add(_u32(rate))
    ..add(_u32(rate))
    ..add(_u16(1))
    ..add(_u16(8))
    ..add('data'.codeUnits)
    ..add(_u32(samples))
    ..add(data);
  final file = File('${dir.path}/$name')..writeAsBytesSync(header.takeBytes());
  return file;
}

List<int> _u32(int v) => [v & 0xFF, (v >> 8) & 0xFF, (v >> 16) & 0xFF, (v >> 24) & 0xFF];
List<int> _u16(int v) => [v & 0xFF, (v >> 8) & 0xFF];
