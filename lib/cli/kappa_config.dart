class KappaConfig {
  final String appName;
  final AppLocaleConfig appLocale;
  final AppFlavorConfig appFlavor;
  final String launcherIcon;

  const KappaConfig({
    required this.appName,
    required this.appLocale,
    required this.appFlavor,
    required this.launcherIcon,
  });

  factory KappaConfig.fromMap(Map<dynamic, dynamic> map) => KappaConfig(
        appName: map['app_name'] as String,
        appLocale: AppLocaleConfig.fromMap(map['app_locale'] as Map<String, dynamic>),
        appFlavor: AppFlavorConfig.fromMap(map['app_flavor'] as Map<String, dynamic>),
        launcherIcon: map['launcher_icon'] as String,
      );

  Map<String, dynamic> toMap() => {
        'app_name': appName,
        'app_locale': appLocale.toMap(),
        'app_flavor': appFlavor.toMap(),
        'launcher_icon': launcherIcon,
      };

  @override
  String toString() =>
      'KappaConfig(appName: $appName, appLocale: $appLocale, appFlavor: $appFlavor, launcherIcon: $launcherIcon)';
}

class AppLocaleConfig {
  final String defaultLocale;
  final String fallback;
  final String path;
  final List<String> supported;

  const AppLocaleConfig({
    required this.defaultLocale,
    required this.fallback,
    required this.path,
    required this.supported,
  });

  factory AppLocaleConfig.fromMap(Map<String, dynamic> map) => AppLocaleConfig(
        defaultLocale: map['default'] as String,
        fallback: map['fallback'] as String,
        path: map['path'] as String,
        supported: List<String>.from(map['supported']),
      );

  Map<String, dynamic> toMap() => {
        'default': defaultLocale,
        'fallback': fallback,
        'path': path,
        'supported': supported,
      };

  Map<String, String> toStringMap() => {
        'appLocale': defaultLocale,
        'fallbackLocale': fallback,
        'appLocalePath': path,
        'supportedLocales': supported.join(','),
      };

  @override
  String toString() =>
      'AppLocale(defaultLocale: $defaultLocale, fallback: $fallback, path: $path, supported: $supported)';
}

class AppFlavorConfig {
  // final String defaultFlavor;
  // final Map<String, FlavorConfig> flavors;
  final String applicationId;
  final String bundleId;
  final bool macosSupported;

  const AppFlavorConfig({
    // required this.defaultFlavor,
    // required this.flavors,
    required this.applicationId,
    required this.bundleId,
    required this.macosSupported,
  });

  factory AppFlavorConfig.fromMap(Map<String, dynamic> map) => AppFlavorConfig(
        // defaultFlavor: map['default'] as String,
        // flavors: (map['flavors'] as Map<String, dynamic>).map(
        //   (key, value) => MapEntry(
        //     key,
        //     FlavorConfig.fromMap(value as Map<String, dynamic>),
        //   ),
        // ),
        applicationId: map['application_id'] as String,
        bundleId: map['bundle_id'] as String,
        macosSupported: map['macos_supported'] as bool,
      );

  Map<String, dynamic> toMap() => {
        // 'default': defaultFlavor,
        // 'flavors': flavors.map((key, value) => MapEntry(key, value.toMap())),
        'application_id': applicationId,
        'bundle_id': bundleId,
        'macos_supported': macosSupported,
      };

  @override
  String toString() =>
      'AppFlavor(applicationId: $applicationId, bundleId: $bundleId, macosSupported: $macosSupported)';
}

class FlavorConfig {
  final String title;
  final String description;
  final String color;
  final String alias;
  final bool showAlias;

  const FlavorConfig({
    required this.title,
    required this.description,
    required this.color,
    required this.alias,
    required this.showAlias,
  });

  factory FlavorConfig.fromMap(Map<String, dynamic> map) => FlavorConfig(
        title: map['title'] as String,
        description: map['description'] as String,
        color: map['color'] as String,
        alias: map['alias'] as String,
        showAlias: map['show_alias'] as bool,
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'color': color,
        'alias': alias,
        'show_alias': showAlias,
      };

  @override
  String toString() =>
      'FlavorConfig(title: $title, description: $description, color: $color, alias: $alias, showAlias: $showAlias)';
}
