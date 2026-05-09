import 'package:freezed_annotation/freezed_annotation.dart';

import 'kc_explain_response_confidence_interval.dart';
import 'kc_explain_response_top_features_inner.dart';

part 'kc_explain_response.freezed.dart';
part 'kc_explain_response.g.dart';

@freezed
abstract class KCExplainResponse with _$KCExplainResponse {
  const factory KCExplainResponse({
    required String pairId,
    required String modelVersion,
    required double finalScore,
    required List<KCExplainResponseTopFeaturesInner> topFeatures,
    required KCExplainResponseConfidenceInterval confidenceInterval,
  }) = _KCExplainResponse;

  factory KCExplainResponse.fromJson(Map<String, dynamic> json) =>
      _$KCExplainResponseFromJson(json);
}
