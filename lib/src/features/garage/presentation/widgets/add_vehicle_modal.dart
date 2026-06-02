import 'package:flutter/material.dart';
import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/core/core_exports.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/features/garage/presentation/controllers/add_vechile_controller.dart';
import 'package:vehicle_tracker/src/features/garage/state/add_vehicle_state.dart';

class AddVechicleModal extends StatefulWidget {
  const AddVechicleModal({super.key});

  static void show(BuildContext context, {VoidCallback? onVehicleAdded}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const AddVechicleModal(),
      ),
    ).then((value) {
      if (value == true && onVehicleAdded != null) onVehicleAdded();
    });
  }

  @override
  State<AddVechicleModal> createState() => _AddVechicleModalState();
}

class _AddVechicleModalState extends State<AddVechicleModal> {
  late final AddVechileController _controller;
  final _formKey = GlobalKey<FormState>();
  final _plateController = TextEditingController();
  final _kmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = sl<AddVechileController>();
    _controller.loadBrands();
  }

  @override
  void dispose() {
    _plateController.dispose();
    _kmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: .circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Adicionar veículo',
              style: textTheme.titleLarge?.copyWith(color: colors.primary),
            ),
            const SizedBox(height: 24),

            IonBuilder(
              ion: _controller,
              builder: (context, state) {
                if (state.status == .loading && state.brands.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  children: [
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      dropdownColor: colors.surface,
                      initialValue: state.selectedBrand?.codigo,
                      decoration: const InputDecoration(
                        labelText: 'Selecione a marca',
                        prefixIcon: Icon(Icons.directions_car_outlined),
                      ),
                      items: state.brands
                          .map(
                            (b) => DropdownMenuItem(
                              value: b.codigo,
                              child: Text(b.nome, overflow: .ellipsis),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          final brand = state.brands.firstWhere(
                            (element) => element.codigo == value,
                          );
                          _controller.selectBrand(brand);
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      dropdownColor: colors.surface,
                      initialValue: state.selectedModel?.codigo,
                      decoration: InputDecoration(
                        labelText: 'Selecione o modelo',
                        prefixIcon: const Icon(Icons.build_circle_outlined),
                        hintText:
                            state.status == .loading && state.brands.isNotEmpty
                            ? 'Carregando modelos...'
                            : null,
                      ),
                      items: state.models
                          .map(
                            (m) => DropdownMenuItem(
                              value: m.codigo,
                              child: Text(m.nome, overflow: .ellipsis),
                            ),
                          )
                          .toList(),
                      onChanged: state.models.isEmpty
                          ? null
                          : (value) {
                              if (value != null) {
                                final model = state.models.firstWhere(
                                  (element) => element.codigo == value,
                                );
                                _controller.selectModel(model);
                              }
                            },
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            CustomTextFormField(
              controller: _plateController,
              labelText: 'Placa (ex: ABC1D23)',
              prefixIcon: Icons.badge_outlined,
              textInputAction: .next,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Campo obrigatório' : null,
            ),

            const SizedBox(height: 16),

            CustomTextFormField(
              controller: _kmController,
              labelText: 'Quilometragem atual',
              prefixIcon: Icons.speed,
              keyboardType: .number,
              textInputAction: .done,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Campo obrigatório' : null,
            ),

            const SizedBox(height: 24),

            IonBuilder<AddVehicleState>(
              ion: _controller,
              builder: (context, state) {
                final isLoading = state.status == .loading;

                return ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            final success = await _controller.submitVehicle(
                              plate: _plateController.text.toUpperCase(),
                              currentKm:
                                  double.tryParse(_kmController.text) ?? 0.0,
                            );
                            if (success && context.mounted) {
                              Navigator.of(context).pop(true);
                            }
                          }
                        },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text('Salvar veículo'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
