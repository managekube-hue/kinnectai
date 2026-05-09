import 'package:dio/dio.dart';

import 'dna_kit_repository.dart';

class DnaKitRepositoryImpl implements DnaKitRepository {
  DnaKitRepositoryImpl({required Dio dio, this.basePath = '/api/v1'}) : _dio = dio;

  final Dio _dio;
  final String basePath;

  @override
  Future<Map<String, dynamic>> orderKit({required Map<String, dynamic> shippingAddress}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$basePath/dna/order',
      data: {'shipping_address': shippingAddress},
    );
    return response.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> getKitStatus(String kitId) async {
    final response = await _dio.get<Map<String, dynamic>>('$basePath/dna/kits/$kitId');
    return response.data ?? {};
  }

  @override
  Future<void> registerKit(String kitId, String barcode) async {
    await _dio.post<void>('$basePath/dna/kits/$kitId/register', data: {'barcode': barcode});
  }

  @override
  Future<Map<String, dynamic>> getResults(String kitId) async {
    final response = await _dio.get<Map<String, dynamic>>('$basePath/dna/kits/$kitId/results');
    return response.data ?? {};
  }

  @override
  Future<void> requestRawDeletion(String kitId) async {
    await _dio.post<void>('$basePath/dna/raw/$kitId/delete');
  }

  @override
  Future<void> connectProvider(String provider, String oauthToken) async {
    await _dio.post<void>('$basePath/dna/connect', data: {'provider': provider, 'oauth_token': oauthToken});
  }

  @override
  Future<void> disconnectProvider(String provider) async {
    await _dio.post<void>('$basePath/dna/disconnect', data: {'provider': provider});
  }
}
