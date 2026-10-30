import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uuid/uuid.dart';

import '../app/providers.dart';
import '../core/constants/app_constants.dart';
import '../data/database/app_database.dart';
import '../data/repositories/settings_repository.dart';
import 'audio_handler.dart';
import 'listening_tracker.dart';

/// High-level playback API used by the UI. It translates library tracks
/// into queue items, records listening, persists the queue and reports
/// unavailable files instead of failing silently.
class PlaybackController {
  PlaybackController(this._ref) {
    _subscriptions
      ..add(_handler.mediaItem.listen(_onMediaItem))
      ..add(_handler.player.playingStream.listen(_onPlaying))
      ..add(_handler.player.positionStream.listen(_onPosition))
      ..add(_handler.player.processingStateStream.listen(_onProcessing))
      ..add(_handler.player.durationStream.listen(_onDuration))
      ..add(_handler.player.errorStream.listen(_onError))
      ..add(_handler.queue.listen((_) => _scheduleSave()));
  }

  final Ref _ref;
  final _uuid = const Uuid();
  final _subscriptions = <StreamSubscription<Object?>>[];
  final _messages = StreamController<String>.broadcast();
  late final ListeningTracker tracker = ListeningTracker(DatabaseListeningSink(_db));
  Timer? _checkpointTimer;
  Timer? _saveDebounce;
  String? _context;

  CadenceAudioHandler get _handler => _ref.read(audioHandlerProvider);
  AppDatabase get _db => _ref.read(databaseProvider);

  /// User-facing notices (e.g. skipped unavailable files).
  Stream<String> get messages => _messages.stream;

  MediaItem toMediaItem(Track t) {
    final paths = _ref.read(storagePathsProvider);
    return mediaItemFor(
      entryId: _uuid.v4(),
      trackId: t.id,
      path: paths.resolveSource(t.sourceUri),
      title: t.title,
      artist: t.artist,
      album: t.album,
      durationMs: t.durationMs,
      artworkPath: t.artworkKey == null ? null : paths.artworkPath(t.artworkKey!),
    );
  }

  /// Filters out tracks whose files are gone and marks them unavailable.
  Future<List<Track>> _playable(List<Track> tracks) async {
    final paths = _ref.read(storagePathsProvider);
    final ok = <Track>[];
    var missing = 0;
    for (final t in tracks) {
      if (File(paths.resolveSource(t.sourceUri)).existsSync()) {
        ok.add(t);
        if (t.availability != Availability.available) {
          await _db.tracksDao.setAvailability(t.id, Availability.available);
        }
      } else {
        missing++;
        await _db.tracksDao.setAvailability(t.id, Availability.missing);
      }
    }
    if (missing > 0) {
      _messages.add(missing == 1 ? 'Skipped 1 unavailable file' : 'Skipped $missing unavailable files');
    }
    return ok;
  }

  Future<void> playTracks(
    List<Track> tracks, {
    int startIndex = 0,
    String? context,
    Duration? position,
    bool shuffle = false,
  }) async {
    if (tracks.isEmpty) return;
    final start = tracks[startIndex.clamp(0, tracks.length - 1)];
    final playable = await _playable(tracks);
    if (playable.isEmpty) return;
    var index = playable.indexWhere((t) => identical(t, start));
    if (index < 0) index = 0;
    _context = context;
    await _handler.loadQueue(
      playable.map(toMediaItem).toList(),
      initialIndex: index,
      position: position ?? Duration.zero,
    );
    if (shuffle != _handler.shuffleEnabled) {
      await _handler.setShuffleMode(shuffle ? AudioServiceShuffleMode.all : AudioServiceShuffleMode.none);
    }
  }

  Future<void> shuffleTracks(List<Track> tracks, {String? context}) async {
    if (tracks.isEmpty) return;
    final list = [...tracks]..shuffle();
    await playTracks(list, context: context, shuffle: true);
  }

  /// Resumes from the saved position (only if it is still meaningful).
  Future<void> resume(Track t) {
    final pos = t.lastPositionMs ?? 0;
    final valid = t.durationMs == null || pos < t.durationMs!;
    return playTracks(
      [t],
      position: Duration(milliseconds: valid ? pos : 0),
      context: 'continue',
    );
  }

  Future<void> playNext(List<Track> tracks) async {
    final playable = await _playable(tracks);
    if (playable.isEmpty) return;
    await _handler.playNext(playable.map(toMediaItem).toList());
    _messages.add(playable.length == 1 ? 'Playing next' : '${playable.length} songs playing next');
  }

