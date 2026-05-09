import 'package:freezed_annotation/freezed_annotation.dart';

import 'feed_metadata.dart';
import 'memory_card.dart';

part 'feed_get200_response.freezed.dart';
part 'feed_get200_response.g.dart';

@freezed
abstract class FeedGet200Response with _$FeedGet200Response {
  const factory FeedGet200Response({
    required List<MemoryCard> items,
    String? nextCursor,
    required FeedMetadata metadata,
  }) = _FeedGet200Response;

  factory FeedGet200Response.fromJson(Map<String, dynamic> json) =>
      _$FeedGet200ResponseFromJson(json);
}
