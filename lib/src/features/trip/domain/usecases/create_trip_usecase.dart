import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class CreateTripUsecase {
  final ITripRepository _repository;

  CreateTripUsecase(this._repository);

  Future<Trip> call(Trip trip) => _repository.createTrip(trip);
}
