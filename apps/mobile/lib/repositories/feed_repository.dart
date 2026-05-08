import '../models/dtos/discovery_candidate_dto.dart';
import '../models/dtos/memory_dto.dart';
import '../models/dtos/paginated_response.dart';

abstract class FeedRepository {
  Future<PaginatedResponse<MemoryDTO>> fetchLine({
    required String? cursor,
    required String tab,
    int limit,
  });

  Future<PaginatedResponse<DiscoveryCandidateDTO>> fetchDiscoveryCandidates({
    required String? cursor,
    Map<String, dynamic>? filters,
    int limit,
  });

  Future<void> pulseMemory(String memoryId);
}
