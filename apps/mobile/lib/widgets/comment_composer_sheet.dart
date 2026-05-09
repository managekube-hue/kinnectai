import 'package:flutter/material.dart';
import '../theme/colors.dart';

class CommentComposerSheet extends StatefulWidget {
  final String memoryId;
  final String? replyToCommentId;
  final Function(String) onSubmit;
  
  const CommentComposerSheet({
    super.key,
    required this.memoryId,
    this.replyToCommentId,
    required this.onSubmit,
  });

  @override
  State<CommentComposerSheet> createState() => _CommentComposerSheetState();
}

class _CommentComposerSheetState extends State<CommentComposerSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: KinnectColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  widget.replyToCommentId != null ? 'Reply' : 'Add Comment',
                  style: const TextStyle(
                    color: KinnectColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: KinnectColors.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              style: const TextStyle(color: KinnectColors.textPrimary),
              maxLines: 4,
              maxLength: 500,
              decoration: const InputDecoration(
                hintText: 'Write your comment...',
                hintStyle: TextStyle(color: KinnectColors.textSecondary),
                border: InputBorder.none,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  '${_controller.text.length}/500',
                  style: TextStyle(
                    color: _controller.text.length > 450
                        ? KinnectColors.error
                        : KinnectColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _controller.text.trim().isEmpty || _isSubmitting
                      ? null
                      : _submitComment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KinnectColors.accent,
                    disabledBackgroundColor: KinnectColors.textMuted,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: KinnectColors.background,
                          ),
                        )
                      : const Text(
                          'Create',
                          style: TextStyle(color: KinnectColors.background),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitComment() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 500));
    widget.onSubmit(_controller.text.trim());
    if (mounted) Navigator.pop(context);
  }
}
