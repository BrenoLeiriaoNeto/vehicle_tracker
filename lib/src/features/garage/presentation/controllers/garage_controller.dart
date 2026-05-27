import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/features/garage/domain_exports.dart';

class GarageState {
  final GarageStatus status;
  final List<BrandEntity> brands;
  final String errorMessage;

  GarageState({
    this.status = .initial,
    this.brands = const [],
    this.errorMessage = '',
  });

  GarageState copyWith({
    GarageStatus? status,
    List<BrandEntity>? brands,
    String? errorMessage,
  }) {
    return GarageState(
      status: status ?? this.status,
      brands: brands ?? this.brands,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

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
