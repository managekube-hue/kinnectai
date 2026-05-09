// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentSessionDTO _$PaymentSessionDTOFromJson(Map<String, dynamic> json) =>
    _PaymentSessionDTO(
      sessionId: json['session_id'] as String,
      productId: json['product_id'] as String,
      offeringId: json['offering_id'] as String?,
      currency: json['currency'] as String,
      amountCents: (json['amount_cents'] as num).toInt(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      receiptUrl: json['receipt_url'] as String?,
    );

Map<String, dynamic> _$PaymentSessionDTOToJson(_PaymentSessionDTO instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'product_id': instance.productId,
      'offering_id': instance.offeringId,
      'currency': instance.currency,
      'amount_cents': instance.amountCents,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'expires_at': instance.expiresAt?.toIso8601String(),
      'receipt_url': instance.receiptUrl,
    };
