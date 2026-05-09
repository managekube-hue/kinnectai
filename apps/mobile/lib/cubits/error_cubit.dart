import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ---------------------------------------------------------------------------
// States
// ---------------------------------------------------------------------------

sealed class ErrorState extends Equatable {
  const ErrorState();

  @override
  List<Object?> get props => [];
}

class ErrorClear extends ErrorState {}

class ErrorActive extends ErrorState {
  const ErrorActive({
    required this.message,
    required this.timestamp,
    this.code,
    this.source,
    this.stackTrace,
  });

  final String message;
  final DateTime timestamp;
  final String? code;
  final String? source;
  final String? stackTrace;

  @override
  List<Object?> get props => [message, timestamp, code, source, stackTrace];
}

// ---------------------------------------------------------------------------
// Cubit
// ---------------------------------------------------------------------------

/// Global error handler cubit. Widgets listen to this to show snackbars,
/// dialogs, or error banners.
class ErrorCubit extends Cubit<ErrorState> {
  ErrorCubit() : super(ErrorClear());

  /// Report an error from anywhere in the app.
  void report({
    required String message,
    String? code,
    String? source,
    Object? error,
    StackTrace? stackTrace,
  }) {
    debugPrint('[ErrorCubit] $source: $message (code=$code)');
    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }

    emit(ErrorActive(
      message: message,
      timestamp: DateTime.now(),
      code: code,
      source: source,
      stackTrace: stackTrace?.toString(),
    ));
  }

  /// Clear the current error (e.g. after the user dismisses it).
  void clear() {
    emit(ErrorClear());
  }
}


