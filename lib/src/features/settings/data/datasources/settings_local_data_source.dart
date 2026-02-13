import 'dart:convert'; // For jsonEncode/jsonDecode
import 'package:flutter/material.dart'; // For ThemeMode

import 'package:kappa/src/core/storage/i_local_storage.dart';
import 'package:kappa/src/features/settings/domain/entities/settings_entity.dart'; // Import AppSettingEntity

abstract class SettingsLocalDataSource {
  Future<AppSettingEntity> getAppSettings();
  Future<void> saveAppSettings(AppSettingEntity settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const _kAppSettingsKey = 'app_settings';

  final ILocalStorage localStorage;

  SettingsLocalDataSourceImpl(this.localStorage);

  @override
  Future<AppSettingEntity> getAppSettings() async {
    final String? settingsJson = localStorage.read<String>(_kAppSettingsKey);
    if (settingsJson != null && settingsJson.isNotEmpty) {
      final Map<String, dynamic> settingsMap = jsonDecode(settingsJson);
      // Reconstruct AppSettingEntity from map
      return AppSettingEntity(
        themeMode: ThemeMode.values.firstWhere(
            (e) => e.toString() == settingsMap['themeMode'],
            orElse: () => AppSettingEntity().themeMode),
        languageCode: settingsMap['languageCode'] as String? ?? AppSettingEntity().languageCode,
        receiveNotifications: settingsMap['receiveNotifications'] as bool? ?? AppSettingEntity().receiveNotifications,
      );
    }
    return const AppSettingEntity(); // Return default settings if none found
  }

  @override
  Future<void> saveAppSettings(AppSettingEntity settings) async {
    final Map<String, dynamic> settingsMap = {
      'themeMode': settings.themeMode.toString(),
      'languageCode': settings.languageCode,
      'receiveNotifications': settings.receiveNotifications,
    };
    await localStorage.write(_kAppSettingsKey, jsonEncode(settingsMap));
  }
}
