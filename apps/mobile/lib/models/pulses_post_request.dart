import 'package:freezed_annotation/freezed_annotation.dart';

part 'pulses_post_request.freezed.dart';
part 'pulses_post_request.g.dart';

@freezed
abstract class PulsesPostRequest with _$PulsesPostRequest {
  const factory PulsesPostRequest({
    required String memoryId,
  }) = _PulsesPostRequest;

  factory PulsesPostRequest.fromJson(Map<String, dynamic> json) =>
      _$PulsesPostRequestFromJson(json);
}
