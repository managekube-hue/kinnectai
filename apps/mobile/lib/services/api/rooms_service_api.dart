import 'package:dio/dio.dart';
import 'package:kinnectai_app/models/room_create_request.dart';
import 'package:kinnectai_app/models/room_token_response.dart';

class RoomsServiceApi {
  RoomsServiceApi(this._dio, {String? baseUrl})
      : _baseUrl = baseUrl ?? 'https://api.kinnectai.app/v1';

  final Dio _dio;
  final String _baseUrl;

  Future<RoomTokenResponse> createRoom(RoomCreateRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_baseUrl/rooms',
      data: request.toJson(),
    );
    final data = response.data ?? <String, dynamic>{};
    return RoomTokenResponse.fromJson(data);
  }
}
