import 'package:equatable/equatable.dart';

enum MemoryBoxStatus { draft, sealed, triggered, delivered }

class MemoryBoxItemDTO extends Equatable {
  const MemoryBoxItemDTO({
    required this.id,
    required this.recipientName,
    required this.triggerType,
    required this.status,
    required this.sealedAt,
  });

  final String id;
  final String recipientName;
  final String triggerType;
  final MemoryBoxStatus status;
  final DateTime? sealedAt;

  factory MemoryBoxItemDTO.fromJson(Map<String, dynamic> json) {
    return MemoryBoxItemDTO(
      id: (json['id'] ?? '').toString(),
      recipientName: (json['recipient_name'] ?? '').toString(),
      triggerType: (json['trigger_type'] ?? '').toString(),
      status: _statusFromValue(json['status']),
      sealedAt: DateTime.tryParse((json['sealed_at'] ?? '').toString()),
    );
  }

  @override
  List<Object?> get props => [id, recipientName, triggerType, status, sealedAt];

  static MemoryBoxStatus _statusFromValue(dynamic value) {
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
}
