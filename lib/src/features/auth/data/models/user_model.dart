import 'package:vehicle_tracker/src/features/auth/auth_domain_exports.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String documentId) {
    return UserModel(
      id: documentId,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? 'driver',
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'name': name, 'role': role};
  }
}
