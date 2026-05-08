import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/dtos/memory_box_item_dto.dart';
import '../repositories/memory_box_repository.dart';

sealed class MemoryBoxState extends Equatable {
  const MemoryBoxState();

  @override
  List<Object?> get props => [];
}

class MemoryBoxLoading extends MemoryBoxState {}

class MemoryBoxLoaded extends MemoryBoxState {
  const MemoryBoxLoaded({
    required this.items,
    required this.storageUsed,
  });

  final List<MemoryBoxItemDTO> items;
  final double storageUsed;

  @override
  List<Object?> get props => [items, storageUsed];
}

class MemoryBoxSealing extends MemoryBoxState {}

class MemoryBoxSuccess extends MemoryBoxState {}

class MemoryBoxError extends MemoryBoxState {
  const MemoryBoxError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class MemoryBoxCubit extends Cubit<MemoryBoxState> {
  MemoryBoxCubit(this._repository) : super(MemoryBoxLoading());

  final MemoryBoxRepository _repository;

  Future<void> loadVault() async {
    emit(MemoryBoxLoading());
    try {
      final items = await _repository.fetchVault();
      emit(MemoryBoxLoaded(
        items: items,
        storageUsed: _calculateStorageUsed(items),
      ));
    } catch (error) {
      emit(MemoryBoxError(error.toString()));
    }
  }

  Future<void> sealMemory(String memoryId) async {
    emit(MemoryBoxSealing());
    try {
      await _repository.sealMemory(memoryId);
      emit(MemoryBoxSuccess());
      await loadVault();
    } catch (error) {
      emit(MemoryBoxError(error.toString()));
    }
  }

  Future<void> revokeTrigger(String memoryId) async {
    emit(MemoryBoxLoading());
    try {
      await _repository.revokeTrigger(memoryId);
      emit(MemoryBoxSuccess());
      await loadVault();
    } catch (error) {
      emit(MemoryBoxError(error.toString()));
    }
  }

  Future<void> exportData() async {
    emit(MemoryBoxLoading());
    try {
      await _repository.requestExport();
      emit(MemoryBoxSuccess());
    } catch (error) {
      emit(MemoryBoxError(error.toString()));
    }
  }

  double _calculateStorageUsed(List<MemoryBoxItemDTO> items) {
    if (items.isEmpty) {
      return 0.0;
    }

    final sealedCount = items.where((item) => item.status != MemoryBoxStatus.draft).length;
    return (sealedCount / items.length).clamp(0.0, 1.0);
  }
}
