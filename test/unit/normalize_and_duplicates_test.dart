import 'package:cadence/core/utils/duplicates.dart';
import 'package:cadence/core/utils/text_normalize.dart';
import 'package:cadence/data/database/daos/tracks_dao.dart';
import 'package:cadence/data/repositories/settings_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('normalizeKey', () {
    test('lowercases, folds accents, strips punctuation and collapses spaces', () {
      expect(normalizeKey('  Café   del   Mar!! '), 'cafe del mar');
      expect(normalizeKey("Don't Stop"), 'don t stop');
      expect(normalizeKey(null), '');
    });

    test('preserves Kannada letters and combining marks', () {
      const kannada = 'ಬೊಂಬೆ ಹೇಳುತೈತೆ';
      expect(normalizeKey(kannada), kannada);
      expect(normalizeKey('  ಬೊಂಬೆ   ಹೇಳುತೈತೆ! '), kannada);
    });

    test('search text joins normalized fields', () {
      expect(buildSearchText(['Hello', null, 'World ']), 'hello | world');
    });
  });

  group('splitArtists', () {
    test('splits featuring credits and semicolons but keeps band names', () {
      expect(splitArtists('A feat. B'), ['A', 'B']);
      expect(splitArtists('A; B ft. C'), ['A', 'B', 'C']);
      expect(splitArtists('Simon & Garfunkel'), ['Simon & Garfunkel']);
      expect(splitArtists('AC/DC'), ['AC/DC']);
      expect(splitArtists(null), isEmpty);
    });
  });

  group('language and year', () {
    test('maps codes and refuses to guess unknown values', () {
      expect(normalizeLanguage('kan'), 'Kannada');
      expect(normalizeLanguage('eng'), 'English');
      expect(normalizeLanguage('und'), isNull);
      expect(normalizeLanguage(''), isNull);
      expect(normalizeLanguage('tulu'), 'Tulu');
    });

    test('accepts only plausible release years', () {
      final now = DateTime(2026, 6, 1);
      expect(validReleaseYear(2026, now: now), 2026);
      expect(validReleaseYear(2027, now: now), 2027);
      expect(validReleaseYear(2030, now: now), isNull);
      expect(validReleaseYear(1800, now: now), isNull);
      expect(validReleaseYear(null, now: now), isNull);
    });
  });

  group('duplicate detection', () {
    const base = TrackIdentity(
      fileHash: 'abc',
      titleKey: 'song',
      artistKey: 'artist',
      albumKey: 'album',
      durationMs: 200000,
    );

    test('identical hash is an exact duplicate', () {
      const other = TrackIdentity(fileHash: 'abc', titleKey: 'x', artistKey: 'y', albumKey: '', durationMs: 1);
      expect(compareTracks(base, other), DuplicateKind.exactFile);
    });

    test('same metadata within duration tolerance is only "similar"', () {
      const other = TrackIdentity(
        fileHash: 'zzz',
        titleKey: 'song',
        artistKey: 'artist',
        albumKey: 'album',
        durationMs: 201500,
      );
      expect(compareTracks(base, other), DuplicateKind.similarMetadata);
    });

    test('different duration, album or artist is not a duplicate', () {
      expect(
        compareTracks(
          base,
          const TrackIdentity(
            fileHash: 'z',
            titleKey: 'song',
            artistKey: 'artist',
            albumKey: 'album',
            durationMs: 260000,
          ),
        ),
        DuplicateKind.none,
      );
      expect(
        compareTracks(
          base,
          const TrackIdentity(
            fileHash: 'z',
            titleKey: 'song',
            artistKey: 'artist',
            albumKey: 'live',
            durationMs: 200000,
          ),
        ),
        DuplicateKind.none,
      );
      expect(
        compareTracks(
          base,
          const TrackIdentity(
            fileHash: 'z',
            titleKey: 'song',
            artistKey: 'other',
            albumKey: 'album',
            durationMs: 200000,
          ),
        ),
        DuplicateKind.none,
      );
    });

    test('missing duration never produces a similarity match', () {
      const other = TrackIdentity(fileHash: 'z', titleKey: 'song', artistKey: 'artist', albumKey: 'album');
      expect(compareTracks(base, other), DuplicateKind.none);
    });
  });

  group('settings parsing', () {
    test('malformed values fall back to defaults and keep every home section', () {
      final s = AppSettings.fromJson({
        'themeMode': 'neon',
        'homeSections': [
          {'id': 'favorites', 'visible': false},
          {'id': 'favorites', 'visible': true},
          {'id': 'bogus'},
          42,
        ],
        'sorts': {'songs': 'playCount:desc', 'bad': 'nope'},
      });
      expect(s.homeSections.first.id, HomeSectionId.favorites);
      expect(s.homeSections.first.visible, isFalse);
      expect(s.homeSections.length, HomeSectionId.values.length);
      expect(s.sortFor('songs').sort, TrackSort.playCount);
      expect(s.sortFor('songs').descending, isTrue);
      expect(s.sorts.containsKey('bad'), isFalse);
    });

    test('round-trips through JSON', () {
      const s = AppSettings(userName: 'Asha', onlineLookups: true, pinnedArtists: ['a']);
      final back = AppSettings.fromJson(s.toJson());
      expect(back.userName, 'Asha');
      expect(back.onlineLookups, isTrue);
      expect(back.pinnedArtists, ['a']);
    });
  });
}
