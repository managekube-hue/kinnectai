import 'package:freezed_annotation/freezed_annotation.dart';

part 'memory_box_item_dto.freezed.dart';
part 'memory_box_item_dto.g.dart';

enum MemoryBoxStatus { draft, sealed, triggered, delivered }

@freezed
abstract class MemoryBoxItemDTO with _$MemoryBoxItemDTO {
  const factory MemoryBoxItemDTO({
    required String id,
    @JsonKey(name: 'recipient_name') required String recipientName,
    @JsonKey(name: 'trigger_type') required String triggerType,
    @JsonKey(fromJson: _statusFromValue) required MemoryBoxStatus status,
    @JsonKey(name: 'sealed_at') DateTime? sealedAt,
  }) = _MemoryBoxItemDTO;

  factory MemoryBoxItemDTO.fromJson(Map<String, dynamic> json) =>
      _$MemoryBoxItemDTOFromJson(json);
}

MemoryBoxStatus _statusFromValue(dynamic value) {
  switch (value?.toString().toLowerCase()) {
    case 'draft':
      return MemoryBoxStatus.draft;
    case 'sealed':
      return MemoryBoxStatus.sealed;
    case 'triggered':
      return MemoryBoxStatus.triggered;
    case 'delivered':
      return MemoryBoxStatus.delivered;
    default:
      return MemoryBoxStatus.draft;
  }
}
