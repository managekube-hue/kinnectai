import 'dart:convert';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import '../secure_messaging_service.dart';

class E2EEService {
  E2EEService({SecureMessagingService? secureMessagingService})
      : _secure = secureMessagingService ?? SecureMessagingService();

  final SecureMessagingService _secure;

  Future<void> initializeLocalIdentity() async {
    await _secure.installLocalKeys();
  }

  Future<void> processPeerBundle({
    required String recipientId,
    required int deviceId,
    required PreKeyBundle bundle,
  }) async {
    await _secure.processRemotePreKeyBundle(
      recipientId: recipientId,
      deviceId: deviceId,
      bundle: bundle,
    );
  }

  Future<String> encryptText({
    required String recipientId,
    required int deviceId,
    required String plaintext,
  }) async {
    final message = await _secure.encryptText(
      recipientId: recipientId,
      deviceId: deviceId,
      plaintext: plaintext,
    );
    return base64Encode(message.serialize());
  }

  Future<String> decryptPreKey({
    required String senderId,
    required int deviceId,
    required String payloadBase64,
  }) async {
    final bytes = base64Decode(payloadBase64);
    final preKeyMessage = PreKeySignalMessage(bytes);
    return _secure.decryptPreKeyMessage(
      senderId: senderId,
      deviceId: deviceId,
      message: preKeyMessage,
    );
  }
}
