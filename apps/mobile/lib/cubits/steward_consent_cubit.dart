import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/dtos/seal_confirmation_dto.dart';
import '../repositories/memory_box_repository.dart';

// ---------------------------------------------------------------------------
// States
// ---------------------------------------------------------------------------

sealed class StewardConsentState extends Equatable {
  const StewardConsentState();

  @override
  List<Object?> get props => [];
}

class StewardConsentIdle extends StewardConsentState {}

class StewardConsentLoading extends StewardConsentState {}

/// The steward has reviewed and approved the legal consent flow.
class StewardConsentGranted extends StewardConsentState {
  const StewardConsentGranted({
    required this.memoryId,
    required this.recipientId,
    required this.triggerType,
    required this.consentTimestamp,
  });

  final String memoryId;
  final String recipientId;
  final String triggerType;
  final DateTime consentTimestamp;

  @override
  List<Object?> get props => [memoryId, recipientId, triggerType, consentTimestamp];
}

/// Memory has been sealed after consent.
class StewardConsentSealed extends StewardConsentState {
  const StewardConsentSealed(this.confirmation);

  final SealConfirmationDTO confirmation;

  @override
  List<Object?> get props => [confirmation];
}

class StewardConsentRevoked extends StewardConsentState {}

class StewardConsentError extends StewardConsentState {
  const StewardConsentError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// ---------------------------------------------------------------------------
// Cubit
// ---------------------------------------------------------------------------

class StewardConsentCubit extends Cubit<StewardConsentState> {
  StewardConsentCubit(this._repository) : super(StewardConsentIdle());

  final MemoryBoxRepository _repository;

  /// Record that the steward/creator has given legal consent for sealing.
  void grantConsent({
    required String memoryId,
    required String recipientId,
    required String triggerType,
  }) {
    emit(StewardConsentGranted(
      memoryId: memoryId,
      recipientId: recipientId,
      triggerType: triggerType,
      consentTimestamp: DateTime.now(),
    ));
  }

  /// Seal the memory after consent has been granted.
  Future<void> sealAfterConsent(String memoryId) async {
    final current = state;
    if (current is! StewardConsentGranted) {
      emit(const StewardConsentError('Consent must be granted before sealing'));
      return;
    }

    emit(StewardConsentLoading());
    try {
      await _repository.sealMemory(memoryId);
      // The repository currently returns void; build a local confirmation.
      final confirmation = SealConfirmationDTO(
        memoryId: memoryId,
        sealedAt: DateTime.now(),
        triggerType: current.triggerType,
        recipientId: current.recipientId,
      );
      emit(StewardConsentSealed(confirmation));
    } catch (e) {
      emit(StewardConsentError('Seal failed: $e'));
    }
  }

  /// Revoke a previously set trigger (before delivery).
  Future<void> revokeTrigger(String memoryId) async {
    emit(StewardConsentLoading());
    try {
      await _repository.revokeTrigger(memoryId);
      emit(StewardConsentRevoked());
    } catch (e) {
      emit(StewardConsentError('Revoke failed: $e'));
    }
  }
}
