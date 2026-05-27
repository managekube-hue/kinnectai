import 'package:dio/dio.dart';
import 'package:kinnectai_app/models/kinnection_list.dart';
import 'package:kinnectai_app/models/kinnection_path.dart';

class KinGraphServiceApi {
  KinGraphServiceApi(this._dio, {String? baseUrl})
      : _baseUrl = baseUrl ?? 'https://api.kinnectai.app/v1';

  final Dio _dio;
  final String _baseUrl;

  Future<KinnectionList> getKinnections() async {
    final response = await _dio.get<Map<String, dynamic>>('$_baseUrl/kinnections');
    final data = response.data ?? <String, dynamic>{};
    return KinnectionList.fromJson(data);
  }

  Future<KinnectionPath> getPath(String userA, String userB) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_baseUrl/kinnections/path',
      queryParameters: {'user_a': userA, 'user_b': userB},
    );
    final data = response.data ?? <String, dynamic>{};
    return KinnectionPath.fromJson(data);
  }
}
