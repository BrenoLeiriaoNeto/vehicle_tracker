import 'package:vehicle_tracker/src/features/dashboard/dashboard_domain_exports.dart';

abstract class IWeatherRepository {
  Future<WeatherInfo> getCurrentWeather(double latitude, double longitude);
}
