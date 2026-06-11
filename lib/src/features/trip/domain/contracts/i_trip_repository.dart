import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

abstract class ITripRepository {
  Future<Trip> createTrip(Trip trip);
  Future<Trip> updateTrip(
    String tripId,
    double currentKm,
    TripVehicleState state,
  );
  Future<Trip> completeTrip(String tripId, DateTime completedAt);
  Future<List<Trip>> getTripHistory(String userId);
  Future<List<Trip>> getTrips(String userId);
  Stream<Trip?> watchActiveTrip(String userId);
}
