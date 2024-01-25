import 'package:alphawash/data/repository/auth_repo.dart';
import 'package:alphawash/data/repository/location_repo.dart';
import 'package:alphawash/data/repository/onboarding_repo.dart';
import 'package:alphawash/data/repository/profile_repo.dart';
import 'package:alphawash/data/repository/report_repo.dart';
import 'package:alphawash/data/repository/splash_repo.dart';
import 'package:alphawash/data/repository/worker/worker_area_repo.dart';
import 'package:alphawash/data/repository/worker_repo.dart';
import 'package:alphawash/provider/ReportProvider.dart';
import 'package:alphawash/provider/auth_provider.dart';
import 'package:alphawash/provider/localization_provider.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/provider/onboarding_provider.dart';
import 'package:alphawash/provider/profile_provider.dart';
import 'package:alphawash/provider/splash_provider.dart';
import 'package:alphawash/provider/theme_provider.dart';
import 'package:alphawash/provider/worker/worker_area_provider.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/utill/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';
import 'package:dio/dio.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.BASE_URL, sl(), loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(() => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => AuthRepo(dioClient: sl()));
  sl.registerLazySingleton(() => ProfileRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => LocationRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => WorkerRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => OnBoardingRepo(dioClient: sl()));
  sl.registerLazySingleton(() => WorkerAreaRepo(dioClient: sl()));
  sl.registerLazySingleton(() => ReportRepo(dioClient: sl()));

  // CUSTOMER
  sl.registerFactory(() => SplashProvider(splashRepo: sl()));
  sl.registerFactory(() => CustomerAuthProvider(authRepo: sl()));
  sl.registerFactory(() => ProfileProvider(profileRepo: sl()));
  sl.registerFactory(() => LocationProvider(locationRepo: sl()));
  sl.registerFactory(() => LocalizationProvider(sharedPreferences: sl()));
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerFactory(() => WorkerProvider(workerRepo: sl()));
  sl.registerFactory(() => OnBoardingProvider(onboardingRepo: sl()));
  sl.registerFactory(() => WorkerAreaProvider(workerAreaRepo: sl()));
  sl.registerFactory(() => ReportProvider(reportRepo: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
