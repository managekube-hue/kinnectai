import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Consent-aware analytics wrapper (PRD Addendum 3.0 §S4, Items 36–40, 102).
///
/// All Firebase Analytics calls must pass through this class.
/// Events that involve off-platform data (consent layer 4, bitmask 0x08)
/// are silently dropped when the user has not granted that consent.
///
/// Consent bitmask layout:
/// ```
/// 0x01 — Layer 1: Identity matching
/// 0x02 — Layer 2: Genomic / bioidentity
/// 0x04 — Layer 3: Behavioural profiling
/// 0x08 — Layer 4: Off-platform tracking
/// 0x10 — Layer 5: Third-party data sharing
/// ```
abstract class ConsentAnalytics {
  static const _consentBox = 'user_consent';
  static const _consentFlagsKey = 'consent_flags';

  // Layer bitmask constants
  static const int layerIdentity = 0x01;
  static const int layerGenomic = 0x02;
  static const int layerBehavioural = 0x04;
  static const int layerOffPlatform = 0x08;
  static const int layerThirdParty = 0x10;

  /// Track an event, subject to consent gating.
  ///
  /// Pass `offPlatform: true` for any event that involves data collected
  /// outside the Kinnect app (layer 4). The event is dropped silently
  /// if the user has revoked layer-4 consent.
  static void track(
    String event, {
    Map<String, dynamic>? params,
    bool offPlatform = false,
    bool thirdParty = false,
  }) {
    final flags = _consentFlags();

    if (offPlatform && (flags & layerOffPlatform == 0)) return;
    if (thirdParty && (flags & layerThirdParty == 0)) return;

    FirebaseAnalytics.instance.logEvent(
      name: event,
      parameters: params?.map(
        (k, v) => MapEntry(k, v?.toString() ?? ''),
      ),
    );
  }

  /// Returns true if the user has granted consent for the given layer.
  static bool hasConsent(int layerMask) {
    return (_consentFlags() & layerMask) != 0;
  }

  static int _consentFlags() {
    final box = Hive.box<int>(_consentBox);
    return box.get(_consentFlagsKey, defaultValue: 0) ?? 0;
  }

  /// Persist updated consent flags (called from consent settings screen).
  static Future<void> setConsentFlags(int flags) async {
    final box = Hive.box<int>(_consentBox);
    await box.put(_consentFlagsKey, flags);
  }

  /// Open the Hive box. Call during app bootstrap.
  static Future<void> initialize() async {
    await Hive.openBox<int>(_consentBox);
  }
}
