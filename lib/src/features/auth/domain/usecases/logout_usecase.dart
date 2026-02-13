import 'package:dartz/dartz.dart';
import 'package:kappa/src/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Exception, void>> call() {
    return repository.logout();
  }
}
