import '../../../../kappa.dart';

class LocalStorageException extends BaseException {
  final String message;

  LocalStorageException(this.message);

  @override
  String toString() {
    return 'LocalStorageException: $message';
  }

  @override
  List<Object?> get props => [message];
}
