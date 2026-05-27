import 'package:dio/dio.dart';

/// Room service for WebRTC video calls (PRD Section 08).
/// JWT + Kin Score gate authentication. mediasoup SFU.
class RoomService {
  RoomService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: 'http://localhost:8080/v1'));

  final Dio _dio;

  /// Create a new Room.
  Future<Map<String, dynamic>> createRoom({
    required String name,
    bool isPrivate = true,
    double? kinScoreGate,
    DateTime? scheduledAt,
    List<String>? invitedKinIds,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>('/rooms', data: {
      'name': name,
      'is_private': isPrivate,
      'kin_score_gate': ?kinScoreGate,
      if (scheduledAt != null) 'scheduled_at': scheduledAt.toIso8601String(),
      'invited_kin_ids': ?invitedKinIds,
    });
    return response.data ?? {};
  }

  /// Join an existing Room. Returns SFU connection token.
  Future<Map<String, dynamic>> joinRoom(String roomId) async {
    final response = await _dio.post<Map<String, dynamic>>('/rooms/$roomId/join');
    return response.data ?? {};
  }

  /// Leave a Room.
  Future<void> leaveRoom(String roomId) async {
    await _dio.post<void>('/rooms/$roomId/leave');
  }

  /// Get Room details (participants, status, etc.).
  Future<Map<String, dynamic>> getRoomDetails(String roomId) async {
    final response = await _dio.get<Map<String, dynamic>>('/rooms/$roomId');
    return response.data ?? {};
  }

  /// List active Rooms the user can join.
  Future<List<Map<String, dynamic>>> listActiveRooms() async {
    final response = await _dio.get<Map<String, dynamic>>('/rooms/active');
    final items = (response.data?['items'] as List?) ?? [];
    return items.whereType<Map<String, dynamic>>().toList();
  }

  /// List scheduled Gatherings.
  Future<List<Map<String, dynamic>>> listScheduledGatherings() async {
    final response = await _dio.get<Map<String, dynamic>>('/rooms/scheduled');
    final items = (response.data?['items'] as List?) ?? [];
    return items.whereType<Map<String, dynamic>>().toList();
  }

  /// Start recording (requires all participant consent per Addendum 3.0 S3).
  Future<void> startRecording(String roomId) async {
    await _dio.post<void>('/rooms/$roomId/recording/start');
  }

  /// Stop recording.
  Future<void> stopRecording(String roomId) async {
    await _dio.post<void>('/rooms/$roomId/recording/stop');
  }

  /// Go Live (converts Room to HLS broadcast).
  Future<void> goLive(String roomId) async {
    await _dio.post<void>('/rooms/$roomId/live');
  }

  /// Host controls: mute a participant.
  Future<void> muteParticipant(String roomId, String participantId) async {
    await _dio.post<void>('/rooms/$roomId/participants/$participantId/mute');
  }

  /// Host controls: remove a participant.
  Future<void> removeParticipant(String roomId, String participantId) async {
    await _dio.post<void>('/rooms/$roomId/participants/$participantId/remove');
  }
}
