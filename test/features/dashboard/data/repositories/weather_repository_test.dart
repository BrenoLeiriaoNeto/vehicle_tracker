import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vehicle_tracker/src/features/dashboard/data/repositories/weather_repository.dart';
import 'package:vehicle_tracker/src/features/dashboard/dashboard_domain_exports.dart';
import 'package:weather/weather.dart';

class MockWeatherFactory extends Mock implements WeatherFactory {}

class MockWeather extends Mock implements Weather {}

void main() {
  late MockWeatherFactory weatherFactory;
  late WeatherRepository repository;
  late MockWeather weather;

  setUp(() {
    weatherFactory = MockWeatherFactory();
    repository = WeatherRepository(weatherFactory);
    weather = MockWeather();
  });

  group('WeatherRepository', () {
    test(
      'deve retornar WeatherInfo convertendo Weather para WeatherModel',
      () async {
        when(
          () => weatherFactory.currentWeatherByLocation(10.0, 20.0),
        ).thenAnswer((_) async => weather);

        when(() => weather.temperature).thenReturn(Temperature(300.0));
        when(() => weather.tempFeelsLike).thenReturn(Temperature(304.0));
        when(() => weather.weatherDescription).thenReturn('Ensolarado');
        when(() => weather.windSpeed).thenReturn(5.2);
        when(() => weather.humidity).thenReturn(75.0);
        when(() => weather.weatherIcon).thenReturn('01d');

        final result = await repository.getCurrentWeather(10.0, 20.0);

        expect(result, isA<WeatherInfo>());
        expect(result.temperature, closeTo(26.85, 0.01));
        expect(result.temperatureFeelsLike, closeTo(30.85, 0.01));
        expect(result.description, 'Ensolarado');
        expect(result.windSpeed, 5.2);
        expect(result.humidity, 75);
        expect(result.iconCode, '01d');
      },
    );

    test('deve lançar exceção quando WeatherFactory falhar', () async {
      when(
        () => weatherFactory.currentWeatherByLocation(any(), any()),
      ).thenThrow(Exception('Falha de rede'));

      expect(
        () => repository.getCurrentWeather(10.0, 20.0),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Erro ao buscar dados no OpenWeatherMap'),
          ),
        ),
      );
    });
  });
}
