import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';
import 'package:vehicle_tracker/src/features/profile/profile_domain_exports.dart';
import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class CompleteTripUsecase {
  final ITripRepository _tripRepository;
  final IVehicleRepository _vehicleRepository;
  final IProfileRepository _profileRepository;

  CompleteTripUsecase(
    this._tripRepository,
    this._vehicleRepository,
    this._profileRepository,
  );
  Future<Trip> call(String tripId, DateTime completedAt, double finalKm) async {
    final completedTrip = await _tripRepository.completeTrip(
      tripId,
      completedAt,
      finalKm,
    );

    final kmsDriven = completedTrip.currentKm;
    final userId = completedTrip.userId;
    final vehicleId = completedTrip.vehicleId;

    await Future.wait([
      _vehicleRepository.updateVehicleMileageAfterTrip(vehicleId, kmsDriven),
      _profileRepository.updateProfileStatsAfterTrip(userId, kmsDriven),
    ]);

    return completedTrip;
  }
}
