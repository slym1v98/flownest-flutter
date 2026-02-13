import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kappa/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:kappa/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:kappa/src/features/auth/data/models/auth_model.dart';
import 'package:kappa/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:kappa/src/features/auth/domain/entities/auth_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements AuthRemoteDataSource {}
class MockLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockRemoteDataSource mockRemote;
  late MockLocalDataSource mockLocal;

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocal = MockLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  const tModel = AuthModel(id: '1', email: 'test@test.com', token: 'token');

  group('AuthRepositoryImpl', () {
    test('login should save token and return user on success', () async {
      // Arrange
      when(() => mockRemote.login(any(), any())).thenAnswer((_) async => tModel);
      when(() => mockLocal.saveToken(any())).thenAnswer((_) async => {});
      when(() => mockLocal.cacheAuthUser(any())).thenAnswer((_) async => {});

      // Act
      final result = await repository.login('test@test.com', 'password');

      // Assert
      expect(result, const Right(tModel));
      verify(() => mockRemote.login('test@test.com', 'password')).called(1);
      verify(() => mockLocal.saveToken('token')).called(1);
    });

    test('getAuthStatus should return cached user if exists', () async {
      when(() => mockLocal.getCachedAuthUser()).thenAnswer((_) async => tModel);

      final result = await repository.getAuthStatus();

      expect(result, const Right(tModel));
    });
  });
}
