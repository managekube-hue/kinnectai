import 'package:dio/dio.dart';
import 'package:kinnectai_app/models/revenue_cat_webhook.dart';
import 'package:retrofit/retrofit.dart';

part 'payment_service_api.g.dart';

@RestApi(baseUrl: 'https://api.kinnectai.app/v1')
abstract class PaymentServiceApi {
  factory PaymentServiceApi(Dio dio, {String baseUrl}) = _PaymentServiceApi;

  @POST('/webhooks/revenuecat')
  Future<void> handleRevenueCatWebhook(@Body() RevenueCatWebhook request);
}
