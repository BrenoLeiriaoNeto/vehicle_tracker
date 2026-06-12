import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';
import 'package:vehicle_tracker/src/features/garage/presentation/controllers/add_vechile_controller.dart';

class MockGetBrandsUseCase extends Mock implements GetBrandsUseCase {}

class MockGetModelsUseCase extends Mock implements GetModelsUseCase {}

class MockGetYearsUseCase extends Mock implements GetYearsUseCase {}

class MockSaveVehicleUseCase extends Mock implements SaveVehicleUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const Vehicle(
        plate: 'ABC1234',
        brand: 'Fiat',
        model: 'Uno',
        year: '2010',
        currentKm: 0.0,
      ),
    );
  });

  late MockGetBrandsUseCase getBrandsUseCase;
  late MockGetModelsUseCase getModelsUseCase;
  late MockGetYearsUseCase getYearsUseCase;
  late MockSaveVehicleUseCase saveVehicleUseCase;
  late AddVechileController controller;

  setUp(() {
    getBrandsUseCase = MockGetBrandsUseCase();
    getModelsUseCase = MockGetModelsUseCase();
    getYearsUseCase = MockGetYearsUseCase();
    saveVehicleUseCase = MockSaveVehicleUseCase();
    controller = AddVechileController(
      getBrandsUseCase,
      getModelsUseCase,
      getYearsUseCase,
      saveVehicleUseCase,
    );
  });

  group('AddVechileController', () {
    test('loadBrands deve carregar marcas e atualizar estado', () async {
      final brands = const [FipeItem(codigo: '1', nome: 'Fiat')];
      when(() => getBrandsUseCase()).thenAnswer((_) async => brands);

      await controller.loadBrands();

      expect(controller.state.status, AddVehicleStatus.success);
      expect(controller.state.brands, brands);
    });

    test('selectBrand deve configurar marca e carregar modelos', () async {
      final brand = const FipeItem(codigo: '1', nome: 'Fiat');
      final models = const [FipeItem(codigo: '2', nome: 'Uno')];
      when(() => getModelsUseCase('1')).thenAnswer((_) async => models);

      await controller.selectBrand(brand);

      expect(controller.state.selectedBrand, brand);
      expect(controller.state.models, models);
      expect(controller.state.status, AddVehicleStatus.initial);
    });

    test(
      'selectModel deve carregar anos quando a marca estiver selecionada',
      () async {
        final brand = const FipeItem(codigo: '1', nome: 'Fiat');
        controller.set(controller.state.copyWith(selectedBrand: brand));
        final model = const FipeItem(codigo: '2', nome: 'Uno');
        final years = const [FipeItem(codigo: '2020', nome: '2020')];
        when(() => getYearsUseCase('1', '2')).thenAnswer((_) async => years);

        await controller.selectModel(model);

        expect(controller.state.selectedModel, model);
        expect(controller.state.years, years);
        expect(controller.state.status, AddVehicleStatus.initial);
      },
    );

    test('selectYear deve selecionar o ano', () {
      final year = const FipeItem(codigo: '2020', nome: '2020');
      controller.selectYear(year);

      expect(controller.state.selectedYear, year);
    });

    test(
      'submitVehicle deve falhar quando dados obrigatórios estiverem vazios',
      () async {
        final result = await controller.submitVehicle(plate: '', currentKm: 0);

        expect(result, isFalse);
        expect(controller.state.status, AddVehicleStatus.error);
        expect(
          controller.state.errorMessage,
          'Preencha todos os dados obrigatórios!',
        );
      },
    );

    test(
      'submitVehicle deve salvar o veículo quando todos os dados estiverem corretos',
      () async {
        final brand = const FipeItem(codigo: '1', nome: 'Fiat');
        final model = const FipeItem(codigo: '2', nome: 'Uno');
        final year = const FipeItem(codigo: '2020', nome: '2020');
        controller.set(
          controller.state.copyWith(
            selectedBrand: brand,
            selectedModel: model,
            selectedYear: year,
          ),
        );
        when(() => saveVehicleUseCase(any())).thenAnswer((_) async {});

        final result = await controller.submitVehicle(
          plate: 'abc1234',
          currentKm: 500.0,
        );

        expect(result, isTrue);
        expect(controller.state.status, AddVehicleStatus.success);
        verify(() => saveVehicleUseCase(any())).called(1);
      },
    );
  });
}
