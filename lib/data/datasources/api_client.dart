import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:worker_manager/worker_manager.dart';

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
    _dio.interceptors.add(LogInterceptor(responseBody: true));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) async {
          if (response.data is String) {
            final jsonStr = response.data as String;
            final decoded = await workerManager.execute<Map<String, dynamic>>(
              () => jsonDecode(jsonStr) as Map<String, dynamic>,
              priority: WorkPriority.immediately,
            );
            response.data = decoded;
          }
          handler.next(response);
        },
      ),
    );
  }

  Future<T> get<T>(String path, {Map<String, dynamic>? query}) =>
      _retryRequest<T>(() => _dio.get(path, queryParameters: query));

  Future<T> post<T>(String path, Map<String, dynamic> body) =>
      _retryRequest<T>(() => _dio.post(path, data: body));

  Future<T> put<T>(String path, Map<String, dynamic> body) =>
      _retryRequest<T>(() => _dio.put(path, data: body));

  Future<void> delete(String path) =>
      _retryRequest<void>(() => _dio.delete(path));

  Future<T> _retryRequest<T>(Future<Response> Function() requestFn) async {
    var attempt = 0;
    var delay = initialDelay;

    while (true) {
      try {
        final response = await requestFn();
        return response.data as T;
      } on DioError catch (e) {
        final code = e.response?.statusCode;
        final isRetryable =
            code == null || [408, 429, 500, 502, 503, 504].contains(code);

        attempt++;
        if (attempt > maxRetries || !isRetryable) {
          rethrow;
        }
        await Future.delayed(delay);
        delay *= 2;
      }
    }
  }
}
