import 'package:equatable/equatable.dart';

/// Memory card model - represents a video/memory in The Line feed
class Memory extends Equatable {
  final String id;
  final String creatorId;
  final String creatorUsername;
  final String creatorDisplayName;
  final String? creatorAvatarUrl;
  final String videoUrl;
  final String? thumbnailUrl;
  final String caption;
  final String? voiceprintId;
  final String? voiceprintLabel;
  final int pulseCount;
  final int commentCount;
  final int rewindCount;
  final int saveCount;
  final int shareCount;
  final String? branchId;
  final String? branchName;
  final double kinScore; // 0.0 to 1.0
  final DateTime createdAt;
  final Duration duration;
  final bool isPulsed;
  final bool isSaved;
  final Map<String, dynamic>? metadata;

  const Memory({
    required this.id,
    required this.creatorId,
    required this.creatorUsername,
    required this.creatorDisplayName,
    this.creatorAvatarUrl,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.caption,
    this.voiceprintId,
    this.voiceprintLabel,
    this.pulseCount = 0,
    this.commentCount = 0,
    this.rewindCount = 0,
    this.saveCount = 0,
    this.shareCount = 0,
    this.branchId,
    this.branchName,
    required this.kinScore,
    required this.createdAt,
    required this.duration,
    this.isPulsed = false,
    this.isSaved = false,
    this.metadata,
  });

  factory Memory.fromJson(Map<String, dynamic> json) {
    return Memory(
      id: json['id'] as String,
      creatorId: json['creator_id'] as String,
      creatorUsername: json['creator_username'] as String,
      creatorDisplayName: json['creator_display_name'] as String,
      creatorAvatarUrl: json['creator_avatar_url'] as String?,
      videoUrl: json['video_url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      caption: json['caption'] as String,
      voiceprintId: json['voiceprint_id'] as String?,
      voiceprintLabel: json['voiceprint_label'] as String?,
      pulseCount: json['pulse_count'] as int? ?? 0,
      commentCount: json['comment_count'] as int? ?? 0,
      rewindCount: json['rewind_count'] as int? ?? 0,
      saveCount: json['save_count'] as int? ?? 0,
      shareCount: json['share_count'] as int? ?? 0,
      branchId: json['branch_id'] as String?,
      branchName: json['branch_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      duration: Duration(seconds: json['duration_seconds'] as int),
      isPulsed: json['is_pulsed'] as bool? ?? false,
      isSaved: json['is_saved'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creator_id': creatorId,
      'creator_username': creatorUsername,
      'creator_display_name': creatorDisplayName,
      'creator_avatar_url': creatorAvatarUrl,
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'caption': caption,
      'voiceprint_id': voiceprintId,
      'voiceprint_label': voiceprintLabel,
      'pulse_count': pulseCount,
      'comment_count': commentCount,
      'rewind_count': rewindCount,
      'save_count': saveCount,
      'share_count': shareCount,
      'branch_id': branchId,
      'branch_name': branchName,
      'kin_score': kinScore,
      'created_at': createdAt.toIso8601String(),
      'duration_seconds': duration.inSeconds,
      'is_pulsed': isPulsed,
      'is_saved': isSaved,
      'metadata': metadata,
    };
  }

  Memory copyWith({
    String? id,
    String? creatorId,
    String? creatorUsername,
    String? creatorDisplayName,
    String? creatorAvatarUrl,
    String? videoUrl,
    String? thumbnailUrl,
    String? caption,
    String? voiceprintId,
    String? voiceprintLabel,
    int? pulseCount,
    int? commentCount,
    int? rewindCount,
    int? saveCount,
    int? shareCount,
    String? branchId,
    String? branchName,
    double? kinScore,
    DateTime? createdAt,
    Duration? duration,
    bool? isPulsed,
    bool? isSaved,
    Map<String, dynamic>? metadata,
  }) {
    return Memory(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      creatorUsername: creatorUsername ?? this.creatorUsername,
      creatorDisplayName: creatorDisplayName ?? this.creatorDisplayName,
      creatorAvatarUrl: creatorAvatarUrl ?? this.creatorAvatarUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      caption: caption ?? this.caption,
      voiceprintId: voiceprintId ?? this.voiceprintId,
      voiceprintLabel: voiceprintLabel ?? this.voiceprintLabel,
      pulseCount: pulseCount ?? this.pulseCount,
      commentCount: commentCount ?? this.commentCount,
      rewindCount: rewindCount ?? this.rewindCount,
      saveCount: saveCount ?? this.saveCount,
      shareCount: shareCount ?? this.shareCount,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      kinScore: kinScore ?? this.kinScore,
      createdAt: createdAt ?? this.createdAt,
      duration: duration ?? this.duration,
      isPulsed: isPulsed ?? this.isPulsed,
      isSaved: isSaved ?? this.isSaved,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Get formatted Kin Score percentage (e.g., "92%")
  String get kinScorePercentage => '${(kinScore * 100).toInt()}%';

  /// Get formatted pulse count (e.g., "1.2k", "84")
  String get formattedPulseCount => _formatCount(pulseCount);

  /// Get formatted comment count
  String get formattedCommentCount => _formatCount(commentCount);

  static String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  @override
  List<Object?> get props => [
        id,
        creatorId,
        videoUrl,
        pulseCount,
        commentCount,
        kinScore,
        isPulsed,
        isSaved,
      ];
}

/// Kin Score breakdown model
class KinScoreBreakdown extends Equatable {
  final double score;
  final String relationship;
  final int sharedBranches;
  final int sharedAncestors;
  final String? haplogroup;
  final List<String> connectionPath;

  const KinScoreBreakdown({
    required this.score,
    required this.relationship,
    this.sharedBranches = 0,
    this.sharedAncestors = 0,
    this.haplogroup,
    this.connectionPath = const [],
  });

  factory KinScoreBreakdown.fromJson(Map<String, dynamic> json) {
    return KinScoreBreakdown(
      relationship: json['relationship'] as String,
      sharedBranches: json['shared_branches'] as int? ?? 0,
      sharedAncestors: json['shared_ancestors'] as int? ?? 0,
      haplogroup: json['haplogroup'] as String?,
      connectionPath: (json['connection_path'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [
        score,
        relationship,
        sharedBranches,
        sharedAncestors,
        haplogroup,
        connectionPath,
      ];
}

/// Comment model
class Comment extends Equatable {
  final String id;
  final String memoryId;
  final String authorId;
  final String authorUsername;
  final String authorDisplayName;
  final String? authorAvatarUrl;
  final double kinScore;
  final String text;
  final DateTime createdAt;
  final int pulseCount;
  final bool isPulsed;

  const Comment({
    required this.id,
    required this.memoryId,
    required this.authorId,
    required this.authorUsername,
    required this.authorDisplayName,
    this.authorAvatarUrl,
    required this.kinScore,
    required this.text,
    required this.createdAt,
    this.pulseCount = 0,
    this.isPulsed = false,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      memoryId: json['memory_id'] as String,
      authorId: json['author_id'] as String,
      authorUsername: json['author_username'] as String,
      authorDisplayName: json['author_display_name'] as String,
      authorAvatarUrl: json['author_avatar_url'] as String?,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      pulseCount: json['pulse_count'] as int? ?? 0,
      isPulsed: json['is_pulsed'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [id, memoryId, text, createdAt, kinScore];
}
