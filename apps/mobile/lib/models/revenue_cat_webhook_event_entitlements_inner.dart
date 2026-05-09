import 'package:freezed_annotation/freezed_annotation.dart';

part 'revenue_cat_webhook_event_entitlements_inner.freezed.dart';
part 'revenue_cat_webhook_event_entitlements_inner.g.dart';

@freezed
abstract class RevenueCatWebhookEventEntitlementsInner with _$RevenueCatWebhookEventEntitlementsInner {
  const factory RevenueCatWebhookEventEntitlementsInner({
    required bool active,
    String? expiresDate,
  }) = _RevenueCatWebhookEventEntitlementsInner;

  factory RevenueCatWebhookEventEntitlementsInner.fromJson(Map<String, dynamic> json) =>
      _$RevenueCatWebhookEventEntitlementsInnerFromJson(json);
}
