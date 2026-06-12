import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';

void main() {
  group('Vehicle', () {
    test('deve criar um Vehicle com os valores corretos', () {
      const vehicle = Vehicle(
        plate: 'ABC1234',
        brand: 'Fiat',
        model: 'Uno',
        year: '2010',
        currentKm: 75000.5,
        status: 'available',
      );

      expect(vehicle.plate, 'ABC1234');
      expect(vehicle.brand, 'Fiat');
      expect(vehicle.model, 'Uno');
      expect(vehicle.year, '2010');
      expect(vehicle.currentKm, 75000.5);
      expect(vehicle.status, 'available');
    });
  });
}
