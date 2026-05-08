import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/dtos/discovery_candidate_dto.dart';
import '../../repositories/feed_repository.dart';

sealed class DiscoveryEvent extends Equatable {
  const DiscoveryEvent();

  @override
  List<Object?> get props => [];
}

class FetchCandidates extends DiscoveryEvent {
  const FetchCandidates({this.filters, this.loadMore = false});

  final Map<String, dynamic>? filters;
  final bool loadMore;

  @override
  List<Object?> get props => [filters, loadMore];
}

class ApplyFilter extends DiscoveryEvent {
  const ApplyFilter(this.filters);

  final Map<String, dynamic> filters;

  @override
  List<Object?> get props => [filters];
}

class DismissCandidate extends DiscoveryEvent {
  const DismissCandidate(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class KinnectRequest extends DiscoveryEvent {
  const KinnectRequest(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}

sealed class DiscoveryState extends Equatable {
  const DiscoveryState();

  @override
  List<Object?> get props => [];
}

class DiscoveryInitial extends DiscoveryState {}

class DiscoveryLoading extends DiscoveryState {}

class DiscoveryLoaded extends DiscoveryState {
  const DiscoveryLoaded({
    required this.candidates,
    required this.hasMore,
    this.nextCursor,
    this.filters = const <String, dynamic>{},
  });

  final List<DiscoveryCandidateDTO> candidates;
  final bool hasMore;
  final String? nextCursor;
  final Map<String, dynamic> filters;

  DiscoveryLoaded copyWith({
    List<DiscoveryCandidateDTO>? candidates,
    bool? hasMore,
    String? nextCursor,
    Map<String, dynamic>? filters,
  }) {
    return DiscoveryLoaded(
      candidates: candidates ?? this.candidates,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: nextCursor ?? this.nextCursor,
      filters: filters ?? this.filters,
    );
  }

  @override
  List<Object?> get props => [candidates, hasMore, nextCursor, filters];
}

class DiscoveryEmpty extends DiscoveryState {}

class DiscoveryError extends DiscoveryState {
  const DiscoveryError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class DiscoveryBloc extends Bloc<DiscoveryEvent, DiscoveryState> {
  DiscoveryBloc(this._feedRepository) : super(DiscoveryInitial()) {
    on<FetchCandidates>(_onFetchCandidates);
    on<ApplyFilter>(_onApplyFilter);
    on<DismissCandidate>(_onDismissCandidate);
    on<KinnectRequest>(_onKinnectRequest);
  }

  final FeedRepository _feedRepository;

  Future<void> _onFetchCandidates(
    FetchCandidates event,
    Emitter<DiscoveryState> emit,
  ) async {
    final current = state;
    final isLoadMore = event.loadMore && current is DiscoveryLoaded;

    if (!isLoadMore) {
      emit(DiscoveryLoading());
    }

    try {
      final filters =
          event.filters ??
          (current is DiscoveryLoaded
              ? current.filters
              : const <String, dynamic>{});
      final cursor = isLoadMore ? current.nextCursor : null;
      final response = await _feedRepository.fetchDiscoveryCandidates(
        cursor: cursor,
        filters: filters,
      );

      final merged = isLoadMore
          ? [...current.candidates, ...response.items]
          : response.items;

      if (merged.isEmpty) {
        emit(DiscoveryEmpty());
        return;
      }

      emit(
        DiscoveryLoaded(
          candidates: merged,
          hasMore: response.hasMore,
          nextCursor: response.nextCursor,
          filters: filters,
        ),
      );
    } catch (error) {
      emit(DiscoveryError(error.toString()));
    }
  }

  Future<void> _onApplyFilter(
    ApplyFilter event,
    Emitter<DiscoveryState> emit,
  ) async {
    add(FetchCandidates(filters: event.filters));
  }

  Future<void> _onDismissCandidate(
    DismissCandidate event,
    Emitter<DiscoveryState> emit,
  ) async {
    final current = state;
    if (current is! DiscoveryLoaded) {
      return;
    }

    final updated = current.candidates
        .where((candidate) => candidate.userId != event.userId)
        .toList();

    if (updated.isEmpty) {
      emit(DiscoveryEmpty());
      return;
    }

    emit(current.copyWith(candidates: updated));
  }

  Future<void> _onKinnectRequest(
    KinnectRequest event,
    Emitter<DiscoveryState> emit,
  ) async {
    final current = state;
    if (current is! DiscoveryLoaded) {
      return;
    }

    final updated = current.candidates
        .where((candidate) => candidate.userId != event.userId)
        .toList();

    emit(current.copyWith(candidates: updated));
  }
}
