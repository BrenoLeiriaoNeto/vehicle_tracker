import 'package:vehicle_tracker/src/features/garage/domain_exports.dart';

class BrandModel extends BrandEntity {
  const BrandModel({required super.id, required super.name});

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(id: json['codigo'] ?? '', name: json['nome'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'codigo': id, 'nome': name};
  }
}
