import 'package:dio/dio.dart';
import 'package:kinnectai_app/models/feed_get200_response.dart';
import 'package:kinnectai_app/models/pulses_post201_response.dart';
import 'package:kinnectai_app/models/pulses_post_request.dart';

class FeedServiceApi {
  FeedServiceApi(this._dio, {String? baseUrl})
      : _baseUrl = baseUrl ?? 'https://api.kinnectai.app/v1';

  final Dio _dio;
  final String _baseUrl;

  Future<FeedGet200Response> getFeed({
    int? limit,
    String? cursor,
    String? fallbackMode,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_baseUrl/feed',
      queryParameters: {
        'limit': ?limit,
        'cursor': ?cursor,
        'fallback_mode': ?fallbackMode,
      },
    );
    final data = response.data ?? <String, dynamic>{};
    return FeedGet200Response.fromJson(data);
  }

  Future<PulsesPost201Response> sendPulse(PulsesPostRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_baseUrl/pulses',
      data: request.toJson(),
    );
    final data = response.data ?? <String, dynamic>{};
    return PulsesPost201Response.fromJson(data);
  }
}
