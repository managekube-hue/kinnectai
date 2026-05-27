import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../models/dtos/payment_session_dto.dart';

// ---------------------------------------------------------------------------
// States
// ---------------------------------------------------------------------------

sealed class CommerceState extends Equatable {
  const CommerceState();

  @override
  List<Object?> get props => [];
}

class CommerceInitial extends CommerceState {}

class CommerceLoading extends CommerceState {}

class CommerceOfferingsLoaded extends CommerceState {
  const CommerceOfferingsLoaded(this.offerings);

  final Offerings offerings;

  @override
  List<Object?> get props => [offerings];
}

class CommercePurchasing extends CommerceState {}

class CommercePurchaseComplete extends CommerceState {
  const CommercePurchaseComplete(this.customerInfo);

  final CustomerInfo customerInfo;

  @override
  List<Object?> get props => [customerInfo];
}

class CommerceRestored extends CommerceState {
  const CommerceRestored(this.customerInfo);

  final CustomerInfo customerInfo;

  @override
  List<Object?> get props => [customerInfo];
}

class CommerceHistoryLoaded extends CommerceState {
  const CommerceHistoryLoaded(this.sessions);

  final List<PaymentSessionDTO> sessions;

  @override
  List<Object?> get props => [sessions];
}

class CommerceError extends CommerceState {
  const CommerceError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// ---------------------------------------------------------------------------
// Cubit
// ---------------------------------------------------------------------------

class CommerceCubit extends Cubit<CommerceState> {
  CommerceCubit() : super(CommerceInitial());

  Future<void> loadOfferings() async {
    emit(CommerceLoading());
    try {
      final offerings = await Purchases.getOfferings();
      emit(CommerceOfferingsLoaded(offerings));
    } catch (e) {
      emit(CommerceError('Failed to load offerings: $e'));
    }
  }

  Future<void> purchase(Package package) async {
    emit(CommercePurchasing());
    try {
      final result = await Purchases.purchasePackage(package);
      emit(CommercePurchaseComplete(result.customerInfo));
    } catch (e) {
      emit(CommerceError('Purchase failed: $e'));
    }
  }

  Future<void> restorePurchases() async {
    emit(CommerceLoading());
    try {
      final info = await Purchases.restorePurchases();
      emit(CommerceRestored(info));
    } catch (e) {
      emit(CommerceError('Restore failed: $e'));
    }
  }
}
