import 'package:get_it/get_it.dart';

import '../../core/core_exports.dart';
import '../../features/garage/garage_data_exports.dart';
import '../../features/garage/garage_domain_exports.dart';
import '../../features/garage/presentation/controllers/garage_controller.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<HttpClient>(() => HttpClient());

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
