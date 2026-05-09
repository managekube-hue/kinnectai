import 'dart:convert';

import 'package:dio/dio.dart';

class StewardService {
  StewardService({Dio? dio, String? baseUrl})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: baseUrl ?? 'https://api.kinnectai.app'));

  final Dio _dio;

  Future<void> submitConsent({
    required String userId,
    required bool accepted,
    required String ipAddress,
    required String userAgent,
    required DateTime timestamp,
  }) async {
    await _dio.post(
      '/steward/consent',
      data: <String, dynamic>{
        'user_id': userId,
        'accepted': accepted,
        'ip_address': ipAddress,
        'user_agent': userAgent,
        'timestamp_utc': timestamp.toUtc().toIso8601String(),
        'signature': _signature(userId, accepted, timestamp),
      },
    );
  }

  String _signature(String userId, bool accepted, DateTime timestamp) {
    final raw = '$userId|$accepted|${timestamp.toUtc().toIso8601String()}';
    return base64Encode(utf8.encode(raw));
  }
}
