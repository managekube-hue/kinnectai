import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/room_cubit.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// Single-room screen for WebRTC-backed rooms (PRD §08, Audit Item 41–42).
///
/// Deep-linked via `kinnect://room/<roomId>` →
/// `POST /v1/rooms/:id/join` → WebRTC SFU token
///
/// Provided with [roomId], this screen instructs [RoomCubit] to join on
/// mount and displays connection state / participant controls.
class RoomsScreen extends StatefulWidget {
  const RoomsScreen({required this.roomId, super.key});

  final String roomId;

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RoomCubit>().joinRoom(widget.roomId);
  }

  @override
  void dispose() {
    context.read<RoomCubit>().leaveRoom();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomState>(
      builder: (ctx, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: KinnectColors.textPrimary,
            title: const Text('Room', style: KinnectTextStyles.headlineSmall),
            actions: [
              if (state is RoomJoined)
                IconButton(
                  icon: Icon(
                    state.isMuted ? Icons.mic_off : Icons.mic,
                    color: KinnectColors.textPrimary,
                  ),
                  onPressed: () => ctx.read<RoomCubit>().toggleMute(),
                ),
            ],
          ),
          body: switch (state) {
            RoomConnecting() => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Joining room…',
                      style: KinnectTextStyles.bodyMedium.copyWith(
                        color: KinnectColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            RoomJoined(:final participants) => _RoomView(
                roomId: widget.roomId,
                participants: participants,
                state: state,
              ),
            RoomError(:final message) => Center(
                child: Text(
                  message,
                  style: KinnectTextStyles.bodyMedium.copyWith(
                    color: KinnectColors.error,
                  ),
                ),
              ),
            _ => const SizedBox.shrink(),
          },
        );
      },
    );
  }
}

class _RoomView extends StatelessWidget {
  const _RoomView({
    required this.roomId,
    required this.participants,
    required this.state,
  });

  final String roomId;
  final List<String> participants;
  final RoomJoined state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: participants.length,
            itemBuilder: (_, i) => _ParticipantTile(userId: participants[i]),
          ),
        ),
        _RoomControls(state: state),
      ],
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  const _ParticipantTile({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: KinnectColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person, size: 40, color: KinnectColors.textSecondary),
            const SizedBox(height: 4),
            Text(
              userId,
              style: KinnectTextStyles.bodySmall.copyWith(
                color: KinnectColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomControls extends StatelessWidget {
  const _RoomControls({required this.state});

  final RoomJoined state;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              iconSize: 32,
              icon: Icon(
                state.isMuted ? Icons.mic_off : Icons.mic,
                color: state.isMuted
                    ? KinnectColors.textSecondary
                    : KinnectColors.textPrimary,
              ),
              onPressed: () => context.read<RoomCubit>().toggleMute(),
            ),
            IconButton(
              iconSize: 32,
              icon: Icon(
                state.isCameraOn ? Icons.videocam : Icons.videocam_off,
                color: state.isCameraOn
                    ? KinnectColors.textPrimary
                    : KinnectColors.textSecondary,
              ),
              onPressed: () => context.read<RoomCubit>().toggleCamera(),
            ),
            IconButton(
              iconSize: 32,
              icon: const Icon(Icons.call_end, color: Colors.red),
              onPressed: () {
                context.read<RoomCubit>().leaveRoom();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
