import 'package:dio/dio.dart';
import 'package:kinnectai_app/models/kc_explain_response.dart';
import 'package:retrofit/retrofit.dart';

part 'kernel_service_api.g.dart';

@RestApi(baseUrl: 'https://api.kinnectai.app/v1')
abstract class KernelServiceApi {
  factory KernelServiceApi(Dio dio, {String baseUrl}) = _KernelServiceApi;

  @GET('/kc/explain/{pairId}')
  Future<KCExplainResponse> explainKC(@Path('pairId') String pairId);
}
