import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

void main() {
  group('Trip Entitiy - Testes Unitários de Getters', () {
    test('Deve calcular a distância restante corretamente', () {
      const trip = Trip(
        id: '1',
        userId: 'user_123',
        vehicleId: 'abc-1234',
        vehicleName: 'Fusca',
        origin: 'São Paulo',
        destination: 'Campinas',
        totalDistance: 100.0,
        currentKm: 40.0, // Rodou 40km de 100km
        status: TripStatus.inProgress,
        vehicleState: TripVehicleState.moving,
      );

      expect(trip.remainingDistance, equals(60.0));
    });

    test('Deve calcular o progresso em double entre 0.0 e 1.0', () {
      const trip = Trip(
        id: '1',
        userId: 'user_123',
        vehicleId: 'abc-1234',
        vehicleName: 'Fusca',
        origin: 'São Paulo',
        destination: 'Campinas',
        totalDistance: 100.0,
        currentKm: 75.0,
        status: TripStatus.inProgress,
        vehicleState: TripVehicleState.moving,
      );

      expect(trip.progress, equals(0.75));
      expect(trip.progressPercentage, equals('75'));
    });

    test(
      'Não deve estourar o progresso se o km atual passar do total de forma anômala',
      () {
        const trip = Trip(
          id: '1',
          userId: 'user_123',
          vehicleId: 'abc-1234',
          vehicleName: 'Fusca',
          origin: 'São Paulo',
          destination: 'Campinas',
          totalDistance: 100.0,
          currentKm: 120.0,
          status: TripStatus.inProgress,
          vehicleState: TripVehicleState.moving,
        );

        expect(trip.progress, equals(1.0));
        expect(trip.remainingDistance, equals(0.0));
        expect(trip.progressPercentage, equals('100'));
      },
    );
  });
}