  Future<void> addToQueue(List<Track> tracks) async {
    final playable = await _playable(tracks);
    if (playable.isEmpty) return;
    await _handler.addQueueItems(playable.map(toMediaItem).toList());
    _messages.add(playable.length == 1 ? 'Added to queue' : 'Added ${playable.length} songs to queue');
  }

  Future<void> togglePlay() => _handler.player.playing ? _handler.pause() : _handler.play();
  Future<void> pause() => _handler.pause();
  Future<void> setSpeed(double speed) => _handler.setSpeed(speed);
  Future<void> next() => _handler.skipToNext();
  Future<void> previous() => _handler.skipToPrevious();
  Future<void> seek(Duration d) => _handler.seek(d);
  Future<void> jumpTo(int index) => _handler.skipToQueueItem(index);
  Future<void> removeAt(int index) => _handler.removeQueueItemAt(index);
  Future<void> move(int from, int to) => _handler.moveQueueItem(from, to);
  Future<void> clearUpcoming() => _handler.clearUpcoming();
  Future<void> shuffleQueue() => _handler.shuffleUpcomingOnce();

  Future<void> cycleRepeat() {
    final next = switch (_handler.player.loopMode) {
      LoopMode.off => AudioServiceRepeatMode.all,
      LoopMode.all => AudioServiceRepeatMode.one,
      LoopMode.one => AudioServiceRepeatMode.none,
    };
    return _handler.setRepeatMode(next);
  }

  Future<void> toggleShuffle() =>
      _handler.setShuffleMode(_handler.shuffleEnabled ? AudioServiceShuffleMode.none : AudioServiceShuffleMode.all);

  /// Pushes edited metadata into queue items and the media notification.
  Future<void> refreshTrack(String trackId) async {
    final t = await _db.tracksDao.byId(trackId);
    if (t == null) return;
    final paths = _ref.read(storagePathsProvider);
    _handler.refreshMetadata(
      trackId,
      (old) => old.copyWith(
        title: t.title,
        artist: t.artist,
        album: t.album,
        artUri: t.artworkKey == null ? null : Uri.file(paths.artworkPath(t.artworkKey!)),
      ),
    );
  }

  // ---- Listening tracking -------------------------------------------------

  String? _trackIdOf(MediaItem? item) => item?.extras?[QueueExtras.trackId] as String?;

  void _onMediaItem(MediaItem? item) {
    final trackId = _trackIdOf(item);
    if (trackId == null) {
      unawaited(tracker.stop());
      return;
    }
    if (trackId == tracker.currentTrackId && _sameEntry(item)) return;
    _lastEntryId = item!.id;
    unawaited(
      tracker.begin(
        trackId,
        durationMs: item.duration?.inMilliseconds,
        playing: _handler.player.playing,
        context: _context,
      ),
    );
  }

  String? _lastEntryId;
  bool _sameEntry(MediaItem? item) => item?.id == _lastEntryId;

  void _onPlaying(bool playing) {
    tracker.setPlaying(playing);
    _checkpointTimer?.cancel();
    if (playing) {
      _checkpointTimer = Timer.periodic(ListeningRules.checkpointInterval, (_) {
        tracker.checkpoint();
        _savePosition();
      });
    } else {
      _savePosition();
      _scheduleSave();
    }
  }

  void _onPosition(Duration position) => tracker.updatePosition(position.inMilliseconds);

  void _onProcessing(ProcessingState state) {
    if (state == ProcessingState.completed) {
      tracker.markCompleted();
      unawaited(tracker.checkpoint());
      final id = tracker.currentTrackId;
      if (id != null) unawaited(_db.tracksDao.setLastPosition(id, null));
    }
  }

  void _onDuration(Duration? duration) {
    if (duration == null) return;
    tracker.updateDuration(duration.inMilliseconds);
    final id = tracker.currentTrackId;
    if (id == null) return;
    // Fill in duration when the tags did not include it.
    unawaited(() async {
      final t = await _db.tracksDao.byId(id);
      if (t != null && t.durationMs == null) {
        await (_db.update(
          _db.tracks,
        )..where((r) => r.id.equals(id))).write(TracksCompanion(durationMs: Value(duration.inMilliseconds)));
      }
    }());
  }

