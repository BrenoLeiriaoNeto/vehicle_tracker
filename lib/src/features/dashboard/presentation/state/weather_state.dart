import 'package:vehicle_tracker/src/features/dashboard/dashboard_domain_exports.dart';

class WeatherState {
  final WeatherStatus status;
  final WeatherInfo? weather;
  final String? errorMessage;

  WeatherState({required this.status, this.weather, this.errorMessage});

  factory WeatherState.initial() => WeatherState(status: .initial);

  WeatherState copyWith({
    WeatherStatus? status,
    WeatherInfo? weather,
    String? errorMessage,
  }) {
    return WeatherState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
