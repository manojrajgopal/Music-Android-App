import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../audio/audio_handler.dart';
import '../data/database/app_database.dart';
import '../data/database/daos/tracks_dao.dart';
import '../data/repositories/library_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/services/artwork_service.dart';
import '../data/services/import_service.dart';
import '../data/services/storage_paths.dart';

// ---- Root dependencies (overridden in main.dart and tests) ----

final databaseProvider = Provider<AppDatabase>((ref) => throw UnimplementedError('databaseProvider'));
final storagePathsProvider = Provider<StoragePaths>((ref) => throw UnimplementedError('storagePathsProvider'));
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider'),
);
final audioHandlerProvider = Provider<CadenceAudioHandler>((ref) => throw UnimplementedError('audioHandlerProvider'));

// ---- Services and repositories ----

final artworkServiceProvider = Provider<ArtworkService>(
  (ref) => ArtworkService(ref.watch(databaseProvider), ref.watch(storagePathsProvider)),
);

final importServiceProvider = Provider<ImportService>(
  (ref) =>
      ImportService(ref.watch(databaseProvider), ref.watch(storagePathsProvider), ref.watch(artworkServiceProvider)),
);

final libraryRepositoryProvider = Provider<LibraryRepository>(
  (ref) => LibraryRepository(
    ref.watch(databaseProvider),
    ref.watch(storagePathsProvider),
    ref.watch(artworkServiceProvider),
  ),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(sharedPreferencesProvider)),
);

// ---- Settings ----

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.watch(settingsRepositoryProvider).load();

  Future<void> _set(AppSettings next) async {
    state = next;
    await ref.read(settingsRepositoryProvider).save(next);
  }

  Future<void> update(AppSettings Function(AppSettings s) change) => _set(change(state));

  Future<void> setThemeMode(ThemeMode mode) => _set(state.copyWith(themeMode: mode));

  Future<void> setSort(String view, TrackSort sort, bool descending) =>
      _set(state.copyWith(sorts: {...state.sorts, view: SortPref(sort, descending)}));

  Future<void> resetHome() => _set(
    state.copyWith(homeSections: AppSettings.defaultHomeSections, pinnedArtists: const [], pinnedPlaylists: const []),
  );
}

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(SettingsController.new);

/// Whether animations should be reduced (system setting or user choice).
bool reduceMotionOf(BuildContext context, AppSettings settings) =>
    settings.reduceMotion || MediaQuery.maybeDisableAnimationsOf(context) == true;
