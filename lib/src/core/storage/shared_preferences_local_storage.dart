import 'package:shared_preferences/shared_preferences.dart';
import '../storage/i_local_storage.dart';

/// A concrete implementation of [ILocalStorage] using `shared_preferences`.
class SharedPreferencesLocalStorage implements ILocalStorage {
  late SharedPreferences _prefs;

  /// Initializes the SharedPreferences instance.
  /// Must be called before any other methods are used.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<void> delete(String key) async {
    await _prefs.remove(key);
  }

  @override
  T? read<T>(String key) {
    if (T == String) {
      return _prefs.getString(key) as T?;
    } else if (T == bool) {
      return _prefs.getBool(key) as T?;
    } else if (T == int) {
      return _prefs.getInt(key) as T?;
    } else if (T == double) {
      return _prefs.getDouble(key) as T?;
    } else if (T == List<String>) {
      return _prefs.getStringList(key) as T?;
    }
    // Fallback for unsupported types or default
    return _prefs.get(key) as T?;
  }

  @override
  Future<void> write<T>(String key, T value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else {
      // Handle unsupported types or convert to String (e.g., JSON encode)
      // For now, it will throw an error if the type is not supported by SharedPreferences
      throw UnsupportedError('Type ${value.runtimeType} is not supported by SharedPreferencesLocalStorage');
    }
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }
}
