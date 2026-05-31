import 'package:go_router/go_router.dart';
import 'package:vehicle_tracker/src/core/core_exports.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/core/widgets/scaffold_with_bottom_nav_bar.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/pages/auth_screen.dart';
import 'package:vehicle_tracker/src/features/dashboard/presentation/pages/dashboard_page.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: dashboard,
    refreshListenable: sl<AuthController>(),

    redirect: (context, state) {
      final authController = sl<AuthController>();
      final authState = authController.state;

      final isLoggingIn = state.matchedLocation == auth;

      if (authState.status != .authenticated) {
        return isLoggingIn ? null : auth;
      }

      if (isLoggingIn) {
        return dashboard;
      }

      return null;
    },

    routes: [
      GoRoute(path: auth, builder: (context, state) => const AuthScreen()),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithBottomNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: dashboard,
                builder: (context, state) => DashboardPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
