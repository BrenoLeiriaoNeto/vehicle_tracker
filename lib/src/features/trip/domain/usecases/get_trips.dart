import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class GetTrips {
  final ITripRepository _repository;

  GetTrips(this._repository);
  Future<List<Trip>> call(String userId) => _repository.getTripHistory(userId);
}
