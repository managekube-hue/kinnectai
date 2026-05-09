import 'package:dio/dio.dart';

import 'room_repository.dart';

class RoomRepositoryImpl implements RoomRepository {
  RoomRepositoryImpl({required Dio dio, this.basePath = '/v1'}) : _dio = dio;

  final Dio _dio;
  final String basePath;

  @override
  Future<Map<String, dynamic>> createRoom({required String name, bool isPrivate = true, double? kinScoreGate}) async {
    final response = await _dio.post<Map<String, dynamic>>('$basePath/rooms', data: {
      'name': name,
      'is_private': isPrivate,
      if (kinScoreGate != null) 'kin_score_gate': kinScoreGate,
    });
    return response.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> joinRoom(String roomId) async {
    final response = await _dio.post<Map<String, dynamic>>('$basePath/rooms/$roomId/join');
    return response.data ?? {};
  }

  @override
  Future<void> leaveRoom(String roomId) async {
    await _dio.post<void>('$basePath/rooms/$roomId/leave');
  }

  @override
  Future<Map<String, dynamic>> getRoomDetails(String roomId) async {
    final response = await _dio.get<Map<String, dynamic>>('$basePath/rooms/$roomId');
    return response.data ?? {};
  }

  @override
  Future<List<Map<String, dynamic>>> listActiveRooms() async {
    final response = await _dio.get<Map<String, dynamic>>('$basePath/rooms/active');
    return ((response.data?['items'] as List?) ?? []).whereType<Map<String, dynamic>>().toList();
  }

  @override
  Future<List<Map<String, dynamic>>> listScheduledGatherings() async {
    final response = await _dio.get<Map<String, dynamic>>('$basePath/rooms/scheduled');
    return ((response.data?['items'] as List?) ?? []).whereType<Map<String, dynamic>>().toList();
  }

  @override
  Future<void> startRecording(String roomId) async {
    await _dio.post<void>('$basePath/rooms/$roomId/recording/start');
  }

  @override
  Future<void> stopRecording(String roomId) async {
    await _dio.post<void>('$basePath/rooms/$roomId/recording/stop');
  }
}
