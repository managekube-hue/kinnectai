import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// DNA Kit logistics service (Addendum 3.0 Section 5).
/// Handles kit ordering, tracking, barcode registration, and results retrieval.
class DnaKitService {
  DnaKitService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: 'http://localhost:8080/api/v1'));

  final Dio _dio;

  /// Order a new Kinnect Kit.
  Future<Map<String, dynamic>> orderKit({required Map<String, dynamic> shippingAddress}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/dna/order',
      data: {'shipping_address': shippingAddress},
    );
    return response.data ?? {};
  }

  /// Get kit tracking status.
  Future<Map<String, dynamic>> getKitStatus(String kitId) async {
    final response = await _dio.get<Map<String, dynamic>>('/dna/kits/$kitId');
    return response.data ?? {};
  }

  /// Register kit barcode after receiving physical tube.
  Future<void> registerKit(String kitId, String barcode) async {
    await _dio.post<void>(
      '/dna/kits/$kitId/register',
      data: {'barcode': barcode},
    );
  }

  /// Get DNA results (haplogroup, ethnicity, etc.).
  Future<Map<String, dynamic>> getResults(String kitId) async {
    final response = await _dio.get<Map<String, dynamic>>('/dna/kits/$kitId/results');
    return response.data ?? {};
  }

  /// Request raw data deletion (GDPR Art. 17). Irreversible.
  Future<void> requestRawDeletion(String kitId) async {
    await _dio.post<void>('/dna/raw/$kitId/delete');
  }

  /// Connect external DNA provider (Sequencing.com OAuth).
  Future<void> connectProvider(String provider, String oauthToken) async {
    await _dio.post<void>(
      '/dna/connect',
      data: {'provider': provider, 'oauth_token': oauthToken},
    );
  }

  /// Disconnect external DNA provider.
  Future<void> disconnectProvider(String provider) async {
    await _dio.post<void>('/dna/disconnect', data: {'provider': provider});
  }
}
