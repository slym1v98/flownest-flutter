import 'package:dartz/dartz.dart';
import 'package:kappa/src/features/settings/domain/entities/settings_entity.dart';
import 'package:kappa/src/features/settings/domain/repositories/settings_repository.dart';

class SaveAppSettingsUseCase {
  final SettingsRepository repository;

  SaveAppSettingsUseCase(this.repository);

  Future<Either<Exception, void>> call(AppSettingEntity settings) {
    return repository.saveAppSettings(settings);
  }
}
