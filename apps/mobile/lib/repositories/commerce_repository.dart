import '../models/dtos/payment_session_dto.dart';

abstract class CommerceRepository {
  Future<PaymentSessionDTO> initCheckout({required String productId, required String currency});
  Future<void> completePurchase(String sessionId);
  Future<List<PaymentSessionDTO>> fetchPaymentHistory();
  Future<void> restorePurchases();
  Future<double> getBloomCreditBalance();
}
