import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kappa/src/features/auth/domain/entities/auth_entity.dart';
import 'package:kappa/src/features/auth/domain/usecases/get_auth_status_usecase.dart';
import 'package:kappa/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:kappa/src/features/auth/domain/usecases/logout_usecase.dart';
import 'package:kappa/src/features/auth/domain/usecases/register_usecase.dart';
import 'package:kappa/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:kappa/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:kappa/src/core/logging/i_logger.dart'; // Import ILogger
import 'package:kappa/src/injector.dart'; // Import injector for SL.call

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetAuthStatusUseCase getAuthStatusUseCase;
  final ILogger _logger = SL.call<ILogger>(); // Use ILogger

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getAuthStatusUseCase,
  }) : super(const AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthState> emit,
  ) async {
    _logger.info('AppStarted event received, checking auth status...');
    final result = await getAuthStatusUseCase();
    result.fold(
      (failure) {
        _logger.error('Failed to get auth status on app start: ${failure.toString()}');
        emit(const Unauthenticated());
      },
      (user) {
        if (user.isAuthenticated) {
          emit(Authenticated(user: user));
          _logger.info('User is authenticated: ${user.email}');
        } else {
          emit(const Unauthenticated());
          _logger.info('User is unauthenticated.');
        }
      },
    );
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    _logger.info('Login requested for email: ${event.email}');
    final result = await loginUseCase(event.email, event.password);
    result.fold(
      (failure) {
        _logger.error('Login failed for email ${event.email}: ${failure.toString()}');
        emit(AuthError(message: failure.toString()));
      },
      (user) {
        emit(Authenticated(user: user));
        _logger.info('User logged in: ${user.email}');
      },
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    _logger.info('Registration requested for email: ${event.email}');
    final result = await registerUseCase(event.email, event.password);
    result.fold(
      (failure) {
        _logger.error('Registration failed for email ${event.email}: ${failure.toString()}');
        emit(AuthError(message: failure.toString()));
      },
      (user) {
        emit(Authenticated(user: user));
        _logger.info('User registered and logged in: ${user.email}');
      },
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    _logger.info('Logout requested.');
    final result = await logoutUseCase();
    result.fold(
      (failure) {
        _logger.error('Logout failed: ${failure.toString()}');
        emit(AuthError(message: failure.toString()));
      },
      (_) {
        emit(const Unauthenticated());
        _logger.info('User logged out.');
      },
    );
  }
}
