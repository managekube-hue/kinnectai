import 'package:equatable/equatable.dart';

class KinScoreDTO extends Equatable {
  const KinScoreDTO({
    required this.userId,
    required this.score,
    required this.relationshipLabel,
    required this.primarySignal,
    required this.confidencePercent,
    required this.lastUpdated,
  });

  final String userId;
  final double score;
  final String relationshipLabel;
  final String primarySignal;
  final int confidencePercent;
  final DateTime lastUpdated;

  factory KinScoreDTO.fromJson(Map<String, dynamic> json) {
    return KinScoreDTO(
      userId: (json['user_id'] ?? '').toString(),
      score: (json['normalized_score'] as num?)?.toDouble() ?? 0.0,
      relationshipLabel: (json['relationship_label'] ?? '').toString(),
      primarySignal: (json['primary_signal'] ?? '').toString(),
      confidencePercent: (json['confidence_percent'] as num?)?.toInt() ?? 0,
      lastUpdated: DateTime.tryParse((json['last_updated'] ?? '').toString()) ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'normalized_score': score,
      'relationship_label': relationshipLabel,
      'primary_signal': primarySignal,
      'confidence_percent': confidencePercent,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

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
