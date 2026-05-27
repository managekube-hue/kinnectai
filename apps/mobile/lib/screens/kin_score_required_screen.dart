import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// Shown when a user tries to access a route that requires a minimum Kin Score
/// they have not yet reached.
class KinScoreRequiredScreen extends StatelessWidget {
  const KinScoreRequiredScreen({super.key, this.requiredScore});

  /// The minimum score that was required (if available from the query params).
  final double? requiredScore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: KinnectColors.warning,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    PhosphorIcons.lock(),
                    color: KinnectColors.warning,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Kin Score Required',
                  style: KinnectTextStyles.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  requiredScore != null
                      ? 'This content requires a minimum Kin Score of '
                          '${requiredScore!.toStringAsFixed(2)}. '
                          'Strengthen your connections to unlock access.'
                      : 'This content requires a higher Kin Score. '
                          'Strengthen your connections to unlock access.',
                  textAlign: TextAlign.center,
                  style: KinnectTextStyles.bodyLarge.copyWith(
                    color: KinnectColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KinnectColors.accent,
                      foregroundColor: KinnectColors.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => context.go('/line'),
                    child: const Text('Go to Home'),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.go('/kin-score-detail'),
                  child: Text(
                    'Learn about Kin Score',
                    style: KinnectTextStyles.bodyLarge.copyWith(
                      color: KinnectColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
