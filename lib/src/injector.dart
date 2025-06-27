part of '../kappa.dart';

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
  static Service call<Service extends InjectableService>() => injector<Service>();

  static Future<void> initBaseServices() async {
    injector
      // DioClient for network requests
      ..registerLazySingleton<DioClient>(DioClient.new)

      // Local Database for local storage
      ..registerLazySingleton<LocalDatabase>(LocalDatabase.new)

      // Local Storage for shared preferences
      ..registerLazySingleton<LocalStorage>(LocalStorage.new)
      ..registerLazySingleton<LocalSecureStorage>(LocalSecureStorage.new)

      // Common
      ..registerLazySingleton<ConnectivityBloc>(ConnectivityBloc.new)
      ..registerLazySingleton<LoaderCubit>(LoaderCubit.new)
      ..registerLazySingleton<ThemeCubit>(ThemeCubit.new)
      ..registerLazySingleton<LocalizationCubit>(LocalizationCubit.new);
  }
}
