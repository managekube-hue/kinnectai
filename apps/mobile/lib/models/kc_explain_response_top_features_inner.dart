import 'package:freezed_annotation/freezed_annotation.dart';

part 'kc_explain_response_top_features_inner.freezed.dart';
part 'kc_explain_response_top_features_inner.g.dart';

@freezed
abstract class KCExplainResponseTopFeaturesInner with _$KCExplainResponseTopFeaturesInner {
  const factory KCExplainResponseTopFeaturesInner({
    required String featureName,
    required String layer,
    required double weight,
    required double importance,
  }) = _KCExplainResponseTopFeaturesInner;

  factory KCExplainResponseTopFeaturesInner.fromJson(Map<String, dynamic> json) =>
      _$KCExplainResponseTopFeaturesInnerFromJson(json);
}
