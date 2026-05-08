// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kin_score_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KinScoreDTO _$KinScoreDTOFromJson(Map<String, dynamic> json) => KinScoreDTO(
  userId: json['user_id'] as String,
  score: (json['normalized_score'] as num).toDouble(),
  relationshipLabel: json['relationship_label'] as String,
  primarySignal: json['primary_signal'] as String,
  confidencePercent: (json['confidence_percent'] as num).toInt(),
  lastUpdated: _dateTimeFromJson(json['last_updated']),
);

Map<String, dynamic> _$KinScoreDTOToJson(KinScoreDTO instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'normalized_score': instance.score,
      'relationship_label': instance.relationshipLabel,
      'primary_signal': instance.primarySignal,
      'confidence_percent': instance.confidencePercent,
      'last_updated': instance.lastUpdated.toIso8601String(),
    };
