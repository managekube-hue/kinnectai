import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kin_score_dto.g.dart';

DateTime _dateTimeFromJson(Object? raw) {
  if (raw == null) return DateTime.fromMillisecondsSinceEpoch(0);
  final s = raw.toString();
  return DateTime.tryParse(s) ?? DateTime.fromMillisecondsSinceEpoch(0);
}

@JsonSerializable()
class KinScoreDTO extends Equatable {
  const KinScoreDTO({
    required this.userId,
    required this.score,
    required this.relationshipLabel,
    required this.primarySignal,
    required this.confidencePercent,
    required this.lastUpdated,
  });

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'normalized_score')
  final double score;

  @JsonKey(name: 'relationship_label')
  final String relationshipLabel;

  @JsonKey(name: 'primary_signal')
  final String primarySignal;

  @JsonKey(name: 'confidence_percent')
  final int confidencePercent;

  @JsonKey(name: 'last_updated', fromJson: _dateTimeFromJson)
  final DateTime lastUpdated;

  factory KinScoreDTO.fromJson(Map<String, dynamic> json) =>
      _$KinScoreDTOFromJson(json);

  Map<String, dynamic> toJson() => _$KinScoreDTOToJson(this);

  @override
  List<Object?> get props => [
        userId,
        score,
        relationshipLabel,
        primarySignal,
        confidencePercent,
        lastUpdated,
      ];
}
