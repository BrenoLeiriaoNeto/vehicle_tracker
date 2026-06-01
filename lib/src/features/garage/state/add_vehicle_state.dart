import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';

class AddVehicleState {
  final AddVehicleStatus status;

  final List<FipeItem> brands;
  final List<FipeItem> models;
  final List<FipeItem> years;

  final FipeItem? selectedBrand;
  final FipeItem? selectedModel;
  final FipeItem? selectedYear;

  final String? errorMessage;

  AddVehicleState({
    required this.status,
    required this.brands,
    required this.models,
    required this.years,
    this.selectedBrand,
    this.selectedModel,
    this.selectedYear,
    this.errorMessage,
  });

  factory AddVehicleState.initial() =>
      AddVehicleState(status: .initial, brands: [], models: [], years: []);

  AddVehicleState copyWith({
    AddVehicleStatus? status,
    List<FipeItem>? brands,
    List<FipeItem>? models,
    List<FipeItem>? years,
    FipeItem? selectedBrand,
    FipeItem? selectedModel,
    FipeItem? selectedYear,
    bool clearModel = false,
    bool clearYear = false,
    String? errorMessage,
  }) {
    return AddVehicleState(
      status: status ?? this.status,
      brands: brands ?? this.brands,
      models: models ?? this.models,
      years: years ?? this.years,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      selectedModel: clearModel ? null : (selectedModel ?? this.selectedModel),
      selectedYear: clearYear ? null : (selectedYear ?? this.selectedYear),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
