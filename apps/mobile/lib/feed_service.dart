import 'dart:convert';

import 'models/memory.dart';
import 'services/api_service.dart';

/// Feed tab filter for The Line (cubit + legacy string filter for [LineBloc]).
enum LineTab {
  all,
  following,
  branch,
  echoes,
  kinnections,
}

/// Fetches the Line vertical feed from gateway.
class FeedService {
  final ApiService _api = ApiService();

  Future<Memory?> getMemoryById(String memoryId) async {
    final response = await _api.get('/memory/$memoryId', requireAuth: false);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load memory detail: ${response.body}');
    }

    final decoded = _decodeJson(response.body);
    final payload = (decoded['payload'] is Map<String, dynamic>)
        ? decoded['payload'] as Map<String, dynamic>
        : decoded;

    final mapped = _mapMemoryFromRaw(payload, payload);
    return mapped;
  }

  Future<List<Memory>> getLine(
    String userId, {
    LineTab tab = LineTab.all,
    String? tabFilter,
    String? cursor,
    int? limit,
  }) async {
    final filter = _resolveFilter(tab: tab, tabFilter: tabFilter);

    final query = <String, String>{
      if (limit != null) 'limit': '$limit',
      if (cursor != null && cursor.isNotEmpty) 'cursor': cursor,
      if (filter != null && filter.isNotEmpty) 'tab': filter,
    };

    final endpoint = query.isEmpty
        ? '/feed'
        : '/feed?${Uri(queryParameters: query).query}';

    final response = await _api.get(endpoint, requireAuth: false);
    if (response.statusCode != 200) {
      throw Exception('Failed to load line feed: ${response.body}');
    }

    final body = response.body;
    final decoded = body.isEmpty ? <String, dynamic>{} : _decodeJson(body);
    final rawItems = (decoded['items'] as List<dynamic>? ?? const []);

    final memories = <Memory>[];
    for (final raw in rawItems) {
      if (raw is! Map<String, dynamic>) {
        continue;
      }

      final payload = (raw['payload'] is Map<String, dynamic>)
          ? raw['payload'] as Map<String, dynamic>
          : raw;

      final mapped = _mapMemoryFromRaw(raw, payload);
      if (mapped != null) {
        memories.add(mapped);
      }
    }

    return memories;
  }

  Future<List<Memory>> refreshFeed(
    String userId, {
    LineTab tab = LineTab.all,
  }) {
    return getLine(userId, tab: tab);
  }

  Future<List<Memory>> loadNext(
    String userId,
    String cursor, {
    LineTab tab = LineTab.all,
  }) {
    return getLine(userId, tab: tab, cursor: cursor);
  }

  Future<void> pulseMemory(String memoryId) async {
    final response = await _api.post('/pulses', {
      'memory_id': memoryId,
    }, requireAuth: false);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to send pulse: ${response.body}');
    }
  }

  /// Bloc passes a string tab label; cubit uses [LineTab].
  String? _resolveFilter({required LineTab tab, String? tabFilter}) {
    if (tabFilter != null && tabFilter.isNotEmpty) {
      return tabFilter;
    }
    return tab.name;
  }

  Map<String, dynamic> _decodeJson(String body) {
    try {
      final decoded = body.isEmpty ? null : jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  String _str(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  String? _nullableStr(dynamic value) {
    final s = _str(value);
    return s.isEmpty ? null : s;
  }

  int _int(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(_str(value)) ?? fallback;
  }

  double _double(dynamic value, {double fallback = 0.0}) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(_str(value)) ?? fallback;
  }

  Memory? _mapMemoryFromRaw(
    Map<String, dynamic> raw,
    Map<String, dynamic> payload,
  ) {
    final id = _str(payload['memoryId'] ?? payload['id'] ?? raw['itemId']);
    if (id.isEmpty) {
      return null;
    }

    final createdAtStr = _str(
      payload['publishedAt'] ?? payload['createdAt'] ?? raw['insertedAt'],
    );
    DateTime createdAt;
    try {
      createdAt = DateTime.parse(createdAtStr);
    } catch (_) {
      createdAt = DateTime.now();
    }

    return Memory(
      id: id,
      creatorId: _str(payload['creatorId'] ?? payload['authorId'] ?? 'unknown'),
      creatorUsername: _str(
        payload['creatorUsername'] ?? payload['authorUsername'] ?? 'unknown',
      ),
      creatorDisplayName: _str(
        payload['creatorDisplayName'] ??
            payload['authorDisplayName'] ??
            'Unknown',
      ),
      creatorAvatarUrl: _nullableStr(
        payload['creatorAvatarUrl'] ?? payload['authorAvatarUrl'],
      ),
      videoUrl: _str(payload['videoUrl'] ?? payload['previewUrl'] ?? ''),
      thumbnailUrl: _nullableStr(payload['thumbnailUrl'] ?? payload['previewUrl']),
      caption: _str(payload['caption'] ?? payload['contentSnippet'] ?? ''),
      voiceprintId: _nullableStr(payload['voiceprintId']),
      voiceprintLabel: _nullableStr(payload['voiceprintLabel']),
      pulseCount: _int(payload['pulseCount']),
      commentCount: _int(payload['commentCount']),
      rewindCount: _int(payload['rewindCount']),
      saveCount: _int(payload['saveCount']),
      shareCount: _int(payload['shareCount']),
      branchId: _nullableStr(payload['branchId']),
      branchName: _nullableStr(payload['branchName']),
      kinScore: _double(payload['kinScore']),
      createdAt: createdAt,
      duration: Duration(seconds: _int(payload['durationSeconds'], fallback: 30)),
      isPulsed: (payload['isPulsed'] == true),
      isSaved: (payload['isSaved'] == true),
      metadata: payload,
    );
  }
}
