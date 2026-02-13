/// An abstract interface for a simple key-value storage.
/// Used for non-sensitive data like user preferences.
abstract class ILocalStorage {
  /// Reads a value from storage.
  T? read<T>(String key);

  /// Writes a value to storage.
  Future<void> write<T>(String key, T value);

  /// Deletes a value from storage.
  Future<void> delete(String key);

  /// Deletes all data from storage.
  Future<void> clear();
}
