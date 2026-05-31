import 'package:vehicle_tracker/src/features/dashboard/dashboard_data_exports.dart';
import 'package:vehicle_tracker/src/features/dashboard/dashboard_domain_exports.dart';
import 'package:weather/weather.dart';

class WeatherRepository extends IWeatherRepository {
  final WeatherFactory _weatherFactory;

  WeatherRepository(this._weatherFactory);

  @override
  Future<WeatherInfo> getCurrentWeather(
    double latitude,
    double longitude,
  ) async {
    try {
      final Weather weather = await _weatherFactory.currentWeatherByLocation(
        latitude,
        longitude,
      );

      return WeatherModel.fromPackage(weather);
    } catch (e) {
      throw Exception('Erro ao buscar dados no OpenWeatherMap: $e');
    }
  }
}
