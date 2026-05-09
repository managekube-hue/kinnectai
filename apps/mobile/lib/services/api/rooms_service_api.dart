import 'package:dio/dio.dart';
import 'package:kinnectai_app/models/room_create_request.dart';
import 'package:kinnectai_app/models/room_token_response.dart';
import 'package:retrofit/retrofit.dart';

part 'rooms_service_api.g.dart';

@RestApi(baseUrl: 'https://api.kinnectai.app/v1')
abstract class RoomsServiceApi {
  factory RoomsServiceApi(Dio dio, {String baseUrl}) = _RoomsServiceApi;

  @POST('/rooms')
  Future<RoomTokenResponse> createRoom(@Body() RoomCreateRequest request);
}
