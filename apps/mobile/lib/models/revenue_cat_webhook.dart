import 'package:freezed_annotation/freezed_annotation.dart';

import 'revenue_cat_webhook_event.dart';

part 'revenue_cat_webhook.freezed.dart';
part 'revenue_cat_webhook.g.dart';

@freezed
abstract class RevenueCatWebhook with _$RevenueCatWebhook {
  const factory RevenueCatWebhook({
    required RevenueCatWebhookEvent event,
  }) = _RevenueCatWebhook;

  factory RevenueCatWebhook.fromJson(Map<String, dynamic> json) =>
      _$RevenueCatWebhookFromJson(json);
}
