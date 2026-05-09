import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_token_response_ice_servers_inner.freezed.dart';
part 'room_token_response_ice_servers_inner.g.dart';

@freezed
abstract class RoomTokenResponseIceServersInner with _$RoomTokenResponseIceServersInner {
  const factory RoomTokenResponseIceServersInner({
    required List<String> urls,
    String? username,
    String? credential,
    String? credentialType,
  }) = _RoomTokenResponseIceServersInner;

  factory RoomTokenResponseIceServersInner.fromJson(Map<String, dynamic> json) =>
      _$RoomTokenResponseIceServersInnerFromJson(json);
}
