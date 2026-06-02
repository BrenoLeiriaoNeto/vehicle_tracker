import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';

class VehicleModel extends Vehicle {
  VehicleModel({
    required super.plate,
    required super.brand,
    required super.model,
    required super.year,
    required super.currentKm,
    super.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'plate': plate,
      'brand': brand,
      'model': model,
      'year': year,
      'currentKm': currentKm,
      'status': status,
    };
  }

  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      plate: map['plate'] as String,
      brand: map['brand'] as String,
      model: map['model'] as String,
      year: map['year'] as String,
      currentKm: (map['currentKm'] as num).toDouble(),
      status: map['status'] as String? ?? 'available',
    );
  }
}
