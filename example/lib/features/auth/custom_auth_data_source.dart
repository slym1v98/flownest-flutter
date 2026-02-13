import 'package:kappa/kappa.dart';
import 'package:kappa/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:kappa/src/features/auth/data/models/auth_model.dart';

class CustomAuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final IHttpClient client;

  CustomAuthRemoteDataSourceImpl(this.client);

  @override
  Future<AuthModel> login(String email, String password) async {
    // Giả lập gọi API trả về cấu trúc khác lạ
    await Future.delayed(const Duration(seconds: 1));
    
    // Giả sử API trả về: { "status": "success", "result": { "user": {...}, "token": "..." } }
    final mockApiResponse = {
      "status": "success",
      "result": {
        "user_id": "999",
        "user_email": email,
        "access_token": "custom_token_123"
      }
    };

    final result = mockApiResponse['result'] as Map<String, dynamic>;
    
    // Map về AuthModel của Kappa
    return AuthModel(
      id: result['user_id'],
      email: result['user_email'],
      token: result['access_token'],
    );
  }

  @override
  Future<AuthModel> register(String email, String password) async {
    return login(email, password);
  }
}
