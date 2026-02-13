import 'package:flutter/material.dart';

class KappaUI {
  KappaUI._();

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar(
    String message, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    scaffoldMessengerKey.currentState?.clearSnackBars();
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showError(String message) {
    showSnackBar(message, backgroundColor: Colors.redAccent);
  }

  static void showSuccess(String message) {
    showSnackBar(message, backgroundColor: Colors.green);
  }
}
