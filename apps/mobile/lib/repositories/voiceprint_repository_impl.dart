import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/dtos/voiceprint_creation_dto.dart';
import 'voiceprint_repository.dart';

class VoiceprintRepositoryImpl implements VoiceprintRepository {
  VoiceprintRepositoryImpl({required Dio dio, this.basePath = '/api/v1'}) : _dio = dio;

  final Dio _dio;
  final String basePath;

  @override
  Future<VoiceprintCreationDTO> createVoiceprint(String audioFilePath) async {
    final formData = FormData.fromMap({
      'audio': await MultipartFile.fromFile(audioFilePath),
    });
    final response = await _dio.post<Map<String, dynamic>>(
      '$basePath/voiceprints',
      data: formData,
    );
    return VoiceprintCreationDTO.fromJson(response.data ?? {});
  }

  @override
  Future<List<VoiceprintCreationDTO>> listVoiceprints() async {
    final response = await _dio.get<Map<String, dynamic>>('$basePath/voiceprints');
    final items = (response.data?['items'] as List?) ?? [];
    return items.whereType<Map<String, dynamic>>().map(VoiceprintCreationDTO.fromJson).toList();
  }

  @override
  Future<void> revokeVoiceprint(String voiceprintId) async {
    // Retry 3x (1s, 5s, 15s) per Addendum 3.0 S4
    for (int attempt = 0; attempt < 3; attempt++) {
      try {
        await _dio.delete<void>('$basePath/voiceprints/$voiceprintId/revoke');
        return;
      } catch (e) {
        debugPrint('Revoke attempt ${attempt + 1} failed: $e');
        if (attempt < 2) {
          await Future<void>.delayed(Duration(seconds: [1, 5, 15][attempt]));
        } else {
          rethrow;
        }
      }
    }
  }

  @override
  Future<void> deleteVoiceprint(String voiceprintId) async {
    await _dio.delete<void>('$basePath/voiceprints/$voiceprintId');
  }
}
