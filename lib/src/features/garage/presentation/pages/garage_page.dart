import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/features/garage/presentation/controllers/garage_controller.dart';
import 'package:vehicle_tracker/src/features/garage/presentation/widgets/vehicle_card.dart';
import 'package:vehicle_tracker/src/features/garage/state/garage_state.dart';

class GaragePage extends StatefulWidget {
  const GaragePage({super.key});

  @override
  State<GaragePage> createState() => _GaragePageState();
}

class _GaragePageState extends State<GaragePage> {
  final _garageController = sl<GarageController>();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_garageController.state.vehicles.isEmpty) {
        _garageController.fetchVehicles();
      }
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
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: _garageController.filterVehicles,
                decoration: InputDecoration(
                  hintText: 'Buscar por modelo, marca ou placa...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _garageController.filterVehicles('');
                    },
                  ),
                ),
              ),
            ),

            Expanded(
              child: IonBuilder<GarageState>(
                ion: _garageController,
                builder: (context, state) => _buildListContent(
                  state,
                  colors,
                  textTheme,
                  _garageController,
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_garage',
        backgroundColor: colors.primary,
        child: const Icon(Icons.add, color: Colors.black, size: 28),
        onPressed: () async {
          final vehicleAdded = await context.push<bool>('/garage/new');

          if (vehicleAdded == true && context.mounted) {
            _searchController.clear();

            _garageController.fetchVehicles();
          }
        },
      ),
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

    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == .landscape) {
          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: state.filteredVehicles.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 0,
              childAspectRatio: 3.6,
            ),
            itemBuilder: (context, index) {
              return VehicleCard(vehicle: state.filteredVehicles[index]);
            },
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: state.filteredVehicles.length,
          itemBuilder: (context, index) {
            return VehicleCard(vehicle: state.filteredVehicles[index]);
          },
        );
      },
    );
  }
}
