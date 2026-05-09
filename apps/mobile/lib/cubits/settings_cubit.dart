import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/dtos/settings_state_dto.dart';
import '../repositories/settings_repository.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  const SettingsLoaded(this.settings);

  final SettingsStateDTO settings;

  @override
  List<Object?> get props => [settings];
}

class SettingsSaving extends SettingsState {}

class SettingsSaved extends SettingsState {
  const SettingsSaved(this.settings);

  final SettingsStateDTO settings;

  @override
  List<Object?> get props => [settings];
}

class SettingsError extends SettingsState {
  const SettingsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repository) : super(SettingsLoading());

  final SettingsRepository _repository;

  SettingsStateDTO? _current;

  /// Get the current settings or a default.
  SettingsStateDTO get current => _current ?? const SettingsStateDTO();

  Future<void> load() async {
    emit(SettingsLoading());
    try {
      final settings = await _repository.loadSettings();
      _current = settings;
      emit(SettingsLoaded(settings));
    } catch (error) {
      emit(SettingsError(error.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Privacy controls (Section 7)
  // ---------------------------------------------------------------------------

  Future<void> updatePrivacy({
    bool? privateAccount,
    bool? discoveryEnabled,
    bool? activityStatus,
    bool? syncContacts,
    bool? showHaplogroup,
    double? minKinScoreDisplay,
    bool? allowPulses,
    bool? allowDMs,
    bool? allowStitch,
    bool? offPlatformTracking,
    bool? thirdPartySharing,
    bool? contextualAds,
    bool? feedbackSharing,
  }) async {
    final updated = current.copyWith(
      privateAccount: privateAccount ?? current.privateAccount,
      discoveryEnabled: discoveryEnabled ?? current.discoveryEnabled,
      activityStatus: activityStatus ?? current.activityStatus,
      syncContacts: syncContacts ?? current.syncContacts,
      showHaplogroup: showHaplogroup ?? current.showHaplogroup,
      minKinScoreDisplay: minKinScoreDisplay ?? current.minKinScoreDisplay,
      allowPulses: allowPulses ?? current.allowPulses,
      allowDMs: allowDMs ?? current.allowDMs,
      allowStitch: allowStitch ?? current.allowStitch,
      offPlatformTracking: offPlatformTracking ?? current.offPlatformTracking,
      thirdPartySharing: thirdPartySharing ?? current.thirdPartySharing,
      contextualAds: contextualAds ?? current.contextualAds,
      feedbackSharing: feedbackSharing ?? current.feedbackSharing,
    );
    await _save(updated);
  }

  // ---------------------------------------------------------------------------
  // Push notification toggles (Section 6)
  // ---------------------------------------------------------------------------

  Future<void> toggleNotification(String type, {required bool push}) async {
    final updated = _toggleNotificationField(current, type, push);
    await _save(updated);
  }

  Future<void> togglePush(bool enabled) async {
    await _save(current.copyWith(pushEnabled: enabled));
  }

  // ---------------------------------------------------------------------------
  // Content preferences (Section 3.1)
  // ---------------------------------------------------------------------------

  Future<void> updateContentPreferences({
    bool? restrictedMode,
    bool? stemFeed,
  }) async {
    await _save(current.copyWith(
      restrictedMode: restrictedMode ?? current.restrictedMode,
      stemFeed: stemFeed ?? current.stemFeed,
    ));
  }

  // ---------------------------------------------------------------------------
  // Time & Well-being (Section 3.2)
  // ---------------------------------------------------------------------------

  Future<void> updateTimeWellbeing({
    int? dailyLimitMinutes,
    int? breakReminderMinutes,
    bool? nightModeEnabled,
  }) async {
    await _save(current.copyWith(
      dailyLimitMinutes: dailyLimitMinutes ?? current.dailyLimitMinutes,
      breakReminderMinutes: breakReminderMinutes ?? current.breakReminderMinutes,
      nightModeEnabled: nightModeEnabled ?? current.nightModeEnabled,
    ));
  }

  // ---------------------------------------------------------------------------
  // Memory Box settings (Section 8)
  // ---------------------------------------------------------------------------

  Future<void> updateKinshipAlertRadius(int meters) async {
    await _save(current.copyWith(kinshipAlertRadiusMeters: meters));
  }

  // ---------------------------------------------------------------------------
  // GDPR export
  // ---------------------------------------------------------------------------

  Future<void> requestDataExport() async {
    emit(SettingsSaving());
    try {
      await _repository.requestDataExport();
      emit(SettingsLoaded(current));
    } catch (error) {
      emit(SettingsError(error.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  Future<void> _save(SettingsStateDTO updated) async {
    _current = updated;
    emit(SettingsLoaded(updated)); // Optimistic update
    try {
      final confirmed = await _repository.updatePrivacy(
        privateAccount: updated.privateAccount,
        discoveryEnabled: updated.discoveryEnabled,
      );
      _current = confirmed;
      emit(SettingsLoaded(confirmed));
    } catch (error) {
      emit(SettingsError(error.toString()));
      emit(SettingsLoaded(updated)); // Keep optimistic state
    }
  }

  static SettingsStateDTO _toggleNotificationField(SettingsStateDTO s, String type, bool push) {
    switch (type) {
      case 'pulses': return s.copyWith(pushPulses: push);
      case 'kinnections': return s.copyWith(pushKinnections: push);
      case 'mentions': return s.copyWith(pushMentions: push);
      case 'comments': return s.copyWith(pushComments: push);
      case 'messages': return s.copyWith(pushMessages: push);
      case 'gatherings': return s.copyWith(pushGatherings: push);
      case 'branch': return s.copyWith(pushBranch: push);
      case 'heartbeat': return s.copyWith(pushHeartbeat: push);
      case 'echoes': return s.copyWith(pushEchoes: push);
      case 'memorybox': return s.copyWith(pushMemoryBox: push);
      case 'kinshipalerts': return s.copyWith(pushKinshipAlerts: push);
      case 'ripples': return s.copyWith(pushRipples: push);
      case 'lostbranches': return s.copyWith(pushLostBranches: push);
      case 'live': return s.copyWith(pushLive: push);
      default: return s;
    }
  }
}
