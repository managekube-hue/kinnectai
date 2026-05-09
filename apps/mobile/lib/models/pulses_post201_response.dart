import 'package:freezed_annotation/freezed_annotation.dart';

part 'pulses_post201_response.freezed.dart';
part 'pulses_post201_response.g.dart';

@freezed
abstract class PulsesPost201Response with _$PulsesPost201Response {
  const factory PulsesPost201Response({
    required String pulseId,
    required String memoryId,
    required int newPulseCount,
    required DateTime timestamp,
  }) = _PulsesPost201Response;

  factory PulsesPost201Response.fromJson(Map<String, dynamic> json) =>
      _$PulsesPost201ResponseFromJson(json);
}
