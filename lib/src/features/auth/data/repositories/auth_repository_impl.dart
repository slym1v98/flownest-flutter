import 'package:dartz/dartz.dart';
import 'package:kappa/kappa.dart';
import 'package:kappa/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:kappa/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:kappa/src/features/auth/data/models/auth_model.dart'; // Import AuthModel
import 'package:kappa/src/features/auth/domain/entities/auth_entity.dart';
import 'package:kappa/src/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<BaseException, AuthUserEntity>> login(String email, String password) async {
    try {
      final authModel = await remoteDataSource.login(email, password);
      await localDataSource.saveToken(authModel.token!); // Save token from successful login
      await localDataSource.cacheAuthUser(authModel); // Cache user details
      return Right(authModel); // AuthModel extends AuthUserEntity
    } catch (e) {
      return Left(BaseException(message: 'Login failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<BaseException, AuthUserEntity>> register(String email, String password) async {
    try {
      final authModel = await remoteDataSource.register(email, password);
      await localDataSource.saveToken(authModel.token!); // Save token from successful registration
      await localDataSource.cacheAuthUser(authModel); // Cache user details
      return Right(authModel);
    } catch (e) {
      return Left(BaseException(message: 'Registration failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<BaseException, void>> logout() async {
    try {
      await localDataSource.deleteToken();
      await localDataSource.deleteCachedAuthUser();
      // Optionally, call a remote logout endpoint if exists
      return const Right(null);
    } catch (e) {
      return Left(BaseException(message: 'Logout failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<BaseException, AuthUserEntity>> getAuthStatus() async {
    try {
      final cachedUser = await localDataSource.getCachedAuthUser();
      if (cachedUser != null && cachedUser.isAuthenticated) {
        return Right(cachedUser);
      }
      return Right(AuthUserEntity.unauthenticated); // No cached valid user
    } catch (e) {
      return Left(BaseException(message: 'Failed to get auth status: ${e.toString()}'));
    }
  }
}
