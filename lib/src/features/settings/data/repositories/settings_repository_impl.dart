import 'package:dartz/dartz.dart';
import 'package:kappa/src/features/settings/data/datasources/settings_local_data_source.dart';
// import 'package:kappa/src/features/settings/data/datasources/settings_remote_data_source.dart'; // No longer directly used here
import 'package:kappa/src/features/settings/domain/entities/settings_entity.dart';
import 'package:kappa/src/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  // final SettingsRemoteDataSource remoteDataSource; // Removed
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({
    // required this.remoteDataSource, // Removed
    required this.localDataSource,
  });

  @override
  Future<Either<Exception, AppSettingEntity>> getAppSettings() async {
    try {
      final settings = await localDataSource.getAppSettings();
      return Right(settings);
    } catch (e) {
      return Left(Exception('Failed to get app settings: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, void>> saveAppSettings(AppSettingEntity settings) async {
    try {
      await localDataSource.saveAppSettings(settings);
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to save app settings: ${e.toString()}'));
    }
  }
}
