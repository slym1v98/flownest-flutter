import 'package:flutter_test/flutter_test.dart';
import 'package:kappa/kappa.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;

  setUp(() {
    storage = MockStorage();
    when(() => storage.write(any(), any())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
  });

  group('LoaderCubit', () {
    blocTest<LoaderCubit, LoaderState>(
      'emits [loading: true] when setLoading(true) is called',
      build: () => LoaderCubit(),
      act: (cubit) => cubit.setLoading(true),
      expect: () => [const LoaderState(loading: true)],
    );
  });

  group('ThemeCubit', () {
    blocTest<ThemeCubit, ThemeState>(
      'toggles theme correctly',
      build: () => ThemeCubit(),
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [isA<ThemeState>().having((s) => s.themeMode, 'mode', ThemeMode.dark)],
    );
  });
}
