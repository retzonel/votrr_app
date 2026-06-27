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

final appRouterProvider = Provider<GoRouter>((ref) {
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

      if (!isAuthenticated && !isOnAuthFlow) {
        return AppRoutes.login;
      }

      if (isAuthenticated &&
          (location == AppRoutes.login || location == AppRoutes.register)) {
        return AppRoutes.vote;
      }

      return null;
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

class _AuthStateNotifier extends ChangeNotifier {
  _AuthStateNotifier(Ref ref) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (previous.runtimeType != next.runtimeType) {
        notifyListeners();
      }
    });
  }
}
