import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../router/app_nav.dart';
import '../theme/colors.dart';

class PulseInboxScreen extends StatefulWidget {
  const PulseInboxScreen({super.key});

  @override
  State<PulseInboxScreen> createState() => _PulseInboxScreenState();
}

class _PulseInboxScreenState extends State<PulseInboxScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<PulseNotification> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _notifications = _getSampleNotifications();
      _isLoading = false;
    });
  }

  List<PulseNotification> _getSampleNotifications() {
    return [
      PulseNotification(
        id: '1',
        type: PulseType.pulse,
        fromUser: 'Sarah Kim',
        fromUserId: 'sarah_kim_id',
        memoryId: 'mem1',
        message: 'pulsed your Memory',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
      ),
      PulseNotification(
        id: '2',
        type: PulseType.comment,
        fromUser: 'Marcus Chen',
        fromUserId: 'marcus_chen_id',
        memoryId: 'mem2',
        message: 'commented on your Memory',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      PulseNotification(
        id: '3',
        type: PulseType.kinnection,
        fromUser: 'Elara Vance',
        fromUserId: 'elara_vance_id',
        message: 'accepted your Kinnection request',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Pulse Inbox'),
        actions: [
          IconButton(
            icon: Icon(PhosphorIcons.checks(), color: KinnectColors.textPrimary),
            onPressed: _markAllAsRead,
            tooltip: 'Mark all as read',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: KinnectColors.accent,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pulses'),
            Tab(text: 'Kinnections'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: KinnectColors.accent))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildNotificationList(_notifications),
                _buildNotificationList(_notifications.where((n) => n.type == PulseType.pulse || n.type == PulseType.comment).toList()),
                _buildNotificationList(_notifications.where((n) => n.type == PulseType.kinnection).toList()),
              ],
            ),
    );
  }

  Widget _buildNotificationList(List<PulseNotification> notifications) {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(PhosphorIcons.heart(), size: 64, color: KinnectColors.textMuted),
            const SizedBox(height: 16),
            const Text(
              'No new Pulses',
              style: TextStyle(color: KinnectColors.textPrimary, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your Pulse activity will appear here',
              style: TextStyle(color: KinnectColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      color: KinnectColors.accent,
      backgroundColor: KinnectColors.surface,
      child: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) => _buildNotificationCard(notifications[index]),
      ),
    );
  }

  Widget _buildNotificationCard(PulseNotification notification) {
    return Dismissible(
      key: Key(notification.id),
      onDismissed: (_) => _dismissNotification(notification),
      background: Container(
        color: KinnectColors.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: Icon(PhosphorIcons.trash(), color: KinnectColors.textPrimary),
      ),
      child: InkWell(
        onTap: () => _handleNotificationTap(notification),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.transparent : KinnectColors.surface.withOpacity(0.5),
            border: const Border(bottom: BorderSide(color: KinnectColors.dividerSubtle, width: 1)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: _getTypeColor(notification.type).withOpacity(0.2),
                child: Icon(_getTypeIcon(notification.type), color: _getTypeColor(notification.type)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: KinnectColors.textPrimary, fontSize: 14),
                        children: [
                          TextSpan(
                            text: notification.fromUser,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ' ${notification.message}'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTimestamp(notification.timestamp),
                      style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: KinnectColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(PulseType type) {
    switch (type) {
      case PulseType.pulse:
        return PhosphorIcons.heart();
      case PulseType.comment:
        return PhosphorIcons.chatCircleText();
      case PulseType.kinnection:
        return PhosphorIcons.usersThree();
      case PulseType.rewind:
        return PhosphorIcons.arrowUDownLeft();
    }
  }

  Color _getTypeColor(PulseType type) {
    switch (type) {
      case PulseType.pulse:
        return KinnectColors.error;
      case PulseType.comment:
        return KinnectColors.accent;
      case PulseType.kinnection:
        return KinnectColors.success;
      case PulseType.rewind:
        return KinnectColors.warning;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  void _handleNotificationTap(PulseNotification notification) {
    setState(() => notification.isRead = true);

    if (notification.memoryId != null) {
      AppNav.push(context, '/comments',
        arguments: {'memoryId': notification.memoryId},
      );
    } else if (notification.fromUserId != null) {
      AppNav.push(context, '/profile',
        arguments: {'userId': notification.fromUserId},
      );
    }
  }

  void _dismissNotification(PulseNotification notification) {
    setState(() => _notifications.remove(notification));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification removed'),
        backgroundColor: KinnectColors.surface,
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
  }
}

enum PulseType { pulse, comment, kinnection, rewind }

class PulseNotification {
  final String id;
  final PulseType type;
  final String fromUser;
  final String? fromUserId;
  final String? memoryId;
  final String message;
  final DateTime timestamp;
  bool isRead;

  PulseNotification({
    required this.id,
    required this.type,
    required this.fromUser,
    this.fromUserId,
    this.memoryId,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });
}





