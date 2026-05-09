import 'package:dio/dio.dart';
import 'package:kinnectai_app/models/feed_get200_response.dart';
import 'package:kinnectai_app/models/pulses_post201_response.dart';
import 'package:kinnectai_app/models/pulses_post_request.dart';
import 'package:retrofit/retrofit.dart';

part 'feed_service_api.g.dart';

@RestApi(baseUrl: 'https://api.kinnectai.app/v1')
abstract class FeedServiceApi {
  factory FeedServiceApi(Dio dio, {String baseUrl}) = _FeedServiceApi;

  @GET('/feed')
  Future<FeedGet200Response> getFeed({
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
    @Query('fallback_mode') String? fallbackMode,
  });

  @POST('/pulses')
  Future<PulsesPost201Response> sendPulse(@Body() PulsesPostRequest request);
}
