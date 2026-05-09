import 'package:freezed_annotation/freezed_annotation.dart';

part 'memorybox_post_request.freezed.dart';
part 'memorybox_post_request.g.dart';

@freezed
abstract class MemoryboxPostRequest with _$MemoryboxPostRequest {
  const factory MemoryboxPostRequest({
    required String recipientId,
    required String triggerType,
    required Map<String, dynamic> triggerValue,
    required String contentS3Key,
    required String encryptedDek,
    required String dekKeyId,
    String? stewardId,
  }) = _MemoryboxPostRequest;

  factory MemoryboxPostRequest.fromJson(Map<String, dynamic> json) =>
      _$MemoryboxPostRequestFromJson(json);
}
