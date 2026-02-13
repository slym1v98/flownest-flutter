import 'package:dartz/dartz.dart';
import 'package:kappa/src/features/auth/domain/entities/auth_entity.dart';
import 'package:kappa/src/features/auth/domain/repositories/auth_repository.dart';

class GetAuthStatusUseCase {
  final AuthRepository repository;

  GetAuthStatusUseCase(this.repository);

  Future<Either<Exception, AuthUserEntity>> call() {
    return repository.getAuthStatus();
  }
}
