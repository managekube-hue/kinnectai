import 'package:equatable/equatable.dart';

class GraphNodeDTO extends Equatable {
  const GraphNodeDTO({
    required this.id,
    required this.label,
    required this.nodeType,
  });

  final String id;
  final String label;
  final String nodeType;

  factory GraphNodeDTO.fromJson(Map<String, dynamic> json) {
    return GraphNodeDTO(
      id: (json['id'] ?? '').toString(),
      label: (json['label'] ?? '').toString(),
      nodeType: (json['node_type'] ?? '').toString(),
    );
  }

  @override
  List<Object?> get props => [id, label, nodeType];
}

class GraphEdgeDTO extends Equatable {
  const GraphEdgeDTO({
    required this.from,
    required this.to,
    required this.relationship,
    this.confidence,
  });

  final String from;
  final String to;
  final String relationship;
  final double? confidence;

  factory GraphEdgeDTO.fromJson(Map<String, dynamic> json) {
    return GraphEdgeDTO(
      from: (json['from'] ?? '').toString(),
      to: (json['to'] ?? '').toString(),
      relationship: (json['relationship'] ?? '').toString(),
      confidence: (json['confidence'] as num?)?.toDouble(),
    );
  }

  @override
  List<Object?> get props => [from, to, relationship, confidence];
}

class GraphResponseDTO extends Equatable {
  const GraphResponseDTO({
    required this.nodes,
    required this.edges,
  });

  final List<GraphNodeDTO> nodes;
  final List<GraphEdgeDTO> edges;

  factory GraphResponseDTO.fromJson(Map<String, dynamic> json) {
    final rawNodes = (json['nodes'] as List?) ?? const <dynamic>[];
    final rawEdges = (json['edges'] as List?) ?? const <dynamic>[];

    return GraphResponseDTO(
      nodes: rawNodes
          .whereType<Map<String, dynamic>>()
          .map(GraphNodeDTO.fromJson)
          .toList(),
      edges: rawEdges
          .whereType<Map<String, dynamic>>()
          .map(GraphEdgeDTO.fromJson)
          .toList(),
    );
  }

  @override
  List<Object?> get props => [nodes, edges];
}
