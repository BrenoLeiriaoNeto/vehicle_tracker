import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vehicle_tracker/src/features/dashboard/dashboard_domain_exports.dart';

class MockIWeatherRepository extends Mock implements IWeatherRepository {}

class MockPosition extends Mock implements Position {}

void main() {
  late MockIWeatherRepository repository;
  late GetTargetWeatherUsecase usecase;

  setUpAll(() {
    registerFallbackValue(MockPosition());
  });

  setUp(() {
    repository = MockIWeatherRepository();
  });

  test(
    'deve buscar clima usando localização atual quando disponível',
    () async {
      final position = MockPosition();
      when(() => position.latitude).thenReturn(-23.5);
      when(() => position.longitude).thenReturn(-46.6);

      when(() => repository.getCurrentWeather(-23.5, -46.6)).thenAnswer(
        (_) async => WeatherInfo(
          temperature: 25.0,
          temperatureFeelsLike: 26.0,
          description: 'Céu limpo',
          windSpeed: 5.0,
          humidity: 40,
          iconCode: '01d',
        ),
      );

      usecase = GetTargetWeatherUsecase(
        repository,
        locationFetcher: () async => position,
      );

      final result = await usecase.call();

      expect(result.temperature, 25.0);
      expect(result.temperatureFeelsLike, 26.0);
      expect(result.description, 'Céu limpo');
      expect(result.windSpeed, 5.0);
      expect(result.humidity, 40);
      expect(result.iconCode, '01d');
    },
  );

  test('deve usar coordenadas padrão quando localização for nula', () async {
    when(() => repository.getCurrentWeather(-23.5505, -46.6333)).thenAnswer(
      (_) async => WeatherInfo(
        temperature: 20.0,
        temperatureFeelsLike: 19.0,
        description: 'Nublado',
        windSpeed: 3.0,
        humidity: 70,
        iconCode: '03d',
      ),
    );

    usecase = GetTargetWeatherUsecase(
      repository,
      locationFetcher: () async => null,
    );

    final result = await usecase.call();

    expect(result.temperature, 20.0);
    expect(result.temperatureFeelsLike, 19.0);
    expect(result.description, 'Nublado');
    expect(result.windSpeed, 3.0);
    expect(result.humidity, 70);
    expect(result.iconCode, '03d');
  });
}
