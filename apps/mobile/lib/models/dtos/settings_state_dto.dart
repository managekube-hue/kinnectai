import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state_dto.freezed.dart';
part 'settings_state_dto.g.dart';

@freezed
abstract class SettingsStateDTO with _$SettingsStateDTO {
  const factory SettingsStateDTO({
    @JsonKey(name: 'push_enabled') @Default(true) bool pushEnabled,
    @JsonKey(name: 'private_account') @Default(true) bool privateAccount,
    @JsonKey(name: 'discovery_enabled') @Default(true) bool discoveryEnabled,
  }) = _SettingsStateDTO;

  factory SettingsStateDTO.fromJson(Map<String, dynamic> json) =>
      _$SettingsStateDTOFromJson(json);
}
