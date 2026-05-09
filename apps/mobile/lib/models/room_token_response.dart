import 'package:freezed_annotation/freezed_annotation.dart';

import 'room_token_response_ice_servers_inner.dart';

part 'room_token_response.freezed.dart';
part 'room_token_response.g.dart';

@freezed
abstract class RoomTokenResponse with _$RoomTokenResponse {
  const factory RoomTokenResponse({
    required String roomId,
    required String sfuToken,
    required List<RoomTokenResponseIceServersInner> iceServers,
  }) = _RoomTokenResponse;

  factory RoomTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RoomTokenResponseFromJson(json);
}
