import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class GetInProgressTripsUsecase {
  final ITripRepository _repository;

  GetInProgressTripsUsecase(this._repository);

  Future<List<Trip>> call(String userId) =>
      _repository.getInProgressTrips(userId);
}
