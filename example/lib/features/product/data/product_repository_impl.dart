import 'package:dartz/dartz.dart';
import 'package:kappa/kappa.dart';
import '../domain/product_entity.dart';
import 'product_remote_data_source.dart';

abstract class ProductRepository {
  Future<Either<BaseException, ListOf<ProductEntity>>> getProducts(int page);
}

class ProductRepositoryImpl extends BaseRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<BaseException, ListOf<ProductEntity>>> getProducts(int page) async {
    // We use a custom request because we are mocking, 
    // but in real app you'd use handleRequest with remoteDataSource
    try {
      final data = await remoteDataSource.getProducts(page);
      return Right(ListOf(data));
    } catch (e) {
      return Left(BaseException(message: e.toString()));
    }
  }
}
