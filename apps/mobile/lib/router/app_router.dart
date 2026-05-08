import 'package:flutter/material.dart';

import '../widgets/comment_composer_sheet.dart';
import '../widgets/create_bottom_sheet.dart';
import '../widgets/kinship_badge_sheet.dart';
import '../widgets/pulse_reaction_sheet.dart';
import '../widgets/share_sheet.dart';
import '../widgets/strand_manager_sheet.dart';

class AppRouter {
  AppRouter._();

  static const String welcome = '/';
  static const String theLine = '/line';
  static const String repostStitch = '/repost-stitch';
  static const String treeGraph = '/tree';
  static const String rootProfile = '/profile';
  static const String voiceprintCapture = '/voiceprint-capture';
  static const String timeWellbeing = '/time-wellbeing';
  static const String settings = '/settings';

  static void showCreateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const CreateBottomSheet(),
    );
  }

  static void showStrandSheet(BuildContext context, String memoryId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => StrandManagerSheet(memoryId: memoryId),
    );
  }

  static void showShareSheet(
    BuildContext context,
    String memoryId,
    String memoryUrl,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ShareSheet(memoryId: memoryId, memoryUrl: memoryUrl),
    );
  }

  static void showPulseReactionSheet(
    BuildContext context,
    String memoryId,
    Function(bool) onPulseToggle,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) =>
          PulseReactionSheet(memoryId: memoryId, onPulseToggle: onPulseToggle),
    );
  }

  static void showCommentComposerSheet(
    BuildContext context,
    String memoryId,
    Function(String) onSubmit, {
    String? replyToCommentId,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => CommentComposerSheet(
        memoryId: memoryId,
        replyToCommentId: replyToCommentId,
        onSubmit: onSubmit,
      ),
    );
  }

  static void showKinshipBadgeSheet(
    BuildContext context,
    double kinScore,
    String relationshipType,
    String targetUserId,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => KinshipBadgeSheet(
        kinScore: kinScore,
        relationshipType: relationshipType,
        targetUserId: targetUserId,
      ),
    );
  }
}
