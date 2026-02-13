import 'package:flutter/material.dart';

import '../../../../kappa.dart';

part 'theme_state.dart';

class ThemeCubit extends BaseHydratedCubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  void toggleTheme() {
    emit(ThemeState(
      themeMode: state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
      primaryColorHex: state.primaryColorHex,
    ));
  }

  void setPrimaryColor(Color color) {
    emit(ThemeState(
      themeMode: state.themeMode,
      primaryColorHex: '0x${color.value.toRadixString(16).toUpperCase()}',
    ));
  }

  ThemeData getThemeData() {
    return AppTheme.createTheme(
      brightness: state.themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light,
      primaryColor: state.primaryColor,
    );
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    return ThemeState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return state.toMap();
  }
}
