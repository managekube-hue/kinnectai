import 'package:dio/dio.dart';

import '../models/dtos/discovery_candidate_dto.dart';
import '../models/dtos/paginated_response.dart';
import 'discovery_repository.dart';

class DiscoveryRepositoryImpl implements DiscoveryRepository {
  DiscoveryRepositoryImpl({required Dio dio, this.basePath = '/v1'}) : _dio = dio;

  final Dio _dio;
  final String basePath;

  @override
  Future<PaginatedResponse<DiscoveryCandidateDTO>> fetchCandidates({
    required String? cursor,
    String? filter,
    int limit = 10,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$basePath/discovery/candidates',
      data: {
        if (cursor != null) 'after': cursor,
        if (filter != null && filter != 'All') 'filter': filter,
        'limit': limit,
      },
    );

    final data = (response.data?['data'] as Map<String, dynamic>?) ?? response.data ?? <String, dynamic>{};

    return PaginatedResponse<DiscoveryCandidateDTO>(
      items: ((data['items'] as List?) ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(DiscoveryCandidateDTO.fromJson)
          .toList(),
      nextCursor: data['next_cursor']?.toString(),
      hasMore: data['has_more'] as bool? ?? false,
    );
  }

  @override
  Future<void> dismissCandidate(String userId) async {
    await _dio.post<void>('$basePath/discovery/dismiss', data: {'user_id': userId});
  }

  @override
  Future<void> sendKinnectionRequest(String userId) async {
    await _dio.post<void>('$basePath/kinnections/request', data: {'target_user_id': userId});
  }
}
