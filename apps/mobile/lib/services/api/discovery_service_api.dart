import 'package:dio/dio.dart';
import 'package:kinnectai_app/models/discovery_dismiss_post_request.dart';
import 'package:kinnectai_app/models/discovery_list.dart';

class DiscoveryServiceApi {
  DiscoveryServiceApi(this._dio, {String? baseUrl})
      : _baseUrl = baseUrl ?? 'https://api.kinnectai.app/v1';

  final Dio _dio;
  final String _baseUrl;

  Future<DiscoveryList> getCandidates() async {
    final response = await _dio.get<Map<String, dynamic>>('$_baseUrl/discovery');
    final data = response.data ?? <String, dynamic>{};
    return DiscoveryList.fromJson(data);
  }

  Future<void> dismissCandidate(DiscoveryDismissPostRequest request) async {
    await _dio.post<void>(
      '$_baseUrl/discovery/dismiss',
      data: request.toJson(),
    );
  }
}
