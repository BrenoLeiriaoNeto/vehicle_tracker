import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/core/theme/theme_controller.dart';
import 'package:vehicle_tracker/src/features/auth/auth_domain_exports.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:vehicle_tracker/src/features/dashboard/dashboard_domain_exports.dart';
import 'package:vehicle_tracker/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:vehicle_tracker/src/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:vehicle_tracker/src/features/trip/presentation/controllers/trip_controller.dart';
import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class MockGetTargetWeatherUsecase extends Mock
    implements GetTargetWeatherUsecase {}

class MockWatchTripUsecase extends Mock implements WatchTripUsecase {}

class MockCreateTripUsecase extends Mock implements CreateTripUsecase {}

class MockUpdateTripUsecase extends Mock implements UpdateTripUsecase {}

class MockGetTrips extends Mock implements GetTrips {}

class MockGetInProgressTripsUsecase extends Mock
    implements GetInProgressTripsUsecase {}

class MockCompleteTripUsecase extends Mock implements CompleteTripUsecase {}

class MockLoginWithEmailPasswordUsecase extends Mock
    implements LoginWithEmailPasswordUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

void main() {
  late MockGetTargetWeatherUsecase getWeatherUsecase;
  late DashboardController dashboardController;
  late TripController tripController;
  late ThemeController themeController;
  late AuthController authController;
  late MockLoginWithEmailPasswordUsecase loginUsecase;
  late MockLogoutUsecase logoutUsecase;

  setUp(() async {
    await sl.reset();

    loginUsecase = MockLoginWithEmailPasswordUsecase();
    logoutUsecase = MockLogoutUsecase();
    authController = AuthController(loginUsecase, logoutUsecase);

    getWeatherUsecase = MockGetTargetWeatherUsecase();
    dashboardController = DashboardController(getWeatherUsecase);

    final watchTripUsecase = MockWatchTripUsecase();
    final createTripUsecase = MockCreateTripUsecase();
    final updateTripUsecase = MockUpdateTripUsecase();
    final getTrips = MockGetTrips();
    final getInProgressTripsUsecase = MockGetInProgressTripsUsecase();
    final completeTripUsecase = MockCompleteTripUsecase();
    tripController = TripController(
      watchTripUsecase,
      createTripUsecase,
      updateTripUsecase,
      getTrips,
      getInProgressTripsUsecase,
      completeTripUsecase,
    );

    themeController = ThemeController();

    sl.registerSingleton<AuthController>(authController);
    sl.registerSingleton<ThemeController>(themeController);
    sl.registerSingleton<DashboardController>(dashboardController);
    sl.registerSingleton<TripController>(tripController);
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets(
    'DashboardPage displays weather info and no active trip message',
    (tester) async {
      when(() => getWeatherUsecase()).thenAnswer(
        (_) async => WeatherInfo(
          temperature: 22.0,
          temperatureFeelsLike: 24.0,
          description: 'Céu limpo',
          windSpeed: 3.5,
          humidity: 40,
          iconCode: '01d',
        ),
      );

      await tester.pumpWidget(MaterialApp(home: DashboardPage()));

      await tester.pumpAndSettle();

      expect(find.text('CÉU LIMPO'), findsOneWidget);
      expect(find.textContaining('💨 Vento'), findsOneWidget);
      expect(
        find.text('Nenhum veículo em trânsito no momento.'),
        findsOneWidget,
      );
    },
  );
}
