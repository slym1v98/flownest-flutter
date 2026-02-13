import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kappa/src/features/settings/domain/entities/settings_entity.dart';
import 'package:kappa/src/features/settings/domain/usecases/get_app_settings_usecase.dart';
import 'package:kappa/src/features/settings/domain/usecases/save_app_settings_usecase.dart';
import 'package:kappa/src/features/settings/presentation/bloc/settings_event.dart';
import 'package:kappa/src/features/settings/presentation/bloc/settings_state.dart';
import 'package:kappa/src/core/logging/i_logger.dart'; // Import ILogger
import 'package:kappa/src/injector.dart'; // Import injector for SL.call

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetAppSettingsUseCase getAppSettingsUseCase;
  final SaveAppSettingsUseCase saveAppSettingsUseCase;
  final ILogger _logger = SL.call<ILogger>(); // Use ILogger

  SettingsBloc({
    required this.getAppSettingsUseCase,
    required this.saveAppSettingsUseCase,
  }) : super(const SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<ThemeModeChanged>(_onThemeModeChanged);
    on<LanguageChanged>(_onLanguageChanged);
    on<NotificationsToggled>(_onNotificationsToggled);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());
    _logger.info('Loading app settings...');
    final result = await getAppSettingsUseCase();
    result.fold(
      (failure) {
        _logger.error('Failed to load settings: ${failure.toString()}');
        emit(SettingsError(message: failure.toString()));
      },
      (settings) {
        emit(SettingsLoaded(settings: settings));
        _logger.info('Settings loaded: ${settings.toString()}');
      },
    );
  }

  Future<void> _onThemeModeChanged(
    ThemeModeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final newSettings = currentSettings.copyWith(themeMode: event.themeMode);
      _logger.info('Theme mode changed to: ${event.themeMode}');
      final result = await saveAppSettingsUseCase(newSettings);
      result.fold(
        (failure) {
          _logger.error('Failed to save theme mode: ${failure.toString()}');
          emit(SettingsError(message: failure.toString()));
        },
        (_) => emit(SettingsLoaded(settings: newSettings)),
      );
    }
  }

  Future<void> _onLanguageChanged(
    LanguageChanged event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final newSettings = currentSettings.copyWith(languageCode: event.languageCode);
      _logger.info('Language changed to: ${event.languageCode}');
      final result = await saveAppSettingsUseCase(newSettings);
      result.fold(
        (failure) {
          _logger.error('Failed to save language: ${failure.toString()}');
          emit(SettingsError(message: failure.toString()));
        },
        (_) => emit(SettingsLoaded(settings: newSettings)),
      );
    }
  }

  Future<void> _onNotificationsToggled(
    NotificationsToggled event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final newSettings = currentSettings.copyWith(receiveNotifications: event.enable);
      _logger.info('Notifications toggled to: ${event.enable}');
      final result = await saveAppSettingsUseCase(newSettings);
      result.fold(
        (failure) {
          _logger.error('Failed to save notification preference: ${failure.toString()}');
          emit(SettingsError(message: failure.toString()));
        },
        (_) => emit(SettingsLoaded(settings: newSettings)),
      );
    }
  }
}
