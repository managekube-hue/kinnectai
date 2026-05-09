import 'package:dio/dio.dart';

import 'messaging_repository.dart';

class MessagingRepositoryImpl implements MessagingRepository {
  MessagingRepositoryImpl({required Dio dio, this.basePath = '/v1'}) : _dio = dio;

  final Dio _dio;
  final String basePath;

  @override
  Future<List<Map<String, dynamic>>> fetchThreads() async {
    final response = await _dio.get<Map<String, dynamic>>('$basePath/messages/threads');
    return ((response.data?['items'] as List?) ?? []).whereType<Map<String, dynamic>>().toList();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchMessages(String threadId, {String? cursor}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$basePath/messages/threads/$threadId',
      queryParameters: {if (cursor != null) 'after': cursor},
    );
    return ((response.data?['items'] as List?) ?? []).whereType<Map<String, dynamic>>().toList();
  }

  @override
  Future<void> sendMessage(String threadId, {required String encryptedPayload, required int senderDeviceId}) async {
    await _dio.post<void>('$basePath/messages', data: {
      'thread_id': threadId,
      'encrypted_payload': encryptedPayload,
      'sender_device_id': senderDeviceId,
    });
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    await _dio.delete<void>('$basePath/messages/$messageId');
  }

  @override
  Future<void> markThreadRead(String threadId) async {
    await _dio.post<void>('$basePath/messages/threads/$threadId/read');
  }
}
