import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

part 'voiceprint_state.dart';

class VoiceprintCubit extends Cubit<VoiceprintState> {
  VoiceprintCubit() : super(VoiceprintInitial());

  Future<void> createVoiceprint(String audioPath) async {
    emit(VoiceprintProcessing());

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.kinnectai.com/v1/voiceprints'),
      );

      request.files.add(await http.MultipartFile.fromPath('audio', audioPath));
      request.headers['Authorization'] = 'Bearer YOUR_TOKEN_HERE';

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 201) {
        final data = json.decode(responseData.body);
        emit(VoiceprintCreated(
          voiceprintId: data['voiceprint_id'],
          cloneId: data['elevenlabs_clone_id'],
          embedding: List<double>.from(data['embedding']),
        ));
      } else {
        emit(VoiceprintError('Failed to create voiceprint: ${responseData.body}'));
      }
    } catch (e) {
      emit(VoiceprintError('Error creating voiceprint: $e'));
    }
  }

  Future<void> deleteVoiceprint(String voiceprintId) async {
    emit(VoiceprintProcessing());

    try {
      final response = await http.delete(
        Uri.parse('https://api.kinnectai.com/v1/voiceprints/$voiceprintId'),
        headers: {'Authorization': 'Bearer YOUR_TOKEN_HERE'},
      );

      if (response.statusCode == 200) {
        emit(VoiceprintDeleted());
      } else {
        emit(VoiceprintError('Failed to delete voiceprint'));
      }
    } catch (e) {
      emit(VoiceprintError('Error deleting voiceprint: $e'));
    }
  }
}
