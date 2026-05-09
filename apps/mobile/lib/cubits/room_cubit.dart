import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ---------------------------------------------------------------------------
// States
// ---------------------------------------------------------------------------

sealed class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object?> get props => [];
}

class RoomIdle extends RoomState {}

class RoomConnecting extends RoomState {
  const RoomConnecting(this.roomId);

  final String roomId;

  @override
  List<Object?> get props => [roomId];
}

class RoomJoined extends RoomState {
  const RoomJoined({
    required this.roomId,
    required this.participants,
    required this.isMuted,
    required this.isCameraOn,
  });

  final String roomId;
  final List<String> participants;
  final bool isMuted;
  final bool isCameraOn;

  @override
  List<Object?> get props => [roomId, participants, isMuted, isCameraOn];

  RoomJoined copyWith({
    List<String>? participants,
    bool? isMuted,
    bool? isCameraOn,
  }) {
    return RoomJoined(
      roomId: roomId,
      participants: participants ?? this.participants,
      isMuted: isMuted ?? this.isMuted,
      isCameraOn: isCameraOn ?? this.isCameraOn,
    );
  }
}

class RoomEnded extends RoomState {}

class RoomError extends RoomState {
  const RoomError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// ---------------------------------------------------------------------------
// Cubit
// ---------------------------------------------------------------------------

class RoomCubit extends Cubit<RoomState> {
  RoomCubit() : super(RoomIdle());

  Future<void> joinRoom(String roomId) async {
    emit(RoomConnecting(roomId));
    try {
      // TODO: Connect via WebRTC / LiveKit signalling server
      await Future<void>.delayed(const Duration(milliseconds: 500));
      emit(RoomJoined(
        roomId: roomId,
        participants: const [],
        isMuted: false,
        isCameraOn: true,
      ));
    } catch (e) {
      emit(RoomError('Failed to join room: $e'));
    }
  }

  void toggleMute() {
    final current = state;
    if (current is RoomJoined) {
      emit(current.copyWith(isMuted: !current.isMuted));
    }
  }

  void toggleCamera() {
    final current = state;
    if (current is RoomJoined) {
      emit(current.copyWith(isCameraOn: !current.isCameraOn));
    }
  }

  Future<void> leaveRoom() async {
    // TODO: Disconnect WebRTC session
    emit(RoomEnded());
  }
}
