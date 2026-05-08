import 'package:flutter/foundation.dart';

/// Network error handler with retry logic
class NetworkErrorHandler {
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  /// Execute a network request with automatic retry
  static Future<T> executeWithRetry<T>({
    required Future<T> Function() request,
    int maxAttempts = maxRetries,
    Duration delay = retryDelay,
    bool Function(dynamic error)? shouldRetry,
  }) async {
    int attempts = 0;
    dynamic lastError;

    while (attempts < maxAttempts) {
      try {
        attempts++;
        debugPrint('?? Attempt $attempts/$maxAttempts');
        
        return await request();
        
      } catch (error) {
        lastError = error;
        debugPrint('? Attempt $attempts failed: $error');

        // Check if we should retry this error
        if (shouldRetry != null && !shouldRetry(error)) {
          rethrow;
        }

        // Don't retry if max attempts reached
        if (attempts >= maxAttempts) {
          rethrow;
        }

        // Wait before retrying with exponential backoff
        final backoffDelay = delay * attempts;
        debugPrint('? Waiting ${backoffDelay.inSeconds}s before retry...');
        await Future.delayed(backoffDelay);
      }
    }

    throw lastError ?? Exception('Request failed after $maxAttempts attempts');
  }

  /// Check if error is retryable (network errors, timeouts, 5xx)
  static bool isRetryable(dynamic error) {
    if (error == null) return false;
    
    final errorString = error.toString().toLowerCase();
    
    // Network errors
    if (errorString.contains('socketexception') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('unreachable')) {
      return true;
    }
    
    // HTTP 5xx errors
    if (errorString.contains('500') ||
        errorString.contains('502') ||
        errorString.contains('503') ||
        errorString.contains('504')) {
      return true;
    }
    
    return false;
  }

  /// Parse error to user-friendly message
  static String getUserMessage(dynamic error) {
    if (error == null) return 'An unknown error occurred';
    
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('socketexception') ||
        errorString.contains('connection')) {
      return 'No internet connection. Please check your network.';
    }
    
    if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    
    if (errorString.contains('404')) {
      return 'Content not found.';
    }
    
    if (errorString.contains('403') || errorString.contains('unauthorized')) {
      return 'You do not have permission to access this content.';
    }
    
    if (errorString.contains('500') ||
        errorString.contains('502') ||
        errorString.contains('503')) {
      return 'Server error. Please try again later.';
    }
    
    return 'Something went wrong. Please try again.';
  }
}

/// Result wrapper for API calls with error handling
class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  const Result.success(this.data)
      : error = null,
        isSuccess = true;

  const Result.failure(this.error)
      : data = null,
        isSuccess = false;

  /// Execute callback if successful
  Result<R> map<R>(R Function(T data) transform) {
    if (isSuccess && data != null) {
      try {
        return Result.success(transform(data as T));
      } catch (e) {
        return Result.failure(e.toString());
      }
    }
    return Result.failure(error ?? 'No data');
  }

  /// Execute callback on error
  Result<T> onError(void Function(String error) callback) {
    if (!isSuccess && error != null) {
      callback(error!);
    }
    return this;
  }

  /// Get data or throw error
  T getOrThrow() {
    if (isSuccess && data != null) {
      return data as T;
    }
    throw Exception(error ?? 'No data available');
  }

  /// Get data or return default value
  T getOrDefault(T defaultValue) {
    return data ?? defaultValue;
  }
}
