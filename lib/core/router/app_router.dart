import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../router/app_routes.dart';
import '../../features/auth/data/auth_notifier.dart';
import '../../features/auth/domain/auth_state.dart';
import '../../features/auth/presentation/biometric_gate_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/shell/presentation/main_shell.dart';
import '../../features/vote/presentation/vote_page.dart';
import '../../features/feed/presentation/feed_page.dart';
import '../../features/polling/presentation/polling_page.dart';
import '../../features/settings/presentation/settings_page.dart';

// A provider that exposes the router to the whole app.
// It takes a ref so it can watch auth state for redirects.
final appRouterProvider = Provider<GoRouter>((ref) {
  // We use a ValueNotifier as a listenable so go_router
  // re-evaluates the redirect whenever auth state changes.
  final authNotifier = _AuthStateNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutes.biometric,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final location = state.matchedLocation;

      final isAuthenticated = authState is AuthAuthenticated;
      final isOnAuthFlow = location == AppRoutes.login ||
          location == AppRoutes.register ||
          location == AppRoutes.biometric;

      // Not logged in and trying to reach a protected route → login
      if (!isAuthenticated && !isOnAuthFlow) {
        return AppRoutes.login;
      }

      // Already logged in but on login/register → skip to home
      // (biometric gate is exempt — it should always show on launch)
      if (isAuthenticated &&
          (location == AppRoutes.login || location == AppRoutes.register)) {
        return AppRoutes.vote;
      }

      return null; // no redirect needed
    },
    routes: [
      GoRoute(
        path: AppRoutes.biometric,
        builder: (context, state) => const BiometricGatePage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),

      // Shell route — wraps the four tabs with persistent bottom nav
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.vote,
                builder: (context, state) => const VotePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.feed,
                builder: (context, state) => const FeedPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.polling,
                builder: (context, state) => const PollingPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

// go_router needs a Listenable to know when to re-run redirect.
// This bridges Riverpod's state into something go_router understands.
class _AuthStateNotifier extends ChangeNotifier {
  _AuthStateNotifier(Ref ref) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (previous.runtimeType != next.runtimeType) {
        notifyListeners();
      }
    });
  }
}