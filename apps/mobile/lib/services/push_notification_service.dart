import 'package:flutter/foundation.dart';

import 'deep_link_service.dart';

/// Push notification routing service (Addendum 2.0 S10).
///
/// Maps FCM notification payloads to deep link routes.
/// Auth check: if auth invalid -> route to AuthBloc.loginFlow.
/// Expired payload: show toast + route to home.
class PushNotificationService {
  PushNotificationService._();

  /// Initialize FCM and register handlers.
  static Future<void> initialize() async {
    // TODO: Wire to firebase_messaging when available
    // FirebaseMessaging.onMessage.listen(_handleForeground);
    // FirebaseMessaging.onMessageOpenedApp.listen(_handleBackground);
    // final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    // if (initialMessage != null) _handleInitial(initialMessage);
    debugPrint('[PushNotification] Service initialized');
  }

  /// Route a notification payload to the correct screen.
  /// Returns the go_router path to navigate to.
  static String? routeFromPayload(Map<String, dynamic> data) {
    final type = data['type']?.toString();
    if (type == null) return null;

    switch (type) {
      // Memory Box Delivery -> kinnect://vault/{id}
      case 'memory_box_delivery':
        final memoryId = data['memory_id']?.toString();
        return memoryId != null ? '/vault/$memoryId' : '/memory-box';

      // New Kinnection -> kinnect://root/{id}/profile
      case 'new_kinnection':
        final kinId = data['kin_id']?.toString();
        return kinId != null ? '/root/$kinId/profile' : '/discover';

      // Kinship Alert -> kinnect://alert/{id}/map
      case 'kinship_alert':
        final alertId = data['alert_id']?.toString();
        return alertId != null ? '/alert/$alertId/map' : '/kinship-alerts';

      // Gathering Invite -> kinnect://room/{id}
      case 'gathering_invite':
        final roomId = data['room_id']?.toString();
        return roomId != null ? '/rooms' : '/rooms';

      // Echoes -> kinnect://line/{id}/echo
      case 'echoes':
        final memoryId = data['memory_id']?.toString();
        return memoryId != null ? '/line/$memoryId/echo' : '/echoes';

      // Branch Merge -> kinnect://branch/{id}/merge
      case 'branch_merge':
        final branchId = data['branch_id']?.toString();
        return branchId != null ? '/branch/$branchId/merge' : '/tree';

      // Live Broadcast -> kinnect://live/{id}
      case 'live_broadcast':
        return '/line';

      // Pulse / Comment / Mention
      case 'pulse':
      case 'comment':
      case 'mention':
        return '/line';

      // Message
      case 'message':
        final senderId = data['sender_id']?.toString();
        return senderId != null ? '/dm/$senderId' : '/line';

      // Heartbeat (daily digest)
      case 'heartbeat':
        return '/line';

      // Ripple
      case 'ripple':
        final memoryId = data['memory_id']?.toString();
        return memoryId != null ? '/memory/$memoryId' : '/line';

      // Lost Branches
      case 'lost_branches':
        return '/discover';

      default:
        debugPrint('[PushNotification] Unknown type: $type');
        return '/line';
    }
  }

  /// Check if a payload has expired (e.g. old notification).
  static bool isExpired(Map<String, dynamic> data) {
    final sentAt = data['sent_at']?.toString();
    if (sentAt == null) return false;

    final sent = DateTime.tryParse(sentAt);
    if (sent == null) return false;

    // Consider expired if older than 7 days
    return DateTime.now().difference(sent).inDays > 7;
  }
}
