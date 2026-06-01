import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';
import 'package:vehicle_tracker/src/features/garage/state/garage_state.dart';

class GarageController extends Ion<GarageState> {
  final GetMyGarageUsecase _getMyGarageUsecase;

  GarageController(this._getMyGarageUsecase) : super(.initial());

  Future<void> fetchVehicles() async {
    set(state.copyWith(status: .loading));

    try {
      final list = await _getMyGarageUsecase();
      set(
        state.copyWith(
          status: .success,
          vehicles: list,
          filteredVehicles: list,
        ),
      );
    } catch (e) {
      set(
        state.copyWith(
          status: .error,
          errorMessage: 'Erro ao carregar sua garagem: $e',
        ),
      );
    }
  }

  void filterVehicles(String query) {
    if (query.isEmpty) {
      set(state.copyWith(filteredVehicles: state.vehicles));
      return;
    }

    final filtered = state.vehicles.where((vehicle) {
      final matchModel = vehicle.model.toLowerCase().contains(
        query.toLowerCase(),
      );
      final matchBrand = vehicle.brand.toLowerCase().contains(
        query.toLowerCase(),
      );
      final matchPlate = vehicle.plate.toLowerCase().contains(
        query.toLowerCase(),
      );
      return matchModel || matchBrand || matchPlate;
    }).toList();

    set(state.copyWith(filteredVehicles: filtered));
  }
}
