import 'package:vehicle_tracker/src/features/dashboard/dashboard_domain_exports.dart';
import 'package:weather/weather.dart';

class WeatherModel extends WeatherInfo {
  WeatherModel({
    required super.temperature,
    required super.temperatureFeelsLike,
    required super.description,
    required super.windSpeed,
    required super.humidity,
    required super.iconCode,
  });

  factory WeatherModel.fromPackage(Weather weather) {
    return WeatherModel(
      temperature: weather.temperature?.celsius ?? 0.0,
      temperatureFeelsLike: weather.tempFeelsLike?.celsius ?? 0.0,
      description: weather.weatherDescription ?? 'Clima indisponível',
      windSpeed: weather.windSpeed ?? 0.0,
      humidity: weather.humidity?.toInt() ?? 0,
      iconCode: weather.weatherIcon ?? '01d',
    );
  }
}
