# Cadence — offline music player

A premium, offline-first music player for Android and iOS built with Flutter.
No accounts, no ads, no backend, no analytics. Music, playlists, statistics and
settings stay on the device.

## Toolchain and dependencies

Built and tested with **Flutter 3.47.8 / Dart 3.13.7** (stable, October 2026).
Versions are pinned in `pubspec.lock`.

| Purpose | Package |
|---|---|
| State / DI | `flutter_riverpod` 3.4 |
| Navigation | `go_router` 18.1 |
| Database | `drift` 2.35 + `drift_flutter` (SQLite bundled via `sqlite3` build hooks) |
| Settings | `shared_preferences` |
| Playback | `just_audio` 0.10, `audio_service` 0.18, `audio_session` 0.2 |
| Tags & artwork | `audio_metadata_reader` 1.8, `image` 4 |
| Artwork colors | `material_color_utilities` (Celebi quantizer + Material scoring, HCT re-toning) |
| Files | `file_picker` 13 (system picker, scoped access) |
| Network (opt-in) | `dio` 5 |
| Hashing | `crypto` (SHA-256 / SHA-1) |
| Voice search | `speech_to_text` 7.5, `permission_handler` 13 |
| Backup | `archive` 4 |
| Tests | `flutter_test`, `integration_test`, `mocktail` |

Deliberately **not** used: `palette_generator` (discontinued — replaced by
`material_color_utilities`), `sqlite3_flutter_libs` (end-of-life; sqlite is
bundled by `sqlite3` 3.x), `flutter_local_notifications` (the media
notification comes from `audio_service`; nothing else needs notifications).

## Setup

```bash
flutter pub get
dart run build_runner build      # regenerates Drift code after schema changes
flutter run
```

### Builds

```bash
flutter build apk --release      # Android → build/app/outputs/flutter-apk/EarnLens.apk
flutter build web --release      # Web (see docs/PLATFORM_SUPPORT.md for hosting headers)
```

Android needs compile SDK 37 (required by `permission_handler_android`). On
Windows with the pub cache and project on different drives, Kotlin incremental
compilation is disabled in `android/gradle.properties`.

## Architecture

```
lib/
  main.dart                 audio session, AudioService, DB, prefs → ProviderScope
  app/                      app root, router, routes, providers, theme
  audio/                    the single audio engine and listening tracker
    audio_handler.dart      only AudioPlayer; media session; queue editing
    playback_controller.dart  UI-facing API, queue persistence, error handling
    listening_tracker.dart  monotonic listening measurement → history
    sleep_timer.dart        persisted-deadline sleep timer
  core/                     constants, errors, text normalization, widgets
  data/
    database/               Drift tables, DAOs, migrations
    repositories/           library (edits/favorites/tags), settings
    services/               import, metadata, artwork, URL import, backup,
                            optional online metadata
  features/                 home, new_music, library, search, player,
                            playlists, import_music, metadata, statistics,
                            settings, backup, shell
```

* **One audio engine.** `CadenceAudioHandler` owns the only `AudioPlayer`; UI
  and the system media controls both drive it.
* **Repositories/DAOs** are the only database access. Screens watch Riverpod
  `StreamProvider`s backed by Drift queries, so imports, edits and rescans
  update every screen reactively.
* **Pure domain logic** (`recommendations.dart`, `rankings.dart`,
  `stats_calculator.dart`, `text_normalize.dart`, `duplicates.dart`) has no
  Flutter dependencies and is unit tested.
* Playback position ticks are watched only by the seek bars, never by pages.

### Navigation

An outer `ShellRoute` hosts the floating navigation and mini-player; inside it
a `StatefulShellRoute.indexedStack` keeps each tab's stack. Playlists and
collections open inside the outer shell (navigation stays visible); the
full-screen player, queue, editor, settings, Replay, URL import and backup open
on the root navigator.

### Data model

`tracks` holds effective metadata plus normalized keys
(`title_key`, `artist_key`, `album_key`, `search_text`) and indexes on title,
artist, album, genre, language, date added, play count and hash.
`embedded_tags` keeps the values read from the file; `overridden_fields`
records which fields the user edited, so rescans never overwrite edits and
edits can be reverted. Other tables: `track_artists` (multi-artist credits),
`favorite_albums`, `playlists`, `playlist_tracks` (duplicates allowed,
transactional reorder), `playback_history`, `listening_sessions`, `tags` /
`track_tags` (user tags and mood membership with exclusions), `search_history`,
`artwork_cache` (paths + extracted colors), `import_jobs`.
Lightweight preferences (theme, Home layout, sort orders, queue snapshot,
sleep deadline) live in SharedPreferences.

Migrations: `AppDatabase.migration` — add one step per schema version; never
drop user tables.

### Storage policy

Files picked with the system picker come with temporary access only (iOS
copies them to a temp folder; Android returns cache copies or content URIs
without durable permission). To play reliably later, Cadence keeps **a private
copy** in its documents folder — after a one-time consent dialog. References
are stored as `app://music/<file>` so they survive iOS container moves. Deleting
a song's file removes only that private copy. Embedded artwork is resized to
720 px JPEG once and shared by key across an album.

## Definitions used by statistics

* **Play** — at least 30 s of actual listening, or half of a shorter track.
  Paused time never counts. Measured with a monotonic clock.
* **Completed** — reached 90 % of the duration.
* **Skip** — left before counting and before completion. Taps under 1 s leave
  no history record.
