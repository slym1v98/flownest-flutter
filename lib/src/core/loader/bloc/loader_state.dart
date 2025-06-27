part of 'loader_cubit.dart';

class LoaderState extends BaseState {
  final bool loading;

  const LoaderState({this.loading = false});

  factory LoaderState.fromMap(Map<String, dynamic> map) {
    return LoaderState(loading: map['loading'] ?? false);
  }

  Map<String, dynamic> toMap() {
    return {'loading': loading};
  }

  @override
  List<Object> get props => [loading];
}
