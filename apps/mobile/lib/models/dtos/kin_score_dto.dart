import 'package:freezed_annotation/freezed_annotation.dart';

part 'kin_score_dto.freezed.dart';
part 'kin_score_dto.g.dart';

@freezed
abstract class KinScoreDTO with _$KinScoreDTO {
  const factory KinScoreDTO({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'normalized_score') required double score,
    @JsonKey(name: 'relationship_label') required String relationshipLabel,
    @JsonKey(name: 'primary_signal') required String primarySignal,
    @JsonKey(name: 'confidence_percent') required int confidencePercent,
    @JsonKey(name: 'last_updated', fromJson: _dateTimeFromJson)
    required DateTime lastUpdated,
  }) = _KinScoreDTO;

  factory KinScoreDTO.fromJson(Map<String, dynamic> json) =>
      _$KinScoreDTOFromJson(json);
}

DateTime _dateTimeFromJson(Object? raw) {
  if (raw == null) return DateTime.fromMillisecondsSinceEpoch(0);
  final s = raw.toString();
  return DateTime.tryParse(s) ?? DateTime.fromMillisecondsSinceEpoch(0);
}
