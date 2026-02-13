import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kappa/kappa.dart';
import 'package:mocktail/mocktail.dart';

class MockDioException extends Mock implements DioException {}

// Một repository cụ thể để test logic của BaseRepositoryImpl
class TestRepository extends BaseRepositoryImpl {
  Future<Either<BaseException, String>> getData({CachePolicy policy = CachePolicy.networkOnly}) {
    return handleRequest<String>(
      remoteRequest: () async => 'remote_data',
      getFromCache: () async => 'cached_data',
      policy: policy,
    );
  }
}

void main() {
  late TestRepository repository;

  setUp(() {
    repository = TestRepository();
  });

  group('BaseRepositoryImpl - handleRequest', () {
    test('should return remote data when policy is networkOnly', () async {
      final result = await repository.getData(policy: CachePolicy.networkOnly);
      expect(result, const Right('remote_data'));
    });

    test('should return cached data first when policy is cacheFirst', () async {
      final result = await repository.getData(policy: CachePolicy.cacheFirst);
      expect(result, const Right('cached_data'));
    });

    test('should return remote data when cacheFirst but cache is null', () async {
      final repoWithNoCache = _TestRepoWithNoCache();
      final result = await repoWithNoCache.getData(policy: CachePolicy.cacheFirst);
      expect(result, const Right('remote_data'));
    });
  });
}

class _TestRepoWithNoCache extends BaseRepositoryImpl {
  Future<Either<BaseException, String>> getData({CachePolicy policy = CachePolicy.networkOnly}) {
    return handleRequest<String>(
      remoteRequest: () async => 'remote_data',
      getFromCache: () async => null,
      policy: policy,
    );
  }
}
