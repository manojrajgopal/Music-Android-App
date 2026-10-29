import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/backup/backup_screen.dart';
import '../features/home/home_screen.dart';
import '../features/import_music/url_import_screen.dart';
import '../features/library/collection_screen.dart';
import '../features/library/library_screen.dart';
import '../features/metadata/edit_track_screen.dart';
import '../features/new_music/new_screen.dart';
import '../features/player/player_screen.dart';
import '../features/player/queue_screen.dart';
import '../features/playlists/playlist_screen.dart';
import '../features/search/search_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/shell/app_shell.dart';
import '../features/statistics/replay_screen.dart';
import 'routes.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _chromeKey = GlobalKey<NavigatorState>(debugLabel: 'chrome');

/// Navigation structure:
/// * An outer shell keeps the floating navigation and mini-player visible.
/// * Inside it, an indexed shell preserves each tab's own stack.
/// * Detail pages (playlists, collections) open inside the outer shell.
/// * The player and full-screen tools cover everything on the root navigator.
GoRouter buildRouter() => GoRouter(
  navigatorKey: _rootKey,
  initialLocation: Routes.home,
  routes: [
    ShellRoute(
      navigatorKey: _chromeKey,
      builder: (context, state, child) => AppShell(location: state.uri.path, child: child),
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) {
            TabShell.current = shell;
            return shell;
          },
          branches: [
            StatefulShellBranch(
              routes: [GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen())],
            ),
            StatefulShellBranch(
              routes: [GoRoute(path: Routes.newMusic, builder: (_, _) => const NewScreen())],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: Routes.library,
                  builder: (_, _) => const LibraryScreen(),
                  routes: [
                    GoRoute(
                      path: ':category',
                      builder: (_, state) {
                        final name = state.pathParameters['category'];
                        final category =
                            LibraryCategory.values.where((c) => c.name == name).firstOrNull ?? LibraryCategory.songs;
                        return LibraryCategoryScreen(category: category);
                      },
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [GoRoute(path: Routes.search, builder: (_, _) => const SearchScreen())],
            ),
          ],
        ),
        GoRoute(
          path: '/playlist/:id',
          builder: (_, state) => PlaylistScreen(playlistId: int.tryParse(state.pathParameters['id'] ?? '') ?? -1),
        ),
        GoRoute(
          path: '/collection/:type/:key',
          builder: (_, state) {
            final type =
                CollectionType.values.where((t) => t.name == state.pathParameters['type']).firstOrNull ??
                CollectionType.generated;
            return CollectionScreen(type: type, collectionKey: state.pathParameters['key'] ?? '');
          },
        ),
        GoRoute(
          path: '/track/:id/similar',
          builder: (_, state) => SimilarScreen(trackId: state.pathParameters['id']!),
        ),
      ],
    ),
    GoRoute(
      path: Routes.player,
      parentNavigatorKey: _rootKey,
      pageBuilder: (_, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const PlayerScreen(),
        transitionDuration: const Duration(milliseconds: 380),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, _, child) {
          if (MediaQuery.maybeDisableAnimationsOf(context) == true) return child;
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(curved),
            child: child,
          );
        },
      ),
    ),
    GoRoute(path: Routes.queue, parentNavigatorKey: _rootKey, builder: (_, _) => const QueueScreen()),
    GoRoute(path: Routes.settings, parentNavigatorKey: _rootKey, builder: (_, _) => const SettingsScreen()),
    GoRoute(path: Routes.customizeHome, parentNavigatorKey: _rootKey, builder: (_, _) => const CustomizeHomeScreen()),
    GoRoute(path: Routes.replay, parentNavigatorKey: _rootKey, builder: (_, _) => const ReplayScreen()),
    GoRoute(path: Routes.urlImport, parentNavigatorKey: _rootKey, builder: (_, _) => const UrlImportScreen()),
    GoRoute(path: Routes.backup, parentNavigatorKey: _rootKey, builder: (_, _) => const BackupScreen()),
    GoRoute(
      path: '/track/:id/edit',
      parentNavigatorKey: _rootKey,
      builder: (_, state) => EditTrackScreen(trackId: state.pathParameters['id']!),
    ),
  ],
);
