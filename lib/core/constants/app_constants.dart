/// Rules that define how listening is counted. Shared by the tracker,
/// statistics and tests so every screen agrees on the same definitions.
abstract final class ListeningRules {
  /// A playback counts as a "play" after this much actual listening...
  static const meaningfulPlayMs = 30000;

  /// ...or after this fraction of a shorter track.
  static const meaningfulPlayFraction = 0.5;

  /// A play is "completed" once this fraction of the track was reached.
  static const completedFraction = 0.9;

  /// A local day contributes to a streak after this much listening.
  static const streakDayMinMs = 60000;

  /// In-progress listening is checkpointed this often, so process
  /// termination loses at most this much listening time.
  static const checkpointInterval = Duration(seconds: 15);

  /// Gap after which a new listening session starts.
  static const sessionGap = Duration(minutes: 30);

  /// Continue Listening only offers positions inside this window.
  static const resumeMinMs = 30000;
  static const resumeTailMs = 15000;

  static int meaningfulThresholdFor(int? durationMs) {
    if (durationMs == null || durationMs <= 0) return meaningfulPlayMs;
    final fraction = (durationMs * meaningfulPlayFraction).round();
    return fraction < meaningfulPlayMs ? fraction : meaningfulPlayMs;
  }
}

abstract final class ImportRules {
  static const supportedExtensions = ['mp3', 'm4a', 'aac', 'flac', 'wav', 'ogg', 'opus'];
  static const maxDownloadBytes = 300 * 1024 * 1024;
  static const downloadTimeout = Duration(minutes: 10);
  static const connectTimeout = Duration(seconds: 20);
  static const maxRedirects = 5;
  static const duplicateDurationToleranceMs = 2000;
}

abstract final class AppInfo {
  static const name = 'Music';
  static const backupFormat = 'cadence-backup';
  static const backupVersion = 1;
}
