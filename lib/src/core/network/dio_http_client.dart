import 'package:dio/dio.dart';
import '../network/i_http_client.dart';

/// A concrete implementation of [IHttpClient] using the `Dio` package.
class DioHttpClient implements IHttpClient {
  final Dio _dio;

  DioHttpClient(this._dio);

  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  @override
  Future<dynamic> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> post(String path, {dynamic data, Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> put(String path, {dynamic data, Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handles Dio errors and converts them into a more generic exception type.
  /// You might want to define custom exception classes (e.g., [NetworkException]).
  Exception _handleDioError(DioException e) {
    // Example of handling different DioException types
    if (e.type == DioExceptionType.badResponse) {
      // Handle HTTP error responses (e.g., 404, 500)
      return Exception("HTTP Error: ${e.response?.statusCode} - ${e.response?.statusMessage}");
    } else if (e.type == DioExceptionType.connectionError) {
      // Handle connection issues
      return Exception("Connection Error: Check your internet connection.");
    } else {
      // General Dio error
      return Exception("Network Error: ${e.message}");
    }
  }
}
