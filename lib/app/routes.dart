/// Route paths, kept in one place so links never drift from the router.
abstract final class Routes {
  static const home = '/home';
  static const newMusic = '/new';
  static const library = '/library';
  static const search = '/search';
  static const player = '/player';
  static const queue = '/queue';
  static const settings = '/settings';
  static const customizeHome = '/settings/home';
  static const replay = '/replay';
  static const urlImport = '/import/url';
  static const backup = '/backup';

  static String playlist(int id) => '/playlist/$id';
  static String collection(CollectionType type, String key) => '/collection/${type.name}/${Uri.encodeComponent(key)}';
  static String editTrack(String id) => '/track/$id/edit';
  static String similar(String id) => '/track/$id/similar';
}

/// Kinds of track collections shown by the shared collection screen.
enum CollectionType { artist, album, genre, composer, language, year, mood, tag, favorites, generated, tv }
