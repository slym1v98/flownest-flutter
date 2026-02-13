import 'package:kappa/kappa.dart';
import 'package:kappa/src/presentation/bloc/base_pagination_cubit.dart';
import 'package:kappa/src/presentation/bloc/base_pagination_state.dart';
import 'package:kappa/src/domain/usecases/base_pagination_params.dart';
import 'package:dartz/dartz.dart';
import '../../domain/product_entity.dart';
import '../data/product_repository_impl.dart';

class ProductPaginationState extends BasePaginationState<ProductEntity> {
  const ProductPaginationState({
    super.items,
    super.isLoading,
    super.isLoadingMore,
    super.isLastPage,
    super.errorMessage,
    super.currentPage,
  });
}

class ProductCubit extends BasePaginationCubit<ProductEntity, ProductPaginationState> {
  final ProductRepository repository;

  ProductCubit(this.repository) : super(const ProductPaginationState());

  @override
  Future<Either<BaseException, ListOf<ProductEntity>>> getUsecase(BasePaginationParams params) {
    return repository.getProducts(params.page);
  }

  @override
  ProductPaginationState _createState({
    List<ProductEntity>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isLastPage,
    String? errorMessage,
    int? currentPage,
  }) {
    return ProductPaginationState(
      items: items ?? state.items,
      isLoading: isLoading ?? state.isLoading,
      isLoadingMore: isLoadingMore ?? state.isLoadingMore,
      isLastPage: isLastPage ?? state.isLastPage,
      errorMessage: errorMessage,
      currentPage: currentPage ?? state.currentPage,
    );
  }
}
