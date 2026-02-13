import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../kappa.dart';

enum CachePolicy { networkOnly, networkFirst, cacheFirst }

abstract class BaseRepositoryImpl implements BaseRepository {
  const BaseRepositoryImpl();

  /// A helper method to handle API requests with common error handling and caching policies.
  Future<Either<BaseException, T>> handleRequest<T>({
    required Future<T> Function() remoteRequest,
    Future<void> Function(T data)? saveToCache,
    Future<T?> Function()? getFromCache,
    CachePolicy policy = CachePolicy.networkOnly,
  }) async {
    if (policy == CachePolicy.cacheFirst && getFromCache != null) {
      final cachedData = await getFromCache();
      if (cachedData != null) return Right(cachedData);
    }

    try {
      final remoteData = await remoteRequest();
      if (saveToCache != null) {
        await saveToCache(remoteData);
      }
      return Right(remoteData);
    } on DioException catch (e) {
      if (policy == CachePolicy.networkFirst && getFromCache != null) {
        final cachedData = await getFromCache();
        if (cachedData != null) return Right(cachedData);
      }
      return Left(NetworkException.fromDioError(e));
    } catch (e) {
      return Left(BaseException(message: e.toString()));
    }
  }
}
