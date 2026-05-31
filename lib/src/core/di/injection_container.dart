import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:vehicle_tracker/src/features/auth/auth_data_exports.dart';
import 'package:vehicle_tracker/src/features/auth/auth_domain_exports.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:vehicle_tracker/src/features/auth/presentation/controllers/signup_controller.dart';
import 'package:vehicle_tracker/src/features/dashboard/dashboard_data_exports.dart';
import 'package:vehicle_tracker/src/features/dashboard/dashboard_domain_exports.dart';
import 'package:vehicle_tracker/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:weather/weather.dart';

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
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<ThemeController>(() => ThemeController());

  // ===========================================================================
  // 📊 FEATURE - DASHBOARD
  // ===========================================================================
  sl.registerLazySingleton<WeatherFactory>(
    () => WeatherFactory(
      "14934eae224b12be05cf2933668c6b73",
      language: .PORTUGUESE_BRAZIL,
    ),
  );
  sl.registerFactory<DashboardController>(
    () => DashboardController(sl<GetTargetWeatherUsecase>()),
  );
  sl.registerLazySingleton<GetTargetWeatherUsecase>(
    () => GetTargetWeatherUsecase(sl<IWeatherRepository>()),
  );
  sl.registerLazySingleton<IWeatherRepository>(
    () => WeatherRepository(sl<WeatherFactory>()),
  );

  // ===========================================================================
  // 🔑 FEATURE - AUTH
  // ===========================================================================
  sl.registerLazySingleton<AuthController>(
    () => AuthController(sl<LoginWithEmailPasswordUsecase>()),
  );
  sl.registerLazySingleton<IAuthRepository>(
    () => AuthRepository(sl<FirebaseAuth>(), sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<LoginWithEmailPasswordUsecase>(
    () => LoginWithEmailPasswordUsecase(sl<IAuthRepository>()),
  );
  sl.registerLazySingleton<SignupWithEmailPassword>(
    () => SignupWithEmailPassword(sl<IAuthRepository>()),
  );

  sl.registerFactory<SignupController>(
    () => SignupController(sl<SignupWithEmailPassword>()),
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
