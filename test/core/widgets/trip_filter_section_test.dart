import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_tracker/src/features/trip/presentation/widgets/trip_filter_section.dart';
import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

void main() {
  testWidgets('TripFilterSection displays all chip labels', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TripFilterSection(
            selectedFilter: null,
            onFilterChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Todas'), findsOneWidget);
    expect(find.text('Em Progresso'), findsOneWidget);
    expect(find.text('Concluídas'), findsOneWidget);
    expect(find.text('Manutenção'), findsOneWidget);
  });

  testWidgets('TripFilterSection calls onFilterChanged when chip is tapped', (
    tester,
  ) async {
    TripStatus? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TripFilterSection(
            selectedFilter: TripStatus.inProgress,
            onFilterChanged: (filter) {
              selected = filter;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Concluídas'));
    await tester.pumpAndSettle();

    expect(selected, TripStatus.completed);
  });
}
