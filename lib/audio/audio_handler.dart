import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

/// Extras keys stored on each [MediaItem] in the queue.
abstract final class QueueExtras {
  static const trackId = 'trackId';
  static const path = 'path';
}

/// The single authoritative audio engine. It owns the only [AudioPlayer],
/// mirrors state to the platform media session (notification, lock screen,
/// headset buttons) and exposes queue editing.
///
/// Shuffle physically reorders the upcoming queue (and restores the
/// original order when turned off) so the visible queue always equals the
/// playback order.
class CadenceAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  CadenceAudioHandler({AudioPlayer? player}) : _player = player ?? AudioPlayer() {
    _player.playbackEventStream.listen(_broadcastState, onError: (_) {});
    _player.currentIndexStream.listen(_onIndexChanged);
    _player.durationStream.listen(_onDuration);
    _player.processingStateStream.listen((s) {
      if (s == ProcessingState.completed) {
        // End of a non-repeating queue: stop at the start of the last item.
        _player.pause();
        _player.seek(Duration.zero, index: _player.currentIndex);
      }
    });
  }

  final AudioPlayer _player;
  final _errors = StreamController<String>.broadcast();
  List<MediaItem>? _unshuffledOrder;

  AudioPlayer get player => _player;

  /// Track ids whose files failed to play.
  Stream<String> get playbackErrors => _errors.stream;

  bool get shuffleEnabled => _unshuffledOrder != null;

  List<MediaItem> get _queue => queue.value;

  int? get currentIndex => _player.currentIndex;

  // ---- Queue loading -------------------------------------------------------

  Future<void> loadQueue(
    List<MediaItem> items, {
    int initialIndex = 0,
    Duration position = Duration.zero,
    bool autoplay = true,
  }) async {
    _unshuffledOrder = null;
    queue.add(List.unmodifiable(items));
    if (items.isEmpty) {
      await _player.stop();
      await _player.clearAudioSources();
      mediaItem.add(null);
      return;
    }
    final index = initialIndex.clamp(0, items.length - 1);
    try {
      await _player.setAudioSources(items.map(_sourceFor).toList(), initialIndex: index, initialPosition: position);
    } on PlayerException catch (e) {
      _errors.add(e.message ?? 'Playback failed');
    } on PlayerInterruptedException {
      return;
    }
    mediaItem.add(items[index]);
    if (autoplay) unawaited(_player.play());
  }

  AudioSource _sourceFor(MediaItem item) => AudioSource.file(item.extras![QueueExtras.path] as String, tag: item);

  void _onIndexChanged(int? index) {
    final q = _queue;
    if (index == null || index >= q.length) return;
    mediaItem.add(q[index]);
  }

  void _onDuration(Duration? duration) {
    final index = _player.currentIndex;
    final q = _queue;
    if (duration == null || index == null || index >= q.length) return;
    if (q[index].duration == duration) return;
    final updated = q[index].copyWith(duration: duration);
    final next = [...q]..[index] = updated;
    queue.add(List.unmodifiable(next));
    mediaItem.add(updated);
  }

  // ---- Transport controls --------------------------------------------------

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() async {
    if (_player.hasNext) {
      await _player.seekToNext();
    } else if (_queue.isNotEmpty && _player.loopMode == LoopMode.all) {
      await _player.seek(Duration.zero, index: 0);
    }
  }

  /// Restarts the track after 3 seconds, otherwise goes to the previous one.
  @override
  Future<void> skipToPrevious() async {
    if (_player.position > const Duration(seconds: 3) || !_player.hasPrevious) {
      await _player.seek(Duration.zero);
    } else {
      await _player.seekToPrevious();
    }
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= _queue.length) return;
    await _player.seek(Duration.zero, index: index);
    if (!_player.playing) unawaited(_player.play());
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    await _player.setLoopMode(switch (repeatMode) {
      AudioServiceRepeatMode.one => LoopMode.one,
      AudioServiceRepeatMode.all || AudioServiceRepeatMode.group => LoopMode.all,
      AudioServiceRepeatMode.none => LoopMode.off,
    });
    _broadcastState(_player.playbackEvent);
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    final enable = shuffleMode != AudioServiceShuffleMode.none;
    if (enable == shuffleEnabled) return;
    if (enable) {
      await _shuffleUpcoming(remember: true);
    } else {
      await _restoreOrder();
    }
    _broadcastState(_player.playbackEvent);
  }

  // ---- Queue editing -------------------------------------------------------

  @override
  Future<void> addQueueItem(MediaItem mediaItem) => addQueueItems([mediaItem]);

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    if (_queue.isEmpty) return loadQueue(mediaItems, autoplay: false);
    await _player.addAudioSources(mediaItems.map(_sourceFor).toList());
    queue.add(List.unmodifiable([..._queue, ...mediaItems]));
    _unshuffledOrder?.addAll(mediaItems);
  }

  /// Inserts right after the current item ("Play next").
  Future<void> playNext(List<MediaItem> items) async {
    if (_queue.isEmpty) return loadQueue(items);
    final at = (_player.currentIndex ?? -1) + 1;
    await insertQueueItems(at, items);
  }

  Future<void> insertQueueItems(int index, List<MediaItem> items) async {
    await _player.insertAudioSources(index, items.map(_sourceFor).toList());
    final next = [..._queue]..insertAll(index, items);
    queue.add(List.unmodifiable(next));
    _unshuffledOrder?.addAll(items);
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    if (index < 0 || index >= _queue.length) return;
    final removed = _queue[index];
    await _player.removeAudioSourceAt(index);
    final next = [..._queue]..removeAt(index);
    queue.add(List.unmodifiable(next));
    _unshuffledOrder?.remove(removed);
    if (next.isEmpty) mediaItem.add(null);
  }

  /// Moves an item; the current track keeps playing wherever it lands.
  Future<void> moveQueueItem(int from, int to) async {
    if (from == to || from < 0 || from >= _queue.length) return;
    final target = to.clamp(0, _queue.length - 1);
    await _player.moveAudioSource(from, target);
    final next = [..._queue];
    next.insert(target, next.removeAt(from));
    queue.add(List.unmodifiable(next));
  }

  /// Removes everything except the current item.
  Future<void> clearUpcoming() async {
    final index = _player.currentIndex;
    if (index == null) return;
    final current = _queue[index];
    if (index + 1 < _queue.length) await _player.removeAudioSourceRange(index + 1, _queue.length);
    if (index > 0) await _player.removeAudioSourceRange(0, index);
    queue.add(List.unmodifiable([current]));
    _unshuffledOrder = _unshuffledOrder == null ? null : [current];
  }

  Future<void> shuffleUpcomingOnce() => _shuffleUpcoming(remember: false);

  Future<void> _shuffleUpcoming({required bool remember}) async {
    final index = _player.currentIndex;
    if (index == null || _queue.length < 2) {
      if (remember) _unshuffledOrder = [..._queue];
      return;
    }
    if (remember) _unshuffledOrder = [..._queue];
    final current = _queue[index];
    final others = [..._queue]..removeAt(index);
    others.shuffle(Random());
    await _replaceAround(current, index, const [], others);
  }

  Future<void> _restoreOrder() async {
    final original = _unshuffledOrder;
    _unshuffledOrder = null;
    final index = _player.currentIndex;
    if (original == null || index == null) return;
    final current = _queue[index];
    final present = _queue.toSet();
    final ordered = original.where(present.contains).toList();
    final pos = ordered.indexOf(current);
    if (pos < 0) return;
    await _replaceAround(current, index, ordered.sublist(0, pos), ordered.sublist(pos + 1));
  }

  /// Replaces all items around the current one without interrupting it.
  Future<void> _replaceAround(MediaItem current, int index, List<MediaItem> before, List<MediaItem> after) async {
    if (index + 1 < _queue.length) await _player.removeAudioSourceRange(index + 1, _queue.length);
    if (index > 0) await _player.removeAudioSourceRange(0, index);
    if (before.isNotEmpty) await _player.insertAudioSources(0, before.map(_sourceFor).toList());
    if (after.isNotEmpty) await _player.addAudioSources(after.map(_sourceFor).toList());
    queue.add(List.unmodifiable([...before, current, ...after]));
  }

  /// Replaces metadata (after an edit) for every queue entry of a track.
  void refreshMetadata(String trackId, MediaItem Function(MediaItem old) update) {
    if (!_queue.any((item) => item.extras?[QueueExtras.trackId] == trackId)) return;
    final next = [for (final item in _queue) item.extras?[QueueExtras.trackId] == trackId ? update(item) : item];
    queue.add(List.unmodifiable(next));
    final index = _player.currentIndex;
    if (index != null && index < next.length) mediaItem.add(next[index]);
  }

  // ---- State broadcasting --------------------------------------------------

  void _broadcastState(PlaybackEvent event) {
    final playing = _player.playing;
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const {MediaAction.seek, MediaAction.seekForward, MediaAction.seekBackward},
        androidCompactActionIndices: const [0, 1, 2],
        processingState: switch (_player.processingState) {
          ProcessingState.idle => AudioProcessingState.idle,
          ProcessingState.loading => AudioProcessingState.loading,
          ProcessingState.buffering => AudioProcessingState.buffering,
          ProcessingState.ready => AudioProcessingState.ready,
          ProcessingState.completed => AudioProcessingState.completed,
        },
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
        repeatMode: switch (_player.loopMode) {
          LoopMode.off => AudioServiceRepeatMode.none,
          LoopMode.one => AudioServiceRepeatMode.one,
          LoopMode.all => AudioServiceRepeatMode.all,
        },
        shuffleMode: shuffleEnabled ? AudioServiceShuffleMode.all : AudioServiceShuffleMode.none,
      ),
    );
  }

  Future<void> dispose() async {
    await _errors.close();
    await _player.dispose();
  }
}

/// Builds the media-session item for a track file.
MediaItem mediaItemFor({
  required String entryId,
  required String trackId,
  required String path,
  required String title,
  String? artist,
  String? album,
  int? durationMs,
  String? artworkPath,
}) => MediaItem(
  id: entryId,
  title: title,
  artist: artist,
  album: album,
  duration: durationMs == null ? null : Duration(milliseconds: durationMs),
  artUri: artworkPath != null && File(artworkPath).existsSync() ? Uri.file(artworkPath) : null,
  extras: {QueueExtras.trackId: trackId, QueueExtras.path: path},
);
