import 'package:bloc_test/bloc_test.dart';
import 'package:kinnectai_app/blocs/discovery/discovery_bloc.dart';
import 'package:kinnectai_app/models/dtos/discovery_candidate_dto.dart';
import 'package:kinnectai_app/models/dtos/paginated_response.dart';
import 'package:kinnectai_app/repositories/feed_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockFeedRepository extends Mock implements FeedRepository {}

void main() {
  late FeedRepository repository;

  final candidate = DiscoveryCandidateDTO(
    userId: 'u1',
    displayName: 'Candidate One',
    connectionScore: 82,
    relationshipGuess: '2nd Cousin',
    primarySignal: 'DNA Match',
  );

  setUp(() {
    repository = _MockFeedRepository();
  });

  blocTest<DiscoveryBloc, DiscoveryState>(
    'emits loading then loaded on successful fetch',
    build: () {
      when(
        () => repository.fetchDiscoveryCandidates(
          cursor: any(named: 'cursor'),
          filters: any(named: 'filters'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer(
        (_) async => PaginatedResponse<DiscoveryCandidateDTO>(
          items: [candidate],
          nextCursor: 'c1',
          hasMore: true,
        ),
      );
      return DiscoveryBloc(repository);
    },
    act: (bloc) => bloc.add(const FetchCandidates()),
    expect: () => [isA<DiscoveryLoading>(), isA<DiscoveryLoaded>()],
  );

  blocTest<DiscoveryBloc, DiscoveryState>(
    'dismiss candidate removes item from loaded state',
    build: () => DiscoveryBloc(repository),
    seed: () => DiscoveryLoaded(candidates: [candidate], hasMore: false),
    act: (bloc) => bloc.add(const DismissCandidate('u1')),
    expect: () => [isA<DiscoveryEmpty>()],
  );
}