* **Checkpoint** — in-progress listening is saved every 15 s and on pause /
  app background, so process death loses at most 15 s.
* **Streak day** — a local calendar day with ≥ 1 minute of listening; the
  current streak may end yesterday.
* **Trending (local)** — meaningful plays in the last 7 days vs. the weekly
  average of the previous 21 days; at least 2 recent plays.
* **Daily Top 100 (your library)** — `3 × plays(7 d) + plays(30 d) + 0.25 ×
  all-time plays`; never padded.
* **New** — added to this library; **Recent Releases / Year Hits** use the
  release year tag only, never the import date.

## Permissions

| Permission | When | Why |
|---|---|---|
| None for files | — | System picker (scoped access); no broad storage permission |
| `INTERNET` | URL import, opt-in lookups | Never used in the background |
| `FOREGROUND_SERVICE(_MEDIA_PLAYBACK)`, `WAKE_LOCK` | Playback | Background audio + media notification |
| `RECORD_AUDIO` (Android) | Tapping the mic | Voice search, requested on demand |
| iOS `NSMicrophoneUsageDescription`, `NSSpeechRecognitionUsageDescription` | Tapping the mic | Requested by `speech_to_text` on first use |
| iOS `UIBackgroundModes: audio` | Playback | Background audio / lock screen |

Voice recognition uses the platform speech service, which may need internet
depending on device and language. Typing always works.

## Network features (all user-initiated)

* **Direct URL import** — https only; every redirect hop is resolved and
  rejected if it reaches loopback/private/link-local/CGNAT addresses, http,
  or a streaming service; content type and magic bytes must be audio; 300 MB
  and 10 min limits; `.part` temp file, atomic rename, size check; the user
  must confirm they have the right to download. Streaming services (YouTube,
  Spotify, SoundCloud, …) are refused. Known limitation: DNS is resolved
  separately from the connection, so DNS-rebinding is not fully prevented.
* **YouTube links** — recognised, never downloaded or extracted. "Open in
  YouTube" launches the external app. With online lookups enabled, the public
  oEmbed endpoint provides the title and channel only.
* **Online metadata (off by default)** — MusicBrainz recording search and
  Cover Art Archive front covers, shown as candidates the user picks from.
  Before publishing, add a contact URL to the User-Agent in
  `online_metadata_service.dart` as required by MusicBrainz policy.

## Backup format

`cadence-backup-YYYYMMDD-HHMM.zip` containing:

* `manifest.json` — `{format: "cadence-backup", version: 1, createdAt, includesHistory, includesAudio: false}`
* `data.json` — `tracks` (hash, title/artist/album/duration for matching, edits,
  favorite, rating, counts, tags/moods), `playlists` (ordered track refs),
  `favoriteAlbums`, `settings`, optional `history`.

Restore validates format/version, reads only those two entries in memory (no
extraction), shows a preview, matches songs by hash then by normalized
title/artist/album ± 2 s, and **merges**: restored playlists are added beside
existing ones, play counts take the maximum, history is de-duplicated, and a
chosen policy decides rating/edit conflicts. Audio files are not included.

## Testing

```bash
flutter test                                   # unit + widget tests
flutter test integration_test -d <device-id>   # on a device or emulator
```

* `test/unit` — normalization (incl. Kannada), duplicates, settings parsing,
  rankings, recommendations, listening tracker, streaks/Replay, Drift DAOs
  (playlists, sorting, search, edits/revert, moods), import/rescan/relink with
  WAV fixtures, backup round-trip/conflicts/validation, URL validation with a
  fake HTTP adapter (no public network).
* `test/widget` — navigation, center sheet, mini-player, Home/Library/Search,
  player controls, queue, empty states, themes, contrast of artwork palettes,
  compact layout.
* `integration_test/app_flow_test.dart` — real DB file and audio engine:
  import, play/pause/seek/skip, playlists, favorites, edit, restart
  persistence, search, listening counts, backup/restore, rescan, missing files,
  YouTube recognition, sleep timer, tab navigation.

### Needs physical-device testing

Lock-screen / notification controls, Bluetooth and headset buttons, headphone
unplug, phone-call interruptions, long background sessions and OS process
death, and iOS in general (an iOS build requires macOS/Xcode). The file picker
UI cannot be automated.

## Release

Build the Android release APK:

```bash
flutter build apk --release
```

Every release build also saves a copy named `music.apk` next to
`app-release.apk` in `build/app/outputs/flutter-apk/` (see the
`assembleRelease` step at the end of `android/app/build.gradle.kts`).
`build_music_apk.ps1` runs the same command.

1. Set the application id / bundle id (`app.cadence.cadence`) and display name.
2. Android: create a keystore, add a `signingConfig` for `release` in
   `android/app/build.gradle.kts`, then `flutter build appbundle`.
3. iOS (macOS): open `ios/Runner.xcworkspace`, set the team and bundle id,
   then `flutter build ipa`.
4. Replace the default launcher icons and add a splash screen
   (e.g. with `flutter_launcher_icons` / `flutter_native_splash`).
5. Bump `version:` in `pubspec.yaml`.

## Supported formats

MP3, M4A/AAC, FLAC, WAV and Ogg/Opus are accepted. Actual playback depends on
the platform decoder: iOS does not play Ogg Vorbis/Opus natively, so such files
import on iOS but fail to play and are marked unreadable. Metadata reading is
best-effort; missing tags fall back to the file name and never block import.
