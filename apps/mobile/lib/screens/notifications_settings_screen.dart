import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../theme/colors.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  // Notification toggles: Push and In-App
  final Map<String, Map<String, bool>> _notifications = {
    'pulses': {'push': true, 'inApp': true},
    'kinnections': {'push': true, 'inApp': true},
    'mentions': {'push': true, 'inApp': true},
    'comments': {'push': true, 'inApp': true},
    'messages': {'push': true, 'inApp': true},
    'gatherings': {'push': true, 'inApp': true},
    'branch': {'push': true, 'inApp': true},
    'heartbeat': {'push': true, 'inApp': true},
    'echoes': {'push': true, 'inApp': true},
    'memorybox': {'push': true, 'inApp': true}, // Cannot be fully disabled
    'kinshipalerts': {'push': true, 'inApp': true},
    'ripples': {'push': false, 'inApp': true},
    'lostbranches': {'push': true, 'inApp': true},
    'live': {'push': false, 'inApp': true},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: _disableAll,
            child: const Text('Disable All', style: TextStyle(color: KinnectColors.error)),
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildInfo(),
          _buildNotificationTile(
            'Pulses',
            'Reactions and comments on your Memories',
            PhosphorIcons.heart(),
            'pulses',
          ),
          _buildNotificationTile(
            'New Kinnections',
            'Confirmed connections and Discovery matches',
            PhosphorIcons.usersThree(),
            'kinnections',
          ),
          _buildNotificationTile(
            'Mentions',
            'When you\'re tagged in Memories or comments',
            PhosphorIcons.at(),
            'mentions',
          ),
          _buildNotificationTile(
            'Comments',
            'Replies to your Memories',
            PhosphorIcons.chatCircleText(),
            'comments',
          ),
          _buildNotificationTile(
            'Messages',
            'Direct messages from Kinnections',
            PhosphorIcons.chatDots(),
            'messages',
          ),
          _buildNotificationTile(
            'Gatherings',
            'Room invites and reminders',
            PhosphorIcons.calendarBlank(),
            'gatherings',
          ),
          _buildNotificationTile(
            'Branch Activity',
            'New Memories, Merges, Markers',
            PhosphorIcons.treeStructure(),
            'branch',
          ),
          _buildNotificationTile(
            'Heartbeat',
            'Daily morning digest (recommended)',
            PhosphorIcons.heartbeat(),
            'heartbeat',
            recommended: true,
          ),
          _buildNotificationTile(
            'Echoes',
            'On This Day memory matches',
            PhosphorIcons.clockCounterClockwise(),
            'echoes',
          ),
          _buildNotificationTile(
            'Memory Box',
            'Vault deliveries and Steward alerts',
            PhosphorIcons.lock(),
            'memorybox',
            required: true,
          ),
          _buildNotificationTile(
            'Kinship Alerts',
            'Kin proximity geofence triggers',
            PhosphorIcons.mapPin(),
            'kinshipalerts',
          ),
          _buildNotificationTile(
            'Ripples',
            'Your Memory reaches high engagement',
            PhosphorIcons.trendUp(),
            'ripples',
          ),
          _buildNotificationTile(
            'Lost Branches',
            'New probable Kinnections found',
            PhosphorIcons.magnifyingGlass(),
            'lostbranches',
          ),
          _buildNotificationTile(
            'Live Broadcasts',
            'Kin converts Room to Live',
            PhosphorIcons.broadcast(),
            'live',
          ),
        ],
      ),
    );
  }

  Widget _buildInfo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KinnectColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(PhosphorIcons.info(), color: KinnectColors.accent, size: 20),
              SizedBox(width: 8),
              Text('Push vs In-App', style: TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Push: Device notifications\nIn-App: Pulse tab inbox\n\nDisabling Push won\'t affect In-App history.',
            style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(
    String title,
    String subtitle,
    IconData icon,
    String key, {
    bool recommended = false,
    bool required = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: KinnectColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: KinnectColors.accent),
            title: Row(
              children: [
                Text(title, style: const TextStyle(color: KinnectColors.textPrimary)),
                if (recommended) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: KinnectColors.success.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'RECOMMENDED',
                      style: TextStyle(color: KinnectColors.success, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                if (required) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: KinnectColors.error.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'REQUIRED',
                      style: TextStyle(color: KinnectColors.error, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ],
            ),
            subtitle: Text(subtitle, style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Text('Push', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                      const SizedBox(width: 8),
                      Switch(
                        value: _notifications[key]!['push']!,
                        activeColor: KinnectColors.accent,
                        onChanged: required
                            ? null
                            : (value) => setState(() => _notifications[key]!['push'] = value),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Text('In-App', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                      const SizedBox(width: 8),
                      Switch(
                        value: _notifications[key]!['inApp']!,
                        activeColor: KinnectColors.accent,
                        onChanged: (value) => setState(() => _notifications[key]!['inApp'] = value),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _disableAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: KinnectColors.surface,
        title: const Text('Disable All Notifications?', style: TextStyle(color: KinnectColors.textPrimary)),
        content: const Text(
          'This will disable Push notifications for all types (except Memory Box which is required).\n\nIn-App notifications will remain in your Pulse tab.',
          style: TextStyle(color: KinnectColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: KinnectColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _notifications.forEach((key, value) {
                  if (key != 'memorybox') {
                    value['push'] = false;
                  }
                });
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: KinnectColors.error),
            child: const Text('Disable All Push'),
          ),
        ],
      ),
    );
  }
}
