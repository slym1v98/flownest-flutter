import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../storage/i_local_secure_storage.dart';

/// A concrete implementation of [ILocalSecureStorage] using `flutter_secure_storage`.
class FlutterSecureStorageLocalStorage implements ILocalSecureStorage {
  final FlutterSecureStorage _secureStorage;

  FlutterSecureStorageLocalStorage() : _secureStorage = const FlutterSecureStorage();

  @override
  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  @override
  Future<String?> read(String key) async {
    return await _secureStorage.read(key: key);
  }

  @override
  Future<void> write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  @override
  Future<void> clear() async {
    await _secureStorage.deleteAll();
  }
}