  void _onError(PlayerException error) {
    final id = tracker.currentTrackId;
    if (id != null) unawaited(_db.tracksDao.setAvailability(id, Availability.unreadable));
    _messages.add('This file could not be played. Skipping.');
    if (_handler.player.hasNext) unawaited(_handler.skipToNext());
  }

  void _savePosition() {
    final id = tracker.currentTrackId;
    if (id == null) return;
    final pos = _handler.player.position.inMilliseconds;
    unawaited(_db.tracksDao.setLastPosition(id, pos));
  }

  // ---- Queue persistence -----------------------------------------------------

  void _scheduleSave() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(seconds: 1), saveQueueNow);
  }

  Future<void> saveQueueNow() async {
    final q = _handler.queue.value;
    final ids = [for (final item in q) ?_trackIdOf(item)];
    await _ref
        .read(settingsRepositoryProvider)
        .saveQueue(
          QueueSnapshot(
            ids,
            _handler.player.currentIndex ?? 0,
            _handler.player.position.inMilliseconds,
            repeat: _handler.player.loopMode.index,
          ),
        );
  }

  /// Restores the last queue paused, so a cold start shows the mini-player
  /// where the user left off.
  Future<void> restoreQueue() async {
    final snap = _ref.read(settingsRepositoryProvider).loadQueue();
    if (snap == null || snap.trackIds.isEmpty) return;
    final tracks = await _db.tracksDao.byIds(snap.trackIds);
    final paths = _ref.read(storagePathsProvider);
    final playable = tracks.where((t) => File(paths.resolveSource(t.sourceUri)).existsSync()).toList();
    if (playable.isEmpty) return;
    final wanted = snap.index < snap.trackIds.length ? snap.trackIds[snap.index] : null;
    final index = playable.indexWhere((t) => t.id == wanted).clamp(0, playable.length - 1);
    final samePosition = playable[index].id == wanted;
    await _handler.loadQueue(
      playable.map(toMediaItem).toList(),
      initialIndex: index,
      position: Duration(milliseconds: samePosition ? snap.positionMs : 0),
      autoplay: false,
    );
    if (snap.repeat > 0 && snap.repeat < LoopMode.values.length) {
      await _handler.player.setLoopMode(LoopMode.values[snap.repeat]);
    }
  }

  Future<void> dispose() async {
    _checkpointTimer?.cancel();
    _saveDebounce?.cancel();
    await tracker.stop();
    for (final s in _subscriptions) {
      await s.cancel();
    }
    await _messages.close();
  }
}

final playbackControllerProvider = Provider<PlaybackController>((ref) {
  final controller = PlaybackController(ref);
  ref.onDispose(controller.dispose);
  return controller;
});

final playbackStateProvider = StreamProvider<PlaybackState>((ref) => ref.watch(audioHandlerProvider).playbackState);

final currentMediaItemProvider = StreamProvider<MediaItem?>((ref) => ref.watch(audioHandlerProvider).mediaItem);

final queueProvider = StreamProvider<List<MediaItem>>((ref) => ref.watch(audioHandlerProvider).queue);

final currentTrackIdProvider = Provider<String?>(
  (ref) => ref.watch(currentMediaItemProvider).value?.extras?[QueueExtras.trackId] as String?,
);

/// The current track as stored in the database, so edits and favorites
/// show immediately in the player.
final currentTrackProvider = StreamProvider<Track?>((ref) {
  final id = ref.watch(currentTrackIdProvider);
  if (id == null) return Stream.value(null);
  return ref.watch(databaseProvider).tracksDao.watchById(id);
});

final isPlayingProvider = StreamProvider<bool>((ref) => ref.watch(audioHandlerProvider).player.playingStream);

/// Position ticks; only small widgets (seek bars) should watch this.
final positionProvider = StreamProvider<Duration>((ref) => ref.watch(audioHandlerProvider).player.positionStream);

final durationProvider = StreamProvider<Duration?>((ref) => ref.watch(audioHandlerProvider).player.durationStream);

final speedProvider = StreamProvider<double>((ref) => ref.watch(audioHandlerProvider).player.speedStream);

final loopModeProvider = StreamProvider<LoopMode>((ref) => ref.watch(audioHandlerProvider).player.loopModeStream);

final shuffleProvider = Provider<bool>((ref) {
  final state = ref.watch(playbackStateProvider).value;
  return state?.shuffleMode == AudioServiceShuffleMode.all;
});
