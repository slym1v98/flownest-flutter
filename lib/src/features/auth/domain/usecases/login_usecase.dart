import 'package:dartz/dartz.dart';
import 'package:kappa/kappa.dart';
import 'package:kappa/src/features/auth/domain/entities/auth_entity.dart';
import 'package:kappa/src/features/auth/domain/repositories/auth_repository.dart';

class LoginParams extends UseCaseParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LoginUseCase extends BaseSimpleUseCase<BaseException, AuthUserEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<BaseException, AuthUserEntity>> execute(LoginParams params) {
    return repository.login(params.email, params.password);
  }
}
