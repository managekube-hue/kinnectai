import 'package:equatable/equatable.dart';

class SettingsStateDTO extends Equatable {
  const SettingsStateDTO({
    required this.pushEnabled,
    required this.privateAccount,
    required this.discoveryEnabled,
  });

  final bool pushEnabled;
  final bool privateAccount;
  final bool discoveryEnabled;

  factory SettingsStateDTO.fromJson(Map<String, dynamic> json) {
    return SettingsStateDTO(
      pushEnabled: json['push_enabled'] as bool? ?? true,
      privateAccount: json['private_account'] as bool? ?? true,
      discoveryEnabled: json['discovery_enabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'push_enabled': pushEnabled,
      'private_account': privateAccount,
      'discovery_enabled': discoveryEnabled,
    };
  }

  SettingsStateDTO copyWith({
    bool? pushEnabled,
    bool? privateAccount,
    bool? discoveryEnabled,
  }) {
    return SettingsStateDTO(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      privateAccount: privateAccount ?? this.privateAccount,
      discoveryEnabled: discoveryEnabled ?? this.discoveryEnabled,
    );
  }

  @override
  List<Object?> get props => [pushEnabled, privateAccount, discoveryEnabled];
}
