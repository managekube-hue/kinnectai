import 'package:flutter/foundation.dart';

/// Immutable audit trail logger (Addendum 3.0 S4).
///
/// All consent events, sensitive actions, and security events are logged
/// here. In production, these are forwarded to AWS CloudTrail.
class AuditLogger {
  AuditLogger._();

  static final List<AuditEntry> _localLog = [];

  /// Log a consent event (biometric, steward, recording, data sharing).
  static void logConsent({
    required String userId,
    required String consentType,
    required bool granted,
    String? details,
  }) {
    _log(AuditEntry(
      category: AuditCategory.consent,
      action: granted ? 'consent_granted' : 'consent_declined',
      userId: userId,
      metadata: {
        'consent_type': consentType,
        'granted': granted,
        if (details != null) 'details': details,
      },
    ));
  }

  /// Log a security event (login, device change, password change, 2FA).
  static void logSecurity({
    required String userId,
    required String action,
    Map<String, dynamic>? metadata,
  }) {
    _log(AuditEntry(
      category: AuditCategory.security,
      action: action,
      userId: userId,
      metadata: metadata ?? {},
    ));
  }

  /// Log a sensitive data operation (DNA deletion, voiceprint revocation, export).
  static void logDataOperation({
    required String userId,
    required String operation,
    required String dataType,
    Map<String, dynamic>? metadata,
  }) {
    _log(AuditEntry(
      category: AuditCategory.dataOperation,
      action: operation,
      userId: userId,
      metadata: {
        'data_type': dataType,
        ...?metadata,
      },
    ));
  }

  /// Log a Memory Box lifecycle event (seal, trigger, delivery, steward action).
  static void logMemoryBox({
    required String userId,
    required String memoryId,
    required String action,
    Map<String, dynamic>? metadata,
  }) {
    _log(AuditEntry(
      category: AuditCategory.memoryBox,
      action: action,
      userId: userId,
      metadata: {
        'memory_id': memoryId,
        ...?metadata,
      },
    ));
  }

  /// Log a moderation action (content flagged, blocked, reported).
  static void logModeration({
    required String action,
    required String contentId,
    String? reporterId,
    Map<String, dynamic>? metadata,
  }) {
    _log(AuditEntry(
      category: AuditCategory.moderation,
      action: action,
      userId: reporterId ?? 'system',
      metadata: {
        'content_id': contentId,
        ...?metadata,
      },
    ));
  }

  static void _log(AuditEntry entry) {
    _localLog.add(entry);
    debugPrint('[Audit] ${entry.category.name}/${entry.action} user=${entry.userId} ${entry.metadata}');

    // POST /v1/audit/log { ...entry.toJson() }
  }

  /// Get local audit log (for debugging / local display).
  static List<AuditEntry> get localLog => List.unmodifiable(_localLog);

  /// Clear local log (does NOT affect server-side CloudTrail).
  static void clearLocal() => _localLog.clear();
}

enum AuditCategory { consent, security, dataOperation, memoryBox, moderation }

class AuditEntry {
  AuditEntry({
    required this.category,
    required this.action,
    required this.userId,
    required this.metadata,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  final AuditCategory category;
  final String action;
  final String userId;
  final Map<String, dynamic> metadata;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
    'category': category.name,
    'action': action,
    'user_id': userId,
    'metadata': metadata,
    'timestamp': timestamp.toIso8601String(),
  };
}
