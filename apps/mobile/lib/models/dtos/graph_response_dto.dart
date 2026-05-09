import 'package:freezed_annotation/freezed_annotation.dart';

part 'graph_response_dto.freezed.dart';
part 'graph_response_dto.g.dart';

@freezed
abstract class GraphNodeDTO with _$GraphNodeDTO {
  const factory GraphNodeDTO({
    required String id,
    required String label,
    @JsonKey(name: 'node_type') required String nodeType,
  }) = _GraphNodeDTO;

  factory GraphNodeDTO.fromJson(Map<String, dynamic> json) =>
      _$GraphNodeDTOFromJson(json);
}

@freezed
abstract class GraphEdgeDTO with _$GraphEdgeDTO {
  const factory GraphEdgeDTO({
    required String from,
    required String to,
    required String relationship,
    double? confidence,
  }) = _GraphEdgeDTO;

  factory GraphEdgeDTO.fromJson(Map<String, dynamic> json) =>
      _$GraphEdgeDTOFromJson(json);
}

@freezed
abstract class GraphResponseDTO with _$GraphResponseDTO {
  const factory GraphResponseDTO({
    required List<GraphNodeDTO> nodes,
    required List<GraphEdgeDTO> edges,
  }) = _GraphResponseDTO;

  factory GraphResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$GraphResponseDTOFromJson(json);
}
