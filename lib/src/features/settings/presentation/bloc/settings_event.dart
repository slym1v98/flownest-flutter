import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart'; // For ThemeMode

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

class ThemeModeChanged extends SettingsEvent {
  final ThemeMode themeMode;

  const ThemeModeChanged(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

class LanguageChanged extends SettingsEvent {
  final String languageCode;

  const LanguageChanged(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}

class NotificationsToggled extends SettingsEvent {
  final bool enable;

  const NotificationsToggled(this.enable);

  @override
  List<Object> get props => [enable];
}
