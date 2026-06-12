import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/features/auth/auth_domain_exports.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:vehicle_tracker/src/features/profile/profile_domain_exports.dart';
import 'package:vehicle_tracker/src/features/profile/presentation/controllers/profile_controller.dart';
import 'package:vehicle_tracker/src/features/profile/presentation/pages/profile_form_page.dart';

class MockGetProfileUsecase extends Mock implements GetProfileUsecase {}

class MockUpdateProfileUsecase extends Mock implements UpdateProfileUsecase {}

class MockDeleteProfileUsecase extends Mock implements DeleteProfileUsecase {}

class MockLoginWithEmailPasswordUsecase extends Mock
    implements LoginWithEmailPasswordUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

class FakeProfile extends Fake implements Profile {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const UserEntity(
        id: 'user123',
        email: 'test@example.com',
        name: 'Test User',
        role: 'driver',
      ),
    );
    registerFallbackValue(FakeProfile());
  });

  late MockGetProfileUsecase getProfileUsecase;
  late MockUpdateProfileUsecase updateProfileUsecase;
  late MockDeleteProfileUsecase deleteProfileUsecase;
  late ProfileController profileController;
  late AuthController authController;

  setUp(() async {
    await sl.reset();

    getProfileUsecase = MockGetProfileUsecase();
    updateProfileUsecase = MockUpdateProfileUsecase();
    deleteProfileUsecase = MockDeleteProfileUsecase();

    profileController = ProfileController(
      getProfileUsecase,
      updateProfileUsecase,
      deleteProfileUsecase,
    );

    authController = AuthController(
      MockLoginWithEmailPasswordUsecase(),
      MockLogoutUsecase(),
    );
    authController.setAuthenticatedUser(
      const UserEntity(
        id: 'user123',
        email: 'test@example.com',
        name: 'Test User',
        role: 'driver',
      ),
    );

    sl.registerSingleton<AuthController>(authController);
    sl.registerSingleton<ProfileController>(profileController);
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('ProfileFormPage validates url and saves profile', (
    tester,
  ) async {
    when(() => getProfileUsecase('user123')).thenAnswer(
      (_) async => Profile(
        avatarUrl: '',
        bio: 'Bio de teste',
        tripsCompleted: 3,
        sumKilometers: 120.0,
        totalVehicles: 2,
        memberSince: DateTime(2020, 1, 1),
      ),
    );
    when(() => updateProfileUsecase(any(), any())).thenAnswer(
      (_) async => Profile(
        avatarUrl: '',
        bio: 'Bio de teste',
        tripsCompleted: 3,
        sumKilometers: 120.0,
        totalVehicles: 2,
        memberSince: DateTime(2020, 1, 1),
      ),
    );

    await tester.pumpWidget(const MaterialApp(home: ProfileFormPage()));
    await tester.pumpAndSettle();

    expect(find.text('Editar Perfil'), findsOneWidget);
    expect(find.text('Salvar Alterações'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).last, 'not-a-url');
    await tester.tap(find.text('Salvar Alterações'));
    await tester.pump();

    expect(find.text('Insira uma URL válida'), findsOneWidget);
  });
}
