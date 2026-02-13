import 'package:flutter/material.dart';
import 'kappa_theme_extension.dart';

class AppTheme {
  static ThemeData createTheme({
    required Brightness brightness,
    required Color primaryColor,
  }) {
    final bool isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorSchemeSeed: primaryColor,
      scaffoldBackgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      ),
      extensions: [
        isDark ? KappaThemeExtension.dark : KappaThemeExtension.light,
      ],
    );
  }

  // Fallback themes
  static final lightTheme = createTheme(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF2196F3),
  );

  static final darkTheme = createTheme(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF2196F3),
  );
}
