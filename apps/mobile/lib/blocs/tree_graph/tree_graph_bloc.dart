import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/dtos/graph_response_dto.dart';
import '../../repositories/tree_graph_repository.dart';

sealed class TreeGraphEvent extends Equatable {
  const TreeGraphEvent();

  @override
  List<Object?> get props => [];
}

class LoadSubgraph extends TreeGraphEvent {
  const LoadSubgraph(this.rootId, {this.depthLimit = 4});

  final String rootId;
  final int depthLimit;

  @override
  List<Object?> get props => [rootId, depthLimit];
}

class ExpandNode extends TreeGraphEvent {
  const ExpandNode(this.nodeId);

  final String nodeId;

  @override
  List<Object?> get props => [nodeId];
}

class CenterOnNode extends TreeGraphEvent {
  const CenterOnNode(this.nodeId);

  final String nodeId;

  @override
  List<Object?> get props => [nodeId];
}

class FetchBranchMerge extends TreeGraphEvent {
  const FetchBranchMerge(this.branchId);

  final String branchId;

  @override
  List<Object?> get props => [branchId];
}

sealed class TreeGraphState extends Equatable {
  const TreeGraphState();

  @override
  List<Object?> get props => [];
}

class TreeGraphLoading extends TreeGraphState {}

class TreeGraphLoaded extends TreeGraphState {
  const TreeGraphLoaded({required this.graph, this.centerNodeId});

  final GraphResponseDTO graph;
  final String? centerNodeId;

  TreeGraphLoaded copyWith({GraphResponseDTO? graph, String? centerNodeId}) {
    return TreeGraphLoaded(
      graph: graph ?? this.graph,
      centerNodeId: centerNodeId ?? this.centerNodeId,
    );
  }

  @override
  List<Object?> get props => [graph, centerNodeId];
}

class TreeGraphError extends TreeGraphState {
  const TreeGraphError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class TreeGraphBloc extends Bloc<TreeGraphEvent, TreeGraphState> {
  TreeGraphBloc(this._repository) : super(TreeGraphLoading()) {
    on<LoadSubgraph>(_onLoadSubgraph);
    on<ExpandNode>(_onExpandNode);
    on<CenterOnNode>(_onCenterOnNode);
    on<FetchBranchMerge>(_onFetchBranchMerge);
  }

  final TreeGraphRepository _repository;

  Future<void> _onLoadSubgraph(
    LoadSubgraph event,
    Emitter<TreeGraphState> emit,
  ) async {
    emit(TreeGraphLoading());
    try {
      final graph = await _repository.loadSubgraph(
        event.rootId,
        depthLimit: event.depthLimit,
      );
      emit(TreeGraphLoaded(graph: graph));
    } catch (error) {
      emit(TreeGraphError(error.toString()));
    }
  }

  Future<void> _onExpandNode(
    ExpandNode event,
    Emitter<TreeGraphState> emit,
  ) async {
    final current = state;
    if (current is! TreeGraphLoaded) {
      return;
    }

    try {
      final expanded = await _repository.expandNode(event.nodeId);
      final mergedNodes = <GraphNodeDTO>{
        ...current.graph.nodes,
        ...expanded.nodes,
      }.toList();
      final mergedEdges = <GraphEdgeDTO>{
        ...current.graph.edges,
        ...expanded.edges,
      }.toList();

      emit(
        current.copyWith(
          graph: GraphResponseDTO(nodes: mergedNodes, edges: mergedEdges),
        ),
      );
    } catch (error) {
      emit(TreeGraphError(error.toString()));
    }
  }

  Future<void> _onCenterOnNode(
    CenterOnNode event,
    Emitter<TreeGraphState> emit,
  ) async {
    final current = state;
    if (current is! TreeGraphLoaded) {
      return;
    }

    emit(current.copyWith(centerNodeId: event.nodeId));
  }

  Future<void> _onFetchBranchMerge(
    FetchBranchMerge event,
    Emitter<TreeGraphState> emit,
  ) async {
    // Placeholder hook for branch merge evidence fetching.
    final current = state;
    if (current is TreeGraphLoaded) {
      emit(current);
    }
  }
}
