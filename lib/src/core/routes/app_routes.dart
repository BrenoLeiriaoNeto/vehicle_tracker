import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/core/core_exports.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/core/widgets/scaffold_with_bottom_nav_bar.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/pages/auth_screen.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/pages/logout_page.dart';
import 'package:vehicle_tracker/src/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:vehicle_tracker/src/features/garage/presentation/controllers/garage_controller.dart';
import 'package:vehicle_tracker/src/features/garage/presentation/pages/add_car_page.dart';
import 'package:vehicle_tracker/src/features/garage/presentation/pages/garage_page.dart';
import 'package:vehicle_tracker/src/features/profile/presentation/controllers/profile_controller.dart';
import 'package:vehicle_tracker/src/features/profile/presentation/pages/profile_form_page.dart';
import 'package:vehicle_tracker/src/features/profile/presentation/pages/profile_page.dart';
import 'package:vehicle_tracker/src/features/trip/presentation/controllers/trip_controller.dart';
import 'package:vehicle_tracker/src/features/trip/presentation/pages/new_trip_page.dart';
import 'package:vehicle_tracker/src/features/trip/presentation/pages/trips_page.dart';

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

      if (isLoggingIn && authState.status == .authenticated) {
        return dashboard;
      }

      return null;
    },

    routes: [
      GoRoute(path: auth, builder: (context, state) => const AuthScreen()),
      GoRoute(
        path: '/logout',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const LogoutPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return IonProvider(
            create: (_) => sl<TripController>(),
            child: ScaffoldWithBottomNavBar(navigationShell: navigationShell),
          );
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
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: garage,
                builder: (context, state) => IonProvider(
                  create: (_) => sl<GarageController>(),
                  child: const GaragePage(),
                ),
                routes: [
                  GoRoute(
                    path: 'new',
                    pageBuilder: (context, state) {
                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: AddCarPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                position: animation.drive(
                                  Tween<Offset>(
                                    begin: const Offset(1, 0),
                                    end: .zero,
                                  ).chain(
                                    CurveTween(curve: Curves.easeInOutCubic),
                                  ),
                                ),
                                child: child,
                              );
                            },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: trips,
                builder: (context, state) => const TripsPage(),
                routes: [
                  GoRoute(
                    path: 'new',
                    pageBuilder: (context, state) {
                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: NewTripPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                position: animation.drive(
                                  Tween<Offset>(
                                    begin: const Offset(1, 0),
                                    end: .zero,
                                  ).chain(
                                    CurveTween(curve: Curves.easeInOutCubic),
                                  ),
                                ),
                                child: child,
                              );
                            },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              ShellRoute(
                builder: (context, state, child) {
                  return IonProvider(
                    create: (_) => sl<ProfileController>(),
                    child: child,
                  );
                },
                routes: [
                  GoRoute(
                    path: profile,
                    builder: (context, state) => const ProfilePage(),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        pageBuilder: (context, state) {
                          return CustomTransitionPage(
                            key: state.pageKey,
                            child: ProfileFormPage(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return SlideTransition(
                                    position: animation.drive(
                                      Tween<Offset>(
                                        begin: const Offset(1, 0),
                                        end: .zero,
                                      ).chain(
                                        CurveTween(
                                          curve: Curves.easeInOutCubic,
                                        ),
                                      ),
                                    ),
                                    child: child,
                                  );
                                },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
