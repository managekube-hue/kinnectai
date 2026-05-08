import 'package:dio/dio.dart';

import '../models/dtos/graph_response_dto.dart';
import 'tree_graph_repository.dart';

class TreeGraphRepositoryImpl implements TreeGraphRepository {
  TreeGraphRepositoryImpl({
    required Dio dio,
    this.basePath = '/v1',
  }) : _dio = dio;

  final Dio _dio;
  final String basePath;

  @override
  Future<GraphResponseDTO> loadSubgraph(String rootId, {int depthLimit = 4}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$basePath/tree/graph',
      queryParameters: {
        'root_id': rootId,
        'depth_limit': depthLimit,
      },
    );

    final data = (response.data?['data'] as Map<String, dynamic>?) ?? response.data ?? <String, dynamic>{};
    return GraphResponseDTO.fromJson(data);
  }

  @override
  Future<GraphResponseDTO> expandNode(String nodeId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$basePath/tree/graph/node/$nodeId',
    );

    final data = (response.data?['data'] as Map<String, dynamic>?) ?? response.data ?? <String, dynamic>{};
    return GraphResponseDTO.fromJson(data);
  }
}
