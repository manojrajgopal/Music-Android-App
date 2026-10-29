import 'package:cadence/data/database/app_database.dart';
import 'package:cadence/features/home/recommendations.dart';
import 'package:cadence/features/new_music/rankings.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  final now = DateTime(2026, 10, 29, 12);
  DateTime daysAgo(int d) => now.subtract(Duration(days: d));

  group('local trending', () {
    test('ranks tracks rising this week above steady ones', () {
      final rising = makeTrack(title: 'Rising');
      final steady = makeTrack(title: 'Steady');
      final history = [
        for (var i = 0; i < 5; i++) record(rising.id, daysAgo(1)),
        for (var i = 0; i < 3; i++) record(steady.id, daysAgo(2)),
        for (var i = 0; i < 9; i++) record(steady.id, daysAgo(10)),
      ];
      final ranked = localTrending([rising, steady], history, now: now);
      expect(ranked.first.track.title, 'Rising');
      expect(ranked.any((r) => r.track.title == 'Steady'), isFalse, reason: 'no increase vs its earlier average');
    });

    test('short taps (not counted) never trend', () {
      final t = makeTrack();
      final history = [for (var i = 0; i < 20; i++) record(t.id, daysAgo(1), listenedMs: 2000, counted: false)];
      expect(localTrending([t], history, now: now), isEmpty);
    });
  });

  group('daily top', () {
    test('uses the documented score and never invents entries', () {
      final a = makeTrack(title: 'A', playCount: 4);
      final b = makeTrack(title: 'B', playCount: 0);
      final c = makeTrack(title: 'C', playCount: 0);
      final history = [record(b.id, daysAgo(1)), record(b.id, daysAgo(20))];
      final top = dailyTop([a, b, c], history, now: now);
      expect(top.length, 2, reason: 'C has no plays and is not padded in');
      expect(top.first.track.title, 'B');
      expect(top.first.score, 3 * 1 + 2 + 0);
      expect(top[1].score, 1.0);
    });

    test('caps at the limit', () {
      final tracks = [for (var i = 0; i < 150; i++) makeTrack(title: 'T$i', playCount: i + 1)];
      expect(dailyTop(tracks, const [], now: now).length, 100);
    });
  });

  test('heavy rotation needs recent plays and boosts favorites', () {
    final fav = makeTrack(title: 'Fav', favorite: true);
    final plain = makeTrack(title: 'Plain');
    final unplayed = makeTrack(title: 'Never', favorite: true);
    final history = [record(fav.id, daysAgo(3)), record(plain.id, daysAgo(3)), record(plain.id, daysAgo(4))];
    final result = heavyRotation([fav, plain, unplayed], history, now: now);
    expect(result.map((t) => t.title), ['Fav', 'Plain']);
  });

  group('top picks', () {
    test('returns nothing for a new library rather than padding', () {
      expect(topPicks([makeTrack(), makeTrack()], now: now), isEmpty);
    });

    test('builds favorites, most played and language collections from real data', () {
      final tracks = [
        for (var i = 0; i < 4; i++)
          makeTrack(title: 'K$i', language: 'Kannada', playCount: 5 + i, favorite: i.isEven, artist: 'Singer ${i % 2}'),
        makeTrack(title: 'E', language: 'English', playCount: 1),
      ];
      final picks = topPicks(tracks, now: now);
      final ids = picks.map((c) => c.id).toList();
      expect(ids, contains('most-played'));
      expect(ids, contains('lang-Kannada'));
      expect(ids, isNot(contains('favorites-mix')), reason: 'only 2 favorites, below the minimum');
      expect(picks.firstWhere((c) => c.id == 'lang-Kannada').title, 'Your Kannada Favorites');
    });
  });

  group('more like this', () {
    test('scores shared artist, genre and language, with reasons', () {
      final seed = makeTrack(title: 'Seed', artist: 'A feat. B', genre: 'Pop', language: 'English');
      final sameArtist = makeTrack(title: 'S1', artist: 'B', genre: 'Rock');
      final sameGenre = makeTrack(title: 'S2', artist: 'Z', genre: 'pop');
      final unrelated = makeTrack(title: 'U', artist: 'Q', genre: 'Jazz', language: 'Hindi');
      final result = moreLikeThis(seed, [seed, sameArtist, sameGenre, unrelated]);
      expect(result.map((s) => s.track.title), ['S1', 'S2']);
      expect(result.first.reasons, contains('Same artist'));
    });

    test('returns nothing without shared signals', () {
      final seed = makeTrack(artist: null, genre: null);
      expect(moreLikeThis(seed, [seed, makeTrack(artist: 'X')]), isEmpty);
    });
  });

  test('best of artists requires enough songs', () {
    final tracks = [
      for (var i = 0; i < 4; i++) makeTrack(artist: 'Prolific', playCount: i),
      for (var i = 0; i < 2; i++) makeTrack(artist: 'Rare'),
    ];
    final result = bestOfArtists(tracks);
    expect(result.map((a) => a.name), ['Prolific']);
    expect(result.first.tracks.first.playCount, 3);
  });

  test('continue listening only offers meaningful positions', () {
    final good = makeTrack(title: 'Good', lastPositionMs: 60000, lastPlayedAt: daysAgo(1));
    final tooEarly = makeTrack(title: 'Early', lastPositionMs: 5000, lastPlayedAt: daysAgo(1));
    final atEnd = makeTrack(title: 'End', lastPositionMs: 195000, lastPlayedAt: daysAgo(1));
    final old = makeTrack(title: 'Old', lastPositionMs: 60000, lastPlayedAt: daysAgo(90));
    expect(continueListening([good, tooEarly, atEnd, old], now: now).map((t) => t.title), ['Good']);
  });

  test('mood membership respects exclusions and explicit additions', () {
    final chill = makeTrack(title: 'Ambient', genre: 'Ambient');
    final excluded = makeTrack(title: 'Jazz', genre: 'Jazz');
    final added = makeTrack(title: 'Rock', genre: 'Rock');
    final result = moodTracks(Mood.chill, [chill, excluded, added], {excluded.id: false, added.id: true});
    expect(result.map((t) => t.title).toSet(), {'Ambient', 'Rock'});
  });

  test('long-form mixes are detected by duration, genre or tag', () {
    expect(isLongFormMix(makeTrack(durationMs: 45 * 60000)), isTrue);
    expect(isLongFormMix(makeTrack(genre: 'DJ Mix')), isTrue);
    final tagged = makeTrack(durationMs: 1000);
    expect(isLongFormMix(tagged, taggedIds: {tagged.id}), isTrue);
    expect(isLongFormMix(makeTrack(durationMs: 180000, genre: 'Pop')), isFalse);
  });
}
