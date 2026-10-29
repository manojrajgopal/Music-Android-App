import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/providers.dart';
import 'audio_handler.dart';

class SleepTimerState {
  const SleepTimerState({this.deadline, this.endOfTrack = false});

  final DateTime? deadline;
  final bool endOfTrack;

  bool get active => deadline != null || endOfTrack;

  Duration? remaining(DateTime now) {
    final d = deadline;
    if (d == null) return null;
    final left = d.difference(now);
    return left.isNegative ? Duration.zero : left;
  }
}

/// Sleep timer based on a persisted wall-clock deadline rather than an
/// in-memory countdown alone. If the app is suspended or restarted, the
/// deadline is re-checked on resume and on every tick; when it has passed,
/// playback pauses. The OS may suspend Dart timers while the app is not
/// playing, which is harmless because nothing is playing then.
class SleepTimerController extends Notifier<SleepTimerState> {
  Timer? _ticker;
  StreamSubscription<int?>? _indexSub;

  CadenceAudioHandler get _handler => ref.read(audioHandlerProvider);

  @override
  SleepTimerState build() {
    ref.onDispose(() {
      _ticker?.cancel();
      _indexSub?.cancel();
    });
    final saved = ref.read(settingsRepositoryProvider).sleepDeadline;
    if (saved != null && saved.isAfter(DateTime.now())) {
      _startTicker();
      return SleepTimerState(deadline: saved);
    }
    if (saved != null) ref.read(settingsRepositoryProvider).setSleepDeadline(null);
    return const SleepTimerState();
  }

  void start(Duration duration) {
    final deadline = DateTime.now().add(duration);
    _indexSub?.cancel();
    state = SleepTimerState(deadline: deadline);
    ref.read(settingsRepositoryProvider).setSleepDeadline(deadline);
    _startTicker();
  }

  /// Pauses when the current track finishes.
  void untilEndOfTrack() {
    cancel();
    state = const SleepTimerState(endOfTrack: true);
    final startIndex = _handler.player.currentIndex;
    _indexSub = _handler.player.currentIndexStream.skip(1).listen((index) {
      if (index != startIndex) _expire();
    });
  }

  void cancel() {
    _ticker?.cancel();
    _indexSub?.cancel();
    _ticker = null;
    _indexSub = null;
    ref.read(settingsRepositoryProvider).setSleepDeadline(null);
    state = const SleepTimerState();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => check());
  }

  /// Also called on app resume.
  void check() {
    final d = state.deadline;
    if (d != null && !DateTime.now().isBefore(d)) _expire();
  }

  void _expire() {
    _handler.pause();
    cancel();
  }
}

final sleepTimerProvider = NotifierProvider<SleepTimerController, SleepTimerState>(SleepTimerController.new);
