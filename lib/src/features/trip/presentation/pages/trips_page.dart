import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/features/trip/presentation/controllers/trip_controller.dart';
import 'package:vehicle_tracker/src/features/trip/presentation/widgets/trip_filter_section.dart';
import 'package:vehicle_tracker/src/features/trip/presentation/widgets/trip_history_card.dart';
import 'package:vehicle_tracker/src/features/trip/state/trip_state.dart';
import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  TripStatus? _selectedFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tripController = IonProvider.of<TripController>(context);

      if (tripController.state.trips == null) {
        tripController.getMyTrips();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return IonConsumer<TripController, TripState>(
      builder: (context, state, tripController) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Histórico de Viagens', style: textTheme.titleLarge),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () => tripController.getMyTrips(),
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: Column(
            children: [
              TripFilterSection(
                selectedFilter: _selectedFilter,
                onFilterChanged: (newFilter) {
                  setState(() => _selectedFilter = newFilter);
                },
              ),
              Expanded(
                child:
                    state.isLoading &&
                        (state.trips == null || state.trips!.isEmpty)
                    ? const Center(child: CircularProgressIndicator())
                    : () {
                        final trips = _getFilteredList(state.trips ?? []);

                        if (trips.isEmpty) return _buildEmptyState(theme);

                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: trips.length,
                          itemBuilder: (context, index) {
                            return TripHistoryCard(trip: trips[index]);
                          },
                        );
                      }(),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'fab_trips',
            onPressed: () async {
              final hasNewTrip = await context.push<bool>('/trips/new');

              if (hasNewTrip == true && context.mounted) {
                tripController.getMyTrips();
              }
            },
            backgroundColor: theme.colorScheme.primary,
            child: const Icon(Icons.add_road, color: Colors.black),
          ),
        );
      },
    );
  }

  List<Trip> _getFilteredList(List<Trip> trips) {
    if (_selectedFilter == null) return trips;
    return trips.where((t) => t.status == _selectedFilter).toList();
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Icon(
              Icons.route_outlined,
              size: 64,
              color: theme.colorScheme.tertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma viagem encontrada',
              style: theme.textTheme.titleMedium,
              textAlign: .center,
            ),
            const SizedBox(height: 8),
            Text(
              _selectedFilter == null
                  ? 'Comece criando uma nova rota no botão abaixo!'
                  : 'Nenhuma viagem corresponde ao filtro selecionado.',
              style: theme.textTheme.bodyMedium,
              textAlign: .center,
            ),
          ],
        ),
      ),
    );
  }
}
