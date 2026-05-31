import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/features/dashboard/dashboard_domain_exports.dart';
import 'package:vehicle_tracker/src/features/dashboard/presentation/state/weather_state.dart';

class DashboardController extends Ion<WeatherState> {
  final GetTargetWeatherUsecase _getTargetWeatherUsecase;

  DashboardController(this._getTargetWeatherUsecase) : super(.initial());

  Future<void> fetchWeather() async {
    set(state.copyWith(status: .loading));

    try {
      final weatherInfo = await _getTargetWeatherUsecase();

      set(state.copyWith(status: .success, weather: weatherInfo));
    } catch (e) {
      set(state.copyWith(status: .error, errorMessage: e.toString()));
    }
  }
}
