import 'package:dio/dio.dart';
import 'package:kinnectai_app/models/kc_explain_response.dart';

class KernelServiceApi {
  KernelServiceApi(this._dio, {String? baseUrl})
      : _baseUrl = baseUrl ?? 'https://api.kinnectai.app/v1';

  final Dio _dio;
  final String _baseUrl;

  Future<KCExplainResponse> explainKC(String pairId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_baseUrl/kc/explain/$pairId',
    );
    final data = response.data ?? <String, dynamic>{};
    return KCExplainResponse.fromJson(data);
  }
}
