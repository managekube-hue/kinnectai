import 'package:equatable/equatable.dart';

import '../memory.dart';

enum MemoryType { video, image, bloom, stitch, rewind, legacyReel, unknown }

class MemoryDTO extends Equatable {
  const MemoryDTO({
    required this.id,
    required this.creatorId,
    required this.type,
    required this.mediaUrl,
    this.thumbnailUrl,
    required this.crScore,
    required this.isEcho,
    required this.createdAt,
    required this.strandIds,
    this.branchId,
    this.caption,
    this.pulseCount = 0,
    this.commentCount = 0,
  });

  final String id;
  final String creatorId;
  final MemoryType type;
  final String mediaUrl;
  final String? thumbnailUrl;
  final double crScore;
  final bool isEcho;
  final DateTime createdAt;
  final List<String> strandIds;
  final String? branchId;
  final String? caption;
  final int pulseCount;
  final int commentCount;

  factory MemoryDTO.fromJson(Map<String, dynamic> json) {
    return MemoryDTO(
      id: (json['id'] ?? '').toString(),
      creatorId: (json['creator_id'] ?? '').toString(),
      type: _memoryTypeFromValue(json['type']),
      mediaUrl: (json['media_url'] ?? '').toString(),
      thumbnailUrl: json['thumbnail_url']?.toString(),
      crScore: (json['cr_score'] as num?)?.toDouble() ?? 0.0,
      isEcho: json['is_echo'] as bool? ?? false,
      createdAt:
          DateTime.tryParse((json['created_at'] ?? '').toString()) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      strandIds: ((json['strand_ids'] as List?) ?? const <dynamic>[])
          .map((e) => e.toString())
          .toList(),
      branchId: json['branch_id']?.toString(),
      caption: json['caption']?.toString(),
      pulseCount: (json['pulse_count'] as num?)?.toInt() ?? 0,
      commentCount: (json['comment_count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creator_id': creatorId,
      'type': type.name,
      'media_url': mediaUrl,
      'thumbnail_url': thumbnailUrl,
      'cr_score': crScore,
      'is_echo': isEcho,
      'created_at': createdAt.toIso8601String(),
      'strand_ids': strandIds,
      'branch_id': branchId,
      'caption': caption,
      'pulse_count': pulseCount,
      'comment_count': commentCount,
    };
  }

  Memory toDomain({
    required String creatorUsername,
    required String creatorDisplayName,
  }) {
    return Memory(
      id: id,
      creatorId: creatorId,
      creatorUsername: creatorUsername,
      creatorDisplayName: creatorDisplayName,
      videoUrl: mediaUrl,
      thumbnailUrl: thumbnailUrl,
      caption: caption ?? '',
      pulseCount: pulseCount,
      commentCount: commentCount,
      kinScore: crScore,
      branchId: branchId,
      createdAt: createdAt,
      duration: const Duration(seconds: 30),
    );
  }

  @override
  List<Object?> get props => [
    id,
    creatorId,
    type,
    mediaUrl,
    thumbnailUrl,
    crScore,
    isEcho,
    createdAt,
    strandIds,
    branchId,
    caption,
    pulseCount,
    commentCount,
  ];

  static MemoryType _memoryTypeFromValue(dynamic value) {
    final raw = value?.toString().toLowerCase();
    switch (raw) {
      case 'video':
        return MemoryType.video;
      case 'image':
        return MemoryType.image;
      case 'bloom':
        return MemoryType.bloom;
      case 'stitch':
        return MemoryType.stitch;
      case 'rewind':
        return MemoryType.rewind;
      case 'legacy_reel':
      case 'legacyreel':
        return MemoryType.legacyReel;
      default:
        return MemoryType.unknown;
    }
  }
}
