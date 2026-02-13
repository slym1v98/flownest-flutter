import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kappa/src/core/network/interceptors/auth_interceptor.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}
class MockRequestInterceptorHandler extends Mock implements RequestInterceptorHandler {}
class MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}

void main() {
  late AuthInterceptor interceptor;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    interceptor = AuthInterceptor(
      dio: mockDio,
      getAccessToken: () async => 'valid_token',
      getRefreshToken: () async => 'refresh_token',
      refreshTokens: (token) async => true,
    );
  });

  group('AuthInterceptor', () {
    test('should add Authorization header to request', () async {
      final options = RequestOptions(path: '/test');
      final handler = MockRequestInterceptorHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers['Authorization'], 'Bearer valid_token');
      verify(() => handler.next(options)).called(1);
    });

    test('should NOT add Authorization header if token is null', () async {
      interceptor = AuthInterceptor(
        dio: mockDio,
        getAccessToken: () async => null,
        getRefreshToken: () async => null,
        refreshTokens: (_) async => false,
      );
      final options = RequestOptions(path: '/test');
      final handler = MockRequestInterceptorHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers.containsKey('Authorization'), false);
    });
  });
}
