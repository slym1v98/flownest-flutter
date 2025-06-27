import '../../../../../../kappa.dart';

part 'loader_state.dart';

class LoaderCubit extends BaseHydratedCubit<LoaderState> {
  LoaderCubit() : super(const LoaderState());

  @override
  LoaderState? fromJson(Map<String, dynamic> json) => LoaderState.fromMap(json);

  @override
  Map<String, dynamic>? toJson(LoaderState state) => state.toMap();

  void setLoading(bool? loading) {
    emit(LoaderState(loading: loading ?? false));
  }
}
