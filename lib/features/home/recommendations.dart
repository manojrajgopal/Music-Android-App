import '../../core/constants/app_constants.dart';
import '../../core/utils/text_normalize.dart';
import '../../data/database/app_database.dart';

/// A generated collection with a plain-language reason.
class Collection {
  const Collection({required this.id, required this.title, required this.reason, required this.tracks});

  final String id;
  final String title;
  final String reason;
  final List<Track> tracks;

  String? get coverKey => tracks.map((t) => t.artworkKey).whereType<String>().firstOrNull;
}

const minCollectionSize = 3;

/// Top Picks for You built only from local signals. Collections with too
/// little data are omitted rather than padded.
List<Collection> topPicks(List<Track> tracks, {required DateTime now}) {
  final result = <Collection>[];
  final played = tracks.where((t) => t.playCount > 0).toList();

  final favorites = tracks.where((t) => t.isFavorite).toList()..sort((a, b) => b.playCount.compareTo(a.playCount));
  if (favorites.length >= minCollectionSize) {
    result.add(
      Collection(
        id: 'favorites-mix',
        title: 'Based on Your Favorites',
        reason: 'Songs you marked as favorites',
        tracks: favorites.take(40).toList(),
      ),
    );
  }

  final mostPlayed = [...played]..sort((a, b) => b.playCount.compareTo(a.playCount));
  if (mostPlayed.length >= minCollectionSize) {
    result.add(
      Collection(
        id: 'most-played',
        title: 'Your Most Played',
        reason: 'Ranked by your play counts',
        tracks: mostPlayed.take(40).toList(),
      ),
    );
  }

  final artistPlays = <String, int>{};
  for (final t in played) {
    if (t.artistKey.isEmpty) continue;
    artistPlays[t.artistKey] = (artistPlays[t.artistKey] ?? 0) + t.playCount;
  }
  final topArtists = (artistPlays.entries.toList()..sort((a, b) => b.value.compareTo(a.value)))
      .take(5)
      .map((e) => e.key)
      .toSet();
  final returnTo = tracks.where((t) => topArtists.contains(t.artistKey)).toList()
    ..sort((a, b) => b.playCount.compareTo(a.playCount));
  if (topArtists.length >= 2 && returnTo.length >= minCollectionSize) {
    result.add(
      Collection(
        id: 'artists-return',
        title: 'Artists You Return To',
        reason: 'Your most played artists',
        tracks: returnTo.take(40).toList(),
      ),
    );
  }

  final languagePlays = <String, int>{};
  for (final t in played) {
    if (t.language == null) continue;
    languagePlays[t.language!] = (languagePlays[t.language!] ?? 0) + t.playCount;
  }
  final languages = languagePlays.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  for (final lang in languages.take(2)) {
    final inLang = tracks.where((t) => t.language == lang.key && (t.isFavorite || t.playCount > 0)).toList()
      ..sort((a, b) => _affinity(b).compareTo(_affinity(a)));
    if (inLang.length >= minCollectionSize) {
      result.add(
        Collection(
          id: 'lang-${lang.key}',
          title: 'Your ${lang.key} Favorites',
          reason: 'Favorites and frequent plays tagged ${lang.key}',
          tracks: inLang.take(40).toList(),
        ),
      );
    }
  }

  final cutoff = now.subtract(const Duration(days: 60));
  final rediscover = played.where((t) => t.lastPlayedAt != null && t.lastPlayedAt!.isBefore(cutoff)).toList()
    ..sort((a, b) => b.playCount.compareTo(a.playCount));
  if (rediscover.length >= minCollectionSize) {
    result.add(
      Collection(
        id: 'rediscover',
        title: 'Rediscover Your Library',
        reason: 'Songs you loved but have not played in 60 days',
        tracks: rediscover.take(40).toList(),
      ),
    );
  }
  return result;
}

double _affinity(Track t) => t.playCount + (t.isFavorite ? 5 : 0) + (t.rating ?? 0).toDouble();

/// Explains why a track is considered similar.
class Similar {
  const Similar(this.track, this.score, this.reasons);

  final Track track;
  final double score;
  final List<String> reasons;
}

