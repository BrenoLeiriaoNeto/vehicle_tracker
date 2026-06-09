import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/features/garage/presentation/controllers/garage_controller.dart';
import 'package:vehicle_tracker/src/features/garage/state/garage_state.dart';

class GaragePage extends StatefulWidget {
  const GaragePage({super.key});

  @override
  State<GaragePage> createState() => _GaragePageState();
}

class _GaragePageState extends State<GaragePage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final garageController = IonProvider.of<GarageController>(context);
      garageController.fetchVehicles();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return IonConsumer<GarageController, GarageState>(
      builder: (context, state, garage) {
        print(
          '[UI REBUILD]: Status = ${state.status}, Carros = ${state.vehicles.length}',
        );
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Minha Garagem',
              style: TextStyle(fontWeight: .bold, letterSpacing: 0.5),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: garage.filterVehicles,
                  decoration: InputDecoration(
                    hintText: 'Buscar por modelo, marca ou placa...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        garage.filterVehicles('');
                      },
                    ),
                  ),
                ),
              ),

              Expanded(
                child: _buildListContent(state, colors, textTheme, garage),
              ),
            ],
          ),

          floatingActionButton: FloatingActionButton(
            backgroundColor: colors.primary,
            child: const Icon(Icons.add, color: Colors.black, size: 28),
            onPressed: () async {
              final vehicleAdded = await context.push<bool>('/garage/new');

              if (vehicleAdded == true && context.mounted) {
                _searchController.clear();

                garage.fetchVehicles();
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildListContent(
    GarageState state,
    ColorScheme colors,
    TextTheme textTheme,
    GarageController garage,
  ) {
    if (state.status == .loading) {
      return Center(child: CircularProgressIndicator(color: colors.primary));
    }

    if (state.status == .error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          key: const Key('error_container'),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              Text(
                state.errorMessage ?? 'Ocorreu um erro desconhecido',
                style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                textAlign: .center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: garage.fetchVehicles,
                label: const Text('Tentar novamente'),
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
      );
    }
    if (state.vehicles.isEmpty) {
      return Center(
        child: Text(
          'Sua garagem está vazia. \nAdicione um veículo no botão abaixo!',
          textAlign: .center,
          style: textTheme.bodyLarge?.copyWith(color: Colors.white38),
        ),
      );
    }

    if (state.filteredVehicles.isEmpty) {
      return Center(
        child: Text(
          'Nenhum veículo encontrado para a busca.',
          style: textTheme.bodyLarge?.copyWith(color: Colors.white38),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: state.filteredVehicles.length,
      itemBuilder: (context, index) {
        final vehicle = state.filteredVehicles[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: .circular(16),
            border: .all(color: colors.primary.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              Container(
                width: 90,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: .circular(6),
                  border: .all(color: const Color(0xFF003399), width: 2),
                ),
                child: Column(
                  mainAxisSize: .min,
                  children: [
                    Container(
                      height: 4,
                      width: double.infinity,
                      color: const Color(0xFF003399),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      vehicle.plate,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: .bold,
                        fontSize: 13,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      vehicle.model,
                      style: textTheme.titleMedium,
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${vehicle.brand} - ${vehicle.year}',
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.speed, size: 14, color: colors.secondary),
                        const SizedBox(width: 4),
                        Text(
                          '${vehicle.currentKm.toStringAsFixed(0)} Km',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.secondary,
                            fontWeight: .bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: vehicle.status == 'available'
                      ? colors.secondary.withValues(alpha: 0.1)
                      : Colors.orangeAccent.withValues(alpha: 0.1),
                  borderRadius: .circular(20),
                ),
                child: Text(
                  vehicle.status == 'available' ? 'Disponível' : 'Em Rota',
                  style: TextStyle(
                    color: vehicle.status == 'available'
                        ? colors.secondary
                        : Colors.orangeAccent,
                    fontSize: 11,
                    fontWeight: .bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
