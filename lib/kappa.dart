library kappa;

import 'dart:async';
import 'dart:io' show Directory, HttpOverrides;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:isar/isar.dart';
import 'package:kappa/src/core/storage/local_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:path/path.dart' as p;
import 'package:upgrader/upgrader.dart';

import 'kappa_platform_interface.dart';
import 'src/core/core_exporter.dart';
import 'src/presentation/presentation_exporter.dart';

export 'src/core/core_exporter.dart';
export 'src/data/data_exporter.dart';
export 'src/domain/domain_exporter.dart';
export 'src/presentation/presentation_exporter.dart';

part 'src/injector.dart';

/// Core library for Kappa framework, providing application initialization and configuration.
///
/// Features:
/// - Environment configuration loading with fallback support
/// - Service locator initialization and dependency injection
/// - Local storage and secure storage setup
/// - Hydrated bloc storage configuration
/// - Material app setup with theming and routing
/// - Localization support
/// - Device orientation control
/// - App upgrade handling
/// - Error handling and graceful failure recovery
///
/// Usage:
/// Add in main.dart
/// await Kappa.ensureInitialized(
///   schemas: yourIsarSchemas,
///   lightTheme: yourLightTheme,
///   darkTheme: yourDarkTheme,
///   routerDelegate: yourRouterDelegate,
///   routeInformationParser: yourRouteInformationParser,
///   onInitServices: () async {
///     // Initialize your services
///   },
/// );
///
///
/// The framework automatically handles environment loading based on build flavor
/// and sets up all core services required for the application. It provides
/// fallback mechanisms for environment configurations and graceful error handling
/// during initialization.
class Kappa {
  Future<String?> getPlatformVersion() {
    return KappaPlatform.instance.getPlatformVersion();
  }

  /// Ensures the framework is initialized with the provided configurations.
  static Future<void> ensureInitialized({
    bool? ensureWFBInitialized = true,
    List<CollectionSchema<dynamic>>? schemas = const [],
    Directory? hydratedStorageDirectory,
    Future<void> Function()? onInitServices,
    ThemeData? lightTheme,
    ThemeData? darkTheme,
    List<SingleChildWidget> providers = const [],
    RouterDelegate<Object>? routerDelegate,
    RouteInformationParser<Object>? routeInformationParser,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    Size? designSize,
    DeviceOrientationType orientations = DeviceOrientationType.all,
    Future<void> Function(Map<String, String>)? beforeRunApp,
    Future<void> Function(BuildContext context)? onConnectivityFailure,
    Future<void> Function()? onAppForeground,
    Future<void> Function()? onAppBackground,
    Future<void> Function()? onAppDetached,
    UpgraderMessages? upgraderMessages,
  }) async {
    try {
      /// Load environment variables and initialize core services
      await _runApp(
        ensureWFBInitialized: ensureWFBInitialized,
        schemas: schemas,
        hydratedStorageDirectory: hydratedStorageDirectory,
        onInitServices: onInitServices,
        orientations: orientations,
        beforeRunApp: beforeRunApp,
      );

      /// Initialize the app
      runApp(KappaMaterialApp(
        lightTheme: lightTheme,
        darkTheme: darkTheme,
        routerDelegate: routerDelegate,
        routeInformationParser: routeInformationParser,
        localizationsDelegates: localizationsDelegates,
        providers: providers,
        designSize: designSize,
        onConnectivityFailure: onConnectivityFailure,
        onAppForeground: onAppForeground,
        onAppBackground: onAppBackground,
        onAppDetached: onAppDetached,
        upgraderMessages: upgraderMessages,
      ));
    } catch (e) {
      /// Add graceful error handling and logging
      throw KappaInitializationException(e.toString());
    }
  }

  static Future<void> _runApp({
    bool? ensureWFBInitialized = true,
    List<CollectionSchema<dynamic>>? schemas = const [],
    Directory? hydratedStorageDirectory,
    Future<void> Function()? onInitServices,
    DeviceOrientationType orientations = DeviceOrientationType.all,
    Future<void> Function(Map<String, String>)? beforeRunApp,
  }) async {
    if (ensureWFBInitialized == true) {
      WidgetsFlutterBinding.ensureInitialized();
    }

    /// Clear the saved settings for the upgrader alert dialog
    await Upgrader.clearSavedSettings();

    /// Load the environment variables
    HttpOverrides.global = KappaHttpOverrides();
    await _loadEnv();

    /// Initialize the core service locator
    await SL.initBaseServices();
    await SL.call<LocalDatabase>().initialize(schemas ?? []);
    SL.call<LocalStorage>().init();
    SL.call<LocalSecureStorage>().init();

    /// Initialize the storage for hydrated bloc
    Directory? storageDirectory = hydratedStorageDirectory;
    storageDirectory ??= await getApplicationDocumentsDirectory();
    HydratedBloc.storage = await HydratedStorage.build(storageDirectory: storageDirectory);

    /// Initialize the services
    if (onInitServices != null) {
      await onInitServices.call();
    }

    /// Set the device orientation
    if (DeviceOrientationSupporter.fromType(orientations).isNotEmpty) {
      await SystemChrome.setPreferredOrientations(DeviceOrientationSupporter.fromType(orientations));
    }

    /// Run the app
    if (beforeRunApp != null) {
      await beforeRunApp.call(dotenv.env);
    }
  }

  /// Loads the environment variables from the .env file.
  static Future<void> _loadEnv() async {
    String envFile = '.env';
    const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'develop');
    if (flavor.isNotEmpty) {
      envFile = '.env.$flavor';
    }
    AppFlavor.flavor = AppFlavor.fromString(flavor);
    await dotenv.load(fileName: p.join(AppEnum.envDir, envFile));
  }
}
