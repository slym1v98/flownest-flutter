import 'base_usecase.dart';

class BasePaginationParams extends UseCaseParams {
  final int page;
  final int perPage;
  final Map<String, dynamic>? query;

  const BasePaginationParams({
    this.page = 1,
    this.perPage = 20,
    this.query,
  });

  BasePaginationParams copyWith({
    int? page,
    int? perPage,
    Map<String, dynamic>? query,
  }) {
    return BasePaginationParams(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [page, perPage, query];
}
