import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'audio/audio_handler.dart';
import 'audio/playback_controller.dart';
import 'data/database/app_database.dart';
import 'data/services/storage_paths.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration.music());

  final handler = await AudioService.init(
    builder: CadenceAudioHandler.new,
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'app.cadence.cadence.playback',
      androidNotificationChannelName: 'Playback',
      androidNotificationChannelDescription: 'Media controls for music playback',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
      androidNotificationIcon: 'drawable/ic_stat_music',
    ),
  );

  final paths = await StoragePaths.create();
  final prefs = await SharedPreferences.getInstance();
  final db = AppDatabase();
  await db.miscDao.failInterruptedJobs();

  final container = ProviderContainer(
    overrides: [
      databaseProvider.overrideWithValue(db),
      storagePathsProvider.overrideWithValue(paths),
      sharedPreferencesProvider.overrideWithValue(prefs),
      audioHandlerProvider.overrideWithValue(handler),
    ],
  );
  // Start listening tracking before any playback, then restore the last queue.
  unawaited(container.read(playbackControllerProvider).restoreQueue());

  runApp(UncontrolledProviderScope(container: container, child: const CadenceApp()));
}
