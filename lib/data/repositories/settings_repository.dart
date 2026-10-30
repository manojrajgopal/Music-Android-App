import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/daos/tracks_dao.dart';

enum HomeSectionId {
  continueListening('Continue Listening'),
  heavyRotation('Heavy Rotation'),
  topPicks('Top Picks for You'),
  recentlyPlayed('Recently Played'),
  moods('Find Your Mood'),
  moreLikeThis('More Like This'),
  bestOfArtists('Best of Artists'),
  languages('Languages'),
  yearHits('Year Hits'),
  favorites('Favorites'),
  pinned('Pinned Playlists & Artists');

  const HomeSectionId(this.label);
  final String label;
}

class HomeSectionConfig {
  const HomeSectionConfig(this.id, this.visible);

  final HomeSectionId id;
  final bool visible;

  Map<String, Object> toJson() => {'id': id.name, 'visible': visible};
}

class SortPref {
  const SortPref(this.sort, this.descending);

  final TrackSort sort;
  final bool descending;
}

/// Lightweight preferences stored in SharedPreferences. Library data lives
/// in the database; this holds UI and playback preferences only.
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.dark,
    this.userName,
    this.copyConsent = false,
    this.onlineLookups = false,
    this.reduceMotion = false,
    this.homeSections = defaultHomeSections,
    this.pinnedPlaylists = const [],
    this.pinnedArtists = const [],
    this.sorts = const {},
  });

  static const defaultHomeSections = [
    HomeSectionConfig(HomeSectionId.continueListening, true),
    HomeSectionConfig(HomeSectionId.heavyRotation, true),
    HomeSectionConfig(HomeSectionId.topPicks, true),
    HomeSectionConfig(HomeSectionId.recentlyPlayed, true),
    HomeSectionConfig(HomeSectionId.moods, true),
    HomeSectionConfig(HomeSectionId.moreLikeThis, true),
    HomeSectionConfig(HomeSectionId.bestOfArtists, true),
    HomeSectionConfig(HomeSectionId.languages, true),
    HomeSectionConfig(HomeSectionId.yearHits, true),
    HomeSectionConfig(HomeSectionId.favorites, true),
    HomeSectionConfig(HomeSectionId.pinned, true),
  ];

  final ThemeMode themeMode;
  final String? userName;

  /// The user agreed that imports are copied into app storage.
  final bool copyConsent;

  /// Optional online metadata lookups (off by default).
  final bool onlineLookups;
  final bool reduceMotion;
  final List<HomeSectionConfig> homeSections;
  final List<int> pinnedPlaylists;
  final List<String> pinnedArtists;
  final Map<String, SortPref> sorts;

  SortPref sortFor(String view, {TrackSort fallback = TrackSort.title}) =>
      sorts[view] ?? SortPref(fallback, fallback == TrackSort.dateAdded || fallback == TrackSort.playCount);

  AppSettings copyWith({
    ThemeMode? themeMode,
    Object? userName = _keep,
    bool? copyConsent,
    bool? onlineLookups,
    bool? reduceMotion,
    List<HomeSectionConfig>? homeSections,
    List<int>? pinnedPlaylists,
    List<String>? pinnedArtists,
    Map<String, SortPref>? sorts,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    userName: userName == _keep ? this.userName : userName as String?,
    copyConsent: copyConsent ?? this.copyConsent,
    onlineLookups: onlineLookups ?? this.onlineLookups,
    reduceMotion: reduceMotion ?? this.reduceMotion,
    homeSections: homeSections ?? this.homeSections,
    pinnedPlaylists: pinnedPlaylists ?? this.pinnedPlaylists,
    pinnedArtists: pinnedArtists ?? this.pinnedArtists,
    sorts: sorts ?? this.sorts,
  );

  Map<String, Object?> toJson() => {
    'themeMode': themeMode.name,
    'userName': userName,
    'copyConsent': copyConsent,
    'onlineLookups': onlineLookups,
    'reduceMotion': reduceMotion,
    'homeSections': homeSections.map((s) => s.toJson()).toList(),
    'pinnedPlaylists': pinnedPlaylists,
    'pinnedArtists': pinnedArtists,
    'sorts': {for (final e in sorts.entries) e.key: '${e.value.sort.name}:${e.value.descending ? 'desc' : 'asc'}'},
  };

  /// Tolerant parser: unknown or malformed values fall back to defaults.
  static AppSettings fromJson(Map<String, Object?> json) {
    T? pick<T>(String key) => json[key] is T ? json[key] as T : null;
    final sections = <HomeSectionConfig>[];
    final seen = <HomeSectionId>{};
    for (final raw in (pick<List>('homeSections') ?? const [])) {
      if (raw is! Map) continue;
      final id = HomeSectionId.values.where((v) => v.name == raw['id']).firstOrNull;
      if (id == null || !seen.add(id)) continue;
      sections.add(HomeSectionConfig(id, raw['visible'] != false));
    }
    for (final id in HomeSectionId.values) {
      if (!seen.contains(id)) sections.add(HomeSectionConfig(id, true));
    }
    final sorts = <String, SortPref>{};
    (pick<Map>('sorts') ?? const {}).forEach((key, value) {
      if (key is! String || value is! String) return;
      final parts = value.split(':');
      final sort = TrackSort.values.where((s) => s.name == parts.first).firstOrNull;
      if (sort != null) sorts[key] = SortPref(sort, parts.length > 1 && parts[1] == 'desc');
    });
    return AppSettings(
      themeMode: ThemeMode.values.where((m) => m.name == json['themeMode']).firstOrNull ?? ThemeMode.dark,
      userName: pick<String>('userName'),
      copyConsent: pick<bool>('copyConsent') ?? false,
      onlineLookups: pick<bool>('onlineLookups') ?? false,
      reduceMotion: pick<bool>('reduceMotion') ?? false,
      homeSections: sections,
      pinnedPlaylists: (pick<List>('pinnedPlaylists') ?? const []).whereType<int>().toList(),
      pinnedArtists: (pick<List>('pinnedArtists') ?? const []).whereType<String>().toList(),
      sorts: sorts,
    );
  }
}

