import 'package:dartz/dartz.dart';
import 'package:kappa/kappa.dart';
import 'package:kappa/src/features/auth/domain/entities/auth_entity.dart';
import 'package:kappa/src/features/auth/domain/repositories/auth_repository.dart';

class RegisterParams extends UseCaseParams {
  final String email;
  final String password;

  const RegisterParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterUseCase extends BaseSimpleUseCase<BaseException, AuthUserEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<BaseException, AuthUserEntity>> execute(RegisterParams params) {
    return repository.register(params.email, params.password);
  }
}
