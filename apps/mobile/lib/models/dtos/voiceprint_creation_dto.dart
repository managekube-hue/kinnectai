import 'package:freezed_annotation/freezed_annotation.dart';

part 'voiceprint_creation_dto.freezed.dart';
part 'voiceprint_creation_dto.g.dart';

/// Response DTO returned after a voiceprint is successfully created.
@freezed
abstract class VoiceprintCreationDTO with _$VoiceprintCreationDTO {
  const factory VoiceprintCreationDTO({
    @JsonKey(name: 'voiceprint_id') required String voiceprintId,
    @JsonKey(name: 'elevenlabs_clone_id') required String cloneId,
    required List<double> embedding,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'sample_duration_ms') int? sampleDurationMs,
  }) = _VoiceprintCreationDTO;

  factory VoiceprintCreationDTO.fromJson(Map<String, dynamic> json) =>
      _$VoiceprintCreationDTOFromJson(json);
}
