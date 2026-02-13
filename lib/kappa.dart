import 'package:kappa/src/core/config/app_config.dart'; // New import for AppConfig
import 'package:kappa/src/core/logging/i_logger.dart';

// ... (rest of imports)

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
    } catch (e, stackTrace) { // Add stackTrace to catch block
      SL.call<ILogger>().error("Kappa initialization failed: $e", error: e, stackTrace: stackTrace);
      throw KappaInitializationException('Failed to initialize Kappa: ${e.toString()}');
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

    /// Load the environment variables and AppConfig
    HttpOverrides.global = KappaHttpOverrides();
    final AppConfig appConfig = await _loadEnv(); // Get AppConfig here

    /// Initialize the core service locator
    await SL.initBaseServices(appConfig: appConfig); // Pass AppConfig to initBaseServices
    await SL.call<LocalDatabase>().initialize(schemas ?? []);

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
      // Pass the flavor from appConfig if needed, or the raw env vars
      await beforeRunApp.call(dotenv.env); 
    }
  }

  /// Loads the environment variables from the .env file and returns AppConfig.
  static Future<AppConfig> _loadEnv() async { // Changed return type
    String envFile = '.env';
    const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'develop');
    if (flavor.isNotEmpty) {
      envFile = '.env.$flavor';
    }
    // AppFlavor.flavor = AppFlavor.fromString(flavor); // Removed, handled by AppConfig
    await dotenv.load(fileName: p.join(AppEnum.envDir, envFile));
    return AppConfig.fromEnv(); // Return AppConfig
  }
}
