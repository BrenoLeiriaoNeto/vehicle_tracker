import 'package:flutter/material.dart';
import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/core/core_exports.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:vehicle_tracker/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:vehicle_tracker/src/features/dashboard/presentation/state/weather_state.dart';
import 'package:vehicle_tracker/src/features/dashboard/presentation/widgets/live_trip_card.dart';
import 'package:vehicle_tracker/src/features/trip/presentation/controllers/trip_controller.dart';
import 'package:vehicle_tracker/src/features/trip/state/trip_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final DashboardController _dashboardController;
  late final String _userId;

  @override
  void initState() {
    super.initState();
    _dashboardController = sl<DashboardController>();
    _dashboardController.fetchWeather();

    _userId = sl<AuthController>().state.user?.id ?? '';

    if (_userId.isNotEmpty) {
      sl<TripController>().fetchActiveTrip(_userId);
    }
  }

  Future<void> _refreshDashboard() async {
    await Future.wait([
      _dashboardController.fetchWeather(),
      if (_userId.isNotEmpty) sl<TripController>().fetchActiveTrip(_userId),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeController = sl<ThemeController>();
    final tripController = sl<TripController>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Dashboard',
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
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == .landscape) {
              return _buildLandscapeSplitScreen(
                colors,
                textTheme,
                theme,
                tripController,
              );
            }
            return _buildPortraitLayout(
              colors,
              textTheme,
              theme,
              tripController,
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(
    ColorScheme colors,
    TextTheme textTheme,
    ThemeData theme,
    TripController tripController,
  ) {
    return RefreshIndicator(
      color: colors.primary,
      onRefresh: _refreshDashboard,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            _buildHeader(theme, colors),
            const SizedBox(height: 12),
            _buildWeatherSection(colors, textTheme),
            const SizedBox(height: 24),
            _buildTripsHeader(colors),
            const SizedBox(height: 12),
            _buildTripSection(tripController, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeSplitScreen(
    ColorScheme colors,
    TextTheme textTheme,
    ThemeData theme,
    TripController tripController,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                _buildHeader(theme, colors),
                const SizedBox(height: 12),
                _buildWeatherSection(colors, textTheme),
              ],
            ),
          ),
          const SizedBox(width: 24),

          Expanded(
            flex: 5,
            child: RefreshIndicator(
              color: colors.primary,
              onRefresh: _refreshDashboard,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    _buildTripsHeader(colors),
                    const SizedBox(height: 12),
                    _buildTripSection(tripController, textTheme),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colors) {
    return Text(
      'Clima hoje',
      style: theme.textTheme.headlineMedium?.copyWith(
        fontWeight: .w900,
        color: colors.primary,
      ),
    );
  }

  Widget _buildTripsHeader(ColorScheme colors) {
    return Text(
      'VEÍCULOS EM ROTA',
      style: TextStyle(
        color: colors.secondary,
        fontWeight: .w900,
        letterSpacing: 1.2,
        fontSize: 12,
      ),
    );
  }

  Widget _buildWeatherSection(ColorScheme colors, TextTheme textTheme) {
    return IonBuilder<WeatherState>(
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: .circular(12),
              border: .all(color: colors.primary.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        children: [
                          Image.network(
                            'https://openweathermap.org/img/wn/${weather?.iconCode}@2x.png',
                            width: 44,
                            height: 44,
                            errorBuilder: (_, _, _) =>
                                Icon(Icons.wb_cloudy, color: colors.primary),
                          ),
                          const SizedBox(width: 8),
                          if (weather != null)
                            Expanded(
                              child: Text(
                                weather.description.toUpperCase(),
                                style:
                                    textTheme.titleSmall?.copyWith(
                                      fontWeight: .bold,
                                      letterSpacing: 0.5,
                                    ) ??
                                    TextStyle(color: colors.onSurface),
                                overflow: .ellipsis,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '💨 Vento: ${weather?.windSpeed.toStringAsFixed(1)} m/s\n💧 Umidade: ${weather?.humidity}%',
                        style: textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '🌡️ Sensação: ${weather?.temperatureFeelsLike.toStringAsFixed(1)}°C',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${weather?.temperature.toStringAsFixed(0)}°C',
                  style: TextStyle(
                    fontSize: 42,
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
    );
  }

  Widget _buildTripSection(TripController tripController, TextTheme textTheme) {
    return IonBuilder<TripState>(
      ion: tripController,
      builder: (context, state) {
        final activeTrips = state.activeTrips;

        if (activeTrips.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text(
                'Nenhum veículo em trânsito no momento.',
                style: textTheme.bodyMedium,
              ),
            ),
          );
        }
        return Column(
          children: activeTrips.map((trip) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: LiveTripCard(trip: trip),
            );
          }).toList(),
        );
      },
    );
  }
}
