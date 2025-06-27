part of 'localization_cubit.dart';

class LocalizationState extends BaseState {
  late final Locale language;
  late final List<Locale> supportedLanguages;

  LocalizationState({Locale? locale, List<Locale>? supportedLocales}) {
    language = locale ??
        Locale.fromSubtags(
          languageCode:
              LocalStorage.storageInstance.get(LocalStorage().localeKey, defaultValue: AppEnvironments.appLocale) ??
                  AppEnvironments.appFallbackLocale,
        );
    supportedLanguages = supportedLocales ??
        AppEnvironments.appSupportedLocales.split(',').map((l) => Locale.fromSubtags(languageCode: l)).toList();
  }

  factory LocalizationState.fromMap(Map<String, dynamic> map) {
    return LocalizationState(
      locale: Locale.fromSubtags(languageCode: map['locale'] as String),
      supportedLocales:
          (map['supportedLocales'] as List).map((e) => Locale.fromSubtags(languageCode: e as String)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'locale': language.languageCode,
      'supportedLocales': supportedLanguages.map((e) => e.languageCode).toList(),
    };
  }

  @override
  List<Object> get props => [language, supportedLanguages];
}
