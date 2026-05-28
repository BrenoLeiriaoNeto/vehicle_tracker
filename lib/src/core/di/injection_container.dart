import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:vehicle_tracker/src/features/auth/auth_data_exports.dart';
import 'package:vehicle_tracker/src/features/auth/auth_domain_exports.dart';

import '../../core/core_exports.dart';
import '../../features/garage/garage_data_exports.dart';
import '../../features/garage/garage_domain_exports.dart';
import '../../features/garage/presentation/controllers/garage_controller.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ===========================================================================
  // 🌐 CORE / INFRA
  // ===========================================================================
  sl.registerLazySingleton<HttpClient>(() => HttpClient());
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // ===========================================================================
  // 🔑 FEATURE - AUTH
  // ===========================================================================
  sl.registerLazySingleton<IAuthRepository>(
    () => AuthRepository(sl<FirebaseAuth>()),
  );
  sl.registerLazySingleton<LoginWithEmailPasswordUsecase>(
    () => LoginWithEmailPasswordUsecase(sl<IAuthRepository>()),
  );

  // ===========================================================================
  // 🚗 FEATURE - GARAGE
  // ===========================================================================
  sl.registerLazySingleton<IFipeDataSource>(
    () => FipeDataSource(sl<HttpClient>()),
  );
  sl.registerLazySingleton<IGarageRepository>(
    () => GarageRepository(sl<IFipeDataSource>()),
  );
  sl.registerLazySingleton<GetBrandsUseCase>(
    () => GetBrandsUseCase(sl<IGarageRepository>()),
  );
  sl.registerFactory<GarageController>(
    () => GarageController(sl<GetBrandsUseCase>()),
  );
}
