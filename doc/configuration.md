# Configuration Management

The Kappa Framework provides a robust and centralized way to manage application configurations for various environments (development, staging, production, etc.) using `.env` files and the `AppConfig` class.

## 1. Environment Variables (`.env` files)

Environment variables are loaded from `.env` files located in the project root. The framework automatically loads the correct `.env` file based on the `FLAVOR` build argument.

*   **File Naming Convention:**
    *   `./.env`: Default environment variables (fallback if no specific flavor is found).
    *   `./.env.<flavor_name>`: Specific environment variables for a given `FLAVOR`.
        *   Example: For `FLAVOR=develop`, it will try to load `./.env.develop`. If not found, it falls back to `./.env`.

*   **Loading Mechanism:**
    The `Kappa.ensureInitialized` method automatically handles loading these files via `flutter_dotenv`.

*   **Example `.env.develop`:**
    ```dotenv
    BASE_URL=http://dev.api.yourdomain.com
    API_KEY=your_dev_api_key_123
    ENABLE_ANALYTICS=false
    # Add other environment-specific variables here
    ```

*   **Example `.env.production`:**
    ```dotenv
    BASE_URL=https://api.yourdomain.com
    API_KEY=your_prod_api_key_ABC
    ENABLE_ANALYTICS=true
    # Add other environment-specific variables here
    ```

## 2. Centralized Configuration (`AppConfig`)

The `AppConfig` class (`lib/src/core/config/app_config.dart`) provides a type-safe and convenient way to access configuration values throughout your application.

*   **Definition:**
    ```dart
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

      factory AppConfig.fromEnv() {
        return AppConfig(
          baseUrl: dotenv.env['BASE_URL'] ?? 'http://localhost:8080',
          apiKey: dotenv.env['API_KEY'] ?? 'default_api_key',
          enableAnalytics: dotenv.env['ENABLE_ANALYTICS']?.toLowerCase() == 'true',
          appFlavor: dotenv.env['FLAVOR'] ?? 'develop', // Default value from dotenv.env
        );
      }

      static const AppConfig defaultConfig = AppConfig(
        baseUrl: 'http://localhost:8080',
        apiKey: 'default_api_key',
        enableAnalytics: false,
        appFlavor: 'develop',
      );
    }
    ```

*   **Loading and Accessibility:**
    1.  The `_loadEnv()` method in `lib/kappa.dart` loads the appropriate `.env` file.
    2.  It then creates an `AppConfig` instance using `AppConfig.fromEnv()`.
    3.  This `AppConfig` instance is registered as a `LazySingleton` in the Dependency Injection system (`lib/src/injector.dart`).

*   **Accessing Configuration Values:**
    You can retrieve the `AppConfig` instance anywhere in your application via the Service Locator (`SL`):

    ```dart
    import 'package:kappa/kappa.dart'; // Or specific import for AppConfig

    // ... inside a class or function where you need config
    final AppConfig config = SL.call<AppConfig>();

    // Access values
    print('Base URL: ${config.baseUrl}');
    print('API Key: ${config.apiKey}');
    print('Analytics Enabled: ${config.enableAnalytics}');
    ```

## 3. Build Flavors

Flutter build flavors (`--dart-define=FLAVOR=<flavor_name>`) are used to select the correct `.env` file and set the `appFlavor` in `AppConfig`.

Example build command for the `develop` flavor:

```bash
flutter run --flavor develop --dart-define=FLAVOR=develop -t lib/main_develop.dart
```

By centralizing configuration management, the Kappa Framework ensures a consistent and type-safe approach to handling environment-specific settings, improving application reliability and developer productivity.
