import 'package:equatable/equatable.dart';

class DiscoveryCandidateDTO extends Equatable {
  const DiscoveryCandidateDTO({
    required this.userId,
    required this.displayName,
    required this.connectionScore,
    required this.relationshipGuess,
    required this.primarySignal,
    this.avatarUrl,
    this.previewMediaUrl,
  });

  final String userId;
  final String displayName;
  final double connectionScore;
  final String relationshipGuess;
  final String primarySignal;
  final String? avatarUrl;
  final String? previewMediaUrl;

  factory DiscoveryCandidateDTO.fromJson(Map<String, dynamic> json) {
    return DiscoveryCandidateDTO(
      userId: (json['user_id'] ?? '').toString(),
      displayName: (json['display_name'] ?? '').toString(),
      connectionScore: (json['connection_score'] as num?)?.toDouble() ?? 0.0,
      relationshipGuess: (json['relationship_guess'] ?? '').toString(),
      primarySignal: (json['primary_signal'] ?? '').toString(),
      avatarUrl: json['avatar_url']?.toString(),
      previewMediaUrl: json['preview_media_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'display_name': displayName,
      'connection_score': connectionScore,
      'relationship_guess': relationshipGuess,
      'primary_signal': primarySignal,
      'avatar_url': avatarUrl,
      'preview_media_url': previewMediaUrl,
    };
  }

  @override
  List<Object?> get props => [
        userId,
        displayName,
        connectionScore,
        relationshipGuess,
        primarySignal,
        avatarUrl,
        previewMediaUrl,
      ];
}
