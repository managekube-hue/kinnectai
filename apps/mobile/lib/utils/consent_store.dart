import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'audit_logger.dart';

/// Consent record storage (GDPR Art. 7 / Addendum 3.0 S4).
///
/// Consent records stored separately from user data, retrievable on request.
/// All consent changes trigger AuditLogger entries.
class ConsentStore {
  ConsentStore._();

  static const _boxName = 'consent_records';
  static Box<String>? _box;

  /// Initialize Hive box for consent records.
  static Future<void> initialize() async {
    _box = await Hive.openBox<String>(_boxName);
  }

  /// Record a consent grant/revocation.
  static Future<void> record({
    required String userId,
    required ConsentType type,
    required bool granted,
    String? details,
    String? jurisdiction, // EU, US-IL (BIPA), US-CA (CCPA), etc.
  }) async {
    final record = ConsentRecord(
      userId: userId,
      type: type,
      granted: granted,
      timestamp: DateTime.now(),
      details: details,
      jurisdiction: jurisdiction ?? 'default',
    );

    final key = '${userId}_${type.name}';
    await _box?.put(key, jsonEncode(record.toJson()));

    // Log to audit trail
    AuditLogger.logConsent(
      userId: userId,
      consentType: type.name,
      granted: granted,
      details: details,
    );

    debugPrint('[ConsentStore] ${granted ? "GRANTED" : "REVOKED"}: ${type.name} for $userId ($jurisdiction)');
  }

  /// Get the current consent status for a specific type.
  static ConsentRecord? getConsent(String userId, ConsentType type) {
    final key = '${userId}_${type.name}';
    final raw = _box?.get(key);
    if (raw == null) return null;
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return ConsentRecord.fromJson(json);
  }

  /// Check if consent is granted for a specific type.
  static bool isGranted(String userId, ConsentType type) {
    return getConsent(userId, type)?.granted ?? false;
  }

  /// Get all consent records for a user (for GDPR export).
  static List<ConsentRecord> getAllConsents(String userId) {
    final records = <ConsentRecord>[];
    for (final type in ConsentType.values) {
      final record = getConsent(userId, type);
      if (record != null) records.add(record);
    }
    return records;
  }

  /// Revoke all consents (for account deletion).
  static Future<void> revokeAll(String userId) async {
    for (final type in ConsentType.values) {
      final current = getConsent(userId, type);
      if (current != null && current.granted) {
        await record(userId: userId, type: type, granted: false, details: 'Account deletion');
      }
    }
  }

  /// Export all consent records as JSON (GDPR Art. 7).
  static String exportAsJson(String userId) {
    final records = getAllConsents(userId);
    return jsonEncode(records.map((r) => r.toJson()).toList());
  }
}

enum ConsentType {
  /// Voiceprint biometric capture (BIPA / GDPR Art. 9).
  voiceprintBiometric,

  /// Facial matching biometric (BIPA / GDPR Art. 9).
  facialBiometric,

  /// Genomic data processing (GDPR Art. 9).
  genomicData,

  /// Room recording consent.
  roomRecording,

  /// Steward designation agreement.
  stewardAgreement,

  /// Off-platform data tracking (Layer 4 behavioral).
  offPlatformTracking,

  /// NielsenIQ / Facteus data sharing.
  thirdPartySharing,

  /// Push notification consent.
  pushNotifications,

  /// Analytics / anonymized usage data.
  analyticsTracking,

  /// COPPA guardian consent (for minors).
  coppaGuardian,

  /// Memory Box posthumous trigger.
  memoryBoxPosthumous,
}

class ConsentRecord {
  const ConsentRecord({
    required this.userId,
    required this.type,
    required this.granted,
    required this.timestamp,
    this.details,
    this.jurisdiction = 'default',
  });

  final String userId;
  final ConsentType type;
  final bool granted;
  final DateTime timestamp;
  final String? details;
  final String jurisdiction;

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'type': type.name,
    'granted': granted,
    'timestamp': timestamp.toIso8601String(),
    'details': details,
    'jurisdiction': jurisdiction,
  };

  factory ConsentRecord.fromJson(Map<String, dynamic> json) {
    return ConsentRecord(
      userId: json['user_id'] as String,
      type: ConsentType.values.firstWhere((t) => t.name == json['type'], orElse: () => ConsentType.analyticsTracking),
      granted: json['granted'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      details: json['details'] as String?,
      jurisdiction: json['jurisdiction'] as String? ?? 'default',
    );
  }
}
