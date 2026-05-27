import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../models/dtos/voiceprint_creation_dto.dart';
import '../services/api_service.dart';

// ---------------------------------------------------------------------------
// States
// ---------------------------------------------------------------------------

sealed class VoiceprintState extends Equatable {
  const VoiceprintState();

  @override
  List<Object?> get props => [];
}

class VoiceprintInitial extends VoiceprintState {}

class VoiceprintProcessing extends VoiceprintState {}

class VoiceprintCreated extends VoiceprintState {
  const VoiceprintCreated({
    required this.voiceprintId,
    required this.cloneId,
    required this.embedding,
  });

  final String voiceprintId;
  final String cloneId;
  final List<double> embedding;

  @override
  List<Object?> get props => [voiceprintId, cloneId, embedding];
}

class VoiceprintDeleted extends VoiceprintState {}

class VoiceprintError extends VoiceprintState {
  const VoiceprintError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// ---------------------------------------------------------------------------
// Cubit
// ---------------------------------------------------------------------------

class VoiceprintCubit extends Cubit<VoiceprintState> {
  VoiceprintCubit({http.Client? httpClient})
      : _client = httpClient ?? http.Client(),
        super(VoiceprintInitial());

  final http.Client _client;
  final ApiService _apiService = ApiService();

  static const _baseUrl = '${ApiService.baseUrl}/api/v1/voiceprints';

  Future<void> createVoiceprint(String audioPath) async {
    emit(VoiceprintProcessing());

    try {
      final request = http.MultipartRequest('POST', Uri.parse(_baseUrl));
      request.files.add(await http.MultipartFile.fromPath('audio', audioPath));
      final token = _apiService.accessToken;
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      final streamed = await _client.send(request);
      final response = await http.Response.fromStream(streamed);

      if (streamed.statusCode == 201) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final dto = VoiceprintCreationDTO.fromJson(data);
        emit(VoiceprintCreated(
          voiceprintId: dto.voiceprintId,
          cloneId: dto.cloneId,
          embedding: dto.embedding,
        ));
      } else {
        emit(VoiceprintError('Failed to create voiceprint: ${response.body}'));
      }
    } catch (e) {
      emit(VoiceprintError('Error creating voiceprint: $e'));
    }
  }

  Future<void> deleteVoiceprint(String voiceprintId) async {
    emit(VoiceprintProcessing());

    try {
      final response = await _client.delete(
        Uri.parse('$_baseUrl/$voiceprintId'),
        headers: {
          if ((_apiService.accessToken ?? '').isNotEmpty)
            'Authorization': 'Bearer ${_apiService.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        emit(VoiceprintDeleted());
      } else {
        emit(const VoiceprintError('Failed to delete voiceprint'));
      }
    } catch (e) {
      emit(VoiceprintError('Error deleting voiceprint: $e'));
    }
  }

  @override
  Future<void> close() {
    _client.close();
    return super.close();
  }
}
