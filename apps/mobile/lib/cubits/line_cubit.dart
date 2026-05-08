import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/memory.dart';
import '../services/feed_service.dart';

/// State for The Line feed
sealed class LineState extends Equatable {
  const LineState();
  
  @override
  List<Object?> get props => [];
}

class LineInitial extends LineState {}

class LineLoading extends LineState {}

class LineLoaded extends LineState {
  final List<Memory> memories;
  final int currentIndex;
  final bool hasMore;
  final String? cursor;
  
  const LineLoaded({
    required this.memories,
    this.currentIndex = 0,
    this.hasMore = true,
    this.cursor,
  });
  
  @override
  List<Object?> get props => [memories, currentIndex, hasMore, cursor];
  
  LineLoaded copyWith({
    List<Memory>? memories,
    int? currentIndex,
    bool? hasMore,
    String? cursor,
  }) {
    return LineLoaded(
      memories: memories ?? this.memories,
      currentIndex: currentIndex ?? this.currentIndex,
      hasMore: hasMore ?? this.hasMore,
      cursor: cursor ?? this.cursor,
    );
  }
}

class LineError extends LineState {
  final String message;
  
  const LineError(this.message);
  
  @override
  List<Object?> get props => [message];
}

/// Cubit for managing The Line feed
class LineCubit extends Cubit<LineState> {
  final FeedService _feedService;
  String? _userId;
  LineTab _currentTab = LineTab.all;
  
  LineCubit(this._feedService) : super(LineInitial());
  
  /// Load initial feed
  Future<void> loadFeed(String userId, {LineTab tab = LineTab.all}) async {
    _userId = userId;
    _currentTab = tab;
    
    emit(LineLoading());
    
    try {
      final memories = await _feedService.getLine(userId, tab: tab);
      emit(LineLoaded(memories: memories, hasMore: memories.length >= 20));
    } catch (e) {
      emit(LineError('Failed to load feed: $e'));
    }
  }
  
  /// Refresh feed (pull-to-refresh)
  Future<void> refreshFeed() async {
    if (_userId == null) return;
    
    try {
      final memories = await _feedService.refreshFeed(_userId!, tab: _currentTab);
      emit(LineLoaded(memories: memories, hasMore: memories.length >= 20));
    } catch (e) {
      emit(LineError('Failed to refresh feed: $e'));
    }
  }
  
  /// Load next page when nearing end
  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! LineLoaded || !currentState.hasMore || _userId == null) {
      return;
    }
    
    try {
      final cursor = currentState.cursor ?? currentState.memories.last.id;
      final nextPage = await _feedService.loadNext(_userId!, cursor, tab: _currentTab);
      
      if (nextPage.isEmpty) {
        emit(currentState.copyWith(hasMore: false));
        return;
      }
      
      final updatedMemories = [...currentState.memories, ...nextPage];
      emit(currentState.copyWith(
        memories: updatedMemories,
        cursor: nextPage.last.id,
        hasMore: nextPage.length >= 20,
      ));
    } catch (e) {
      // Keep current state on error
      emit(currentState.copyWith(hasMore: false));
    }
  }
  
  /// Update current video index
  void setCurrentIndex(int index) {
    final currentState = state;
    if (currentState is LineLoaded) {
      emit(currentState.copyWith(currentIndex: index));
      
      // Preload next page when approaching end
      if (index >= currentState.memories.length - 3) {
        loadMore();
      }
    }
  }
  
  /// Update memory after interaction (pulse, save, etc.)
  void updateMemory(Memory updatedMemory) {
    final currentState = state;
    if (currentState is LineLoaded) {
      final updatedMemories = currentState.memories.map((m) {
        return m.id == updatedMemory.id ? updatedMemory : m;
      }).toList();
      
      emit(currentState.copyWith(memories: updatedMemories));
    }
  }
  
  /// Switch feed tab
  Future<void> switchTab(LineTab tab) async {
    if (_userId == null || tab == _currentTab) return;
    
    _currentTab = tab;
    await loadFeed(_userId!, tab: tab);
  }
}
