import 'package:freezed_annotation/freezed_annotation.dart';

part 'kc_explain_response_confidence_interval.freezed.dart';
part 'kc_explain_response_confidence_interval.g.dart';

@freezed
abstract class KCExplainResponseConfidenceInterval with _$KCExplainResponseConfidenceInterval {
  const factory KCExplainResponseConfidenceInterval({
    required double lower,
    required double upper,
  }) = _KCExplainResponseConfidenceInterval;

  factory KCExplainResponseConfidenceInterval.fromJson(Map<String, dynamic> json) =>
      _$KCExplainResponseConfidenceIntervalFromJson(json);
}
