part of 'voiceprint_cubit.dart';

abstract class VoiceprintState extends Equatable {
  const VoiceprintState();

  @override
  List<Object?> get props => [];
}

class VoiceprintInitial extends VoiceprintState {}

class VoiceprintProcessing extends VoiceprintState {}

class VoiceprintCreated extends VoiceprintState {
  final String voiceprintId;
  final String cloneId;
  final List<double> embedding;

  const VoiceprintCreated({
    required this.voiceprintId,
    required this.cloneId,
    required this.embedding,
  });

  @override
  List<Object?> get props => [voiceprintId, cloneId, embedding];
}

class VoiceprintDeleted extends VoiceprintState {}

class VoiceprintError extends VoiceprintState {
  final String message;

  const VoiceprintError(this.message);

  @override
  List<Object?> get props => [message];
}
