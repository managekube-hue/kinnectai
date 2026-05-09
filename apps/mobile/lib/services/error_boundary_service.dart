import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Global error boundary service (Addendum 2.0 S6).
///
/// Standard error taxonomy:
/// - NetworkError: inline banner + cached fallback
/// - ServerError(5xx): full-screen illustration
/// - ClientError(4xx): toast + disable CTA
/// - GraphError: partial render
/// - MediaError: placeholder + background retry
class ErrorBoundaryService {
  ErrorBoundaryService._();

  /// Classify a Dio error into a KinnectAI error type.
  static KinnectError classify(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          return KinnectError(
            type: ErrorType.network,
            message: 'No connection. Tap to retry.',
            retryAction: RetryAction.exponentialBackoff,
          );
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode ?? 0;
          if (statusCode >= 500) {
            return KinnectError(
              type: ErrorType.server,
              message: 'KinnectAI servers are updating. We\'ll be back shortly.',
              retryAction: RetryAction.healthCheck,
              statusCode: statusCode,
            );
          }
          if (statusCode == 429) {
            final retryAfter = int.tryParse(
              error.response?.headers.value('Retry-After') ?? '',
            );
            return KinnectError(
              type: ErrorType.rateLimit,
              message: 'Too many requests. Please wait.',
              retryAction: RetryAction.exponentialBackoff,
              retryAfterSeconds: retryAfter,
            );
          }
          return KinnectError(
            type: ErrorType.client,
            message: 'Action not permitted. Please check permissions.',
            retryAction: RetryAction.disableCta,
            statusCode: statusCode,
          );
        default:
          return KinnectError(
            type: ErrorType.unknown,
            message: error.message ?? 'An unexpected error occurred.',
            retryAction: RetryAction.retry,
          );
      }
    }

    return KinnectError(
      type: ErrorType.unknown,
      message: error.toString(),
      retryAction: RetryAction.retry,
    );
  }

  /// Exponential backoff retry: 1s, 2s, 4s, max 8s.
  static Duration backoffDelay(int attempt) {
    final seconds = (1 << attempt).clamp(1, 8);
    return Duration(seconds: seconds);
  }

  /// Execute with retry logic.
  static Future<T> withRetry<T>(
    Future<T> Function() action, {
    int maxAttempts = 3,
  }) async {
    for (int i = 0; i < maxAttempts; i++) {
      try {
        return await action();
      } catch (e) {
        final error = classify(e);
        if (i == maxAttempts - 1 || error.type == ErrorType.client) {
          rethrow;
        }
        await Future<void>.delayed(backoffDelay(i));
        debugPrint('Retry attempt ${i + 1}/$maxAttempts after ${error.message}');
      }
    }
    throw Exception('Max retry attempts reached');
  }
}

enum ErrorType { network, server, client, rateLimit, graph, media, unknown }

enum RetryAction { exponentialBackoff, healthCheck, disableCta, retry, none }

class KinnectError {
  const KinnectError({
    required this.type,
    required this.message,
    required this.retryAction,
    this.statusCode,
    this.retryAfterSeconds,
  });

  final ErrorType type;
  final String message;
  final RetryAction retryAction;
  final int? statusCode;
  final int? retryAfterSeconds;

  @override
  String toString() => 'KinnectError($type): $message';
}
