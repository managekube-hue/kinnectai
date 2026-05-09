import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_session_dto.freezed.dart';
part 'payment_session_dto.g.dart';

/// Represents a RevenueCat / Stripe payment session for in-app purchases
/// such as Bloom Credits, Vault+ subscription, or Kinnect Card.
@freezed
abstract class PaymentSessionDTO with _$PaymentSessionDTO {
  const factory PaymentSessionDTO({
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'offering_id') String? offeringId,
    required String currency,
    @JsonKey(name: 'amount_cents') required int amountCents,
    /// One of: pending, completed, failed, refunded.
    required String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    @JsonKey(name: 'receipt_url') String? receiptUrl,
  }) = _PaymentSessionDTO;

  factory PaymentSessionDTO.fromJson(Map<String, dynamic> json) =>
      _$PaymentSessionDTOFromJson(json);
}
