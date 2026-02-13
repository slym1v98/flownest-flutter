part of '../kappa.dart';

// Core interfaces and their implementations
import 'package:dio/dio.dart';
import 'package:kappa/src/core/config/app_config.dart'; // New Import
import 'package:kappa/src/core/logging/console_logger.dart';
import 'package:kappa/src/core/logging/i_logger.dart';
import 'package:kappa/src/core/network/dio_http_client.dart';
import 'package:kappa/src/core/network/i_http_client.dart';
import 'package:kappa/src/core/storage/flutter_secure_storage_local_storage.dart';
import 'package:kappa/src/core/storage/i_local_secure_storage.dart';
import 'package:kappa/src/core/storage/i_local_storage.dart';
import 'package:kappa/src/core/storage/shared_preferences_local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import for SharedPreferences.getInstance()


/// Dependency injection configuration and service locator setup.
///
/// Provides:
/// - [injector]: Global GetIt instance for dependency injection
/// - [SL]: Service Locator class with convenient service access
///   - [call]: Generic method to retrieve registered services
///   - [initBaseServices]: Initializes core services including:
///     - Network client (DioClient)
///     - Local storage (LocalDatabase, LocalStorage)
///     - Common state management (ConnectivityBloc, LoaderCubit, etc.)

final injector = GetIt.instance;

class SL {
  static Service call<Service extends Object>() => injector<Service>();

  static Future<void> initBaseServices({required AppConfig appConfig}) async { // Modified signature
    // Register AppConfig first
    injector.registerLazySingleton<AppConfig>(() => appConfig);

    // Register ILogger
    injector.registerLazySingleton<ILogger>(() => ConsoleLogger());

    // Register Dio instance (configured with baseUrl from AppConfig)
    injector.registerLazySingleton<Dio>(() {
      final dio = Dio(BaseOptions(baseUrl: appConfig.baseUrl)); // Use baseUrl from AppConfig
      // Add any interceptors or base options here if needed
      return dio;
    });

    // Register IHttpClient with DioHttpClient implementation
    injector.registerLazySingleton<IHttpClient>(() => DioHttpClient(injector<Dio>()));

    // Register ILocalStorage with SharedPreferencesLocalStorage implementation
    final sharedPrefsStorage = SharedPreferencesLocalStorage();
    await sharedPrefsStorage.init(); // Initialize SharedPreferences
    injector.registerSingleton<ILocalStorage>(sharedPrefsStorage);

    // Register ILocalSecureStorage with FlutterSecureStorageLocalStorage implementation
    injector.registerLazySingleton<ILocalSecureStorage>(() => FlutterSecureStorageLocalStorage());

    // --- Existing Registrations (adjust if they should use new interfaces) ---
    // If LocalDatabase, LocalStorage, LocalSecureStorage are meant to be concrete implementations
    // of our new interfaces, they should be updated or removed.
    // For now, let's keep them as they are and assume they are distinct or will be refactored.

    // Existing: Local Database for local storage (Isar likely)
    injector.registerLazySingleton<LocalDatabase>(LocalDatabase.new);

    // Existing: LocalizationCubit, etc.
    injector
      ..registerLazySingleton<ConnectivityBloc>(ConnectivityBloc.new)
      ..registerLazySingleton<LoaderCubit>(LoaderCubit.new)
      ..registerLazySingleton<ThemeCubit>(ThemeCubit.new)
      ..registerLazySingleton<LocalizationCubit>(LocalizationCubit.new);
  }

  static void initFeatureServices(void Function(GetIt i) registration) {
    registration(injector);
  }

  static void initAuthFeature() {
    // Auth Feature Registrations
    injector.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(injector<IHttpClient>()));
    injector.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(injector<ILocalSecureStorage>()));
    injector.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
          remoteDataSource: injector<AuthRemoteDataSource>(),
          localDataSource: injector<AuthLocalDataSource>(),
        ));

    // Auth Use Cases
    injector.registerLazySingleton<LoginUseCase>(() => LoginUseCase(injector<AuthRepository>()));
    injector.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(injector<AuthRepository>()));
    injector.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(injector<AuthRepository>()));
    injector.registerLazySingleton<GetAuthStatusUseCase>(() => GetAuthStatusUseCase(injector<AuthRepository>()));

    // Auth Bloc
    injector.registerFactory<AuthBloc>(() => AuthBloc(
          loginUseCase: injector<LoginUseCase>(),
          registerUseCase: injector<RegisterUseCase>(),
          logoutUseCase: injector<LogoutUseCase>(),
          getAuthStatusUseCase: injector<GetAuthStatusUseCase>(),
        ));
  }
}
