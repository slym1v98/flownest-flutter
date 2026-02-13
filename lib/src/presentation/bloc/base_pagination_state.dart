import 'package:equatable/equatable.dart';
import 'package:kappa/src/domain/entities/base_entity.dart';

abstract class BasePaginationState<T extends BaseEntity> extends Equatable {
  final List<T> items;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isLastPage;
  final String? errorMessage;
  final int currentPage;

  const BasePaginationState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isLastPage = false,
    this.errorMessage,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [
        items,
        isLoading,
        isLoadingMore,
        isLastPage,
        errorMessage,
        currentPage,
      ];
}
