import 'package:vehicle_tracker/src/core/core_exports.dart';
import 'package:vehicle_tracker/src/features/dashboard/dashboard_domain_exports.dart';

class GetTargetWeatherUsecase {
  final IWeatherRepository _repository;

  GetTargetWeatherUsecase(this._repository);

  Future<WeatherInfo> call() async {
    double lat = -23.5505;
    double lon = -46.6333;

    var location = await getPosition();

    if (location != null) {
      lat = location.latitude;
      lon = location.longitude;
    }

    return await _repository.getCurrentWeather(lat, lon);
  }
}
