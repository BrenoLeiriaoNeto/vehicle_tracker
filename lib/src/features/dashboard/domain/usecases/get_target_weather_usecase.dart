import 'package:geolocator/geolocator.dart';
import 'package:vehicle_tracker/src/core/core_exports.dart';
import 'package:vehicle_tracker/src/features/dashboard/dashboard_domain_exports.dart';

class GetTargetWeatherUsecase {
  final IWeatherRepository _repository;
  final Future<Position?> Function() _locationFetcher;

  GetTargetWeatherUsecase(
    this._repository, {
    Future<Position?> Function()? locationFetcher,
  }) : _locationFetcher = locationFetcher ?? getPosition;

  Future<WeatherInfo> call() async {
    double lat = -23.5505;
    double lon = -46.6333;

    var location = await _locationFetcher();

    if (location != null) {
      lat = location.latitude;
      lon = location.longitude;
    }

    return await _repository.getCurrentWeather(lat, lon);
  }
}
