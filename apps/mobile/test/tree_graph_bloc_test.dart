import 'package:bloc_test/bloc_test.dart';
import 'package:kinnectai_app/blocs/tree_graph/tree_graph_bloc.dart';
import 'package:kinnectai_app/models/dtos/graph_response_dto.dart';
import 'package:kinnectai_app/repositories/tree_graph_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockTreeGraphRepository extends Mock implements TreeGraphRepository {}

void main() {
  late TreeGraphRepository repository;

  final graph = GraphResponseDTO(
    nodes: const [GraphNodeDTO(id: 'n1', label: 'Root', nodeType: 'user')],
    edges: const [],
  );

  setUp(() {
    repository = _MockTreeGraphRepository();
  });

  blocTest<TreeGraphBloc, TreeGraphState>(
    'load subgraph emits loading then loaded',
    build: () {
      when(() => repository.loadSubgraph(any(), depthLimit: any(named: 'depthLimit')))
          .thenAnswer((_) async => graph);
      return TreeGraphBloc(repository);
    },
    act: (bloc) => bloc.add(const LoadSubgraph('root_1')),
    expect: () => [
      isA<TreeGraphLoading>(),
      isA<TreeGraphLoaded>(),
    ],
  );

  blocTest<TreeGraphBloc, TreeGraphState>(
    'center node updates loaded state',
    build: () => TreeGraphBloc(repository),
    seed: () => TreeGraphLoaded(graph: graph),
    act: (bloc) => bloc.add(const CenterOnNode('n1')),
    expect: () => [
      isA<TreeGraphLoaded>().having((s) => s.centerNodeId, 'centerNodeId', 'n1'),
    ],
  );
}
