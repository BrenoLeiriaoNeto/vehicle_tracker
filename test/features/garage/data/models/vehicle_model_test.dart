import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_tracker/src/features/garage/garage_data_exports.dart';

void main() {
  group('VehicleModel', () {
    test('fromMap deve mapear corretamente para o modelo', () {
      final json = {
        'plate': 'ABC1234',
        'brand': 'Fiat',
        'model': 'Uno',
        'year': '2010',
        'currentKm': 110000,
        'status': 'available',
      };

      final model = VehicleModel.fromMap(json);

      expect(model.plate, 'ABC1234');
      expect(model.brand, 'Fiat');
      expect(model.model, 'Uno');
      expect(model.year, '2010');
      expect(model.currentKm, 110000.0);
      expect(model.status, 'available');
    });

    test(
      'toMap deve converter o modelo para um mapa com os campos corretos',
      () {
        final model = VehicleModel(
          plate: 'ABC1234',
          brand: 'Fiat',
          model: 'Uno',
          year: '2010',
          currentKm: 110000.0,
          status: 'available',
        );

        expect(model.toMap(), {
          'plate': 'ABC1234',
          'brand': 'Fiat',
          'model': 'Uno',
          'year': '2010',
          'currentKm': 110000.0,
          'status': 'available',
        });
      },
    );
  });
}
