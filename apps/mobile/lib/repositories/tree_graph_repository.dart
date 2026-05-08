import '../models/dtos/graph_response_dto.dart';

abstract class TreeGraphRepository {
  Future<GraphResponseDTO> loadSubgraph(String rootId, {int depthLimit = 4});
  Future<GraphResponseDTO> expandNode(String nodeId);
}
