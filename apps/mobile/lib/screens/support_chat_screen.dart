import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 12 -- Support Chat.
/// In-app support messaging for help requests.
class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = <_ChatMessage>[
    const _ChatMessage(
      text: 'Hi! I\'m the KinnectAI support assistant. How can I help you today?',
      isUser: false,
      time: '2:30 PM',
    ),
  ];

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true, time: _timeNow()));
      _controller.clear();
    });

    _scrollToBottom();

    // Simulated auto-reply
    Future<void>.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _messages.add(_ChatMessage(
          text: 'Thanks for reaching out. A support team member will follow up '
              'shortly. In the meantime, you can check our Help Center for '
              'common questions.',
          isUser: false,
          time: _timeNow(),
        ));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _timeNow() {
    final now = DateTime.now();
    final h = now.hour > 12 ? now.hour - 12 : now.hour;
    final m = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: KinnectColors.primary,
              ),
              child: Icon(PhosphorIcons.headset(), size: 18, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Support', style: KinnectTextStyles.headlineSmall.copyWith(fontSize: 16)),
                const Text('Typically replies in 2h', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 11)),
              ],
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Quick actions
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: KinnectColors.surface,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _QuickAction(label: 'Account issue', onTap: () => _quickSend('I have an account issue')),
                  _QuickAction(label: 'Memory Box help', onTap: () => _quickSend('I need help with Memory Box')),
                  _QuickAction(label: 'DNA kit status', onTap: () => _quickSend('What is my DNA kit status?')),
                  _QuickAction(label: 'Billing', onTap: () => _quickSend('I have a billing question')),
                ],
              ),
            ),
          ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, i) => _MessageBubble(message: _messages[i]),
            ),
          ),

          // Input
          Container(
            padding: EdgeInsets.fromLTRB(12, 8, 12, MediaQuery.of(context).padding.bottom + 8),
            color: KinnectColors.surface,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(PhosphorIcons.paperclip(), color: KinnectColors.textSecondary),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: KinnectColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: const TextStyle(color: KinnectColors.textMuted),
                      filled: true,
                      fillColor: KinnectColors.surfaceElevated,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(color: KinnectColors.accent, shape: BoxShape.circle),
                    child: Icon(PhosphorIcons.paperPlaneTilt(), size: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _quickSend(String text) {
    _controller.text = text;
    _send();
  }
}

class _ChatMessage {
  const _ChatMessage({required this.text, required this.isUser, required this.time});
  final String text;
  final bool isUser;
  final String time;
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: message.isUser ? KinnectColors.accent : KinnectColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: message.isUser ? const Radius.circular(16) : const Radius.circular(4),
            bottomRight: message.isUser ? const Radius.circular(4) : const Radius.circular(16),
          ),
          border: message.isUser ? null : Border.all(color: KinnectColors.dividerSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : KinnectColors.textPrimary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.time,
              style: TextStyle(
                color: message.isUser ? Colors.white.withOpacity(0.7) : KinnectColors.textMuted,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: KinnectColors.surfaceElevated,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: KinnectColors.dividerSubtle),
          ),
          child: Text(label, style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 13)),
        ),
      ),
    );
  }
}
