import 'package:dartz/dartz.dart';
import 'package:kappa/src/features/settings/domain/entities/settings_entity.dart';
import 'package:kappa/src/features/settings/domain/repositories/settings_repository.dart';

class GetAppSettingsUseCase {
  final SettingsRepository repository;

  GetAppSettingsUseCase(this.repository);

  Future<Either<Exception, AppSettingEntity>> call() {
    return repository.getAppSettings();
  }
}
