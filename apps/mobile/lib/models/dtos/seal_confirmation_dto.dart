import 'package:freezed_annotation/freezed_annotation.dart';

part 'seal_confirmation_dto.freezed.dart';
part 'seal_confirmation_dto.g.dart';

/// Confirmation returned by the API after a Memory Box item is sealed.
@freezed
abstract class SealConfirmationDTO with _$SealConfirmationDTO {
  const factory SealConfirmationDTO({
    @JsonKey(name: 'memory_id') required String memoryId,
    @JsonKey(name: 'sealed_at') required DateTime sealedAt,
    /// The trigger type that was set: time, milestone, posthumous, geofence.
    @JsonKey(name: 'trigger_type') required String triggerType,
    @JsonKey(name: 'trigger_value') String? triggerValue,
    @JsonKey(name: 'recipient_id') required String recipientId,
    @JsonKey(name: 'encryption_key_hash') String? encryptionKeyHash,
  }) = _SealConfirmationDTO;

  factory SealConfirmationDTO.fromJson(Map<String, dynamic> json) =>
      _$SealConfirmationDTOFromJson(json);
}
