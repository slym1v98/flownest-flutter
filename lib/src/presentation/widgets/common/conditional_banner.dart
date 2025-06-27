import 'package:flutter/material.dart';

import '../../../../kappa.dart';

class ConditionalBanner extends StatelessWidget {
  final bool condition;
  final String message;
  final TextDirection? textDirection;
  final BannerLocation location;
  final TextDirection? layoutDirection;
  final Color color;
  final TextStyle textStyle;
  final Widget child;

  const ConditionalBanner({
    super.key,
    required this.condition,
    required this.child,
    required this.message,
    this.textDirection,
    required this.location,
    this.layoutDirection,
    this.color = const Color(0xA0B71C1C),
    this.textStyle = const TextStyle(
      color: Color(0xFFFFFFFF),
      fontSize: 12.0 * 0.85,
      fontWeight: FontWeight.w900,
      height: 1.0,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return ConditionalVisibility(
      condition: condition,
      passed: Banner(
        message: message,
        textDirection: textDirection,
        location: location,
        layoutDirection: layoutDirection,
        color: color,
        textStyle: textStyle,
        child: child,
      ),
      failed: child,
    );
  }
}
