import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state_dto.freezed.dart';
part 'settings_state_dto.g.dart';

@freezed
abstract class SettingsStateDTO with _$SettingsStateDTO {
  const factory SettingsStateDTO({
    // Push notification toggles (Section 6)
    @JsonKey(name: 'push_enabled') @Default(true) bool pushEnabled,
    @JsonKey(name: 'push_pulses') @Default(true) bool pushPulses,
    @JsonKey(name: 'push_kinnections') @Default(true) bool pushKinnections,
    @JsonKey(name: 'push_mentions') @Default(true) bool pushMentions,
    @JsonKey(name: 'push_comments') @Default(true) bool pushComments,
    @JsonKey(name: 'push_messages') @Default(true) bool pushMessages,
    @JsonKey(name: 'push_gatherings') @Default(true) bool pushGatherings,
    @JsonKey(name: 'push_branch') @Default(true) bool pushBranch,
    @JsonKey(name: 'push_heartbeat') @Default(true) bool pushHeartbeat,
    @JsonKey(name: 'push_echoes') @Default(true) bool pushEchoes,
    @JsonKey(name: 'push_memory_box') @Default(true) bool pushMemoryBox,
    @JsonKey(name: 'push_kinship_alerts') @Default(true) bool pushKinshipAlerts,
    @JsonKey(name: 'push_ripples') @Default(false) bool pushRipples,
    @JsonKey(name: 'push_lost_branches') @Default(true) bool pushLostBranches,
    @JsonKey(name: 'push_live') @Default(false) bool pushLive,

    // Privacy (Section 7)
    @JsonKey(name: 'private_account') @Default(true) bool privateAccount,
    @JsonKey(name: 'activity_status') @Default(true) bool activityStatus,
    @JsonKey(name: 'discovery_enabled') @Default(true) bool discoveryEnabled,
    @JsonKey(name: 'sync_contacts') @Default(false) bool syncContacts,
    @JsonKey(name: 'show_haplogroup') @Default(true) bool showHaplogroup,
    @JsonKey(name: 'min_kin_score_display') @Default(0.2) double minKinScoreDisplay,
    @JsonKey(name: 'allow_pulses') @Default(true) bool allowPulses,
    @JsonKey(name: 'allow_dms') @Default(true) bool allowDMs,
    @JsonKey(name: 'allow_stitch') @Default(true) bool allowStitch,
    @JsonKey(name: 'off_platform_tracking') @Default(false) bool offPlatformTracking,
    @JsonKey(name: 'third_party_sharing') @Default(false) bool thirdPartySharing,
    @JsonKey(name: 'contextual_ads') @Default(true) bool contextualAds,
    @JsonKey(name: 'feedback_sharing') @Default(false) bool feedbackSharing,

    // Content Preferences (Section 3.1)
    @JsonKey(name: 'restricted_mode') @Default(false) bool restrictedMode,
    @JsonKey(name: 'stem_feed') @Default(false) bool stemFeed,

    // Time & Well-being (Section 3.2)
    @JsonKey(name: 'daily_limit_minutes') @Default(0) int dailyLimitMinutes,
    @JsonKey(name: 'break_reminder_minutes') @Default(0) int breakReminderMinutes,
    @JsonKey(name: 'night_mode_enabled') @Default(false) bool nightModeEnabled,

    // Memory Box (Section 8)
    @JsonKey(name: 'kinship_alert_radius_meters') @Default(500) int kinshipAlertRadiusMeters,
  }) = _SettingsStateDTO;

  factory SettingsStateDTO.fromJson(Map<String, dynamic> json) =>
      _$SettingsStateDTOFromJson(json);
}
