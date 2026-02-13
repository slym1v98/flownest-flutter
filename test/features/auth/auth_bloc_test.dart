import 'package:flutter_test/flutter_test.dart';
import 'package:kappa/src/features/auth/domain/entities/auth_entity.dart';
import 'package:kappa/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kappa/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:kappa/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:kappa/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:kappa/src/features/auth/domain/usecases/register_usecase.dart';
import 'package:kappa/src/features/auth/domain/usecases/logout_usecase.dart';
import 'package:kappa/src/features/auth/domain/usecases/get_auth_status_usecase.dart';
import 'package:kappa/kappa.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockRegisterUseCase extends Mock implements RegisterUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockGetAuthStatusUseCase extends Mock implements GetAuthStatusUseCase {}

void main() {
  late AuthBloc authBloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockGetAuthStatusUseCase mockGetAuthStatusUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetAuthStatusUseCase = MockGetAuthStatusUseCase();
    
    // Register basic SL for ILogger used in AuthBloc
    // (Assuming SL has been initialized or mocked)
    
    authBloc = AuthBloc(
      loginUseCase: mockLoginUseCase,
      registerUseCase: mockRegisterUseCase,
      logoutUseCase: mockLogoutUseCase,
      getAuthStatusUseCase: mockGetAuthStatusUseCase,
    );
  });

  const tUser = AuthUserEntity(id: '1', email: 'test@example.com', token: 'token');

  group('AuthBloc Login', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when login is successful',
      build: () {
        when(() => mockLoginUseCase.execute(any()))
            .thenAnswer((_) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginRequested(email: 'test@example.com', password: 'password')),
      expect: () => [
        const AuthLoading(),
        const Authenticated(user: tUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(() => mockLoginUseCase.execute(any()))
            .thenAnswer((_) async => Left(BaseException(message: 'Login Failed')));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginRequested(email: 'test@example.com', password: 'password')),
      expect: () => [
        const AuthLoading(),
        const AuthError(message: 'BaseException: Login Failed'),
      ],
    );
  });
}
