import 'app_enum.dart';

class AppFlavor {
  static Flavor? flavor;

  static String get name => flavor?.name ?? '';

  static String get title {
    switch (flavor) {
      case Flavor.staging:
        return 'Staging';
      case Flavor.product:
        return 'Product';
      default:
        return 'Develop';
    }
  }

  static String get description {
    switch (flavor) {
      case Flavor.staging:
        return 'Staging environment';
      case Flavor.product:
        return 'Production environment';
      default:
        return 'Development environment';
    }
  }

  static int get color {
    switch (flavor) {
      case Flavor.staging:
        return 0xFF003D65;
      case Flavor.product:
        return 0xFF066300;
      default:
        return 0xFF7300AC;
    }
  }

  static void set(dynamic name) {
    if (name is Flavor) {
      flavor = name;
      return;
    }
    flavor = fromString(name as String);
  }

  static List<String> toList() {
    return Flavor.values.map((e) => e.name).toList();
  }

  static Map<String, Flavor> toMap() {
    return Map.fromEntries(Flavor.values.map((e) => MapEntry(e.name, e)));
  }

  static Flavor fromString(String? name) {
    return toMap()[name] ?? Flavor.develop;
  }

  static String nameTag(String? name) {
    switch (name) {
      case 'develop':
        return 'dev';
      case 'staging':
        return 'stg';
      default:
        return '';
    }
  }

  static String get nameTagged => nameTag(name);
}
