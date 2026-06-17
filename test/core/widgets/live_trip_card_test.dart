import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';
import 'package:vehicle_tracker/src/features/dashboard/presentation/widgets/live_trip_card.dart';

void main() {
  testWidgets('LiveTripCard displays trip details and progress', (
    tester,
  ) async {
    const trip = Trip(
      id: 'trip1',
      userId: 'user1',
      vehicleId: 'vehicle1',
      vehicleName: 'Caminhão Azul',
      origin: 'São Paulo',
      destination: 'Rio de Janeiro',
      totalDistance: 100.0,
      currentKm: 40.0,
      status: TripStatus.inProgress,
      vehicleState: TripVehicleState.moving,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: LiveTripCard(trip: trip)),
      ),
    );

    expect(find.text('Caminhão Azul'), findsOneWidget);
    expect(find.text('São Paulo -> Rio de Janeiro'), findsOneWidget);
    expect(find.text('40.0 KM'), findsOneWidget);
    expect(find.text('60.0 KM'), findsOneWidget);
    expect(find.text('40%'), findsOneWidget);
  });
}
