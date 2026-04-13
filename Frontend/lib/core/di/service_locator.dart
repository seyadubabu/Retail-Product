import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../../features/pricing/data/datasources/local_datasource.dart';
import '../../features/pricing/data/datasources/remote_datasource.dart';
import '../../features/pricing/data/repositories/pricing_repository_impl.dart';
import '../../features/pricing/presentation/bloc/pricing_bloc.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  await Hive.initFlutter();

  sl.registerLazySingleton(() => DioClient());
  sl.registerLazySingleton(() => NetworkInfo());
  sl.registerLazySingleton(() => RemoteDataSource(sl()));
  sl.registerLazySingleton(() => LocalDataSource());
  sl.registerLazySingleton(() => PricingRepositoryImpl(sl(), sl(), sl()));
  sl.registerFactory(() => PricingBloc(sl()));
  if (kDebugMode) {
    print("DI Initialized");
  }
}