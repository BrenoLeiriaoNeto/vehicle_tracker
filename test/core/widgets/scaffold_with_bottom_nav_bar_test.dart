import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vehicle_tracker/src/core/widgets/scaffold_with_bottom_nav_bar.dart';

void main() {
  testWidgets('ScaffoldWithBottomNavBar builds BottomNavigationBar', (
    tester,
  ) async {
    final router = GoRouter(
      routes: [
        StatefulShellRoute.indexedStack(
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const SizedBox.shrink(),
                ),
              ],
            ),
          ],
          builder: (context, state, shell) =>
              ScaffoldWithBottomNavBar(navigationShell: shell),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    await tester.pumpAndSettle();

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.byType(StatefulNavigationShell), findsOneWidget);
  });
}
