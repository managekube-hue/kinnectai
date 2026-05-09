import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 09.1 -- Kinship Alerts + Addendum 1.0 Sidebar.
/// Geofence proximity alerts: "A Kin is 0.4 miles away right now."
class KinshipAlertMapScreen extends StatefulWidget {
  const KinshipAlertMapScreen({super.key});

  @override
  State<KinshipAlertMapScreen> createState() => _KinshipAlertMapScreenState();
}

class _KinshipAlertMapScreenState extends State<KinshipAlertMapScreen> {
  static final _alerts = [
    _AlertData(kinName: 'Emily Harrington', kinScore: 0.25, distance: '0.4 mi', time: '2 min ago', kinId: 'user_1'),
    _AlertData(kinName: 'Michael O\'Brien', kinScore: 0.125, distance: '1.2 mi', time: '15 min ago', kinId: 'user_2'),
    _AlertData(kinName: 'Sarah Vance', kinScore: 0.50, distance: '3.1 mi', time: '1 hour ago', kinId: 'user_3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Kinship Alerts', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Map placeholder
          Container(
            height: 250,
            width: double.infinity,
            color: KinnectColors.surfaceElevated,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(PhosphorIcons.mapPin(), size: 48, color: KinnectColors.primary),
                      const SizedBox(height: 8),
                      Text('Map View', style: TextStyle(color: KinnectColors.textSecondary)),
                      Text('Google Maps integration required', style: TextStyle(color: KinnectColors.textMuted, fontSize: 12)),
                    ],
                  ),
                ),
                // Kin pins (simulated)
                for (var i = 0; i < _alerts.length; i++)
                  Positioned(
                    left: 60.0 + i * 80,
                    top: 80.0 + (i % 2) * 60,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: KinnectColors.accent,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: KinnectColors.accent.withOpacity(0.4), blurRadius: 8)],
                      ),
                      child: Icon(PhosphorIcons.user(), size: 16, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),

          // Alert list
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Text('Nearby Kin', style: KinnectTextStyles.headlineSmall),
                const Spacer(),
                Text('${_alerts.length} alerts', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          Expanded(
            child: _alerts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(PhosphorIcons.mapPinLine(), size: 48, color: KinnectColors.textMuted),
                        const SizedBox(height: 12),
                        Text('No nearby Kin detected', style: TextStyle(color: KinnectColors.textSecondary)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _alerts.length,
                    itemBuilder: (context, i) => _AlertTile(alert: _alerts[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _AlertData {
  const _AlertData({required this.kinName, required this.kinScore, required this.distance, required this.time, required this.kinId});
  final String kinName;
  final double kinScore;
  final String distance;
  final String time;
  final String kinId;
}

class _AlertTile extends StatelessWidget {
  const _AlertTile({required this.alert});
  final _AlertData alert;

  @override
  Widget build(BuildContext context) {
    final scoreColor = alert.kinScore >= 0.25 ? KinnectColors.accent : KinnectColors.primary;

    return GestureDetector(
      onTap: () => AppNav.push(context, '/root/${alert.kinId}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: KinnectColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: KinnectColors.dividerSubtle),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scoreColor.withOpacity(0.15),
              ),
              child: Icon(PhosphorIcons.user(), color: scoreColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(alert.kinName, style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(
                    '${alert.distance} away -- ${alert.time}',
                    style: TextStyle(color: KinnectColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: scoreColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${(alert.kinScore * 100).round()}%',
                style: TextStyle(color: scoreColor, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
