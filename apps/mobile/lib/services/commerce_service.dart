import 'package:purchases_flutter/purchases_flutter.dart';

class CommerceService {
  CommerceService._();

  static Future<void> initialize({required String revenueCatApiKey}) async {
    await Purchases.configure(PurchasesConfiguration(revenueCatApiKey));
  }

  static Future<Offerings> getOfferings() {
    return Purchases.getOfferings();
  }

  static Future<CustomerInfo> restorePurchases() {
    return Purchases.restorePurchases();
  }
}

