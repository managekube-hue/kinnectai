import '../models/dtos/discovery_candidate_dto.dart';
import '../models/dtos/paginated_response.dart';

abstract class DiscoveryRepository {
  Future<PaginatedResponse<DiscoveryCandidateDTO>> fetchCandidates({
    required String? cursor,
    String? filter,
    int limit = 10,
  });

  Future<void> dismissCandidate(String userId);

  Future<void> sendKinnectionRequest(String userId);
}
