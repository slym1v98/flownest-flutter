import 'package:dartz/dartz.dart';
import 'package:kappa/kappa.dart';
import 'package:kappa/src/features/auth/domain/entities/auth_entity.dart';
import 'package:kappa/src/features/auth/domain/repositories/auth_repository.dart';

class GetAuthStatusUseCase extends BaseSimpleUseCase<BaseException, AuthUserEntity, NoParams> {
  final AuthRepository repository;

  GetAuthStatusUseCase(this.repository);

  @override
  Future<Either<BaseException, AuthUserEntity>> execute(NoParams params) {
    return repository.getAuthStatus();
  }
}
