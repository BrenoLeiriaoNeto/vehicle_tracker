import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/core/core_exports.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:vehicle_tracker/src/features/garage/presentation/controllers/garage_controller.dart';
import 'package:vehicle_tracker/src/features/garage/state/garage_state.dart';
import 'package:vehicle_tracker/src/features/trip/presentation/controllers/trip_controller.dart';
import 'package:vehicle_tracker/src/features/trip/presentation/widgets/new_trip_action_buttons.dart';
import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class NewTripPage extends StatefulWidget {
  const NewTripPage({super.key});

  @override
  State<NewTripPage> createState() => _NewTripPageState();
}

class _NewTripPageState extends State<NewTripPage> {
  final _formKey = GlobalKey<FormState>();

  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _distanceController = TextEditingController();

  String? _selectedVehicleId;
  String? _selectedVehicleName;
  bool _isSubmitting = false;

  bool _isGpsLoading = false;

  Future<void> _getCurrentLocation() async {
    setState(() => _isGpsLoading = true);

    try {
      final address = await fetchCurrentLocation();

      if (address.isNotEmpty) {
        setState(
          () => _originController.text = address.trim().replaceAll(
            RegExp(r'^,\s*'),
            '',
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isGpsLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final garageController = sl<GarageController>();

      if (garageController.state.vehicles.isEmpty) {
        garageController.fetchVehicles();
      }
    });
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _distanceController.dispose();

    super.dispose();
  }

  Future<void> _handleSaveTrip({required bool startImmediatly}) async {
    if (!_formKey.currentState!.validate() || _selectedVehicleId == null) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final userId = sl<AuthController>().state.user?.id ?? '';

      final newTrip = Trip(
        id: FirebaseFirestore.instance.collection('trips').doc().id,
        userId: userId,
        vehicleId: _selectedVehicleId!,
        vehicleName: _selectedVehicleName ?? 'Veículo',
        origin: _originController.text.trim(),
        destination: _destinationController.text.trim(),
        totalDistance: double.tryParse(_distanceController.text) ?? 0.0,
        currentKm: 0.0,
        status: startImmediatly ? .inProgress : .pending,
        vehicleState: startImmediatly ? .moving : .parked,
        startedAt: startImmediatly ? DateTime.now() : null,
      );

      await sl<TripController>().createTrip(newTrip);

      if (startImmediatly == true) {
        sl<TripController>().startLocalSimulation();
      }

      if (mounted) {
        context.pop(true);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              startImmediatly
                  ? 'Viagem iniciada! Cuidado na estrada e dirija com segurança!'
                  : 'Viagem criada com sucesso!',
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao processar viagem: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar Viagem'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: OrientationBuilder(
            builder: (context, orientation) {
              final isLandscape = orientation == .landscape;
              return isLandscape
                  ? _buildLandscapeLayout(theme)
                  : _buildPortraitLayout(theme);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(ThemeData theme) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  const InfoBanner(
                    message:
                        'Preencha a rota para calcular o progresso e iniciar a telemetria',
                  ),
                  const SizedBox(height: 24),
                  _buildVehicleDropdown(theme),
                  const SizedBox(height: 20),
                  _buildOriginField(theme),
                  const SizedBox(height: 20),
                  _buildDestinationField(theme),
                  const SizedBox(height: 20),
                  _buildDistanceField(theme),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: NewTripActionButtons(
            isLandscape: false,
            isSubmitting: _isSubmitting,
            onSavePressed: () => _handleSaveTrip(startImmediatly: false),
            onStartPressed: () => _handleSaveTrip(startImmediatly: true),
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            const InfoBanner(
              message:
                  'Preencha a rota para calcular o progresso e iniciar a telemetria.',
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: .start,
              children: [
                Expanded(flex: 2, child: _buildVehicleDropdown(theme)),
                const SizedBox(width: 16),
                Expanded(flex: 1, child: _buildDistanceField(theme)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: .start,
              children: [
                Expanded(child: _buildOriginField(theme)),
                const SizedBox(width: 16),
                Expanded(child: _buildDestinationField(theme)),
              ],
            ),
            const SizedBox(height: 32),
            NewTripActionButtons(
              isLandscape: true,
              isSubmitting: _isSubmitting,
              onSavePressed: () => _handleSaveTrip(startImmediatly: false),
              onStartPressed: () => _handleSaveTrip(startImmediatly: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleDropdown(ThemeData theme) {
    return IonBuilder<GarageState>(
      ion: sl<GarageController>(),
      builder: (context, state) {
        if (state.status == .loading && state.vehicles.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('Carregando garagem...'),
              ],
            ),
          );
        }
        if (state.status == .error && state.vehicles.isEmpty) {
          return Text(
            'Erro ao carregar veículos: ${state.errorMessage}',
            style: TextStyle(color: theme.colorScheme.error),
          );
        }
        if (state.vehicles.isEmpty) {
          return Text(
            'Nenhum veículo na garagem',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white38),
          );
        }

        return DropdownButtonFormField<String>(
          initialValue: _selectedVehicleId,
          isExpanded: true,
          dropdownColor: theme.colorScheme.surface,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            labelText: 'Selecionar veículo da garagem',
            prefixIcon: Icon(
              Icons.directions_car,
              color: theme.colorScheme.primary,
            ),
          ),
          items: state.vehicles.map((v) {
            return DropdownMenuItem(
              value: v.plate,
              child: Text(
                '${v.brand} ${v.model} ${v.currentKm} Km',
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: _isSubmitting
              ? null
              : (value) {
                  final selected = state.vehicles.firstWhere(
                    (v) => v.plate == value,
                  );
                  setState(() {
                    _selectedVehicleId = value;
                    _selectedVehicleName =
                        '${selected.brand} ${selected.model}';
                  });
                },
          validator: (v) =>
              v == null ? 'Por favor, selecione um veículo' : null,
        );
      },
    );
  }

  Widget _buildOriginField(ThemeData theme) {
    return CustomTextFormField(
      controller: _originController,
      enabled: !_isSubmitting && !_isGpsLoading,
      labelText: 'Ponto de Origem',
      prefixIcon: Icons.location_on,
      suffixIcon: _isGpsLoading
          ? const Padding(
              padding: EdgeInsets.all(12.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : IconButton(
              onPressed: _isSubmitting ? null : _getCurrentLocation,
              tooltip: 'Usar localização atual',
              icon: Icon(Icons.my_location, color: theme.colorScheme.primary),
            ),
      validator: (v) =>
          v == null || v.isEmpty ? 'Informe o ponto de origem' : null,
    );
  }

  Widget _buildDestinationField(ThemeData theme) {
    return CustomTextFormField(
      controller: _destinationController,
      enabled: !_isSubmitting,
      labelText: 'Ponto de Destino',
      prefixIcon: Icons.flag,
      validator: (v) =>
          v == null || v.isEmpty ? 'Informe o ponto de destino' : null,
    );
  }

  Widget _buildDistanceField(ThemeData theme) {
    return CustomTextFormField(
      controller: _distanceController,
      enabled: !_isSubmitting,
      labelText: 'Distância (Km)',
      prefixIcon: Icons.edit_road,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Informe a distância';
        if (double.tryParse(v) == null) return 'Número inválido';
        return null;
      },
    );
  }
}
