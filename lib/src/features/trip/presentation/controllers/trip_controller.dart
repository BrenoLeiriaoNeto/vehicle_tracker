import 'dart:async';

import 'package:ionex/ionex.dart';
import 'package:vehicle_tracker/src/features/trip/state/trip_state.dart';
import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class TripController extends Ion<TripState> {
  final WatchTripUsecase _watchTripUsecase;
  final StartTripUsecase _startTripUsecase;
  final UpdateTripUsecase _updateTripUsecase;
  final GetTrips _getTrips;
  final CompleteTripUsecase _completeTripUsecase;

  StreamSubscription<Trip?>? _tripSubscription;

  TripController(
    this._watchTripUsecase,
    this._startTripUsecase,
    this._updateTripUsecase,
    this._getTrips,
    this._completeTripUsecase,
  ) : super(.initial());

  void watchTrip(String userId) {
    _tripSubscription?.cancel();

    set(state.copyWith(isLoading: true));

    _tripSubscription = _watchTripUsecase(userId).listen(
      (activeTrip) {
        if (activeTrip != null) {
          set(
            state.copyWith(
              trip: activeTrip,
              status: activeTrip.status,
              vehicleState: activeTrip.vehicleState,
              isLoading: false,
              errorMessage: null,
            ),
          );
        } else {
          set(
            state.copyWith(
              trip: null,
              status: .pending,
              vehicleState: .parked,
              isLoading: false,
            ),
          );
        }
      },
      onError: (e) {
        set(state.copyWith(errorMessage: e.toString(), isLoading: false));
      },
    );
  }

  Future<void> createTrip(Trip trip) async {
    set(state.copyWith(isLoading: true));

    try {
      final newTrip = await _startTripUsecase(trip);

      set(
        state.copyWith(
          status: .pending,
          vehicleState: .parked,
          trip: newTrip,
          isLoading: false,
        ),
      );
    } catch (e) {
      set(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> startTrip(
    String tripId,
    double currentKm,
    TripVehicleState vehicleState,
  ) async {
    set(state.copyWith(isLoading: true));
    try {
      await _updateTripUsecase(tripId, currentKm, vehicleState);
    } catch (e) {
      set(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> getMyTrips() async {
    try {
      final trips = await _getTrips();

      set(state.copyWith(trips: trips));
    } catch (e) {
      set(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> completeTrip(String tripId, DateTime completedAt) async {
    set(state.copyWith(isLoading: true));

    try {
      await _completeTripUsecase(tripId, completedAt);

      set(
        state.copyWith(
          status: .completed,
          vehicleState: .parked,
          trip: null,
          isLoading: false,
        ),
      );
    } catch (e) {
      set(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> stopVehicle(
    String tripId,
    double currentKm,
    TripVehicleState vehicleState,
  ) async {
    set(state.copyWith(isLoading: true));
    try {
      await _updateTripUsecase(tripId, currentKm, vehicleState);
    } catch (e) {
      set(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> resumeTrip(
    String tripId,
    double currentKm,
    TripVehicleState vehicleState,
  ) async {
    set(state.copyWith(isLoading: true));
    try {
      await _updateTripUsecase(tripId, currentKm, vehicleState);
    } catch (e) {
      set(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<bool> logoutClear() async {
    final hasActiveStream = _tripSubscription != null;

    if (hasActiveStream) {
      await _tripSubscription?.cancel();
      _tripSubscription = null;
    }

    set(.initial());

    return hasActiveStream;
  }

  @override
  void dispose() {
    _tripSubscription?.cancel();
    super.dispose();
  }
}
