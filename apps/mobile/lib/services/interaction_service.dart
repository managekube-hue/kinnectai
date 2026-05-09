import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/memory.dart';

/// Interaction service for Pulse, Comment, Share, Save actions (PRD Section 09).
/// Writes to backend (Cassandra-backed), provides optimistic UI updates.
class InteractionService {
  InteractionService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: 'http://localhost:8080/v1'));

  final Dio _dio;

  /// Toggle pulse on a memory. Returns new state.
  Future<bool> togglePulse(String memoryId, {required bool currentState}) async {
    try {
      final endpoint = currentState ? '/interactions/pulse/remove' : '/interactions/pulse/add';
      await _dio.post<void>(endpoint, data: {'memory_id': memoryId});
      return !currentState;
    } catch (e) {
      debugPrint('Pulse error: $e');
      return currentState; // Revert on error
    }
  }

  /// Add comment to a memory. CR-sorted on server.
  Future<void> addComment(String memoryId, String text, {String? replyToId}) async {
    try {
      await _dio.post<void>('/comments', data: {
        'memory_id': memoryId,
        'text': text,
        if (replyToId != null) 'reply_to_id': replyToId,
      });
    } catch (e) {
      debugPrint('Comment error: $e');
      rethrow;
    }
  }

  /// Get comments for a memory (sorted by Kin Score, not chronological per PRD).
  Future<List<Comment>> getComments(String memoryId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/comments/$memoryId',
        queryParameters: {'sort': 'kin_score'},
      );
      final items = (response.data?['items'] as List?) ?? [];
      return items
          .whereType<Map<String, dynamic>>()
          .map((j) => Comment(
                id: (j['id'] ?? '').toString(),
                authorUsername: (j['author_username'] ?? '').toString(),
                text: (j['text'] ?? '').toString(),
                createdAt: DateTime.tryParse((j['created_at'] ?? '').toString()) ?? DateTime.now(),
              ))
          .toList();
    } catch (e) {
      debugPrint('Load comments error: $e');
      return [];
    }
  }

  /// Toggle save to Strand.
  Future<bool> toggleSave(String memoryId, {required bool currentState, String? strandId}) async {
    try {
      final endpoint = currentState ? '/strands/remove' : '/strands/add';
      await _dio.post<void>(endpoint, data: {
        'memory_id': memoryId,
        if (strandId != null) 'strand_id': strandId,
      });
      return !currentState;
    } catch (e) {
      debugPrint('Save error: $e');
      return currentState;
    }
  }

  /// Share memory (Branch/Kin only, never external per PRD 00).
  Future<void> shareMemory(String memoryId, {String? branchId, List<String>? kinIds}) async {
    try {
      await _dio.post<void>('/share', data: {
        'memory_id': memoryId,
        if (branchId != null) 'branch_id': branchId,
        if (kinIds != null) 'kin_ids': kinIds,
      });
    } catch (e) {
      debugPrint('Share error: $e');
      rethrow;
    }
  }

  /// Repost a memory to your Branch feed.
  Future<void> repost(String memoryId, {String? caption}) async {
    try {
      await _dio.post<void>('/repost', data: {
        'memory_id': memoryId,
        if (caption != null) 'caption': caption,
      });
    } catch (e) {
      debugPrint('Repost error: $e');
      rethrow;
    }
  }
}
