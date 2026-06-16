import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
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
  final _tripController = sl<TripController>();
  TripStatus? _selectedFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_tripController.state.historyTrips.isEmpty) {
        _tripController.getMyTrips();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Viagens', style: textTheme.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _tripController.getMyTrips(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            TripFilterSection(
              selectedFilter: _selectedFilter,
              onFilterChanged: (newFilter) {
                setState(() => _selectedFilter = newFilter);
              },
            ),
            Expanded(
              child: IonBuilder<TripState>(
                ion: _tripController,
                builder: (context, state) {
                  if (state.isLoading && (state.historyTrips.isEmpty)) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final trips = _getFilteredList(state.historyTrips);

                  if (trips.isEmpty) return _buildEmptyState(theme);

                  return OrientationBuilder(
                    builder: (context, orientation) {
                      if (orientation == .landscape) {
                        return _buildLandscapeGrid(trips);
                      }
                      return _buildPortraitList(trips);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_trips',
        onPressed: () async {
          final hasNewTrip = await context.push<bool>('/trips/new');

          if (hasNewTrip == true && context.mounted) {
            _tripController.getMyTrips();
          }
        },
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.add_road, color: Colors.black),
      ),
    );
  }

  Widget _buildPortraitList(List<Trip> trips) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        return TripHistoryCard(trip: trips[index]);
      },
    );
  }

  Widget _buildLandscapeGrid(List<Trip> trips) {
    return GridView.builder(
      padding: const EdgeInsets.only(left: 12.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.8,
      ),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        return TripHistoryCard(trip: trips[index]);
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
        padding: const EdgeInsets.all(28.0),
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
          ],
        ),
      ),
    );
  }
}
