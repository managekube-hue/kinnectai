import 'package:freezed_annotation/freezed_annotation.dart';

part 'memory_card.freezed.dart';
part 'memory_card.g.dart';

@freezed
abstract class MemoryCard with _$MemoryCard {
  const factory MemoryCard({
    required String memoryId,
    required String creatorId,
    required String type,
    required double kinScore,
    @Default(false) bool isAiGenerated,
    required DateTime createdAt,
    @Default(0) int pulseCount,
    String? caption,
    String? audioUrl,
    String? videoUrl,
    String? c2paManifestUrl,
  }) = _MemoryCard;

  factory MemoryCard.fromJson(Map<String, dynamic> json) => _$MemoryCardFromJson(json);
}
