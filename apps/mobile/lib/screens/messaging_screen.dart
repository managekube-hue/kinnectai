import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Addendum -- DM/Messaging Screen.
/// Thread view, E2EE via Libsignal, max 50MB media.
class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key, this.kinId});

  final String? kinId;

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = <_Msg>[
    const _Msg(text: 'Hey! I saw your Memory about Grandma\'s recipe.', isMe: false, time: '2:15 PM'),
    const _Msg(text: 'Yes! She used to make it every Sunday.', isMe: true, time: '2:16 PM'),
    const _Msg(text: 'I have a photo from 1987 if you want to see it.', isMe: false, time: '2:17 PM'),
  ];

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Msg(text: text, isMe: true, time: _now()));
      _controller.clear();
    });
    _scroll();
  }

  void _scroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      }
    });
  }

  String _now() {
    final n = DateTime.now();
    return '${n.hour > 12 ? n.hour - 12 : n.hour}:${n.minute.toString().padLeft(2, '0')} ${n.hour >= 12 ? 'PM' : 'AM'}';
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
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary), onPressed: () => Navigator.pop(context)),
        title: Row(
          children: [
            Container(width: 32, height: 32, decoration: const BoxDecoration(shape: BoxShape.circle, color: KinnectColors.surfaceElevated), child: Icon(PhosphorIcons.user(), size: 18, color: KinnectColors.textMuted)),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Emily Harrington', style: KinnectTextStyles.headlineSmall.copyWith(fontSize: 16)),
              Row(children: [
                Icon(PhosphorIcons.lock(), size: 10, color: KinnectColors.success),
                const SizedBox(width: 4),
                const Text('End-to-end encrypted', style: TextStyle(color: KinnectColors.success, fontSize: 10)),
              ]),
            ]),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _Bubble(msg: _messages[i]),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(12, 8, 12, MediaQuery.of(context).padding.bottom + 8),
            color: KinnectColors.surface,
            child: Row(
              children: [
                IconButton(icon: Icon(PhosphorIcons.paperclip(), color: KinnectColors.textSecondary), onPressed: () {}),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: KinnectColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Type a message...', hintStyle: const TextStyle(color: KinnectColors.textMuted),
                      filled: true, fillColor: KinnectColors.surfaceElevated,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _send,
                  child: Container(width: 40, height: 40, decoration: const BoxDecoration(color: KinnectColors.accent, shape: BoxShape.circle), child: Icon(PhosphorIcons.paperPlaneTilt(), size: 20, color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Msg {
  const _Msg({required this.text, required this.isMe, required this.time});
  final String text; final bool isMe; final String time;
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.msg});
  final _Msg msg;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: msg.isMe ? KinnectColors.accent : KinnectColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16), topRight: const Radius.circular(16),
            bottomLeft: msg.isMe ? const Radius.circular(16) : const Radius.circular(4),
            bottomRight: msg.isMe ? const Radius.circular(4) : const Radius.circular(16),
          ),
          border: msg.isMe ? null : Border.all(color: KinnectColors.dividerSubtle),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(msg.text, style: TextStyle(color: msg.isMe ? Colors.white : KinnectColors.textPrimary, fontSize: 14, height: 1.4)),
          const SizedBox(height: 4),
          Text(msg.time, style: TextStyle(color: msg.isMe ? Colors.white.withOpacity(0.7) : KinnectColors.textMuted, fontSize: 10)),
        ]),
      ),
    );
  }
}
