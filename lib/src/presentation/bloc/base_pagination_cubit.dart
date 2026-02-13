import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kappa/kappa.dart';
import 'package:kappa/src/domain/usecases/base_pagination_params.dart';
import 'package:kappa/src/presentation/bloc/base_pagination_state.dart';

abstract class BasePaginationCubit<T extends BaseEntity, S extends BasePaginationState<T>>
    extends Cubit<S> {
  BasePaginationCubit(super.initialState);

  Future<Either<BaseException, ListOf<T>>> getUsecase(BasePaginationParams params);

  Future<void> fetchItems({bool isRefresh = false}) async {
    if (state.isLoading || state.isLoadingMore) return;

    final int pageToLoad = isRefresh ? 1 : state.currentPage + 1;

    if (isRefresh) {
      emit(_createState(
        items: state.items,
        isLoading: true,
        currentPage: 1,
        isLastPage: false,
      ));
    } else {
      if (state.isLastPage) return;
      emit(_createState(
        items: state.items,
        isLoadingMore: true,
        currentPage: state.currentPage,
        isLastPage: state.isLastPage,
      ));
    }

    final result = await getUsecase(BasePaginationParams(
      page: pageToLoad,
      perPage: 20, // Default per page
    ));

    result.fold(
      (failure) {
        emit(_createState(
          items: isRefresh ? [] : state.items,
          isLoading: false,
          isLoadingMore: false,
          errorMessage: failure.message,
          currentPage: state.currentPage,
          isLastPage: state.isLastPage,
        ));
      },
      (data) {
        final List<T> newItems = isRefresh ? data.values : [...state.items, ...data.values];
        emit(_createState(
          items: newItems,
          isLoading: false,
          isLoadingMore: false,
          isLastPage: data.values.isEmpty || data.values.length < 20,
          currentPage: pageToLoad,
        ));
      },
    );
  }

  // Helper method to create new state - must be implemented by subclasses
  S _createState({
    List<T>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isLastPage,
    String? errorMessage,
    int? currentPage,
  });
}
