import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class UpdateTripUsecase {
  final ITripRepository _repository;

  UpdateTripUsecase(this._repository);
  Future<Trip> call(String tripId, double currentKm, TripVehicleState state) =>
      _repository.updateTrip(tripId, currentKm, state);
}
