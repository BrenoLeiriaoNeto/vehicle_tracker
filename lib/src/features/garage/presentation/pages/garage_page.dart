import 'package:flutter/material.dart';
import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/features/garage/presentation/controllers/garage_controller.dart';
import 'package:vehicle_tracker/src/features/garage/presentation/widgets/add_vehicle_modal.dart';
import 'package:vehicle_tracker/src/features/garage/state/garage_state.dart';

class GaragePage extends StatefulWidget {
  const GaragePage({super.key});

  @override
  State<GaragePage> createState() => _GaragePageState();
}

class _GaragePageState extends State<GaragePage> {
  late final GarageController _controller;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = sl<GarageController>();
    _controller.fetchVehicles();
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
              onChanged: _controller.filterVehicles,
              decoration: InputDecoration(
                hintText: 'Buscar por modelo, marca ou placa...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _controller.filterVehicles('');
                  },
                ),
              ),
            ),
          ),

          Expanded(
            child: IonBuilder<GarageState>(
              ion: _controller,
              builder: (context, state) {
                if (state.status == .loading) {
                  return Center(
                    child: CircularProgressIndicator(color: colors.primary),
                  );
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
                            state.errorMessage ??
                                'Ocorreu um erro desconhecido',
                            textAlign: .center,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _controller.fetchVehicles,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Tentar novamente'),
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
                      style: textTheme.bodyLarge?.copyWith(
                        color: Colors.white38,
                      ),
                    ),
                  );
                }

                if (state.filteredVehicles.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhum veículo encontrado para a busca.',
                      style: textTheme.bodyLarge?.copyWith(
                        color: Colors.white38,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: state.filteredVehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = state.filteredVehicles[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: .circular(16),
                        border: .all(
                          color: colors.primary.withValues(alpha: 0.05),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 90,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: .circular(6),
                              border: .all(
                                color: const Color(0xFF003399),
                                width: 2,
                              ),
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
                                    Icon(
                                      Icons.speed,
                                      size: 14,
                                      color: colors.secondary,
                                    ),
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
                              vehicle.status == 'available'
                                  ? 'Disponível'
                                  : 'Em Rota',
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
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: colors.primary,
        child: const Icon(Icons.add, color: Colors.black, size: 28),
        onPressed: () {
          AddVechicleModal.show(
            context,
            onVehicleAdded: () {
              _controller.fetchVehicles();
            },
          );
        },
      ),
    );
  }
}
