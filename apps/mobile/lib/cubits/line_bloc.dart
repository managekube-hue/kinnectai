import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/memory.dart';
import '../services/feed_service.dart';

// Events
abstract class LineEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LineFetchRequested extends LineEvent {
  final String userId;
  LineFetchRequested(this.userId);
  @override
  List<Object?> get props => [userId];
}

class LineRefreshRequested extends LineEvent {}

class LineLoadMore extends LineEvent {}

class LineTabChanged extends LineEvent {
  final String tab;
  LineTabChanged(this.tab);
  @override
  List<Object?> get props => [tab];
}

class LinePulseTriggered extends LineEvent {
  final String memoryId;
  LinePulseTriggered(this.memoryId);
  @override
  List<Object?> get props => [memoryId];
}

// States
abstract class LineState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LineInitial extends LineState {}

class LineLoading extends LineState {}

class LineLoaded extends LineState {
  final List<Memory> memories;
  final bool hasMore;
  final String? cursor;

  LineLoaded({
    required this.memories,
    this.hasMore = false,
    this.cursor,
  });

  @override
  List<Object?> get props => [memories, hasMore, cursor];

  LineLoaded copyWith({
    List<Memory>? memories,
    bool? hasMore,
    String? cursor,
  }) {
    return LineLoaded(
      memories: memories ?? this.memories,
      hasMore: hasMore ?? this.hasMore,
      cursor: cursor ?? this.cursor,
    );
  }
}

class LineEmpty extends LineState {}

class LineError extends LineState {
  final String message;
  LineError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class LineBloc extends Bloc<LineEvent, LineState> {
  final FeedService _feedService;
  String? _currentTab;

  LineBloc(this._feedService) : super(LineInitial()) {
    on<LineFetchRequested>(_onFetchRequested);
    on<LineRefreshRequested>(_onRefreshRequested);
    on<LineLoadMore>(_onLoadMore);
    on<LineTabChanged>(_onTabChanged);
    on<LinePulseTriggered>(_onPulseTriggered);
  }

  Future<void> _onFetchRequested(
    LineFetchRequested event,
    Emitter<LineState> emit,
  ) async {
    emit(LineLoading());
    try {
      final memories = await _feedService.getLine(
        event.userId,
        tabFilter: _currentTab,
      );
      
      if (memories.isEmpty) {
        emit(LineEmpty());
      } else {
        emit(LineLoaded(
          memories: memories,
          hasMore: memories.length >= 20,
        ));
      }
    } catch (e) {
      emit(LineError(e.toString()));
    }
  }

  Future<void> _onRefreshRequested(
    LineRefreshRequested event,
    Emitter<LineState> emit,
  ) async {
    if (state is! LineLoaded) return;
    
    try {
      final memories = await _feedService.getLine(
        'current_user_id',
        tabFilter: _currentTab,
      );
      
      emit(LineLoaded(
        memories: memories,
        hasMore: memories.length >= 20,
      ));
    } catch (e) {
      // Keep current state on refresh error
    }
  }

  Future<void> _onLoadMore(
    LineLoadMore event,
    Emitter<LineState> emit,
  ) async {
    if (state is! LineLoaded) return;
    
    final currentState = state as LineLoaded;
    if (!currentState.hasMore) return;

    try {
      final newMemories = await _feedService.getLine(
        'current_user_id',
        cursor: currentState.cursor,
        tabFilter: _currentTab,
      );
      
      emit(currentState.copyWith(
        memories: [...currentState.memories, ...newMemories],
        hasMore: newMemories.length >= 20,
      ));
    } catch (e) {
      // Keep current state on load more error
    }
  }

  Future<void> _onTabChanged(
    LineTabChanged event,
    Emitter<LineState> emit,
  ) async {
    _currentTab = event.tab;
    add(LineFetchRequested('current_user_id'));
  }

  Future<void> _onPulseTriggered(
    LinePulseTriggered event,
    Emitter<LineState> emit,
  ) async {
    if (state is! LineLoaded) return;
    
    final currentState = state as LineLoaded;
    final updatedMemories = currentState.memories.map((memory) {
      if (memory.id == event.memoryId) {
        return memory.copyWith(
          isPulsed: !memory.isPulsed,
          pulseCount: memory.isPulsed 
              ? memory.pulseCount - 1 
              : memory.pulseCount + 1,
        );
      }
      return memory;
    }).toList();
    
    emit(currentState.copyWith(memories: updatedMemories));
  }
}
