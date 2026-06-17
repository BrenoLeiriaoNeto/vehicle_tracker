import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/features/auth/auth_domain_exports.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/signup_controller.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/pages/signup_page.dart';

class MockSignupWithEmailPassword extends Mock
    implements SignupWithEmailPassword {}

class MockLoginWithEmailPasswordUsecase extends Mock
    implements LoginWithEmailPasswordUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

void main() {
  late MockSignupWithEmailPassword signupUsecase;
  late MockLoginWithEmailPasswordUsecase loginUsecase;
  late MockLogoutUsecase logoutUsecase;
  late SignupController signupController;
  late AuthController authController;

  setUp(() async {
    await sl.reset();
    signupUsecase = MockSignupWithEmailPassword();
    loginUsecase = MockLoginWithEmailPasswordUsecase();
    logoutUsecase = MockLogoutUsecase();

    signupController = SignupController(signupUsecase);
    authController = AuthController(loginUsecase, logoutUsecase);

    sl.registerSingleton<AuthController>(authController);
    sl.registerSingleton<SignupController>(signupController);
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets(
    'SignupPage shows name, email, password, confirm password fields',
    (tester) async {
      await tester.pumpWidget(MaterialApp(home: SignupPage(onFlip: () {})));

      expect(find.text('Criar Conta'), findsOneWidget);
      expect(find.text('Nome'), findsOneWidget);
      expect(find.text('E-mail'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
      expect(find.text('Confirmar Senha'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Cadastrar'), findsOneWidget);
    },
  );

  testWidgets('SignupPage calls onFlip when Faça o login button is tapped', (
    tester,
  ) async {
    var flipped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: SignupPage(
          onFlip: () {
            flipped = true;
          },
        ),
      ),
    );

    await tester.tap(find.text('Faça o login'));

    expect(flipped, isTrue);
  });
}
