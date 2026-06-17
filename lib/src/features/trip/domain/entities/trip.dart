import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class Trip {
  final String id;
  final String userId;
  final String vehicleId;
  final String vehicleName;
  final String origin;
  final String destination;
  final double totalDistance;
  final double currentKm;
  final TripStatus status;
  final TripVehicleState vehicleState;
  final DateTime? startedAt;
  final DateTime? completedAt;

  const Trip({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.vehicleName,
    required this.origin,
    required this.destination,
    required this.totalDistance,
    required this.currentKm,
    required this.status,
    required this.vehicleState,
    this.startedAt,
    this.completedAt,
  });

  double get remainingDistance {
    final diff = totalDistance - currentKm;
    return diff > 0 ? diff : 0.0;
  }

  double get progress {
    if (totalDistance <= 0) return 0.0;
    final prg = currentKm / totalDistance;
    return prg > 1.0 ? 1.0 : prg;
  }

  String get progressPercentage => (progress * 100).toStringAsFixed(0);
}
