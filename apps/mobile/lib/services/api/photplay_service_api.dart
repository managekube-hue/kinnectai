import 'package:dio/dio.dart';
import 'package:kinnectai_app/models/photplay_job_response.dart';
import 'package:kinnectai_app/models/photplay_request.dart';

class PhotplayServiceApi {
  PhotplayServiceApi(this._dio, {String? baseUrl})
      : _baseUrl = baseUrl ?? 'https://api.kinnectai.app/v1';

  final Dio _dio;
  final String _baseUrl;

  Future<PhotplayJobResponse> queuePhotplayJob(PhotplayRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_baseUrl/photplay',
      data: request.toJson(),
    );
    final data = response.data ?? <String, dynamic>{};
    return PhotplayJobResponse.fromJson(data);
  }
}
