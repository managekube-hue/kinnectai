import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../cubits/error_cubit.dart';
import '../services/error_boundary_service.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// Global error boundary widget (Addendum 2.0 S6).
///
/// Wraps screens to catch and display errors from ErrorCubit.
/// Shows snackbars, banners, or full-screen errors based on error type.
class AppErrorBoundary extends StatelessWidget {
  const AppErrorBoundary({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ErrorCubit, ErrorState>(
      listener: (context, state) {
        if (state is ErrorActive) {
          _showError(context, state);
        }
      },
      child: child,
    );
  }

  void _showError(BuildContext context, ErrorActive error) {
    final classified = ErrorBoundaryService.classify(Exception(error.message));

    switch (classified.type) {
      case ErrorType.network:
        _showBanner(context, error.message, KinnectColors.warning, PhosphorIcons.wifiSlash());
        break;
      case ErrorType.server:
        _showBanner(context, error.message, KinnectColors.error, PhosphorIcons.cloud());
        break;
      case ErrorType.rateLimit:
        _showBanner(context, 'Too many requests. Please wait.', KinnectColors.warning, PhosphorIcons.clock());
        break;
      case ErrorType.client:
      case ErrorType.graph:
      case ErrorType.media:
      case ErrorType.unknown:
        _showSnackbar(context, error.message);
        break;
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: KinnectColors.error,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () => context.read<ErrorCubit>().clear(),
        ),
      ),
    );
  }

  void _showBanner(BuildContext context, String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        backgroundColor: color.withOpacity(0.15),
        leading: Icon(icon, color: color),
        content: Text(message, style: TextStyle(color: KinnectColors.textPrimary)),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              context.read<ErrorCubit>().clear();
            },
            child: Text('Dismiss', style: TextStyle(color: color)),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              // Trigger retry via ErrorCubit or navigator
            },
            child: Text('Retry', style: TextStyle(color: KinnectColors.primary)),
          ),
        ],
      ),
    );
  }
}

/// Offline banner widget shown when connectivity is lost.
/// Per Addendum 2.0 S5: "Offline: Showing cached Line. Swipe to refresh when connected."
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: KinnectColors.warning.withOpacity(0.15),
      child: Row(
        children: [
          Icon(PhosphorIcons.wifiSlash(), size: 18, color: KinnectColors.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message ?? 'Offline: Showing cached data. Swipe to refresh when connected.',
              style: TextStyle(color: KinnectColors.warning, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-screen error widget for server errors.
class FullScreenError extends StatelessWidget {
  const FullScreenError({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(PhosphorIcons.cloud(), size: 64, color: KinnectColors.textMuted),
            const SizedBox(height: 16),
            Text('Something went wrong', style: KinnectTextStyles.headlineSmall),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: KinnectColors.textSecondary, fontSize: 14),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(PhosphorIcons.arrowCounterClockwise(), size: 18),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: KinnectColors.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
