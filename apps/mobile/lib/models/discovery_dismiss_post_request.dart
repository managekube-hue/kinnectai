import 'package:freezed_annotation/freezed_annotation.dart';

part 'discovery_dismiss_post_request.freezed.dart';
part 'discovery_dismiss_post_request.g.dart';

@freezed
abstract class DiscoveryDismissPostRequest with _$DiscoveryDismissPostRequest {
  const factory DiscoveryDismissPostRequest({
    required String candidateId,
    @Default(0.30) double penalty,
  }) = _DiscoveryDismissPostRequest;

  factory DiscoveryDismissPostRequest.fromJson(Map<String, dynamic> json) =>
      _$DiscoveryDismissPostRequestFromJson(json);
}
