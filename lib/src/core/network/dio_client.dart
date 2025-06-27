import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_isar_store/dio_cache_interceptor_isar_store.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:path/path.dart' as p;

import '../../../kappa.dart';
import 'dio_client_interface.dart';

/// A class that provides a wrapper around the Dio HTTP client library.
///
/// This class provides methods for making HTTP requests such as GET, POST, PUT, PATCH, and DELETE.
/// It also sets up the base URL, headers, timeouts, response type, and interceptors for the Dio client.
class DioClient extends DioClientInterface {
  Dio? _dio;
  String? _uri;
  Object? _data;
  Map<String, dynamic>? _pathParameters = {};
  Map<String, dynamic>? _queryParameters = {};
  Options? _options;
  CancelToken? _cancelToken;
  final List<CancelToken> _cancelTokens = <CancelToken>[];
  ProgressCallback? _onSendProgress;
  ProgressCallback? _onReceiveProgress;

  Dio get dio => _dio ?? Dio();

  String get uri => _uri ?? '';

  Object? get data => _data;

  Map<String, dynamic>? get pathParams => _pathParameters ?? {};

  Map<String, dynamic>? get queryParameters => _queryParameters ?? {};

  Options? get options => _options;

  CancelToken? get cancelToken => _cancelToken;

  ProgressCallback? get onSendProgress => _onSendProgress;

  ProgressCallback? get onReceiveProgress => _onReceiveProgress;

  DioClient() {
    _dio = Dio();

    _dio
      ?..options.baseUrl = AppEnvironments.appApiURL
      ..options.headers = {
        HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
      }
      ..options.connectTimeout = const Duration(milliseconds: 15000)
      ..options.receiveTimeout = const Duration(milliseconds: 15000)
      ..options.responseType = ResponseType.json
      ..interceptors.add(
        PrettyDioLogger(
          compact: false,
          logPrint: (object) {
            Logger.setLevel(Logger.lInfo);
            Logger.info(object.toString());
          },
        ),
      );
    _addDioCacheInterceptor();
  }

  void _addDioCacheInterceptor() async {
    await getApplicationDocumentsDirectory().then((dir) {
      final path = dir.path;
      _dio?.interceptors.add(DioCacheInterceptor(
        options: CacheOptions(
          store: IsarCacheStore(path),
          policy: CachePolicy.request,
          hitCacheOnErrorExcept: [401, 403],
          maxStale: const Duration(days: 7),
          allowPostMethod: false,
          keyBuilder: CacheOptions.defaultCacheKeyBuilder,
        ),
      ));
    });
  }

  String parsePathParams(String url, Map<String, dynamic>? pathParams) {
    if (pathParams != null) {
      pathParams.forEach((key, value) {
        url = url.replaceAll('{$key}', value.toString());
      });
    }
    return url;
  }

  String generateCacheKey(String baseUri, Map<String, String> queryParams) {
    final queryString = queryParams.entries.map((entry) => '${entry.key}=${entry.value}').join('&');
    return p.join(_dio?.options.baseUrl ?? '', '$baseUri?$queryString');
  }

  Future<void> cacheApiResponse(
    String key,
    String response,
    Duration duration,
  ) async {
    final expiredAt = DateTime.now().add(duration);

    final cacheEntry = ApiCacheCollection()
      ..key = key
      ..response = response
      ..createdAt = DateTime.now()
      ..expiredAt = expiredAt;

    await injector<LocalDatabase>().db.writeTxn(() async {
      await injector<LocalDatabase>().db.apiCacheCollections.put(cacheEntry);
    });
  }

  Future<void> cancelAllRequests() async {
    for (var token in _cancelTokens) {
      token.cancel('Request cancelled');
    }
    _cancelTokens.clear();
  }

