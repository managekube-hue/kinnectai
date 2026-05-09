import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/api_service.dart';
import 'dart:convert';

// ---------------------------------------------------------------------------
// States
// ---------------------------------------------------------------------------

enum DnaKitStatus { ordered, shipped, delivered, registered, processing, complete }

sealed class DnaKitState extends Equatable {
  const DnaKitState();

  @override
  List<Object?> get props => [];
}

class DnaKitIdle extends DnaKitState {}

class DnaKitLoading extends DnaKitState {}

class DnaKitTracking extends DnaKitState {
  const DnaKitTracking({
    required this.kitId,
    required this.status,
    this.trackingNumber,
    this.estimatedArrival,
  });

  final String kitId;
  final DnaKitStatus status;
  final String? trackingNumber;
  final DateTime? estimatedArrival;

  @override
  List<Object?> get props => [kitId, status, trackingNumber, estimatedArrival];
}

class DnaKitResultsReady extends DnaKitState {
  const DnaKitResultsReady({
    required this.kitId,
    required this.haplogroup,
    required this.ethnicitySummary,
  });

  final String kitId;
  final String haplogroup;
  final Map<String, double> ethnicitySummary;

  @override
  List<Object?> get props => [kitId, haplogroup, ethnicitySummary];
}

class DnaKitError extends DnaKitState {
  const DnaKitError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// ---------------------------------------------------------------------------
// Cubit
// ---------------------------------------------------------------------------

class DnaKitCubit extends Cubit<DnaKitState> {
  DnaKitCubit({ApiService? api})
      : _api = api ?? ApiService(),
        super(DnaKitIdle());

  final ApiService _api;

  Future<void> orderKit() async {
    emit(DnaKitLoading());
    try {
      final response = await _api.post('/api/v1/dna/order', {}, requireAuth: true);
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        emit(DnaKitTracking(
          kitId: data['kit_id'] as String,
          status: DnaKitStatus.ordered,
          trackingNumber: data['tracking_number'] as String?,
        ));
      } else {
        emit(DnaKitError('Order failed: ${response.body}'));
      }
    } catch (e) {
      emit(DnaKitError('Order error: $e'));
    }
  }

  Future<void> refreshStatus(String kitId) async {
    emit(DnaKitLoading());
    try {
      final response = await _api.get('/api/v1/dna/kits/$kitId');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final rawStatus = data['status']?.toString().toLowerCase() ?? '';

        if (rawStatus == 'complete') {
          emit(DnaKitResultsReady(
            kitId: kitId,
            haplogroup: (data['haplogroup'] ?? '').toString(),
            ethnicitySummary: (data['ethnicity'] as Map<String, dynamic>?)
                {},
          ));
        } else {
          emit(DnaKitTracking(
            kitId: kitId,
            status: _parseStatus(rawStatus),
            trackingNumber: data['tracking_number'] as String?,
            estimatedArrival: DateTime.tryParse(
              (data['estimated_arrival'] ?? '').toString(),
            ),
          ));
        }
      } else {
        emit(DnaKitError('Status check failed: ${response.body}'));
      }
    } catch (e) {
      emit(DnaKitError('Status error: $e'));
    }
  }

  Future<void> registerKit(String kitId, String barcode) async {
    emit(DnaKitLoading());
    try {
      final response = await _api.post(
        '/api/v1/dna/kits/$kitId/register',
        {'barcode': barcode},
        requireAuth: true,
      );
      if (response.statusCode == 200) {
        emit(DnaKitTracking(kitId: kitId, status: DnaKitStatus.registered));
      } else {
        emit(DnaKitError('Registration failed: ${response.body}'));
      }
    } catch (e) {
      emit(DnaKitError('Registration error: $e'));
    }
  }

  static DnaKitStatus _parseStatus(String raw) {
    switch (raw) {
      case 'ordered':
        return DnaKitStatus.ordered;
      case 'shipped':
        return DnaKitStatus.shipped;
      case 'delivered':
        return DnaKitStatus.delivered;
      case 'registered':
        return DnaKitStatus.registered;
      case 'processing':
        return DnaKitStatus.processing;
      case 'complete':
        return DnaKitStatus.complete;
      default:
        return DnaKitStatus.ordered;
    }
  }
}
