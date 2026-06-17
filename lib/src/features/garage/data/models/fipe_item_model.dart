import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';

class FipeItemModel extends FipeItem {
  FipeItemModel({required super.codigo, required super.nome});

  factory FipeItemModel.fromJson(Map<String, dynamic> json) {
    return FipeItemModel(
      codigo: json['code'].toString(),
      nome: json['name'] as String,
    );
  }
}
