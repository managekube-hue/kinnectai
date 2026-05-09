abstract class RoomRepository {
  Future<Map<String, dynamic>> createRoom({
    required String name,
    bool isPrivate = true,
    double? kinScoreGate,
  });
  Future<Map<String, dynamic>> joinRoom(String roomId);
  Future<void> leaveRoom(String roomId);
  Future<Map<String, dynamic>> getRoomDetails(String roomId);
  Future<List<Map<String, dynamic>>> listActiveRooms();
  Future<List<Map<String, dynamic>>> listScheduledGatherings();
  Future<void> startRecording(String roomId);
  Future<void> stopRecording(String roomId);
}
