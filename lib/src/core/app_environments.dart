import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart' as p;

class AppEnvironments {
  AppEnvironments._();

  static final String appName = '${dotenv.env['APP_NAME']}';
  static final String appKey = '${dotenv.env['APP_KEY']}';

  static final String appLocalePath = '${dotenv.env['APP_LOCALE_PATH']}';
  static final String appLocale = '${dotenv.env['APP_LOCALE']}';
  static final String appFallbackLocale = '${dotenv.env['APP_FALLBACK_LOCALE']}';
  static final String appSupportedLocales = '${dotenv.env['APP_SUPPORTED_LOCALES']}';

  static final String appBaseURL = '${dotenv.env['APP_BASE_URL']}';
  static final String appApiPrefix = '${dotenv.env['APP_API_PREFIX']}';

  static String get appEnv => const String.fromEnvironment('FLAVOR', defaultValue: "develop");

  static String get appApiURL => p.join(appBaseURL, appApiPrefix);
}
