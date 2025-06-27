import 'package:dio/dio.dart';

import '../core_exporter.dart';

abstract class DioClientInterface extends InjectableService {
  DioClientInterface setBaseUrl(String baseUrl);

  DioClientInterface setHeaders(Map<String, dynamic> headers);

  DioClientInterface setConnectTimeout(Duration connectTimeout);

  DioClientInterface setReceiveTimeout(Duration receiveTimeout);

  DioClientInterface setResponseType(ResponseType responseType);

  DioClientInterface addInterceptor(Interceptor interceptor);

  DioClientInterface setUri(String uri);

  DioClientInterface setData(Object data);

  DioClientInterface setPathParameters(Map<String, dynamic> pathParameters);

  DioClientInterface setQueryParameters(Map<String, dynamic> queryParameters);

  DioClientInterface setOptions(Options options);

  DioClientInterface setCancelToken(CancelToken cancelToken);

  DioClientInterface setOnSendProgress(ProgressCallback onSendProgress);

  DioClientInterface setOnReceiveProgress(ProgressCallback onReceiveProgress);
}
