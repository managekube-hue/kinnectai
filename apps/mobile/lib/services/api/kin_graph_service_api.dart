import 'package:dio/dio.dart';
import 'package:kinnectai_app/models/kinnection_list.dart';
import 'package:kinnectai_app/models/kinnection_path.dart';
import 'package:retrofit/retrofit.dart';

part 'kin_graph_service_api.g.dart';

@RestApi(baseUrl: 'https://api.kinnectai.app/v1')
abstract class KinGraphServiceApi {
  factory KinGraphServiceApi(Dio dio, {String baseUrl}) = _KinGraphServiceApi;

  @GET('/kinnections')
  Future<KinnectionList> getKinnections();

  @GET('/kinnections/path')
  Future<KinnectionPath> getPath(
    @Query('user_a') String userA,
    @Query('user_b') String userB,
  );
}
