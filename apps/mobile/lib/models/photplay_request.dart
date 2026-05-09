import 'package:freezed_annotation/freezed_annotation.dart';

part 'photplay_request.freezed.dart';
part 'photplay_request.g.dart';

@freezed
abstract class PhotplayRequest with _$PhotplayRequest {
	const factory PhotplayRequest({
		required String photoS3Key,
		String? audioS3Key,
		String? voiceprintId,
		required String qualityTier,
		@Default(true) bool c2paRequired,
	}) = _PhotplayRequest;

	factory PhotplayRequest.fromJson(Map<String, dynamic> json) =>
			_$PhotplayRequestFromJson(json);
}