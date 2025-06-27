enum Flavor {
  develop,
  staging,
  product,
}

enum AppLocale {
  en,
  es,
  fr,
  ja,
  ko,
  vi,
  zh,
}

enum SplashScreenType {
  custom,
  gif,
  fadeIn,
  scale,
  dynamicNextScreenFadeIn,
  usingBackgroundImage,
  usingGradient,
  lottieAnimation,
}

class AppEnum {
  static const String envDir = 'env';
  static const String libDir = 'lib';
  static const String langDir = '$libDir/l10n';
  static const String sourceDir = '$libDir/src';
  static const String configsDir = 'configs';

  static const String coreFolder = 'core';
  static const String coreDir = '$sourceDir/$coreFolder';
  static const String dataFolder = 'data';
  static const String dataDir = '$sourceDir/$dataFolder';
  static const String domainFolder = 'domain';
  static const String domainDir = '$sourceDir/$domainFolder';
  static const String presentationFolder = 'presentation';
  static const String presentationDir = '$sourceDir/$presentationFolder';

  static const String routesFolder = 'routes';
  static const String routesDir = '$coreDir/$routesFolder';

  static const String dataSourcesFolder = 'datasources';
  static const String dataSourcesDir = '$dataDir/$dataSourcesFolder';
  static const String dataSourcesImplFolder = 'implementations';
  static const String dataSourcesImplDir = '$dataSourcesDir/$dataSourcesImplFolder';
  static const String dataSourcesCollectionsFolder = 'collections';
  static const String dataSourcesCollectionsDir = '$dataSourcesDir/$dataSourcesCollectionsFolder';
  static const String modelsFolder = 'models';
  static const String modelsDir = '$dataDir/$modelsFolder';
  static const String repositoriesImplFolder = 'repositories';
  static const String repositoriesImplDir = '$dataDir/$repositoriesImplFolder';

  static const String entitiesFolder = 'entities';
  static const String entitiesDir = '$domainDir/$entitiesFolder';
  static const String repositoriesFolder = 'repositories';
  static const String repositoriesDir = '$domainDir/$repositoriesFolder';
  static const String usecasesFolder = 'usecases';
  static const String usecasesDir = '$domainDir/$usecasesFolder';
  static const String usecaseParamsFolder = 'params';
  static const String usecaseParamsDir = '$usecasesDir/$usecaseParamsFolder';

  static const String blocsFolder = 'blocs';
  static const String blocsDir = '$presentationDir/$blocsFolder';
  static const String screensFolder = 'screens';
  static const String screensDir = '$presentationDir/$screensFolder';
  static const String widgetsFolder = 'widgets';
  static const String widgetsDir = '$presentationDir/$widgetsFolder';
}
