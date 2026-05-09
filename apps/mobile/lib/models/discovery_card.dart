import 'package:freezed_annotation/freezed_annotation.dart';

part 'discovery_card.freezed.dart';
part 'discovery_card.g.dart';

@freezed
abstract class DiscoveryCard with _$DiscoveryCard {
  const factory DiscoveryCard({
    required String candidateId,
    required int kcScoreDisplay,
    required String relationshipGuess,
    required String primarySignal,
    required List<double> confidenceInterval,
  }) = _DiscoveryCard;

  factory DiscoveryCard.fromJson(Map<String, dynamic> json) =>
      _$DiscoveryCardFromJson(json);
}
