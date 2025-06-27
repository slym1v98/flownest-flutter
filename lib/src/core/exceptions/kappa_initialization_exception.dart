import 'base_exception.dart';

class KappaInitializationException extends BaseException {
  late final String message;

  KappaInitializationException(this.message);

  @override
  List<Object?> get props => [message];
}
