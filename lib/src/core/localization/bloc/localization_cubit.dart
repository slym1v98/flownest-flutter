import 'dart:ui';

import '../../../../kappa.dart';

part 'localization_state.dart';

class LocalizationCubit extends BaseHydratedCubit<LocalizationState> {
  LocalizationCubit() : super(LocalizationState());

  void toggleLocale(String languageCode) {
    SL.call<LocalStorage>().set(SL.call<LocalStorage>().localeKey, languageCode);

    emit(
      LocalizationState(
        locale: Locale.fromSubtags(languageCode: languageCode),
        supportedLocales: state.supportedLanguages,
      ),
    );
  }

  @override
  LocalizationState? fromJson(Map<String, dynamic> json) {
    return LocalizationState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(LocalizationState state) {
    return state.toMap();
  }
}
