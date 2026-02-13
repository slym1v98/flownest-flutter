/// An abstract interface for a logging utility.
/// This allows for different logging implementations (e.g., console logger, file logger).
abstract class ILogger {
  /// Logs a verbose message.
  void verbose(String message, [dynamic error, StackTrace? stackTrace]);

  /// Logs a debug message.
  void debug(String message, [dynamic error, StackTrace? stackTrace]);

  /// Logs an info message.
  void info(String message, [dynamic error, StackTrace? stackTrace]);

  /// Logs a warning message.
  void warning(String message, [dynamic error, StackTrace? stackTrace]);

  /// Logs an error message.
  void error(String message, [dynamic error, StackTrace? stackTrace]);
}
