import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';

class MockIVehicleRepository extends Mock implements IVehicleRepository {}

void main() {
  late MockIVehicleRepository repository;

  setUp(() {
    repository = MockIVehicleRepository();
  });

  group('GetBrandsUseCase', () {
    test('deve retornar a lista de marcas do repositório', () async {
      final usecase = GetBrandsUseCase(repository);
      final brands = const [FipeItem(codigo: '1', nome: 'Fiat')];

      when(() => repository.getBrands()).thenAnswer((_) async => brands);

      final result = await usecase.call();

      expect(result, brands);
    });
  });

  group('GetModelsUseCase', () {
    test('deve retornar a lista de modelos para a marca informada', () async {
      final usecase = GetModelsUseCase(repository);
      final models = const [FipeItem(codigo: '2', nome: 'Uno')];

      when(() => repository.getModels('1')).thenAnswer((_) async => models);

      final result = await usecase.call('1');

      expect(result, models);
    });
  });

  group('GetYearsUseCase', () {
    test(
      'deve retornar a lista de anos para marca e modelo informados',
      () async {
        final usecase = GetYearsUseCase(repository);
        final years = const [FipeItem(codigo: '2020', nome: '2020')];

        when(
          () => repository.getYears('1', '2'),
        ).thenAnswer((_) async => years);

        final result = await usecase.call('1', '2');

        expect(result, years);
      },
    );
  });

  group('SaveVehicleUseCase', () {
    test('deve delegar a persistência do veículo ao repositório', () async {
      final usecase = SaveVehicleUseCase(repository);
      const vehicle = Vehicle(
        plate: 'ABC1234',
        brand: 'Fiat',
        model: 'Uno',
        year: '2010',
        currentKm: 100.0,
      );

      when(() => repository.saveVehicle(vehicle)).thenAnswer((_) async {});

      await usecase.call(vehicle);

      verify(() => repository.saveVehicle(vehicle)).called(1);
    });
  });

  group('GetMyGarageUsecase', () {
    test('deve obter a lista de veículos do repositório', () async {
      final usecase = GetMyGarageUsecase(repository);
      final vehicles = const [
        Vehicle(
          plate: 'ABC1234',
          brand: 'Fiat',
          model: 'Uno',
          year: '2010',
          currentKm: 100.0,
        ),
      ];

      when(() => repository.getMyGarage()).thenAnswer((_) async => vehicles);

      final result = await usecase.call();

      expect(result, vehicles);
    });
  });
}
