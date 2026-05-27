import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Content moderation service (Addendum 3.0 Section 9).
///
/// Auto: Perspective API (toxicity >= 0.8) + CLIP (NSFW >= 0.7) -> auto-hide.
/// 0.5-0.8 -> human review queue (24h SLA).
/// P0 (illegal/CSAM) -> 2h removal. P1 (hate) -> 24h. P2 (spam) -> 72h.
class ModerationService {
  ModerationService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: 'http://localhost:8080/v1'));

  final Dio _dio;

  /// Submit content for moderation check before publishing.
  Future<ModerationVerdict> checkContent({
    required String contentId,
    required String contentType, // memory, comment, Photplay, message
    String? textContent,
    String? mediaUrl,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/moderation/check',
        data: {
          'content_id': contentId,
          'content_type': contentType,
          'text': ?textContent,
          'media_url': ?mediaUrl,
        },
      );
      final data = response.data ?? {};
      return ModerationVerdict(
        action: _parseAction(data['action']?.toString()),
        reason: data['reason']?.toString(),
        queuePriority: data['queue_priority']?.toString(),
      );
    } catch (e) {
      debugPrint('Moderation check error: $e');
      // Fail open: allow content but flag for async review
      return const ModerationVerdict(action: ModerationAction.allowWithReview);
    }
  }

  /// Report content by a user.
  Future<void> reportContent({
    required String contentId,
    required String reason,
    String? details,
  }) async {
    await _dio.post<void>('/moderation/report', data: {
      'content_id': contentId,
      'reason': reason,
      'details': ?details,
    });
  }

  /// Block a user (removes from Kin graph, hides all content).
  Future<void> blockUser(String userId) async {
    await _dio.post<void>('/users/$userId/block');
  }

  /// Unblock a user.
  Future<void> unblockUser(String userId) async {
    await _dio.post<void>('/users/$userId/unblock');
  }

  static ModerationAction _parseAction(String? raw) {
    switch (raw) {
      case 'allow':
        return ModerationAction.allow;
      case 'hide':
        return ModerationAction.hide;
      case 'review':
        return ModerationAction.allowWithReview;
      case 'block':
        return ModerationAction.block;
      default:
        return ModerationAction.allow;
    }
  }
}

enum ModerationAction { allow, allowWithReview, hide, block }

class ModerationVerdict {
  const ModerationVerdict({
    required this.action,
    this.toxicityScore,
    this.nsfwScore,
    this.reason,
    this.queuePriority,
  });

  final ModerationAction action;
  final double? toxicityScore;
  final double? nsfwScore;
  final String? reason;
  final String? queuePriority; // P0, P1, P2
}

