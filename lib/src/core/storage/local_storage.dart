import 'package:encrypt_shared_preferences/provider.dart';

import '../../../kappa.dart';

class LocalStorage extends InjectableService {
  static late final EncryptedSharedPreferences storageInstance;

  static final LocalStorage _instance = LocalStorage._internal();

  factory LocalStorage() {
    EncryptedSharedPreferences.initialize(AppEnvironments.appKey.length >= 16
        ? AppEnvironments.appKey.substring(0, 16)
        : AppEnvironments.appKey + ('0' * (16 - AppEnvironments.appKey.length)));
    return _instance;
  }

  LocalStorage._internal();

  EncryptedSharedPreferences init() => storageInstance = EncryptedSharedPreferences.getInstance();

  Future<dynamic> set(String key, dynamic value) async {
    if (value is String) {
      return storageInstance.setString(key, value);
    } else if (value is int) {
      return storageInstance.setInt(key, value);
    } else if (value is double) {
      return storageInstance.setDouble(key, value);
    } else if (value is bool) {
      return storageInstance.setBool(key, value);
    } else if (value is List<String>) {
      return storageInstance.setStringList(key, value);
    } else {
      throw LocalStorageException('Unsupported value type');
    }
  }

  T? get<T>(String key, {T? defaultValue}) {
    if (T == String) {
      return (storageInstance.getString(key) ?? defaultValue) as T;
    } else if (T == int) {
      return (storageInstance.getString(key) ?? defaultValue) as T;
    } else if (T == double) {
      return (storageInstance.getString(key) ?? defaultValue) as T;
    } else if (T == bool) {
      return (storageInstance.getString(key) ?? defaultValue) as T;
    } else if (T == List<String>) {
      return (storageInstance.getString(key) ?? defaultValue) as T;
    } else {
      throw LocalStorageException('Unsupported value type');
    }
  }

  String get localeKey => 'APP_CURRENT_LOCALE';
}
