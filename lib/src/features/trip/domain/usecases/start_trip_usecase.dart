import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class StartTripUsecase {
  final ITripRepository _repository;

  StartTripUsecase(this._repository);

  Future<Trip> call(Trip trip) => _repository.createTrip(trip);
}
