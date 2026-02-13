import 'package:kappa/src/core/storage/i_local_secure_storage.dart';
import 'package:kappa/src/features/auth/domain/entities/auth_entity.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<AuthUserEntity?> getCachedAuthUser();
  Future<void> cacheAuthUser(AuthUserEntity user);
  Future<void> deleteCachedAuthUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _kAuthToken = 'auth_token';
  static const _kAuthUserId = 'auth_user_id';
  static const _kAuthUserEmail = 'auth_user_email';

  final ILocalSecureStorage secureStorage;

  AuthLocalDataSourceImpl(this.secureStorage);

  @override
  Future<void> saveToken(String token) async {
    await secureStorage.write(_kAuthToken, token);
  }

  @override
  Future<String?> getToken() async {
    return await secureStorage.read(_kAuthToken);
  }

  @override
  Future<void> deleteToken() async {
    await secureStorage.delete(_kAuthToken);
  }

  @override
  Future<AuthUserEntity?> getCachedAuthUser() async {
    final id = await secureStorage.read(_kAuthUserId);
    final email = await secureStorage.read(_kAuthUserEmail);
    final token = await secureStorage.read(_kAuthToken);

    if (id != null && email != null) {
      return AuthUserEntity(id: id, email: email, token: token);
    }
    return null;
  }

  @override
  Future<void> cacheAuthUser(AuthUserEntity user) async {
    await secureStorage.write(_kAuthUserId, user.id);
    await secureStorage.write(_kAuthUserEmail, user.email);
    if (user.token != null) {
      await secureStorage.write(_kAuthToken, user.token!);
    }
  }

  @override
  Future<void> deleteCachedAuthUser() async {
    await secureStorage.delete(_kAuthUserId);
    await secureStorage.delete(_kAuthUserEmail);
    await secureStorage.delete(_kAuthToken);
  }
}
