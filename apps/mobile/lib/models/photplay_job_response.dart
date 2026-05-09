import 'package:freezed_annotation/freezed_annotation.dart';

part 'photplay_job_response.freezed.dart';
part 'photplay_job_response.g.dart';

@freezed
abstract class PhotplayJobResponse with _$PhotplayJobResponse {
	const factory PhotplayJobResponse({
		required String jobId,
		required String status,
		required DateTime estimatedCompletion,
	}) = _PhotplayJobResponse;

	factory PhotplayJobResponse.fromJson(Map<String, dynamic> json) =>
			_$PhotplayJobResponseFromJson(json);
}