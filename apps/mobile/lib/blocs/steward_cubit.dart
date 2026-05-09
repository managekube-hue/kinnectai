import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/steward_service.dart';

sealed class StewardState extends Equatable {
  const StewardState();

  @override
  List<Object?> get props => [];
}

class StewardInitial extends StewardState {}

class StewardSubmitting extends StewardState {}

class StewardAccepted extends StewardState {}

class StewardDeclined extends StewardState {}

class StewardError extends StewardState {
  const StewardError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class StewardCubit extends Cubit<StewardState> {
  StewardCubit({StewardService? service})
      : _service = service ?? StewardService(),
        super(StewardInitial());

  final StewardService _service;

  Future<void> submit({
    required String userId,
    required bool accepted,
    required String ipAddress,
    required String userAgent,
  }) async {
    emit(StewardSubmitting());
    try {
      await _service.submitConsent(
        userId: userId,
        accepted: accepted,
        ipAddress: ipAddress,
        userAgent: userAgent,
        timestamp: DateTime.now().toUtc(),
      );
      emit(accepted ? StewardAccepted() : StewardDeclined());
    } catch (e) {
      emit(StewardError('Failed to submit steward consent: $e'));
    }
  }
}
