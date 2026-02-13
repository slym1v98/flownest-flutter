import 'package:dartz/dartz.dart';
import 'package:kappa/src/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Exception, AuthUserEntity>> login(String email, String password);
  Future<Either<Exception, AuthUserEntity>> register(String email, String password);
  Future<Either<Exception, void>> logout();
  Future<Either<Exception, AuthUserEntity>> getAuthStatus();
}
