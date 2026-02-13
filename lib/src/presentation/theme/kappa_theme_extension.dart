import 'package:flutter/material.dart';

class KappaThemeExtension extends ThemeExtension<KappaThemeExtension> {
  final Color? success;
  final Color? warning;
  final Color? info;
  final Color? cardBackground;

  const KappaThemeExtension({
    this.success,
    this.warning,
    this.info,
    this.cardBackground,
  });

  @override
  KappaThemeExtension copyWith({
    Color? success,
    Color? warning,
    Color? info,
    Color? cardBackground,
  }) {
    return KappaThemeExtension(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      cardBackground: cardBackground ?? this.cardBackground,
    );
  }

  @override
  KappaThemeExtension lerp(ThemeExtension<KappaThemeExtension>? other, double t) {
    if (other is! KappaThemeExtension) return this;
    return KappaThemeExtension(
      success: Color.lerp(success, other.success, t),
      warning: Color.lerp(warning, other.warning, t),
      info: Color.lerp(info, other.info, t),
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t),
    );
  }

  static const light = KappaThemeExtension(
    success: Color(0xFF4CAF50),
    warning: Color(0xFFFFC107),
    info: Color(0xFF2196F3),
    cardBackground: Colors.white,
  );

  static const dark = KappaThemeExtension(
    success: Color(0xFF81C784),
    warning: Color(0xFFFFD54F),
    info: Color(0xFF64B5F6),
    cardBackground: Color(0xFF1E1E1E),
  );
}
