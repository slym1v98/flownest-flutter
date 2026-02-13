// lib/src/core/config/app_config.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Represents the application configuration loaded from environment variables.
///
/// This class provides a centralized and type-safe way to access configuration
/// settings for different environments (development, production, etc.).
class AppConfig {
  final String baseUrl;
  final String apiKey;
  final bool enableAnalytics;
  final String appFlavor;

  const AppConfig({
    required this.baseUrl,
    required this.apiKey,
    required this.enableAnalytics,
    required this.appFlavor,
  });

  /// Loads the application configuration from the currently loaded environment variables.
  factory AppConfig.fromEnv() {
    return AppConfig(
      baseUrl: dotenv.env['BASE_URL'] ?? 'http://localhost:8080',
      apiKey: dotenv.env['API_KEY'] ?? 'default_api_key',
      enableAnalytics: dotenv.env['ENABLE_ANALYTICS']?.toLowerCase() == 'true',
      appFlavor: dotenv.env['FLAVOR'] ?? 'develop',
    );
  }

  /// Provides a default configuration when environment variables are not fully set.
  static const AppConfig defaultConfig = AppConfig(
    baseUrl: 'http://localhost:8080',
    apiKey: 'default_api_key',
    enableAnalytics: false,
    appFlavor: 'develop',
  );
}
