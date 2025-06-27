import 'package:isar/isar.dart';

import '../../../../kappa.dart';

/// A custom exception class for database errors.
///
/// This class extends the `Equatable` and `Exception` classes.
///
/// The `message` property is a string that holds the error message.
///
/// The `DatabaseException.fromIsarError` constructor takes an `IsarError` object
/// and initializes the `message` property with the error message from the `IsarError`.
///
/// The `props` getter returns a list containing the `message` property.
class DatabaseException extends BaseException {
  late final String message;

  DatabaseException.fromIsarError(IsarError isarError) : message = isarError.message;

  @override
  List<Object?> get props => [message];
}
