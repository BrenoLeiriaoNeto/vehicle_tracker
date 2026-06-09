import 'package:flutter/material.dart';
import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/core/core_exports.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:vehicle_tracker/src/features/dashboard/presentation/state/weather_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final DashboardController _dashboardController;

  @override
  void initState() {
    super.initState();
    _dashboardController = sl<DashboardController>();

    _dashboardController.fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeController = sl<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Rastreador de veículos',
          style: TextStyle(fontWeight: .bold, fontSize: 20),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
        actions: [
          IonBuilder<ThemeMode>(
            ion: themeController,
            builder: (context, _) {
              return IconButton(
                onPressed: () {
                  themeController.toggleTheme();
                },
                icon: Icon(
                  themeController.isDarkMode
                      ? Icons.wb_sunny
                      : Icons.nightlight_round,
                  color: themeController.isDarkMode
                      ? Colors.orangeAccent
                      : colors.primary,
                ),
                tooltip: 'Mudar tema',
              );
            },
          ),

          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        color: colors.primary,
        onRefresh: () => _dashboardController.fetchWeather(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                'Painel de controle 📊',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: .w900,
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: 12),

              IonBuilder<WeatherState>(
                ion: _dashboardController,
                builder: (context, state) {
                  if (state.status == .loading) {
                    return Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: .circular(12),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 3),
                      ),
                    );
                  }

                  if (state.status == .error) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.2),
                        borderRadius: .circular(12),
                        border: .all(color: Colors.redAccent),
                      ),
                      child: Text(
                        '⚠️ Erro de satélite: ${state.errorMessage}',
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    );
                  }

                  if (state.status == .success && state.weather != null) {
                    final weather = state.weather;
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: .circular(12),
                        border: .all(
                          color: colors.primary.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: .start,
                            children: [
                              Row(
                                children: [
                                  Image.network(
                                    'https://openweathermap.org/img/wn/${weather?.iconCode}@2x.png',
                                    width: 44,
                                    height: 44,
                                    errorBuilder: (_, _, _) => Icon(
                                      Icons.wb_cloudy,
                                      color: colors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  weather != null
                                      ? Text(
                                          weather.description.toUpperCase(),
                                          style:
                                              textTheme.titleSmall?.copyWith(
                                                fontWeight: .bold,
                                                letterSpacing: 0.5,
                                              ) ??
                                              TextStyle(
                                                color: colors.onSurface,
                                              ),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '💨 Vento: ${weather?.windSpeed.toStringAsFixed(1)} m/s  |  💧 Umidade: ${weather?.humidity}%',
                                style: textTheme.bodySmall,
                              ),
                              Text(
                                '🌡️ Sensação: ${weather?.temperatureFeelsLike.toStringAsFixed(1)}°C',
                                style: textTheme.bodySmall,
                              ),
                            ],
                          ),
                          Text(
                            '${weather?.temperature.toStringAsFixed(0)}°C',
                            style: TextStyle(
                              fontSize: 46,
                              fontWeight: .w900,
                              color: colors.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 24),

              Text(
                'VEÍCULOS EM ROTA',
                style: TextStyle(
                  color: colors.secondary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),

              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    'Nenhum veículo em trânsito no momento.',
                    style: textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
