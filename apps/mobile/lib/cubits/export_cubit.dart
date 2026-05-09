import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/api_service.dart';

// ---------------------------------------------------------------------------
// States
// ---------------------------------------------------------------------------

sealed class ExportState extends Equatable {
  const ExportState();

  @override
  List<Object?> get props => [];
}

class ExportIdle extends ExportState {}

class ExportRequesting extends ExportState {}

class ExportPending extends ExportState {
  const ExportPending({required this.exportId, this.estimatedReadyAt});

  final String exportId;
  final DateTime? estimatedReadyAt;

  @override
  List<Object?> get props => [exportId, estimatedReadyAt];
}

class ExportReady extends ExportState {
  const ExportReady({required this.exportId, required this.downloadUrl});

  final String exportId;
  final String downloadUrl;

  @override
  List<Object?> get props => [exportId, downloadUrl];
}

class ExportError extends ExportState {
  const ExportError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// ---------------------------------------------------------------------------
// Cubit
// ---------------------------------------------------------------------------

/// Handles GDPR Article 20 data-portability exports.
class ExportCubit extends Cubit<ExportState> {
  ExportCubit({ApiService? api})
      : _api = api ?? ApiService(),
        super(ExportIdle());

  final ApiService _api;

  /// Request a new data export. The server will queue the job and return
  /// an export ID for polling.
  Future<void> requestExport() async {
    emit(ExportRequesting());
    try {
      final response = await _api.post(
        '/api/v1/users/me/export',
        {},
        requireAuth: true,
      );

      if (response.statusCode == 202 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        emit(ExportPending(
          exportId: (data['export_id'] ?? '').toString(),
          estimatedReadyAt: DateTime.tryParse(
            (data['estimated_ready_at'] ?? '').toString(),
          ),
        ));
      } else {
        emit(ExportError('Export request failed: ${response.body}'));
      }
    } catch (e) {
      emit(ExportError('Export request error: $e'));
    }
  }

  /// Poll the server for export status.
  Future<void> checkStatus(String exportId) async {
    try {
      final response = await _api.get('/api/v1/users/me/export/$exportId');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final status = data['status']?.toString().toLowerCase();

        if (status == 'ready' || status == 'complete') {
          emit(ExportReady(
            exportId: exportId,
            downloadUrl: (data['download_url'] ?? '').toString(),
          ));
        } else {
          emit(ExportPending(
            exportId: exportId,
            estimatedReadyAt: DateTime.tryParse(
              (data['estimated_ready_at'] ?? '').toString(),
            ),
          ));
        }
      } else {
        emit(ExportError('Status check failed: ${response.body}'));
      }
    } catch (e) {
      emit(ExportError('Status check error: $e'));
    }
  }
}
