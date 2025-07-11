import 'dart:async';
import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;
  final int maxRetries;
  final Duration initialDelay;

  ApiClient({
    required String baseUrl,
    required String apiKey,
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           headers: {
             'Authorization': 'Bearer $apiKey',
             'Accept': 'application/json',
           },
         ),
       ) {
    _dio.interceptors.add(
      LogInterceptor(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
      ),
    );
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) {
    return _retryRequest(() => _dio.get(path, queryParameters: query));
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) {
    return _retryRequest(
      () => _dio.post(
        path,
        data: body,
        options: Options(contentType: 'application/json'),
      ),
    );
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) {
    return _retryRequest(
      () => _dio.put(
        path,
        data: body,
        options: Options(contentType: 'application/json'),
      ),
    );
  }

  Future<void> delete(String path) {
    return _retryRequest(() => _dio.delete(path));
  }

  Future<dynamic> _retryRequest(Future<Response> Function() requestFn) async {
    var attempt = 0;
    var delay = initialDelay;

    while (true) {
      try {
        final response = await requestFn();
        return response.data;
      } on DioError catch (e) {
        final status = e.response?.statusCode;
        final shouldRetry =
            status == null || [408, 429, 500, 502, 503, 504].contains(status);

        attempt++;
        if (attempt > maxRetries || !shouldRetry) {
          rethrow;
        }
        await Future.delayed(delay);
        delay *= 2;
      }
    }
  }
}
