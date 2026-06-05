import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class TripState {
  final TripStatus status;
  final TripVehicleState vehicleState;
  final Trip? trip;
  final List<Trip>? trips;
  final String? errorMessage;
  final bool isLoading;

  TripState({
    required this.status,
    required this.vehicleState,
    this.trip,
    this.trips,
    this.errorMessage,
    this.isLoading = false,
  });

  factory TripState.initial() =>
      TripState(status: .pending, vehicleState: .parked, isLoading: false);

  TripState copyWith({
    TripStatus? status,
    TripVehicleState? vehicleState,
    Trip? trip,
    List<Trip>? trips,
    String? errorMessage,
    bool? isLoading,
  }) {
    return TripState(
      status: status ?? this.status,
      vehicleState: vehicleState ?? this.vehicleState,
      trip: trip ?? this.trip,
      trips: trips ?? this.trips,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
