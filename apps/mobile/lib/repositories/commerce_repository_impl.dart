import 'package:dio/dio.dart';

import '../models/dtos/payment_session_dto.dart';
import 'commerce_repository.dart';

class CommerceRepositoryImpl implements CommerceRepository {
  CommerceRepositoryImpl({required Dio dio, this.basePath = '/v1'}) : _dio = dio;

  final Dio _dio;
  final String basePath;

  @override
  Future<PaymentSessionDTO> initCheckout({required String productId, required String currency}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$basePath/payments/checkout',
      data: {'product_id': productId, 'currency': currency},
    );
    return PaymentSessionDTO.fromJson(response.data ?? {});
  }

  @override
  Future<void> completePurchase(String sessionId) async {
    await _dio.post<void>('$basePath/payments/complete', data: {'session_id': sessionId});
  }

  @override
  Future<List<PaymentSessionDTO>> fetchPaymentHistory() async {
    final response = await _dio.get<Map<String, dynamic>>('$basePath/payments/history');
    final items = (response.data?['items'] as List?) ?? [];
    return items.whereType<Map<String, dynamic>>().map(PaymentSessionDTO.fromJson).toList();
  }

  @override
  Future<void> restorePurchases() async {
    await _dio.post<void>('$basePath/payments/restore');
  }

  @override
  Future<double> getBloomCreditBalance() async {
    final response = await _dio.get<Map<String, dynamic>>('$basePath/payments/balance');
  }
}
