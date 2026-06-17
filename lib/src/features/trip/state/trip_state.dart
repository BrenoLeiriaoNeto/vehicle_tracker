import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class TripState {
  final TripStatus status;
  final TripVehicleState vehicleState;
  final Trip? trip;
  final List<Trip> activeTrips;
  final List<Trip> historyTrips;
  final String? errorMessage;
  final bool isLoading;

  TripState({
    required this.status,
    required this.vehicleState,
    this.trip,
    this.activeTrips = const [],
    this.historyTrips = const [],
    this.errorMessage,
    this.isLoading = false,
  });

  factory TripState.initial() => TripState(
    status: .pending,
    vehicleState: .parked,
    isLoading: false,
    activeTrips: [],
    historyTrips: [],
  );

  TripState copyWith({
    TripStatus? status,
    TripVehicleState? vehicleState,
    Trip? trip,
    List<Trip>? activeTrips,
    List<Trip>? historyTrips,
    String? errorMessage,
    bool? isLoading,
  }) {
    return TripState(
      status: status ?? this.status,
      vehicleState: vehicleState ?? this.vehicleState,
      trip: trip ?? this.trip,
      activeTrips: activeTrips ?? this.activeTrips,
      historyTrips: historyTrips ?? this.historyTrips,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