  /// * GET
  Future<Response<dynamic>> get({bool refreshing = false}) async {
    final cancelToken = CancelToken();
    _cancelTokens.add(cancelToken);

    try {
      injector<LoaderCubit>().setLoading(true);
      String cacheKey = generateCacheKey(parsePathParams(uri, pathParams), queryParameters as Map<String, String>);

      if (refreshing) {
        final cache = await injector<LocalDatabase>()
            .db
            .apiCacheCollections
            .filter()
            .keyEqualTo(cacheKey)
            .and()
            .expiredAtGreaterThan(DateTime.now())
            .findFirst();

        if (cache != null) {
          return Response(
            requestOptions: RequestOptions(path: uri),
            data: cache.response,
            statusCode: 200,
            statusMessage: 'OK',
          );
        }
      }

      final response = await _dio!.get(
        parsePathParams(uri, pathParams),
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      _cancelTokens.remove(cancelToken);

      await cacheApiResponse(cacheKey, response.data.toString(), const Duration(days: 7));
      injector<LoaderCubit>().setLoading(false);
      return response;
    } on DioException {
      _cancelTokens.remove(cancelToken);
      rethrow;
    }
  }

  /// * POST
  Future<Response<dynamic>> post() async {
    try {
      injector<LoaderCubit>().setLoading(true);
      final response = await _dio!.post(
        parsePathParams(uri, pathParams),
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      injector<LoaderCubit>().setLoading(false);
      return response;
    } on DioException {
      rethrow;
    }
  }

  /// * PUT
  Future<Response<dynamic>> put() async {
    try {
      injector<LoaderCubit>().setLoading(true);
      final response = await _dio!.put(
        parsePathParams(uri, pathParams),
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      injector<LoaderCubit>().setLoading(false);
      return response;
    } on DioException {
      rethrow;
    }
  }

  /// * PATCH
  Future<Response<dynamic>> patch() async {
    try {
      injector<LoaderCubit>().setLoading(true);
      final response = await _dio!.patch(
        parsePathParams(uri, pathParams),
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      injector<LoaderCubit>().setLoading(false);
      return response;
    } on DioException {
      rethrow;
    }
  }

  /// * DELETE
  Future<dynamic> delete() async {
    try {
      injector<LoaderCubit>().setLoading(true);
      final response = await _dio!.delete(
        parsePathParams(uri, pathParams),
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      injector<LoaderCubit>().setLoading(false);
      return response;
    } on DioException {
      rethrow;
    }
  }

  @override
  DioClient addInterceptor(Interceptor interceptor) {
    _dio!.interceptors.add(interceptor);
    return this;
  }

  @override
  DioClient setBaseUrl(String baseUrl) {
    _dio!.options.baseUrl = baseUrl;
    return this;
  }

  @override
  DioClient setConnectTimeout(Duration connectTimeout) {
    _dio!.options.connectTimeout = connectTimeout;
    return this;
  }

  @override
  DioClient setHeaders(Map<String, dynamic> headers) {
    _dio!.options.headers.addAll(headers);
    return this;
  }

  @override
  DioClient setReceiveTimeout(Duration receiveTimeout) {
    _dio!.options.receiveTimeout = receiveTimeout;
    return this;
  }

  @override
  DioClient setResponseType(ResponseType responseType) {
    _dio!.options.responseType = responseType;
    return this;
  }

  @override
  DioClient setCancelToken(CancelToken cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  @override
  DioClient setData(Object data) {
    _data = data;
    return this;
  }

  @override
  DioClient setOnReceiveProgress(ProgressCallback onReceiveProgress) {
    _onReceiveProgress = onReceiveProgress;
    return this;
  }

  @override
  DioClient setOnSendProgress(ProgressCallback onSendProgress) {
    _onSendProgress = onSendProgress;
    return this;
  }

  @override
  DioClient setOptions(Options options) {
    _options = options;
    return this;
  }

  @override
  DioClient setPathParameters(Map<String, dynamic> pathParameters) {
    _pathParameters = pathParameters;
    return this;
  }

  @override
  DioClient setQueryParameters(Map<String, dynamic> queryParameters) {
    _queryParameters = queryParameters;
    return this;
  }

  @override
  DioClient setUri(String uri) {
    _uri = uri;
    return this;
  }
}
