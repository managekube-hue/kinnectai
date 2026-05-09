import 'package:freezed_annotation/freezed_annotation.dart';

import '../memory.dart';

part 'memory_dto.freezed.dart';
part 'memory_dto.g.dart';

enum MemoryType { video, image, Photplay, stitch, rewind, legacyReel, unknown }

@freezed
abstract class MemoryDTO with _$MemoryDTO {
  const MemoryDTO._();

  const factory MemoryDTO({
    required String id,
    @JsonKey(name: 'creator_id') required String creatorId,
    @JsonKey(fromJson: _memoryTypeFromValue) required MemoryType type,
    @JsonKey(name: 'media_url') required String mediaUrl,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    @JsonKey(name: 'cr_score') @Default(0.0) double crScore,
    @JsonKey(name: 'is_echo') @Default(false) bool isEcho,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    required DateTime createdAt,
    @JsonKey(name: 'strand_ids') @Default([]) List<String> strandIds,
    @JsonKey(name: 'branch_id') String? branchId,
    String? caption,
    @JsonKey(name: 'pulse_count') @Default(0) int pulseCount,
    @JsonKey(name: 'comment_count') @Default(0) int commentCount,
  }) = _MemoryDTO;

  factory MemoryDTO.fromJson(Map<String, dynamic> json) =>
      _$MemoryDTOFromJson(json);

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
}

MemoryType _memoryTypeFromValue(dynamic value) {
  final raw = value?.toString().toLowerCase();
  switch (raw) {
    case 'video':
      return MemoryType.video;
    case 'image':
      return MemoryType.image;
    case 'Photplay':
      return MemoryType.Photplay;
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

DateTime _dateTimeFromJson(Object? raw) {
  if (raw == null) return DateTime.fromMillisecondsSinceEpoch(0);
  final s = raw.toString();
  return DateTime.tryParse(s) ?? DateTime.fromMillisecondsSinceEpoch(0);
}

