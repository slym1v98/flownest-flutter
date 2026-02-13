import 'package:dartz/dartz.dart';
import 'package:kappa/kappa.dart';
import 'package:kappa/src/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<BaseException, AuthUserEntity>> login(String email, String password);
  Future<Either<BaseException, AuthUserEntity>> register(String email, String password);
  Future<Either<BaseException, void>> logout();
  Future<Either<BaseException, AuthUserEntity>> getAuthStatus();
}
