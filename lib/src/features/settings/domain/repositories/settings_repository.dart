import 'package:dartz/dartz.dart';
import 'package:kappa/src/features/settings/domain/entities/settings_entity.dart';

abstract class SettingsRepository {
  Future<Either<Exception, AppSettingEntity>> getAppSettings();
  Future<Either<Exception, void>> saveAppSettings(AppSettingEntity settings);
}
