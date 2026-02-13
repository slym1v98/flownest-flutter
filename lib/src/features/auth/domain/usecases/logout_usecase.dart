import 'package:dartz/dartz.dart';
import 'package:kappa/kappa.dart';
import 'package:kappa/src/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase extends BaseSimpleUseCase<BaseException, void, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<BaseException, void>> execute(NoParams params) {
    return repository.logout();
  }
}
