import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/features/garage/domain_exports.dart';
import 'package:vehicle_tracker/src/features/garage/state/garage_state.dart';

class GarageController {
  final GetBrandsUseCase _getBrandsUseCase;

  final ionState = Ion<GarageState>(GarageState());

  GarageController(this._getBrandsUseCase);

  Future<void> fetchBrands() async {
    ionState.set(ionState.state.copyWith(status: .loading));

    try {
      final fetchedBrands = await _getBrandsUseCase();

      ionState.set(
        ionState.state.copyWith(status: .success, brands: fetchedBrands),
      );
    } catch (e) {
      ionState.set(
        ionState.state.copyWith(status: .error, errorMessage: e.toString()),
      );
    }
  }
}
