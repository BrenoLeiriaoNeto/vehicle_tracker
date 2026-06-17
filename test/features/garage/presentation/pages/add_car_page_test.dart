import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';
import 'package:vehicle_tracker/src/features/garage/presentation/controllers/add_vechile_controller.dart';
import 'package:vehicle_tracker/src/features/garage/presentation/pages/add_car_page.dart';

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
        currentKm: 100.0,
      ),
    );
  });

  late MockGetBrandsUseCase getBrandsUseCase;
  late MockGetModelsUseCase getModelsUseCase;
  late MockGetYearsUseCase getYearsUseCase;
  late MockSaveVehicleUseCase saveVehicleUseCase;
  late AddVechileController controller;

  setUp(() async {
    await sl.reset();

    getBrandsUseCase = MockGetBrandsUseCase();
    getModelsUseCase = MockGetModelsUseCase();
    getYearsUseCase = MockGetYearsUseCase();
    saveVehicleUseCase = MockSaveVehicleUseCase();

    when(
      () => getBrandsUseCase(),
    ).thenAnswer((_) async => const [FipeItem(codigo: '1', nome: 'Fiat')]);
    when(
      () => getModelsUseCase('1'),
    ).thenAnswer((_) async => const [FipeItem(codigo: '2', nome: 'Uno')]);
    when(
      () => getYearsUseCase('1', '2'),
    ).thenAnswer((_) async => const [FipeItem(codigo: '2010', nome: '2010')]);
    when(() => saveVehicleUseCase(any())).thenAnswer((_) async {});

    controller = AddVechileController(
      getBrandsUseCase,
      getModelsUseCase,
      getYearsUseCase,
      saveVehicleUseCase,
    );

    sl.registerSingleton<AddVechileController>(controller);
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('AddCarPage renders form and validates required fields', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AddCarPage()));
    await tester.pumpAndSettle();

    expect(find.text('Adicionar Veículo'), findsOneWidget);
    expect(find.text('Selecione a marca'), findsOneWidget);
    expect(find.text('Salvar veículo'), findsOneWidget);

    await tester.tap(find.text('Salvar veículo'));
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsNWidgets(2));
  });
}
