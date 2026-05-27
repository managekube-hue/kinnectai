import 'package:dio/dio.dart';
import 'package:kinnectai_app/models/revenue_cat_webhook.dart';

class PaymentServiceApi {
  PaymentServiceApi(this._dio, {String? baseUrl})
      : _baseUrl = baseUrl ?? 'https://api.kinnectai.app/v1';

  final Dio _dio;
  final String _baseUrl;

  Future<void> handleRevenueCatWebhook(RevenueCatWebhook request) async {
    await _dio.post<void>(
      '$_baseUrl/webhooks/revenuecat',
      data: request.toJson(),
    );
  }
}
