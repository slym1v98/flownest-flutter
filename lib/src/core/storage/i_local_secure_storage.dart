/// An abstract interface for a secure key-value storage.
/// Used for sensitive data like tokens or user credentials.
abstract class ILocalSecureStorage {
  /// Reads a value from secure storage.
  Future<String?> read(String key);

  /// Writes a value to secure storage.
  Future<void> write(String key, String value);

  /// Deletes a value from secure storage.
  Future<void> delete(String key);

  /// Deletes all data from secure storage.
  Future<void> clear();
}
