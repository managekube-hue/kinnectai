import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/dtos/voiceprint_creation_dto.dart';

/// Voiceprint service for ElevenLabs integration (PRD Section 02.9 + Addendum 3.0 S4).
///
/// Captures 256-dim voice embedding. Requires explicit biometric consent.
/// Revocation: DELETE /v1/voiceprints/{id} -> ElevenLabs DELETE /v1/voices/{voice_id}.
class VoiceprintService {
  VoiceprintService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: 'http://localhost:8080/api/v1'));

  final Dio _dio;

  /// Upload audio and create voiceprint.
  /// Returns VoiceprintCreationDTO with voiceprintId, cloneId, embedding.
  Future<VoiceprintCreationDTO> createVoiceprint(String audioFilePath) async {
    final formData = FormData.fromMap({
      'audio': await MultipartFile.fromFile(audioFilePath),
    });

    final response = await _dio.post<Map<String, dynamic>>(
      '/voiceprints',
      data: formData,
    );

    return VoiceprintCreationDTO.fromJson(response.data ?? {});
  }

  /// Get user's existing voiceprints.
  Future<List<VoiceprintCreationDTO>> listVoiceprints() async {
    final response = await _dio.get<Map<String, dynamic>>('/voiceprints');
    final items = (response.data?['items'] as List?) ?? [];
    return items
        .whereType<Map<String, dynamic>>()
        .map(VoiceprintCreationDTO.fromJson)
        .toList();
  }

  /// Revoke and delete a voiceprint.
  /// Triggers backend DELETE /v1/voices/{voice_id} on ElevenLabs.
  /// Retry 3x (1s, 5s, 15s) per Addendum 3.0 S4.
  Future<void> revokeVoiceprint(String voiceprintId) async {
    for (int attempt = 0; attempt < 3; attempt++) {
      try {
        await _dio.delete<void>('/voiceprints/$voiceprintId/revoke');
        return;
      } catch (e) {
        debugPrint('Revoke attempt ${attempt + 1} failed: $e');
        if (attempt < 2) {
          await Future<void>.delayed(Duration(seconds: [1, 5, 15][attempt]));
        } else {
          // Escalate to manual ticket after 3 failures
          debugPrint('Revocation failed after 3 attempts. Escalating to support.');
          rethrow;
        }
      }
    }
  }

  /// Delete voiceprint permanently (GDPR Art. 9 / BIPA).
  Future<void> deleteVoiceprint(String voiceprintId) async {
    await _dio.delete<void>('/voiceprints/$voiceprintId');
  }
}
