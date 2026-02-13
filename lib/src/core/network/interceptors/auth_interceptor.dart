import 'package:dio/dio.dart';
import 'package:kappa/kappa.dart';

class AuthInterceptor extends QueuedInterceptor {
  final Dio _dio;
  final Future<String?> Function() _getAccessToken;
  final Future<String?> Function() _getRefreshToken;
  final Future<bool> Function(String refreshToken) _refreshTokens;

  AuthInterceptor({
    required Dio dio,
    required Future<String?> Function() getAccessToken,
    required Future<String?> Function() getRefreshToken,
    required Future<bool> Function(String refreshToken) refreshTokens,
  })  : _dio = dio,
        _getAccessToken = getAccessToken,
        _getRefreshToken = getRefreshToken,
        _refreshTokens = refreshTokens;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await _getRefreshToken();
      if (refreshToken != null) {
        final success = await _refreshTokens(refreshToken);
        if (success) {
          // Retry the request with the new token
          final newToken = await _getAccessToken();
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newToken';
          
          try {
            final response = await _dio.fetch(options);
            return handler.resolve(response);
          } on DioException catch (e) {
            return handler.next(e);
          }
        }
      }
    }
    return handler.next(err);
  }
}
