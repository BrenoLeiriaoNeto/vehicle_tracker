import 'package:vehicle_tracker/src/features/auth/auth_domain_exports.dart';
import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class GetTrips {
  final ITripRepository _repository;
  final IAuthRepository _authRepository;

  GetTrips(this._repository, this._authRepository);

  Future<List<Trip>> call() {
    final userId = _authRepository.getCurrentUserId();

    return _repository.getTrips(userId);
  }
}
