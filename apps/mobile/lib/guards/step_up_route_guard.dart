import 'package:flutter/material.dart';

import '../utils/step_up_auth.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// Widget-level step-up authentication gate (PRD Addendum 2.0 §S12).
///
/// Wraps sensitive routes (Memory Box sealing, account deletion, password
/// change) with a biometric / PIN challenge before rendering [child].
///
/// Usage in router:
/// ```dart
/// GoRoute(
///   path: '/vault/seal',
///   pageBuilder: (_, __) => MaterialPage(
///     child: StepUpRouteGuard(child: MemoryBoxScreen()),
///   ),
/// ),
/// ```
class StepUpRouteGuard extends StatefulWidget {
  const StepUpRouteGuard({
    required this.child,
    this.reason = 'This action requires additional verification.',
    super.key,
  });

  final Widget child;
  final String reason;

  @override
  State<StepUpRouteGuard> createState() => _StepUpRouteGuardState();
}

class _StepUpRouteGuardState extends State<StepUpRouteGuard> {
  late final Future<bool> _challenge;

  @override
  void initState() {
    super.initState();
    _challenge = StepUpAuth.verify(context, reason: widget.reason);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _challenge,
      builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.data == true) {
          return widget.child;
        }
        return Scaffold(
          backgroundColor: KinnectColors.background,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_outline, size: 56, color: KinnectColors.textSecondary),
                  const SizedBox(height: 16),
                  Text(
                    'Authentication required',
                    style: KinnectTextStyles.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.reason,
                    style: KinnectTextStyles.bodyMedium.copyWith(
                      color: KinnectColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Go back'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
