import '../models/dtos/voiceprint_creation_dto.dart';

abstract class VoiceprintRepository {
  Future<VoiceprintCreationDTO> createVoiceprint(String audioFilePath);
  Future<List<VoiceprintCreationDTO>> listVoiceprints();
  Future<void> revokeVoiceprint(String voiceprintId);
  Future<void> deleteVoiceprint(String voiceprintId);
}
