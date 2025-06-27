import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/foundation.dart';

class Logger {
  static final _success = AnsiPen()..green();
  static final _error = AnsiPen()..red();
  static final _warning = AnsiPen()..yellow();
  static final _info = AnsiPen()..blue();
  static final _debug = AnsiPen()..gray();

  // Log levels
  static const int lDebug = 0;
  static const int lInfo = 1;
  static const int lWarning = 2;
  static const int lError = 3;

  static int _currentLevel = lInfo;

  static void setLevel(int level) {
    _currentLevel = level;
  }

  static void success(String message, {String? prefix}) {
    if (kDebugMode) {
      final now = DateTime.now();
      final time = '${now.hour}:${now.minute}:${now.second}';
      print(_success('[✓ SUCCESS] [$time] ${prefix ?? ''} $message'));
    }
  }

  static void error(String message, {String? prefix, Object? error, StackTrace? stackTrace}) {
    if (_currentLevel <= lError) {
      final now = DateTime.now();
      final time = '${now.hour}:${now.minute}:${now.second}';
      if (kDebugMode) {
        print(_error('[✗ ERROR] [$time] ${prefix ?? ''} $message'));
      }
      if (error != null) {
        if (kDebugMode) {
          print(_error('[✗ ERROR] [$time]\n $error'));
        }
      }
      if (stackTrace != null) {
        if (kDebugMode) {
          print(_error('[✗ ERROR] [$time]\n $stackTrace'));
        }
      }
    }
  }

  static void warning(String message, {String? prefix}) {
    if (_currentLevel <= lWarning) {
      if (kDebugMode) {
        final now = DateTime.now();
        final time = '${now.hour}:${now.minute}:${now.second}';
        print(_warning('[⚠︎ WARNING] [$time] ${prefix ?? ''} $message'));
      }
    }
  }

  static void info(String message, {String? prefix}) {
    if (_currentLevel <= lInfo) {
      if (kDebugMode) {
        final now = DateTime.now();
        final time = '${now.hour}:${now.minute}:${now.second}';
        print(_info('[ⓘ INFO] [$time] ${prefix ?? ''} $message'));
      }
    }
  }

  static void debug(String message, {String? prefix}) {
    if (_currentLevel <= lDebug) {
      if (kDebugMode) {
        final now = DateTime.now();
        final time = '${now.hour}:${now.minute}:${now.second}';
        print(_debug('[DEBUG] [$time] ${prefix ?? ''} $message'));
      }
    }
  }

  static void progress(String message, {double? percentage}) {
    if (percentage != null) {
      final bar = _createProgressBar(percentage);
      if (kDebugMode) {
        print('\r$message: $bar ${percentage.toStringAsFixed(1)}%');
      }
    } else {
      if (kDebugMode) {
        print('\r$message...');
      }
    }
  }

  static String _createProgressBar(double percentage, {int width = 20}) {
    final completed = (percentage / 100 * width).round();
    final remaining = width - completed;
    return '[${'=' * completed}${' ' * remaining}]';
  }

  static void table(List<List<String>> rows, {List<String>? header}) {
    if (rows.isEmpty) return;

    // Add header if provided
    if (header != null) {
      rows.insert(0, header);
    }

    // Calculate column widths
    final columnWidths = List<int>.filled(rows[0].length, 0);
    for (var row in rows) {
      for (var i = 0; i < row.length; i++) {
        columnWidths[i] = (columnWidths[i] > row[i].length) ? columnWidths[i] : row[i].length;
      }
    }

    // Print rows
    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      final formattedRow = row.asMap().entries.map((entry) {
        final value = entry.value;
        final width = columnWidths[entry.key];
        return value.padRight(width);
      }).join(' | ');

      if (kDebugMode) {
        print(formattedRow);
      }

      // Print separator after header
      if (i == 0 && header != null) {
        if (kDebugMode) {
          print(columnWidths.map((w) => '-' * w).join('-+-'));
        }
      }
    }
  }
}
