import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vehicle_tracker/src/features/profile/profile_domain_exports.dart';

class ProfileModel extends Profile {
  ProfileModel({
    super.avatarUrl,
    super.bio,
    required super.tripsCompleted,
    required super.sumKilometers,
    required super.totalVehicles,
    super.memberSince,
  });

  Map<String, dynamic> toJson() {
    return {
      'avatarUrl': avatarUrl,
      'bio': bio,
      'tripsCompleted': tripsCompleted,
      'sumKilometers': sumKilometers,
      'totalVehicles': totalVehicles,
      'memberSince': memberSince != null
          ? Timestamp.fromDate(memberSince!)
          : null,
    };
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final timestamp = json['memberSince'] as Timestamp?;

    return ProfileModel(
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      tripsCompleted: (json['tripsCompleted'] as num?)?.toInt() ?? 0,
      sumKilometers: (json['sumKilometers'] as num?)?.toDouble() ?? 0.0,
      totalVehicles: (json['totalVehicles'] as num?)?.toInt() ?? 0,
      memberSince: timestamp?.toDate(),
    );
  }
}
