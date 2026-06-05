import 'dart:convert';

import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class TripModel extends Trip {
  TripModel({
    required super.id,
    required super.userId,
    required super.vehicleId,
    required super.vehicleName,
    required super.origin,
    required super.destination,
    required super.totalDistance,
    required super.currentKm,
    required super.status,
    required super.vehicleState,
    super.startedAt,
    super.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'vehicleId': vehicleId,
      'vehicleName': vehicleName,
      'origin': origin,
      'destination': destination,
      'totalDistance': totalDistance,
      'currentKm': currentKm,
      'status': status.name,
      'vehicleState': vehicleState.name,
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory TripModel.fromMap(Map<String, dynamic> map) {
    return TripModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      vehicleId: map['vehicleId'] ?? '',
      vehicleName: map['vehicleName'] ?? '',
      origin: map['origin'] ?? '',
      destination: map['destination'] ?? '',
      totalDistance: (map['totalDistance'] as num).toDouble(),
      currentKm: (map['currentKm'] as num).toDouble(),
      status: TripStatus.values.byName(map['status'] ?? 'pending'),
      vehicleState: TripVehicleState.values.byName(
        map['vehicleState'] ?? 'parked',
      ),
      startedAt: map['startedAt'] != null
          ? DateTime.parse(map['startedAt'])
          : null,
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TripModel.fromJson(String source) =>
      TripModel.fromJson(json.decode(source));

  factory TripModel.fromEntity(Trip trip) {
    return TripModel(
      id: trip.id,
      userId: trip.userId,
      vehicleId: trip.vehicleId,
      vehicleName: trip.vehicleName,
      origin: trip.origin,
      destination: trip.destination,
      totalDistance: trip.totalDistance,
      currentKm: trip.currentKm,
      status: trip.status,
      vehicleState: trip.vehicleState,
      startedAt: trip.startedAt,
      completedAt: trip.completedAt,
    );
  }

  TripModel copyWith({
    double? currentKm,
    TripStatus? status,
    TripVehicleState? vehicleState,
    DateTime? completedAt,
  }) {
    return TripModel(
      id: id,
      userId: userId,
      vehicleId: vehicleId,
      vehicleName: vehicleName,
      origin: origin,
      destination: destination,
      totalDistance: totalDistance,
      currentKm: currentKm ?? this.currentKm,
      status: status ?? this.status,
      vehicleState: vehicleState ?? this.vehicleState,
      startedAt: startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
