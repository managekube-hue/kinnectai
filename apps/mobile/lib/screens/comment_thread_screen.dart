import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';
import '../models/memory.dart';
import '../services/interaction_service.dart';

class CommentThreadScreen extends StatefulWidget {
  final String memoryId;

  const CommentThreadScreen({
    super.key,
    required this.memoryId,
  });

  @override
  State<CommentThreadScreen> createState() => _CommentThreadScreenState();
}

class _CommentThreadScreenState extends State<CommentThreadScreen> {
  final InteractionService _interactionService = InteractionService();
  final TextEditingController _commentController = TextEditingController();
  List<Comment> _comments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    setState(() => _isLoading = true);
    final comments = await _interactionService.getComments(widget.memoryId);
    setState(() {
      _comments = comments;
      _isLoading = false;
    });
  }

  Future<void> _postComment() async {
    if (_commentController.text.trim().isEmpty) return;

    await _interactionService.addComment(
      widget.memoryId,
      _commentController.text.trim(),
    );
    _commentController.clear();
    await _loadComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Comments', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(KinnectColors.accent),
                    ),
                  )
                : _comments.isEmpty
                    ? Center(
                        child: Text(
                          'No comments yet',
                          style: KinnectTextStyles.bodyMedium.copyWith(
                            color: KinnectColors.textSecondary,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _comments.length,
                        padding: const EdgeInsets.all(KinnectSpacing.md),
                        itemBuilder: (context, index) {
                          final comment = _comments[index];
                          return _CommentCard(comment: comment);
                        },
                      ),
          ),
          _CommentInput(
            controller: _commentController,
            onSend: _postComment,
          ),
        ],
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  final Comment comment;

  const _CommentCard({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: KinnectSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: KinnectColors.surface,
            child: Text(
              comment.authorUsername[0].toUpperCase(),
              style: KinnectTextStyles.bodyLarge.copyWith(
                color: KinnectColors.accent,
              ),
            ),
          ),
          const SizedBox(width: KinnectSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '@${comment.authorUsername}',
                      style: KinnectTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: KinnectSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: KinnectColors.success.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${(comment.kinScore * 100).toInt()}%',
                        style: KinnectTextStyles.caption.copyWith(
                          color: KinnectColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.text,
                  style: KinnectTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _CommentInput({
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: KinnectSpacing.md,
        right: KinnectSpacing.md,
        top: KinnectSpacing.sm,
        bottom: MediaQuery.of(context).padding.bottom + KinnectSpacing.sm,
      ),
      decoration: const BoxDecoration(
        color: KinnectColors.surface,
        border: Border(
          top: BorderSide(color: KinnectColors.textMuted, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: KinnectTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                hintStyle: KinnectTextStyles.bodyMedium.copyWith(
                  color: KinnectColors.textSecondary,
                ),
                filled: true,
                fillColor: KinnectColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(KinnectSpacing.radiusLarge),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: KinnectSpacing.md,
                  vertical: KinnectSpacing.sm,
                ),
              ),
            ),
          ),
          const SizedBox(width: KinnectSpacing.sm),
          IconButton(
            icon: Icon(PhosphorIcons.paperPlaneTilt(), color: KinnectColors.accent),
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}
