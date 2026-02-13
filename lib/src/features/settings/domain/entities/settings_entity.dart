import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart'; // For ThemeMode

class AppSettingEntity extends Equatable {
  final ThemeMode themeMode;
  final String languageCode;
  final bool receiveNotifications;

  const AppSettingEntity({
    this.themeMode = ThemeMode.system,
    this.languageCode = 'en',
    this.receiveNotifications = true,
  });

  AppSettingEntity copyWith({
    ThemeMode? themeMode,
    String? languageCode,
    bool? receiveNotifications,
  }) {
    return AppSettingEntity(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      receiveNotifications: receiveNotifications ?? this.receiveNotifications,
    );
  }

  @override
  List<Object> get props => [themeMode, languageCode, receiveNotifications];
}
