import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

class DioClient {
  DioClient._();

  static Dio? _instance;

  static Dio instance() {
    if (_instance != null) return _instance!;

    final dio = Dio(
      BaseOptions(
        baseUrl: const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8080/api'),
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        logPrint: (message) {},
        retries: 3,
        retryDelays: const [
          Duration(milliseconds: 500),
          Duration(seconds: 1),
          Duration(seconds: 2),
        ],
        retryEvaluator: (error, _) {
          final code = error.response?.statusCode ?? 0;
          return code == 429 || code >= 500 || error.type == DioExceptionType.connectionTimeout || error.type == DioExceptionType.connectionError;
        },
      ),
    );

    _instance = dio;
    return dio;
  }
}
