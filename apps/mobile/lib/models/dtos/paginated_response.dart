class PaginatedResponse<T> {
  const PaginatedResponse({
    required this.items,
    required this.nextCursor,
    required this.hasMore,
    this.kinScoreContext,
  });

  final List<T> items;
  final String? nextCursor;
  final bool hasMore;
  final double? kinScoreContext;

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemFromJson,
  ) {
    final rawItems = (json['items'] as List?) ?? const <dynamic>[];
    return PaginatedResponse<T>(
      items: rawItems
          .whereType<Map<String, dynamic>>()
          .map(itemFromJson)
          .toList(),
      nextCursor: json['next_cursor']?.toString(),
      hasMore: json['has_more'] as bool? ?? false,
      kinScoreContext: (json['kin_score_context'] as num?)?.toDouble(),
    );
  }
}
