import 'package:freezed_annotation/freezed_annotation.dart';

import 'revenue_cat_webhook_event_entitlements_inner.dart';

part 'revenue_cat_webhook_event.freezed.dart';
part 'revenue_cat_webhook_event.g.dart';

@freezed
abstract class RevenueCatWebhookEvent with _$RevenueCatWebhookEvent {
  const factory RevenueCatWebhookEvent({
    required String id,
    required DateTime createdAt,
    required String type,
    required String appUserId,
    required String productIdentifier,
    required String store,
    Map<String, RevenueCatWebhookEventEntitlementsInner>? entitlements,
  }) = _RevenueCatWebhookEvent;

  factory RevenueCatWebhookEvent.fromJson(Map<String, dynamic> json) =>
      _$RevenueCatWebhookEventFromJson(json);
}
