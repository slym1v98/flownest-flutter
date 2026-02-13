import 'package:kappa/kappa.dart';
import 'package:kappa/src/features/product/domain/entities/product_entity.dart';
import 'package:kappa/src/presentation/bloc/base_pagination_state.dart';
import 'package:kappa/src/presentation/bloc/base_pagination_cubit.dart';
import 'package:kappa/src/domain/usecases/base_pagination_params.dart';
import 'package:dartz/dartz.dart';

class ProductState extends BasePaginationState<ProductEntity> {
  const ProductState({
    super.items,
    super.isLoading,
    super.isLoadingMore,
    super.isLastPage,
    super.errorMessage,
    super.currentPage,
  });
}

class ProductCubit extends BasePaginationCubit<ProductEntity, ProductState> {
  ProductCubit() : super(const ProductState());

  @override
  Future<Either<BaseException, ListOf<ProductEntity>>> getUsecase(BasePaginationParams params) async {
    // Trong thực tế, đây sẽ là gọi tới ProductUseCase
    // Để ví dụ, tôi trả về dữ liệu giả
    await Future.delayed(const Duration(seconds: 1));
    final List<ProductEntity> mockData = List.generate(
      20,
      (index) => ProductEntity(
        id: '${params.page}_$index',
        name: 'Product ${params.page}_$index',
        price: 100.0 + index,
      ),
    );
    return Right(ListOf(mockData));
  }

  @override
  ProductState _createState({
    List<ProductEntity>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isLastPage,
    String? errorMessage,
    int? currentPage,
  }) {
    return ProductState(
      items: items ?? state.items,
      isLoading: isLoading ?? state.isLoading,
      isLoadingMore: isLoadingMore ?? state.isLoadingMore,
      isLastPage: isLastPage ?? state.isLastPage,
      errorMessage: errorMessage,
      currentPage: currentPage ?? state.currentPage,
    );
  }
}
