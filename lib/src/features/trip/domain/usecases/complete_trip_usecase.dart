import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class CompleteTripUsecase {
  final ITripRepository _repository;

  CompleteTripUsecase(this._repository);
  Future<Trip> call(String tripId, DateTime completedAt) =>
      _repository.completeTrip(tripId, completedAt);
}
