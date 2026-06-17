import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class WatchTripUsecase {
  final ITripRepository _repository;

  WatchTripUsecase(this._repository);
  Stream<Trip?> call(String userId) => _repository.watchActiveTrip(userId);
}
