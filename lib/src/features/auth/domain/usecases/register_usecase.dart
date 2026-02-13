import 'package:dartz/dartz.dart';
import 'package:kappa/src/features/auth/domain/entities/auth_entity.dart';
import 'package:kappa/src/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Exception, AuthUserEntity>> call(String email, String password) {
    return repository.register(email, password);
  }
}
