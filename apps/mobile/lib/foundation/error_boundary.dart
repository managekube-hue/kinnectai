import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import '../config/error_registry.dart';

class AppErrorBoundary extends StatefulWidget {
  const AppErrorBoundary({required this.child, super.key});

  final Widget child;

  @override
  State<AppErrorBoundary> createState() => _AppErrorBoundaryState();
}

class _AppErrorBoundaryState extends State<AppErrorBoundary> {
  FlutterErrorDetails? _lastError;

  @override
  void initState() {
    super.initState();
    FlutterError.onError = (details) {
      developer.log(
        details.exceptionAsString(),
        name: 'AppErrorBoundary',
        error: details.exception,
        stackTrace: details.stack,
      );
      if (mounted) {
        setState(() => _lastError = details);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    final lastError = _lastError;
    if (lastError == null) {
      return widget.child;
    }

    final code = ErrorRegistry.mapException(lastError.exception);
    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Something went wrong',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text('Error code: $code'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => setState(() => _lastError = null),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
