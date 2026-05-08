import 'models/memory.dart';

/// Feed tab filter for The Line (cubit + legacy string filter for [LineBloc]).
enum LineTab {
  all,
  following,
  branch,
}

/// Fetches the Line vertical feed. Stub returns sample data until the backend is wired.
class FeedService {
  Future<List<Memory>> getLine(
    String userId, {
    LineTab tab = LineTab.all,
    String? tabFilter,
    String? cursor,
    int? limit,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final filter = _resolveFilter(tab: tab, tabFilter: tabFilter);
    if (cursor != null && cursor.isNotEmpty) {
      return const [];
    }
    var items = _stubMemories(filter);
    if (limit != null && limit > 0 && items.length > limit) {
      items = items.take(limit).toList();
    }
    return items;
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

  /// Bloc passes a string tab label; cubit uses [LineTab].
  String? _resolveFilter({required LineTab tab, String? tabFilter}) {
    if (tabFilter != null && tabFilter.isNotEmpty) {
      return tabFilter;
    }
    return tab.name;
  }

  List<Memory> _stubMemories(String? filter) {
    return [
      Memory(
        id: '1',
        creatorId: 'elara_vance_id',
        creatorUsername: 'elara_vance',
        creatorDisplayName: 'Elara Vance (${filter ?? LineTab.all.name})',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        thumbnailUrl: null,
        caption: 'Sharing a moment with Kin.',
        voiceprintLabel: 'Original Voiceprint · Elara Vance',
        pulseCount: 1200,
        commentCount: 84,
        kinScore: 0.92,
        branchId: 'vance_branch',
        branchName: 'Vance Family',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        duration: const Duration(seconds: 45),
      ),
      Memory(
        id: '2',
        creatorId: 'marcus_chen_id',
        creatorUsername: 'marcus_chen',
        creatorDisplayName: 'Marcus Chen',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        thumbnailUrl: null,
        caption: 'Sample Kin memory.',
        pulseCount: 856,
        commentCount: 42,
        kinScore: 0.78,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        duration: const Duration(seconds: 32),
      ),
    ];
  }
}
