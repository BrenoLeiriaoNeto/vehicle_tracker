import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';
import 'package:vehicle_tracker/src/features/trip/presentation/widgets/trip_history_card.dart';

void main() {
  testWidgets('TripHistoryCard shows destination, distance, and status badge', (
    tester,
  ) async {
    const trip = Trip(
      id: 'trip1',
      userId: 'user1',
      vehicleId: 'vehicle1',
      vehicleName: 'Caminhão Azul',
      origin: 'São Paulo',
      destination: 'Belo Horizonte',
      totalDistance: 200.0,
      currentKm: 100.0,
      status: TripStatus.completed,
      vehicleState: TripVehicleState.parked,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: TripHistoryCard(trip: trip)),
      ),
    );

    expect(find.text('Caminhão Azul'), findsOneWidget);
    expect(find.text('São Paulo -> Belo Horizonte'), findsOneWidget);
    expect(find.text('Distância: 200.0 KM'), findsOneWidget);
    expect(find.text('Concluída'), findsOneWidget);
  });
}
