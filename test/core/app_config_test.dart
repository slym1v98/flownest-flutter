import 'package:flutter_test/flutter_test.dart';
import 'package:kappa/src/core/config/app_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  group('AppConfig Tests', () {
    test('should return default values when dotenv is not loaded', () {
      final config = AppConfig.fromEnv();
      expect(config.baseUrl, 'http://localhost:8080');
      expect(config.appFlavor, 'develop');
    });

    test('defaultConfig should have correct values', () {
      const config = AppConfig.defaultConfig;
      expect(config.baseUrl, 'http://localhost:8080');
      expect(config.enableAnalytics, false);
    });
  });
}
