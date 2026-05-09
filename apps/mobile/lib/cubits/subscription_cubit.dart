import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

// ---------------------------------------------------------------------------
// States
// ---------------------------------------------------------------------------

enum SubscriptionTier { free, vaultPlus }

sealed class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionActive extends SubscriptionState {
  const SubscriptionActive({
    required this.tier,
    required this.expiresAt,
    required this.isTrialPeriod,
  });

  final SubscriptionTier tier;
  final DateTime? expiresAt;
  final bool isTrialPeriod;

  @override
  List<Object?> get props => [tier, expiresAt, isTrialPeriod];
}

class SubscriptionInactive extends SubscriptionState {}

class SubscriptionError extends SubscriptionState {
  const SubscriptionError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// ---------------------------------------------------------------------------
// Cubit
// ---------------------------------------------------------------------------

/// Manages the user's Vault+ subscription state via RevenueCat.
class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit() : super(SubscriptionLoading());

  static const _vaultPlusEntitlement = 'vault_plus';

  Future<void> load() async {
    emit(SubscriptionLoading());
    try {
      final info = await Purchases.getCustomerInfo();
      _emitFromCustomerInfo(info);
    } catch (e) {
      emit(SubscriptionError('Failed to load subscription: $e'));
    }
  }

  Future<void> subscribe(Package package) async {
    emit(SubscriptionLoading());
    try {
      final info = await Purchases.purchasePackage(package);
      _emitFromCustomerInfo(info);
    } catch (e) {
      emit(SubscriptionError('Subscribe failed: $e'));
    }
  }

  Future<void> restore() async {
    emit(SubscriptionLoading());
    try {
      final info = await Purchases.restorePurchases();
      _emitFromCustomerInfo(info);
    } catch (e) {
      emit(SubscriptionError('Restore failed: $e'));
    }
  }

  void _emitFromCustomerInfo(CustomerInfo info) {
    final entitlement = info.entitlements.active[_vaultPlusEntitlement];
    if (entitlement != null) {
      emit(SubscriptionActive(
        tier: SubscriptionTier.vaultPlus,
        expiresAt: entitlement.expirationDate != null
            ? DateTime.tryParse(entitlement.expirationDate!)
            : null,
        isTrialPeriod: entitlement.periodType == PeriodType.trial,
      ));
    } else {
      emit(SubscriptionInactive());
    }
  }
}
