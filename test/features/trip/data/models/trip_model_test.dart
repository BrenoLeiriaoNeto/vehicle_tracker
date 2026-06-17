import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_tracker/src/features/trip/trip_data_exports.dart';
import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

void main() {
  group('TripModel - Serialização e Mapeamento', () {
    final tMap = {
      'id': 'trip_123',
      'userId': 'user_01',
      'vehicleId': 'car_99',
      'vehicleName': 'Uno com Escada',
      'origin': 'Sorocaba',
      'destination': 'Epitácio',
      'totalDistance': 300.0,
      'currentKm': 0.0,
      'status': 'pending',
      'vehicleState': 'parked',
      'startedAt': null,
      'completedAt': null,
    };

    test('Deve retornar um TripModel válido a partir de um Map', () {
      final result = TripModel.fromMap(tMap);

      expect(result.id, 'trip_123');
      expect(result.status, TripStatus.pending);
    });

    test(
      'Deve retornar um Map contendo os dados corretos a partir do Model',
      () {
        final model = TripModel(
          id: 'trip_123',
          userId: 'user_01',
          vehicleId: 'car_99',
          vehicleName: 'Uno com Escada',
          origin: 'Sorocaba',
          destination: 'Epitácio',
          totalDistance: 300.0,
          currentKm: 0.0,
          status: TripStatus.pending,
          vehicleState: TripVehicleState.parked,
        );

        final result = model.toMap();

        expect(result, tMap);
      },
    );
  });
}
