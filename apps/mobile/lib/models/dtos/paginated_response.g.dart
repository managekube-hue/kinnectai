// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginatedResponse<T> _$PaginatedResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _PaginatedResponse<T>(
  items: (json['items'] as List<dynamic>).map(fromJsonT).toList(),
  nextCursor: json['next_cursor'] as String?,
  hasMore: json['has_more'] as bool? ?? false,
  kinScoreContext: (json['kin_score_context'] as num?)?.toDouble(),
);

Map<String, dynamic> _$PaginatedResponseToJson<T>(
  _PaginatedResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'items': instance.items.map(toJsonT).toList(),
  'next_cursor': instance.nextCursor,
  'has_more': instance.hasMore,
  'kin_score_context': instance.kinScoreContext,
};