const _keep = Object();

/// Snapshot of the play queue so it can be restored after the OS ends the
/// process.
class QueueSnapshot {
  const QueueSnapshot(this.trackIds, this.index, this.positionMs, {this.repeat = 0, this.shuffle = false});

  final List<String> trackIds;
  final int index;
  final int positionMs;
  final int repeat;
  final bool shuffle;
}

class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _settingsKey = 'settings.v1';
  static const _queueKey = 'queue.v1';
  static const _sleepKey = 'sleepTimer.deadline';
  static const _downloadsKey = 'downloadedLinks.v1';

  AppSettings load() {
    final raw = _prefs.getString(_settingsKey);
    if (raw == null) return const AppSettings();
    try {
      return AppSettings.fromJson((jsonDecode(raw) as Map).cast<String, Object?>());
    } catch (_) {
      return const AppSettings();
    }
  }

  Future<void> save(AppSettings settings) => _prefs.setString(_settingsKey, jsonEncode(settings.toJson()));

  QueueSnapshot? loadQueue() {
    final raw = _prefs.getString(_queueKey);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map;
      return QueueSnapshot(
        (json['ids'] as List).cast<String>(),
        json['index'] as int,
        json['position'] as int,
        repeat: json['repeat'] as int? ?? 0,
        shuffle: json['shuffle'] as bool? ?? false,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> saveQueue(QueueSnapshot s) => _prefs.setString(
    _queueKey,
    jsonEncode({
      'ids': s.trackIds,
      'index': s.index,
      'position': s.positionMs,
      'repeat': s.repeat,
      'shuffle': s.shuffle,
    }),
  );

  DateTime? get sleepDeadline {
    final ms = _prefs.getInt(_sleepKey);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  /// The library song saved from a link (see `linkKey`), if any.
  String? downloadedTrack(String linkKey) => _downloadedLinks()[linkKey];

  Future<void> rememberDownload(String linkKey, String trackId) =>
      _prefs.setString(_downloadsKey, jsonEncode({..._downloadedLinks(), linkKey: trackId}));

  Map<String, String> _downloadedLinks() {
    final raw = _prefs.getString(_downloadsKey);
    if (raw == null) return const {};
    try {
      return (jsonDecode(raw) as Map).cast<String, String>();
    } catch (_) {
      return const {};
    }
  }

  Future<void> setSleepDeadline(DateTime? deadline) =>
      deadline == null ? _prefs.remove(_sleepKey) : _prefs.setInt(_sleepKey, deadline.millisecondsSinceEpoch);
}
