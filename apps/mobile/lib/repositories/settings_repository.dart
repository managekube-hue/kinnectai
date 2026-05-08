import '../models/dtos/settings_state_dto.dart';

abstract class SettingsRepository {
  Future<SettingsStateDTO> loadSettings();
  Future<SettingsStateDTO> togglePush(bool enabled);
  Future<SettingsStateDTO> updatePrivacy({
    bool? privateAccount,
    bool? discoveryEnabled,
  });
  Future<void> requestDataExport();
  Future<void> revokeConsent(String consentType);
}
