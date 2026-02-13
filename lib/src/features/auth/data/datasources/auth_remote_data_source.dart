import 'package:kappa/src/core/network/i_http_client.dart';
import 'package:kappa/src/features/auth/data/models/auth_model.dart'; // Import AuthModel

abstract class AuthRemoteDataSource {
  Future<AuthModel> login(String email, String password);
  Future<AuthModel> register(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final IHttpClient client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<AuthModel> login(String email, String password) async {
    final response = await client.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return AuthModel.fromJson(response);
  }

  @override
  Future<AuthModel> register(String email, String password) async {
    final response = await client.post(
      '/auth/register',
      data: {'email': email, 'password': password},
    );
    return AuthModel.fromJson(response);
  }
}
