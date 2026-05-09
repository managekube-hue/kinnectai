abstract class MessagingRepository {
  Future<List<Map<String, dynamic>>> fetchThreads();
  Future<List<Map<String, dynamic>>> fetchMessages(String threadId, {String? cursor});
  Future<void> sendMessage(String threadId, {required String encryptedPayload, required int senderDeviceId});
  Future<void> deleteMessage(String messageId);
  Future<void> markThreadRead(String threadId);
}
