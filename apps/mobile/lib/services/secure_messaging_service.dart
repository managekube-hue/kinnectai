import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class SecureMessagingService {
  SecureMessagingService()
    : _sessionStore = InMemorySessionStore(),
      _preKeyStore = InMemoryPreKeyStore(),
      _signedPreKeyStore = InMemorySignedPreKeyStore() {
    _identityKeyPair = generateIdentityKeyPair();
    _registrationId = generateRegistrationId(false);
    _identityStore = InMemoryIdentityKeyStore(_identityKeyPair, _registrationId);
  }

  late final IdentityKeyPair _identityKeyPair;
  late final int _registrationId;
  late final InMemoryIdentityKeyStore _identityStore;
  final InMemorySessionStore _sessionStore;
  final InMemoryPreKeyStore _preKeyStore;
  final InMemorySignedPreKeyStore _signedPreKeyStore;

  int get registrationId => _registrationId;

  Future<void> installLocalKeys({
    int preKeyBatchSize = 32,
    int preKeyStartId = 1,
    int signedPreKeyId = 1,
  }) async {
    final preKeys = generatePreKeys(preKeyStartId, preKeyBatchSize);
    for (final preKey in preKeys) {
      await _preKeyStore.storePreKey(preKey.id, preKey);
    }

    final signedPreKey = generateSignedPreKey(_identityKeyPair, signedPreKeyId);
    await _signedPreKeyStore.storeSignedPreKey(signedPreKey.id, signedPreKey);
  }

  Future<void> processRemotePreKeyBundle({
    required String recipientId,
    required int deviceId,
    required PreKeyBundle bundle,
  }) async {
    final address = SignalProtocolAddress(recipientId, deviceId);
    final sessionBuilder = SessionBuilder(
      _sessionStore,
      _preKeyStore,
      _signedPreKeyStore,
      _identityStore,
      address,
    );
    await sessionBuilder.processPreKeyBundle(bundle);
  }

  Future<CiphertextMessage> encryptText({
    required String recipientId,
    required int deviceId,
    required String plaintext,
  }) async {
    final address = SignalProtocolAddress(recipientId, deviceId);
    final cipher = SessionCipher(
      _sessionStore,
      _preKeyStore,
      _signedPreKeyStore,
      _identityStore,
      address,
    );
    return cipher.encrypt(Uint8List.fromList(plaintext.codeUnits));
  }

  Future<String> decryptPreKeyMessage({
    required String senderId,
    required int deviceId,
    required PreKeySignalMessage message,
  }) async {
    final address = SignalProtocolAddress(senderId, deviceId);
    final cipher = SessionCipher(
      _sessionStore,
      _preKeyStore,
      _signedPreKeyStore,
      _identityStore,
      address,
    );
    final bytes = await cipher.decryptWithCallback(
      message,
      (_) {},
    );
    return String.fromCharCodes(bytes);
  }
}

