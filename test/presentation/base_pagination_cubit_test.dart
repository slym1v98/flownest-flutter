import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kappa/kappa.dart';
import 'package:kappa/src/domain/usecases/base_pagination_params.dart';
import 'package:kappa/src/presentation/bloc/base_pagination_cubit.dart';
import 'package:kappa/src/presentation/bloc/base_pagination_state.dart';
import 'package:mocktail/mocktail.dart';

// Mocking dependencies
class MockEntity extends Mock implements BaseEntity {}

class TestPaginationState extends BasePaginationState<MockEntity> {
  const TestPaginationState({
    super.items,
    super.isLoading,
    super.isLoadingMore,
    super.isLastPage,
    super.errorMessage,
    super.currentPage,
  });
}

class TestPaginationCubit extends BasePaginationCubit<MockEntity, TestPaginationState> {
  final Future<Either<BaseException, ListOf<MockEntity>>> Function(BasePaginationParams) onGetUsecase;

  TestPaginationCubit(this.onGetUsecase) : super(const TestPaginationState());

  @override
  Future<Either<BaseException, ListOf<MockEntity>>> getUsecase(BasePaginationParams params) =>
      onGetUsecase(params);

  @override
  TestPaginationState _createState({
    List<MockEntity>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isLastPage,
    String? errorMessage,
    int? currentPage,
  }) {
    return TestPaginationState(
      items: items ?? state.items,
      isLoading: isLoading ?? state.isLoading,
      isLoadingMore: isLoadingMore ?? state.isLoadingMore,
      isLastPage: isLastPage ?? state.isLastPage,
      errorMessage: errorMessage,
      currentPage: currentPage ?? state.currentPage,
    );
  }
}

void main() {
  group('BasePaginationCubit', () {
    late List<MockEntity> mockList;

    setUp(() {
      mockList = List.generate(20, (_) => MockEntity());
    });

    blocTest<TestPaginationCubit, TestPaginationState>(
      'emits [isLoading: true, success] when fetchItems is successful',
      build: () => TestPaginationCubit((params) async => Right(ListOf(mockList))),
      act: (cubit) => cubit.fetchItems(isRefresh: true),
      expect: () => [
        const TestPaginationState(items: [], isLoading: true, currentPage: 1),
        TestPaginationState(items: mockList, isLoading: false, currentPage: 1, isLastPage: false),
      ],
    );

    blocTest<TestPaginationCubit, TestPaginationState>(
      'sets isLastPage to true when received list is smaller than perPage',
      build: () => TestPaginationCubit((params) async => Right(ListOf([MockEntity()]))),
      act: (cubit) => cubit.fetchItems(isRefresh: true),
      verify: (cubit) {
        expect(cubit.state.isLastPage, true);
      },
    );
  });
}
