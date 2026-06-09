import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/core/core_exports.dart';
import 'package:vehicle_tracker/src/core/di/injection_container.dart';
import 'package:vehicle_tracker/src/features/garage/presentation/controllers/add_vechile_controller.dart';
import 'package:vehicle_tracker/src/features/garage/state/add_vehicle_state.dart';

class AddCarPage extends StatefulWidget {
  const AddCarPage({super.key});

  @override
  State<AddCarPage> createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
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

    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Veículo')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                IonBuilder<AddVehicleState>(
                  ion: _controller,
                  builder: (context, state) {
                    if (state.status == .loading && state.brands.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    return Column(
                      children: [
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          dropdownColor: colors.surface,
                          initialValue: state.selectedBrand?.codigo,
                          decoration: const InputDecoration(
                            labelText: 'Seleciona a marca',
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
                                state.status == .loading &&
                                    state.brands.isNotEmpty
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
                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          dropdownColor: colors.surface,
                          isExpanded: true,
                          initialValue: state.selectedYear?.codigo,
                          decoration: InputDecoration(
                            labelText: 'Selecione o ano / combustível',
                            prefixIcon: const Icon(
                              Icons.calendar_today_outlined,
                            ),
                            hintText:
                                state.status == .loading &&
                                    state.models.isNotEmpty &&
                                    state.years.isEmpty
                                ? 'Carrgando anos...'
                                : null,
                          ),
                          items: state.years.isEmpty
                              ? null
                              : state.years
                                    .map(
                                      (y) => DropdownMenuItem(
                                        value: y.codigo,
                                        child: Text(
                                          y.nome,
                                          overflow: .ellipsis,
                                        ),
                                      ),
                                    )
                                    .toList(),
                          onChanged:
                              (state.status == .loading || state.years.isEmpty)
                              ? null
                              : (value) {
                                  if (value != null) {
                                    final year = state.years.firstWhere(
                                      (e) => e.codigo == value,
                                    );
                                    _controller.selectYear(year);
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
                  validator: (value) => value == null || value.isEmpty
                      ? 'Campo obrigatório'
                      : null,
                ),

                const SizedBox(height: 16),

                CustomTextFormField(
                  controller: _kmController,
                  labelText: 'Quilometragem atual',
                  prefixIcon: Icons.speed,
                  keyboardType: .number,
                  textInputAction: .done,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Campo obrigatório'
                      : null,
                ),

                const SizedBox(height: 32),

                IonBuilder(
                  ion: _controller,
                  builder: (context, state) {
                    final isLoading = state.status == .loading;

                    return SizedBox(
                      width: .infinity,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  final success = await _controller
                                      .submitVehicle(
                                        plate: _plateController.text
                                            .toUpperCase(),
                                        currentKm:
                                            double.tryParse(
                                              _kmController.text,
                                            ) ??
                                            0.0,
                                      );
                                  if (success && context.mounted) {
                                    context.pop(true);
                                  }
                                }
                              },
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Salvar veículo'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
