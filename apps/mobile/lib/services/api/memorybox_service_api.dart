import 'package:dio/dio.dart';
import 'package:kinnectai_app/models/memorybox_post_request.dart';
import 'package:kinnectai_app/models/vault_sealed_response.dart';

class MemoryboxServiceApi {
  MemoryboxServiceApi(this._dio, {String? baseUrl})
      : _baseUrl = baseUrl ?? 'https://api.kinnectai.app/v1';

  final Dio _dio;
  final String _baseUrl;

  Future<VaultSealedResponse> sealMemory(MemoryboxPostRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_baseUrl/memorybox',
      data: request.toJson(),
    );
    final data = response.data ?? <String, dynamic>{};
    return VaultSealedResponse.fromJson(data);
  }
}
