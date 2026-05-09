import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/typography.dart';

/// Wraps [child] with a connectivity overlay (PRD Items 72–74, 103).
///
/// When the device is offline, [OfflineBanner] is shown above [child] (or
/// [offlinePlaceholder] replaces it entirely if provided). When connectivity
/// is restored, [retryAction] is called automatically.
///
/// Example:
/// ```dart
/// NetworkErrorBoundary(
///   retryAction: () => context.read<LineCubit>().refresh(),
///   child: LineFeedView(),
/// )
/// ```
class NetworkErrorBoundary extends StatefulWidget {
  const NetworkErrorBoundary({
    required this.retryAction,
    required this.child,
    this.offlinePlaceholder,
    super.key,
  });

  final Future<void> Function() retryAction;
  final Widget child;

  /// When set, replaces [child] entirely while offline instead of showing a
  /// banner. Useful for screens whose data cannot be loaded without network.
  final Widget? offlinePlaceholder;

  @override
  State<NetworkErrorBoundary> createState() => _NetworkErrorBoundaryState();
}

class _NetworkErrorBoundaryState extends State<NetworkErrorBoundary> {
  late final Stream<List<ConnectivityResult>> _stream;
  bool _offline = false;

  @override
  void initState() {
    super.initState();
    _stream = Connectivity().onConnectivityChanged;
    _checkInitial();
  }

  Future<void> _checkInitial() async {
    final results = await Connectivity().checkConnectivity();
    if (mounted) {
      setState(() => _offline = results.contains(ConnectivityResult.none));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: _stream,
      builder: (ctx, snap) {
        final results = snap.data;
        if (results != null) {
          final wasOffline = _offline;
          _offline = results.contains(ConnectivityResult.none);
          if (wasOffline && !_offline) {
            // Came back online — trigger retry asynchronously.
            Future.microtask(widget.retryAction);
          }
        }

        if (_offline) {
          return widget.offlinePlaceholder ??
              Column(
                children: [
                  _OfflineBanner(onRetry: widget.retryAction),
                  Expanded(child: widget.child),
                ],
              );
        }

        return widget.child;
      },
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: KinnectColors.surface,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.wifi_off, size: 16, color: KinnectColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'No internet connection',
                  style: KinnectTextStyles.bodySmall.copyWith(
                    color: KinnectColors.textSecondary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onRetry,
                child: Text(
                  'Retry',
                  style: KinnectTextStyles.bodySmall.copyWith(
                    color: KinnectColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
