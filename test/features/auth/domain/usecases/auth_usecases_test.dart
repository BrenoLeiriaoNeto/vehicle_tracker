import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vehicle_tracker/src/features/auth/auth_domain_exports.dart';

class MockIAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockIAuthRepository repository;

  setUp(() {
    repository = MockIAuthRepository();
  });

  group('LoginWithEmailPasswordUsecase', () {
    test(
      'deve delegar a chamada ao repositório e retornar o usuário',
      () async {
        final usecase = LoginWithEmailPasswordUsecase(repository);
        const expectedUser = UserEntity(
          id: 'user1',
          email: 'test@example.com',
          name: 'Teste',
          role: 'driver',
        );

        when(
          () => repository.loginWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => expectedUser);

        final result = await usecase.call(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(result, expectedUser);
        verify(
          () => repository.loginWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).called(1);
      },
    );
  });

  group('SignupWithEmailPassword', () {
    test('deve delegar a criação de usuário ao repositório', () async {
      final usecase = SignupWithEmailPassword(repository);
      const expectedUser = UserEntity(
        id: 'user2',
        email: 'new@example.com',
        name: 'Novo Usuário',
        role: 'driver',
      );

      when(
        () => repository.signUpWithEmailAndPassword(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => expectedUser);

      final result = await usecase.call(
        email: 'new@example.com',
        password: 'newpassword',
        name: 'Novo Usuário',
      );

      expect(result, expectedUser);
      verify(
        () => repository.signUpWithEmailAndPassword(
          name: 'Novo Usuário',
          email: 'new@example.com',
          password: 'newpassword',
        ),
      ).called(1);
    });
  });

  group('LogoutUsecase', () {
    test('deve chamar logout no repositório', () async {
      final usecase = LogoutUsecase(repository);

      when(() => repository.logout()).thenAnswer((_) async {});

      await usecase.call();

      verify(() => repository.logout()).called(1);
    });
  });
}
