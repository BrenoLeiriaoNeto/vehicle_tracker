import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/features/auth/auth_domain_exports.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/pages/login_page.dart';

class MockLoginWithEmailPasswordUsecase extends Mock
    implements LoginWithEmailPasswordUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

void main() {
  late MockLoginWithEmailPasswordUsecase loginUsecase;
  late MockLogoutUsecase logoutUsecase;
  late AuthController authController;

  setUp(() async {
    await sl.reset();
    loginUsecase = MockLoginWithEmailPasswordUsecase();
    logoutUsecase = MockLogoutUsecase();
    authController = AuthController(loginUsecase, logoutUsecase);
    sl.registerSingleton<AuthController>(authController);
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('LoginPage shows email and password fields and login button', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: LoginPage(onFlip: () {})));

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Entrar'), findsOneWidget);
  });

  testWidgets('LoginPage calls onFlip when Cadastre-se button is tapped', (
    tester,
  ) async {
    var flipped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(
          onFlip: () {
            flipped = true;
          },
        ),
      ),
    );

    await tester.tap(find.text('Cadastre-se'));

    expect(flipped, isTrue);
  });
}
