import 'package:flutter/material.dart';

class KappaPalette {
  final String name;
  final Color primary;
  final Color secondary;

  const KappaPalette({
    required this.name,
    required this.primary,
    required this.secondary,
  });
}

class AppPalettes {
  static const blue = KappaPalette(
    name: 'Ocean Blue',
    primary: Color(0xFF2196F3),
    secondary: Color(0xFF03A9F4),
  );

  static const green = KappaPalette(
    name: 'Nature Green',
    primary: Color(0xFF4CAF50),
    secondary: Color(0xFF8BC34A),
  );

  static const orange = KappaPalette(
    name: 'Sunset Orange',
    primary: Color(0xFFFF9800),
    secondary: Color(0xFFFFC107),
  );

  static const all = [blue, green, orange];
}
