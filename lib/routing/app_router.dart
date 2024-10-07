import 'package:evergreen_lifechurch_todo/features/authentication/data/firebase_auth_repository.dart';
import 'package:evergreen_lifechurch_todo/features/todos/todos_screen.dart';
import 'package:evergreen_lifechurch_todo/routing/app_startup.dart';
import 'package:evergreen_lifechurch_todo/routing/go_router_refresh_stream.dart';
import 'package:evergreen_lifechurch_todo/routing/scaffold_with_nested_navigation.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _todosNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'todos');
final _accountNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'account');
final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

enum AppRoute {
  startup('/startup'),
  signIn('/signIn'),
  todos('/todos'),
  profile('/profile'),
  settings('/settings');

  const AppRoute(this.path);

  final String path;

}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  // rebuild GoRouter when app startup state changes
  final appStartupState = ref.watch(appStartupProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: AppRoute.signIn.path,
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // If the app is still initializing, show the /startup route
      if (appStartupState.isLoading || appStartupState.hasError) {
        return AppRoute.startup.path;
      }
      final path = state.uri.path;
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        if (path.startsWith(AppRoute.startup.path) ||
            path.startsWith(AppRoute.signIn.path)) {
          return AppRoute.todos.path;
        }
      } else {
        if (path.startsWith(AppRoute.startup.path) ||
            path.startsWith(AppRoute.todos.path) ||
            // also comments ||
            path.startsWith(AppRoute.profile.path) ||
            path.startsWith(AppRoute.settings.path)) {
          return AppRoute.signIn.path;
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: AppRoute.startup.path,
        pageBuilder: (context, state) => NoTransitionPage(
          child: AppStartupWidget(
            // * This is just a placeholder
            // * The loaded route will be managed by GoRouter on state change
            onLoaded: (_) => const SizedBox.shrink(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoute.signIn.path,
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) => NoTransitionPage(
          child: SignInScreen(providers: [EmailAuthProvider()],),
        ),
      ),
      // Stateful navigation based on:
      // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
      StatefulShellRoute.indexedStack(
        pageBuilder: (_, __, navigationShell) => NoTransitionPage(
          child: ScaffoldWithNestedNavigation(navigationShell: navigationShell),
        ),
        branches: [
          StatefulShellBranch(navigatorKey: _todosNavigatorKey,
            routes: [
              GoRoute(path: AppRoute.todos.path, name: AppRoute.todos.name,
                pageBuilder: (_, __) => const NoTransitionPage(
                  child: TodosScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(navigatorKey: _settingsNavigatorKey,
            routes: [
              GoRoute(path: AppRoute.settings.path, name: AppRoute.settings.name,
                pageBuilder: (_, __) => const NoTransitionPage(
                  child: Scaffold(body:Center(child: Text('Settings'),)),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _accountNavigatorKey,
            routes: [
              // Google play store policy requires an account to be deletable
              // by the user https://support.google.com/googleplay/android-developer/answer/13327111?hl=en
              // which is provided by the UI
              GoRoute(
                path: AppRoute.profile.path,
                name: AppRoute.profile.name,
                pageBuilder: (_, __) => const NoTransitionPage(
                  child: ProfileScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
