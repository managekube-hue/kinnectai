import 'package:dio/dio.dart';

import '../models/dtos/memory_box_item_dto.dart';
import 'memory_box_repository.dart';

class MemoryBoxRepositoryImpl implements MemoryBoxRepository {
  MemoryBoxRepositoryImpl({required Dio dio, this.basePath = '/v1'})
    : _dio = dio;

  final Dio _dio;
  final String basePath;

  @override
  Future<List<MemoryBoxItemDTO>> fetchVault() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$basePath/memory-box/vault',
    );
    final data =
        (response.data?['data'] as Map<String, dynamic>?) ??
        response.data ??
        <String, dynamic>{};
    final items = (data['items'] as List?) ?? const <dynamic>[];

    return items
        .whereType<Map<String, dynamic>>()
        .map(MemoryBoxItemDTO.fromJson)
        .toList();
  }

  @override
  Future<void> sealMemory(String memoryId) async {
    await _dio.post<void>(
      '$basePath/memories/seal',
      data: {'memory_id': memoryId},
    );
  }

  @override
  Future<void> revokeTrigger(String memoryId) async {
    await _dio.post<void>('$basePath/memory-box/$memoryId/revoke');
  }

  @override
  Future<void> requestExport() async {
    await _dio.post<void>('$basePath/data/export/request');
  }
}
