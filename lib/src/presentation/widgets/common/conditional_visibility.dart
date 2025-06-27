import 'package:flutter/material.dart';

import '../../../../kappa.dart';

class ConditionalVisibility extends StatelessWidget {
  final bool condition;
  final Widget? passed;
  final Widget? failed;

  const ConditionalVisibility({
    super.key,
    required this.condition,
    this.passed = const SizedBox(),
    this.failed = const SizedBox(),
  });

  @override
  Widget build(BuildContext context) {
    return Conditional<Widget>(
      condition: condition,
      passed: passed ?? const SizedBox(),
      failed: failed ?? const SizedBox(),
    ).value as Widget;
  }
}
