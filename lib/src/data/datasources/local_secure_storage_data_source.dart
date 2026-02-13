import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../kappa.dart';

class LocalSecureStorage extends InjectableService {
  static late final FlutterSecureStorage storageInstance;

  static final LocalSecureStorage _instance = LocalSecureStorage._internal();

  factory LocalSecureStorage() {
    return _instance;
  }

  LocalSecureStorage._internal();

  FlutterSecureStorage init() => storageInstance = const FlutterSecureStorage();

  Future<dynamic> set(String key, dynamic value) async {
    if (value is int || value is double || value is bool) {
      value = value.toString();
    } else if (value is List<String>) {
      value = value.join('-;;-');
    } else if (value is BaseModel || value is List<BaseModel> || value is BaseEntity || value is List<BaseEntity>) {
      value = value.toString();
    } else {
      throw LocalStorageException('Unsupported value type');
    }

    return storageInstance.write(
      key: key,
      value: value,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  Future<T?> get<T>(String key, {T? defaultValue}) async {
    String? value = await storageInstance.read(key: key, iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
    if (T is String || T is int || T is double || T is bool) return value as T;
    if (T is List<String>) return value?.split('-;;-') as T;
    if (T is BaseModel) return BaseModel.fromString(value!) as T;
    if (T is BaseEntity) return BaseEntity.fromString(value!) as T;
    if (T is List<BaseModel>) return jsonDecode(value!).map((e) => BaseModel.fromJson(e)).toList() as T;
    if (T is List<BaseEntity>) return jsonDecode(value!).map((e) => BaseEntity.fromMap(e)).toList() as T;
    return defaultValue;
  }

  IOSOptions _getIOSOptions() => IOSOptions(accountName: AppEnvironments.appKey);

  AndroidOptions _getAndroidOptions() => const AndroidOptions(encryptedSharedPreferences: true);
}
