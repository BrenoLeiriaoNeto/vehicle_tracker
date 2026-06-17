import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';
import 'package:vehicle_tracker/src/features/garage/presentation/controllers/garage_controller.dart';

class MockGetMyGarageUsecase extends Mock implements GetMyGarageUsecase {}

void main() {
  late MockGetMyGarageUsecase getMyGarageUsecase;
  late GarageController controller;

  setUp(() {
    getMyGarageUsecase = MockGetMyGarageUsecase();
    controller = GarageController(getMyGarageUsecase);
  });

  group('GarageController', () {
    test(
      'fetchVehicles deve buscar os veículos e atualizar o estado',
      () async {
        final vehicles = const [
          Vehicle(
            plate: 'ABC1234',
            brand: 'Fiat',
            model: 'Uno',
            year: '2010',
            currentKm: 100.0,
          ),
        ];

        when(() => getMyGarageUsecase()).thenAnswer((_) async => vehicles);

        await controller.fetchVehicles();

        expect(controller.state.status, GarageStatus.success);
        expect(controller.state.vehicles, vehicles);
        expect(controller.state.filteredVehicles, vehicles);
      },
    );

    test('filterVehicles deve filtrar por modelo, marca e placa', () {
      final vehicles = const [
        Vehicle(
          plate: 'ABC1234',
          brand: 'Fiat',
          model: 'Uno',
          year: '2010',
          currentKm: 100.0,
        ),
        Vehicle(
          plate: 'DEF5678',
          brand: 'Ford',
          model: 'Ka',
          year: '2014',
          currentKm: 60000.0,
        ),
      ];

      controller.set(
        controller.state.copyWith(
          vehicles: vehicles,
          filteredVehicles: vehicles,
        ),
      );

      controller.filterVehicles('fiat');
      expect(controller.state.filteredVehicles.length, 1);
      expect(controller.state.filteredVehicles.first.brand, 'Fiat');

      controller.filterVehicles('def');
      expect(controller.state.filteredVehicles.length, 1);
      expect(controller.state.filteredVehicles.first.plate, 'DEF5678');

      controller.filterVehicles('');
      expect(controller.state.filteredVehicles, vehicles);
    });
  });
}
