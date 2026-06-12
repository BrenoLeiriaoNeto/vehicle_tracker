import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vehicle_tracker/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:vehicle_tracker/src/features/dashboard/dashboard_domain_exports.dart';

class MockGetTargetWeatherUsecase extends Mock
    implements GetTargetWeatherUsecase {}

void main() {
  late MockGetTargetWeatherUsecase getTargetWeatherUsecase;
  late DashboardController controller;

  setUp(() {
    getTargetWeatherUsecase = MockGetTargetWeatherUsecase();
    controller = DashboardController(getTargetWeatherUsecase);
  });

  group('DashboardController', () {
    test(
      'fetchWeather define status success quando busca clima com sucesso',
      () async {
        final weatherInfo = WeatherInfo(
          temperature: 25.0,
          temperatureFeelsLike: 26.0,
          description: 'Céu limpo',
          windSpeed: 5.0,
          humidity: 40,
          iconCode: '01d',
        );

        when(
          () => getTargetWeatherUsecase(),
        ).thenAnswer((_) async => weatherInfo);

        await controller.fetchWeather();

        expect(controller.state.status, WeatherStatus.success);
        expect(controller.state.weather, weatherInfo);
        expect(controller.state.errorMessage, isNull);
      },
    );

    test(
      'fetchWeather define status error quando usecase lança exceção',
      () async {
        when(
          () => getTargetWeatherUsecase(),
        ).thenThrow(Exception('Falha no clima'));

        await controller.fetchWeather();

        expect(controller.state.status, WeatherStatus.error);
        expect(controller.state.weather, isNull);
        expect(controller.state.errorMessage, contains('Falha no clima'));
      },
    );
  });
}
