import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/features/auth/auth_domain_exports.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:vehicle_tracker/src/features/profile/profile_domain_exports.dart';
import 'package:vehicle_tracker/src/features/profile/presentation/controllers/profile_controller.dart';
import 'package:vehicle_tracker/src/features/profile/presentation/pages/profile_page.dart';
import 'package:vehicle_tracker/src/features/trip/presentation/controllers/trip_controller.dart';
import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class MockGetProfileUsecase extends Mock implements GetProfileUsecase {}

class MockUpdateProfileUsecase extends Mock implements UpdateProfileUsecase {}

class MockDeleteProfileUsecase extends Mock implements DeleteProfileUsecase {}

class MockCreateTripUsecase extends Mock implements CreateTripUsecase {}

class MockUpdateTripUsecase extends Mock implements UpdateTripUsecase {}

class MockWatchTripUsecase extends Mock implements WatchTripUsecase {}

class MockGetTrips extends Mock implements GetTrips {}

class MockGetInProgressTripsUsecase extends Mock
    implements GetInProgressTripsUsecase {}

class MockCompleteTripUsecase extends Mock implements CompleteTripUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

class MockLoginWithEmailPasswordUsecase extends Mock
    implements LoginWithEmailPasswordUsecase {}

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
  });

  late MockGetProfileUsecase getProfileUsecase;
  late MockUpdateProfileUsecase updateProfileUsecase;
  late MockDeleteProfileUsecase deleteProfileUsecase;
  late ProfileController profileController;
  late AuthController authController;
  late TripController tripController;

  setUp(() async {
    await sl.reset();

    getProfileUsecase = MockGetProfileUsecase();
    updateProfileUsecase = MockUpdateProfileUsecase();
    deleteProfileUsecase = MockDeleteProfileUsecase();
    final watchTripUsecase = MockWatchTripUsecase();
    final createTripUsecase = MockCreateTripUsecase();
    final updateTripUsecase = MockUpdateTripUsecase();
    final getTrips = MockGetTrips();
    final getInProgressTripsUsecase = MockGetInProgressTripsUsecase();
    final completeTripUsecase = MockCompleteTripUsecase();
    final logoutUsecase = MockLogoutUsecase();

    profileController = ProfileController(
      getProfileUsecase,
      updateProfileUsecase,
      deleteProfileUsecase,
    );
    authController = AuthController(
      MockLoginWithEmailPasswordUsecase(),
      logoutUsecase,
    );
    authController.setAuthenticatedUser(
      const UserEntity(
        id: 'user123',
        email: 'test@example.com',
        name: 'Test User',
        role: 'driver',
      ),
    );

    tripController = TripController(
      watchTripUsecase,
      createTripUsecase,
      updateTripUsecase,
      getTrips,
      getInProgressTripsUsecase,
      completeTripUsecase,
    );

    sl.registerSingleton<AuthController>(authController);
    sl.registerSingleton<ProfileController>(profileController);
    sl.registerSingleton<TripController>(tripController);
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('ProfilePage shows profile details and metrics', (tester) async {
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

    await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
    await tester.pumpAndSettle();

    expect(find.text('Meu Perfil'), findsOneWidget);
    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('Bio de teste'), findsOneWidget);
    expect(find.text('Carros'), findsOneWidget);
    expect(find.text('Viagens'), findsOneWidget);
    expect(find.text('120'), findsOneWidget);
  });
}
