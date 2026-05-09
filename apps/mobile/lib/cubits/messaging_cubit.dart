import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/dtos/message_dto.dart';
import '../services/messaging/e2ee_service.dart';

sealed class MessagingState extends Equatable {
  const MessagingState();

  @override
  List<Object?> get props => [];
}

class MessagingIdle extends MessagingState {}

class MessagingLoading extends MessagingState {}

class MessagingLoaded extends MessagingState {
  const MessagingLoaded({
    required this.threadId,
    required this.currentUserId,
    required this.peerId,
    required this.messages,
  });

  final String threadId;
  final String currentUserId;
  final String peerId;
  final List<MessageDTO> messages;

  MessagingLoaded copyWith({
    List<MessageDTO>? messages,
  }) {
    return MessagingLoaded(
      threadId: threadId,
      currentUserId: currentUserId,
      peerId: peerId,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [threadId, currentUserId, peerId, messages];
}

class MessagingError extends MessagingState {
  const MessagingError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class MessagingCubit extends Cubit<MessagingState> {
  MessagingCubit({E2EEService? e2eeService})
      : _e2ee = e2eeService ?? E2EEService(),
        super(MessagingIdle());

  final E2EEService _e2ee;

  Future<void> initializeThread({
    required String threadId,
    required String currentUserId,
    required String peerId,
  }) async {
    emit(MessagingLoading());
    try {
      await _e2ee.initializeLocalIdentity();
      emit(MessagingLoaded(
        threadId: threadId,
        currentUserId: currentUserId,
        peerId: peerId,
        messages: const [],
      ));
    } catch (e) {
      emit(MessagingError('Failed to initialize secure thread: $e'));
    }
  }

  Future<void> sendMessage({
    required String plaintext,
    int deviceId = 1,
  }) async {
    final current = state;
    if (current is! MessagingLoaded || plaintext.trim().isEmpty) return;

    try {
      final encrypted = await _e2ee.encryptText(
        recipientId: current.peerId,
        deviceId: deviceId,
        plaintext: plaintext.trim(),
      );
      final now = DateTime.now();
      final message = MessageDTO(
        id: now.microsecondsSinceEpoch.toString(),
        threadId: current.threadId,
        senderId: current.currentUserId,
        recipientId: current.peerId,
        ciphertext: encrypted,
        sentAt: now,
      );
      emit(current.copyWith(messages: [...current.messages, message]));
    } catch (e) {
      emit(MessagingError('Failed to send message: $e'));
    }
  }
}
