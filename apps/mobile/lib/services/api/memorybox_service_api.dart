import 'package:dio/dio.dart';
import 'package:kinnectai_app/models/memorybox_post_request.dart';
import 'package:kinnectai_app/models/vault_sealed_response.dart';
import 'package:retrofit/retrofit.dart';

part 'memorybox_service_api.g.dart';

@RestApi(baseUrl: 'https://api.kinnectai.app/v1')
abstract class MemoryboxServiceApi {
  factory MemoryboxServiceApi(Dio dio, {String baseUrl}) = _MemoryboxServiceApi;

  @POST('/memorybox')
  Future<VaultSealedResponse> sealMemory(@Body() MemoryboxPostRequest request);
}
