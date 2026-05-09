import 'package:freezed_annotation/freezed_annotation.dart';

part 'discovery_candidate_dto.freezed.dart';
part 'discovery_candidate_dto.g.dart';

@freezed
abstract class DiscoveryCandidateDTO with _$DiscoveryCandidateDTO {
  const factory DiscoveryCandidateDTO({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'display_name') required String displayName,
    @JsonKey(name: 'connection_score') required double connectionScore,
    @JsonKey(name: 'relationship_guess') required String relationshipGuess,
    @JsonKey(name: 'primary_signal') required String primarySignal,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'preview_media_url') String? previewMediaUrl,
  }) = _DiscoveryCandidateDTO;

  factory DiscoveryCandidateDTO.fromJson(Map<String, dynamic> json) =>
      _$DiscoveryCandidateDTOFromJson(json);
}