/// More Like This: shared artist, album, genre, language, tags and
/// listening affinity. Tracks with no shared signal are never returned.
List<Similar> moreLikeThis(
  Track seed,
  List<Track> library, {
  Map<String, Set<int>> tagsByTrack = const {},
  int limit = 20,
}) {
  final seedArtists = splitArtists(seed.artist).map(normalizeKey).toSet();
  final seedTags = tagsByTrack[seed.id] ?? const {};
  final seedGenre = normalizeKey(seed.genre);
  final results = <Similar>[];
  for (final t in library) {
    if (t.id == seed.id) continue;
    var score = 0.0;
    final reasons = <String>[];
    final artists = splitArtists(t.artist).map(normalizeKey).toSet();
    if (seedArtists.isNotEmpty && artists.intersection(seedArtists).isNotEmpty) {
      score += 4;
      reasons.add('Same artist');
    }
    if (seed.albumKey.isNotEmpty && t.albumKey == seed.albumKey) {
      score += 2;
      reasons.add('Same album');
    }
    if (seedGenre.isNotEmpty && normalizeKey(t.genre) == seedGenre) {
      score += 3;
      reasons.add('Same genre');
    }
    if (seed.language != null && t.language == seed.language) {
      score += 1.5;
      reasons.add('Same language');
    }
    final sharedTags = (tagsByTrack[t.id] ?? const <int>{}).intersection(seedTags).length;
    if (sharedTags > 0) {
      score += 2.0 * sharedTags;
      reasons.add('Shared tags');
    }
    if (score == 0) continue;
    if (seed.releaseYear != null && t.releaseYear != null && (seed.releaseYear! - t.releaseYear!).abs() <= 3) {
      score += 0.5;
    }
    score += t.isFavorite ? 1 : 0;
    score += (t.playCount > 0 ? 0.5 : 0);
    results.add(Similar(t, score, reasons));
  }
  results.sort((a, b) => b.score.compareTo(a.score));
  return results.take(limit).toList();
}

/// Best of [artist]: only for artists with enough songs to be meaningful.
class ArtistCollection {
  const ArtistCollection({required this.artistKey, required this.name, required this.tracks, required this.plays});

  final String artistKey;
  final String name;
  final List<Track> tracks;
  final int plays;

  String? get coverKey => tracks.map((t) => t.artworkKey).whereType<String>().firstOrNull;
}

const minArtistSongs = 4;

List<ArtistCollection> bestOfArtists(List<Track> tracks, {int limit = 10}) {
  final groups = <String, List<Track>>{};
  final names = <String, String>{};
  for (final t in tracks) {
    for (final name in splitArtists(t.artist)) {
      final key = normalizeKey(name);
      groups.putIfAbsent(key, () => []).add(t);
      names.putIfAbsent(key, () => name);
    }
  }
  final result = <ArtistCollection>[];
  groups.forEach((key, list) {
    if (list.length < minArtistSongs) return;
    list.sort((a, b) => _affinity(b).compareTo(_affinity(a)));
    result.add(
      ArtistCollection(artistKey: key, name: names[key]!, tracks: list, plays: list.fold(0, (s, t) => s + t.playCount)),
    );
  });
  result.sort((a, b) {
    final c = b.plays.compareTo(a.plays);
    return c != 0 ? c : b.tracks.length.compareTo(a.tracks.length);
  });
  return result.take(limit).toList();
}

/// Continue Listening: tracks with a saved position worth resuming.
List<Track> continueListening(List<Track> tracks, {required DateTime now, int limit = 15}) {
  final cutoff = now.subtract(const Duration(days: 30));
  final list = tracks.where((t) {
    final pos = t.lastPositionMs;
    final dur = t.durationMs;
    if (pos == null || dur == null || t.lastPlayedAt == null) return false;
    if (t.lastPlayedAt!.isBefore(cutoff)) return false;
    return pos >= ListeningRules.resumeMinMs && pos <= dur - ListeningRules.resumeTailMs;
  }).toList()..sort((a, b) => b.lastPlayedAt!.compareTo(a.lastPlayedAt!));
  return list.take(limit).toList();
}

/// Mood membership: explicit user choices win; otherwise transparent genre
/// hints suggest tracks. [explicit] maps trackId to included/excluded.
List<Track> moodTracks(Mood mood, List<Track> tracks, Map<String, bool> explicit) {
  final result = <Track>[];
  for (final t in tracks) {
    final choice = explicit[t.id];
    if (choice == false) continue;
    if (choice == true) {
      result.add(t);
      continue;
    }
    final genre = normalizeKey(t.genre);
    if (genre.isEmpty) continue;
    if (mood.genreHints.any((hint) => genre.contains(hint))) result.add(t);
  }
  result.sort((a, b) => _affinity(b).compareTo(_affinity(a)));
  return result;
}
