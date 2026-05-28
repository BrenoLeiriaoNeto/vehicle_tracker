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
