import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/messaging_cubit.dart';
import '../theme/colors.dart';

class DmThreadScreen extends StatefulWidget {
  const DmThreadScreen({
    required this.threadId,
    required this.currentUserId,
    required this.peerId,
    super.key,
  });

  final String threadId;
  final String currentUserId;
  final String peerId;

  @override
  State<DmThreadScreen> createState() => _DmThreadScreenState();
}

class _DmThreadScreenState extends State<DmThreadScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MessagingCubit>().initializeThread(
      threadId: widget.threadId,
      currentUserId: widget.currentUserId,
      peerId: widget.peerId,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    await context.read<MessagingCubit>().sendMessage(
      plaintext: _textController.text,
    );
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Direct Message'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<MessagingCubit, MessagingState>(
              builder: (context, state) {
                if (state is MessagingLoading || state is MessagingIdle) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is MessagingError) {
                  return Center(child: Text(state.message));
                }
                if (state is! MessagingLoaded) {
                  return const SizedBox.shrink();
                }
                if (state.messages.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(12),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final msg = state.messages[state.messages.length - 1 - index];
                    final isSelf = msg.senderId == state.currentUserId;
                    return Align(
                      alignment: isSelf ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelf ? KinnectColors.accent : KinnectColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          msg.ciphertext,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Type encrypted message',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _send,
                    child: const Text('Send'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
