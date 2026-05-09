import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_metadata.freezed.dart';
part 'feed_metadata.g.dart';

@freezed
abstract class FeedMetadata with _$FeedMetadata {
  const factory FeedMetadata({
    required String kernelStatus,
    required bool fallbackApplied,
    required int cacheAgeSeconds,
  }) = _FeedMetadata;

  factory FeedMetadata.fromJson(Map<String, dynamic> json) => _$FeedMetadataFromJson(json);
}
