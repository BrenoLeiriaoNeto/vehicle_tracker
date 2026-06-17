import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vehicle_tracker/src/features/auth/auth_domain_exports.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/auth_controller.dart';

class MockLoginWithEmailPasswordUsecase extends Mock
    implements LoginWithEmailPasswordUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

void main() {
  late MockLoginWithEmailPasswordUsecase loginUsecase;
  late MockLogoutUsecase logoutUsecase;
  late AuthController controller;

  setUp(() {
    loginUsecase = MockLoginWithEmailPasswordUsecase();
    logoutUsecase = MockLogoutUsecase();
    controller = AuthController(loginUsecase, logoutUsecase);
  });

  group('AuthController', () {
    test(
      'login deve atualizar o estado para authenticated quando a chamada for bem sucedida',
      () async {
        const user = UserEntity(
          id: 'user1',
          email: 'test@example.com',
          name: 'Teste',
          role: 'driver',
        );

        when(
          () => loginUsecase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => user);

        await controller.login('test@example.com', 'senha');

        expect(controller.state.status, AuthStatus.authenticated);
        expect(controller.state.user, user);
        expect(controller.state.errorMessage, isNull);
      },
    );

    test(
      'setAuthenticatedUser deve atualizar o estado de usuário autenticado',
      () {
        const user = UserEntity(
          id: 'user1',
          email: 'test@example.com',
          name: 'Teste',
          role: 'driver',
        );

        controller.setAuthenticatedUser(user);

        expect(controller.state.status, AuthStatus.authenticated);
        expect(controller.state.user, user);
      },
    );

    test(
      'setUnauthenticatedUser deve atualizar o estado para unauthenticated',
      () {
        controller.setUnauthenticatedUser();

        expect(controller.state.status, AuthStatus.unauthenticated);
        expect(controller.state.user, isNull);
      },
    );

    test(
      'logout deve chamar o usecase e não alterar o estado em caso de sucesso',
      () async {
        when(() => logoutUsecase()).thenAnswer((_) async {});

        await controller.logout();

        verify(() => logoutUsecase()).called(1);
      },
    );
  });
}
