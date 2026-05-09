import 'package:dio/dio.dart';
import 'package:kinnectai_app/models/photplay_job_response.dart';
import 'package:kinnectai_app/models/photplay_request.dart';
import 'package:retrofit/retrofit.dart';

part 'photplay_service_api.g.dart';

@RestApi(baseUrl: 'https://api.kinnectai.app/v1')
abstract class PhotplayServiceApi {
  factory PhotplayServiceApi(Dio dio, {String baseUrl}) = _PhotplayServiceApi;

  @POST('/photplay')
  Future<PhotplayJobResponse> queuePhotplayJob(@Body() PhotplayRequest request);
}
