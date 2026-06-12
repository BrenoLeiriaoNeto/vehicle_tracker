import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';
import 'package:vehicle_tracker/src/features/garage/presentation/controllers/garage_controller.dart';
import 'package:vehicle_tracker/src/features/garage/presentation/pages/garage_page.dart';

class MockGetMyGarageUsecase extends Mock implements GetMyGarageUsecase {}

void main() {
  late MockGetMyGarageUsecase getMyGarageUsecase;
  late GarageController controller;

  setUp(() async {
    await sl.reset();

    getMyGarageUsecase = MockGetMyGarageUsecase();
    controller = GarageController(getMyGarageUsecase);

    when(() => getMyGarageUsecase()).thenAnswer(
      (_) async => const [
        Vehicle(
          plate: 'ABC1234',
          brand: 'Fiat',
          model: 'Uno',
          year: '2010',
          currentKm: 100.0,
        ),
      ],
    );

    sl.registerSingleton<GarageController>(controller);
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('GaragePage displays saved vehicle list after fetch', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: GaragePage()));
    await tester.pumpAndSettle();

    expect(find.text('Minha Garagem'), findsOneWidget);
    expect(find.text('ABC1234'), findsOneWidget);
    expect(find.text('Uno'), findsOneWidget);
    expect(find.textContaining('Fiat'), findsOneWidget);
  });
}
