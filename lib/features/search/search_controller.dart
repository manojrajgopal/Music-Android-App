import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/utils/text_normalize.dart';
import '../../data/database/app_database.dart';
import '../../data/database/daos/playlists_dao.dart';
import '../../data/database/daos/tracks_dao.dart';

class SearchResults {
  const SearchResults({
    this.query = '',
    this.songs = const [],
    this.artists = const [],
    this.albums = const [],
    this.playlists = const [],
    this.genres = const [],
    this.loading = false,
  });

  final String query;
  final List<Track> songs;
  final List<TrackGroup> artists;
  final List<TrackGroup> albums;
  final List<PlaylistSummary> playlists;
  final List<TrackGroup> genres;
  final bool loading;

  bool get isEmpty => songs.isEmpty && artists.isEmpty && albums.isEmpty && playlists.isEmpty && genres.isEmpty;
}

/// Debounced local search. One query batch runs per pause in typing, and a
/// newer query always supersedes an older in-flight one.
class LibrarySearchController extends Notifier<SearchResults> {
  static const debounce = Duration(milliseconds: 250);

  Timer? _timer;
  int _generation = 0;
  String _raw = '';
  TrackFilter _filter = const TrackFilter();

  TrackFilter get filter => _filter;

  @override
  SearchResults build() {
    ref.onDispose(() => _timer?.cancel());
    return const SearchResults();
  }

  void setQuery(String raw) {
    _raw = raw;
    _timer?.cancel();
    if (normalizeKey(raw).isEmpty) {
      _generation++;
      state = const SearchResults();
      return;
    }
    state = SearchResults(
      query: raw,
      songs: state.songs,
      artists: state.artists,
      albums: state.albums,
      playlists: state.playlists,
      genres: state.genres,
      loading: true,
    );
    _timer = Timer(debounce, _run);
  }

  void setFilter(TrackFilter filter) {
    _filter = filter;
    if (normalizeKey(_raw).isNotEmpty) _run();
  }

  /// Runs immediately (e.g. on submit or voice input).
  Future<void> runNow(String raw) {
    _raw = raw;
    _timer?.cancel();
    return _run();
  }

  Future<void> _run() async {
    final q = normalizeKey(_raw);
    if (q.isEmpty) return;
    final gen = ++_generation;
    final db = ref.read(databaseProvider);
    final dao = db.tracksDao;
    final results = await Future.wait([
      dao.searchTracks(q, filter: _filter),
      dao.searchArtists(q),
      dao.searchAlbums(q),
      db.playlistsDao.allPlaylists(),
      dao.searchGenres(q),
    ]);
    if (gen != _generation) return;
    final playlists = (results[3] as List<Playlist>).where((p) => normalizeKey(p.name).contains(q)).toList();
    state = SearchResults(
      query: _raw,
      songs: results[0] as List<Track>,
      artists: results[1] as List<TrackGroup>,
      albums: results[2] as List<TrackGroup>,
      playlists: [for (final p in playlists) PlaylistSummary(playlist: p, trackCount: 0)],
      genres: results[4] as List<TrackGroup>,
    );
  }

  Future<void> remember() async {
    final cleaned = cleanDisplay(_raw);
    if (cleaned != null) await ref.read(databaseProvider).miscDao.addSearch(cleaned);
  }
}

final searchControllerProvider = NotifierProvider<LibrarySearchController, SearchResults>(LibrarySearchController.new);

final recentSearchesProvider = StreamProvider<List<SearchEntry>>(
  (ref) => ref.watch(databaseProvider).miscDao.watchRecentSearches(),
);
