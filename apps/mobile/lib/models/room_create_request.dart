import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_create_request.freezed.dart';
part 'room_create_request.g.dart';

@freezed
abstract class RoomCreateRequest with _$RoomCreateRequest {
  const factory RoomCreateRequest({
    required String name,
    required String privacy,
    List<String>? inviteeIds,
  }) = _RoomCreateRequest;

  factory RoomCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$RoomCreateRequestFromJson(json);
}
