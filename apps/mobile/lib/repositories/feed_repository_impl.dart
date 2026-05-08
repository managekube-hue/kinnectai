import 'package:dio/dio.dart';

import '../models/dtos/discovery_candidate_dto.dart';
import '../models/dtos/memory_dto.dart';
import '../models/dtos/paginated_response.dart';
import 'feed_repository.dart';

class FeedRepositoryImpl implements FeedRepository {
  FeedRepositoryImpl({required Dio dio, this.basePath = '/v1'}) : _dio = dio;

  final Dio _dio;
  final String basePath;

  @override
  Future<PaginatedResponse<MemoryDTO>> fetchLine({
    required String? cursor,
    required String tab,
    int limit = 20,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$basePath/feed/line',
      queryParameters: {
        if (cursor != null && cursor.isNotEmpty) 'after': cursor,
        'tab_filter': tab,
        'limit': limit,
      },
    );

    final data =
        (response.data?['data'] as Map<String, dynamic>?) ??
        response.data ??
        <String, dynamic>{};
    final meta =
        (response.data?['meta'] as Map<String, dynamic>?) ??
        const <String, dynamic>{};

    return PaginatedResponse<MemoryDTO>(
      items: ((data['items'] as List?) ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(MemoryDTO.fromJson)
          .toList(),
      nextCursor: data['next_cursor']?.toString(),
      hasMore: data['has_more'] as bool? ?? false,
      kinScoreContext: (meta['kin_score'] as num?)?.toDouble(),
    );
  }

  @override
  Future<PaginatedResponse<DiscoveryCandidateDTO>> fetchDiscoveryCandidates({
    required String? cursor,
    Map<String, dynamic>? filters,
    int limit = 20,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$basePath/discovery/candidates',
      data: {
        'filters': filters ?? <String, dynamic>{},
        if (cursor != null && cursor.isNotEmpty) 'after': cursor,
        'limit': limit,
      },
    );

    final data =
        (response.data?['data'] as Map<String, dynamic>?) ??
        response.data ??
        <String, dynamic>{};
    final meta =
        (response.data?['meta'] as Map<String, dynamic>?) ??
        const <String, dynamic>{};

    return PaginatedResponse<DiscoveryCandidateDTO>(
      items: ((data['items'] as List?) ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(DiscoveryCandidateDTO.fromJson)
          .toList(),
      nextCursor: data['next_cursor']?.toString(),
      hasMore: data['has_more'] as bool? ?? false,
      kinScoreContext: (meta['kin_score'] as num?)?.toDouble(),
    );
  }

  @override
  Future<void> pulseMemory(String memoryId) async {
    await _dio.post<void>('$basePath/memories/$memoryId/pulse');
  }
}
