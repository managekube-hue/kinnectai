import 'package:dio/dio.dart';
import 'package:kinnectai_app/models/discovery_dismiss_post_request.dart';
import 'package:kinnectai_app/models/discovery_list.dart';
import 'package:retrofit/retrofit.dart';

part 'discovery_service_api.g.dart';

@RestApi(baseUrl: 'https://api.kinnectai.app/v1')
abstract class DiscoveryServiceApi {
  factory DiscoveryServiceApi(Dio dio, {String baseUrl}) = _DiscoveryServiceApi;

  @GET('/discovery')
  Future<DiscoveryList> getCandidates();

  @POST('/discovery/dismiss')
  Future<void> dismissCandidate(@Body() DiscoveryDismissPostRequest request);
}
