class WeatherInfo {
  final double temperature;
  final double temperatureFeelsLike;
  final String description;
  final double windSpeed;
  final int humidity;
  final String iconCode;

  WeatherInfo({
    required this.temperature,
    required this.temperatureFeelsLike,
    required this.description,
    required this.windSpeed,
    required this.humidity,
    required this.iconCode,
  });
}
