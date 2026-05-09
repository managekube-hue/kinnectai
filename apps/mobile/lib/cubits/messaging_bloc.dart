import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/secure_messaging_service.dart';

// ---------------------------------------------------------------------------
// Events
// ---------------------------------------------------------------------------

sealed class MessagingEvent extends Equatable {
  const MessagingEvent();

  @override
  List<Object?> get props => [];
}

class MessagingInitSession extends MessagingEvent {
  const MessagingInitSession({required this.recipientId, required this.deviceId});

  final String recipientId;
  final int deviceId;

  @override
  List<Object?> get props => [recipientId, deviceId];
}

class MessagingSendText extends MessagingEvent {
  const MessagingSendText({
    required this.recipientId,
    required this.deviceId,
    required this.plaintext,
  });

  final String recipientId;
  final int deviceId;
  final String plaintext;

  @override
  List<Object?> get props => [recipientId, deviceId, plaintext];
}

class MessagingReceiveMessage extends MessagingEvent {
  const MessagingReceiveMessage({
    required this.senderId,
    required this.deviceId,
    required this.ciphertext,
  });

  final String senderId;
  final int deviceId;
  final List<int> ciphertext;

  @override
  List<Object?> get props => [senderId, deviceId, ciphertext];
}

// ---------------------------------------------------------------------------
// States
// ---------------------------------------------------------------------------

sealed class MessagingState extends Equatable {
  const MessagingState();

  @override
  List<Object?> get props => [];
}

class MessagingIdle extends MessagingState {}

class MessagingSessionReady extends MessagingState {
  const MessagingSessionReady(this.recipientId);

  final String recipientId;

  @override
  List<Object?> get props => [recipientId];
}

class MessagingSending extends MessagingState {}

class MessagingSent extends MessagingState {
  const MessagingSent(this.ciphertextLength);

  final int ciphertextLength;

  @override
  List<Object?> get props => [ciphertextLength];
}

class MessagingDecrypted extends MessagingState {
  const MessagingDecrypted(this.plaintext);

  final String plaintext;

  @override
  List<Object?> get props => [plaintext];
}

class MessagingError extends MessagingState {
  const MessagingError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// ---------------------------------------------------------------------------
// BLoC
// ---------------------------------------------------------------------------

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  MessagingBloc({SecureMessagingService? messagingService})
      : _sms = messagingService ?? SecureMessagingService(),
        super(MessagingIdle()) {
    on<MessagingInitSession>(_onInitSession);
    on<MessagingSendText>(_onSendText);
    on<MessagingReceiveMessage>(_onReceiveMessage);
  }

  final SecureMessagingService _sms;

  Future<void> _onInitSession(
    MessagingInitSession event,
    Emitter<MessagingState> emit,
  ) async {
    try {
      await _sms.installLocalKeys();
      // In production, fetch the remote PreKeyBundle from the server and call
      // _sms.processRemotePreKeyBundle(...) here.
      emit(MessagingSessionReady(event.recipientId));
    } catch (e) {
      emit(MessagingError('Session init failed: $e'));
    }
  }

  Future<void> _onSendText(
    MessagingSendText event,
    Emitter<MessagingState> emit,
  ) async {
    emit(MessagingSending());
    try {
      final cipher = await _sms.encryptText(
        recipientId: event.recipientId,
        deviceId: event.deviceId,
        plaintext: event.plaintext,
      );
      emit(MessagingSent(cipher.serialize().length));
    } catch (e) {
      emit(MessagingError('Send failed: $e'));
    }
  }

  Future<void> _onReceiveMessage(
    MessagingReceiveMessage event,
    Emitter<MessagingState> emit,
  ) async {
    try {
      // In production, determine message type (PreKeySignalMessage vs
      // SignalMessage) and decrypt accordingly.
      emit(const MessagingError('Decryption not yet wired to transport'));
    } catch (e) {
      emit(MessagingError('Decrypt failed: $e'));
    }
  }
}
