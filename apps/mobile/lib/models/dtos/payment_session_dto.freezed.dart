// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_session_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentSessionDTO {

@JsonKey(name: 'session_id') String get sessionId;@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'offering_id') String? get offeringId; String get currency;@JsonKey(name: 'amount_cents') int get amountCents;/// One of: pending, completed, failed, refunded.
 String get status;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'expires_at') DateTime? get expiresAt;@JsonKey(name: 'receipt_url') String? get receiptUrl;
/// Create a copy of PaymentSessionDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentSessionDTOCopyWith<PaymentSessionDTO> get copyWith => _$PaymentSessionDTOCopyWithImpl<PaymentSessionDTO>(this as PaymentSessionDTO, _$identity);

  /// Serializes this PaymentSessionDTO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentSessionDTO&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.offeringId, offeringId) || other.offeringId == offeringId)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.amountCents, amountCents) || other.amountCents == amountCents)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.receiptUrl, receiptUrl) || other.receiptUrl == receiptUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,productId,offeringId,currency,amountCents,status,createdAt,expiresAt,receiptUrl);

@override
String toString() {
  return 'PaymentSessionDTO(sessionId: $sessionId, productId: $productId, offeringId: $offeringId, currency: $currency, amountCents: $amountCents, status: $status, createdAt: $createdAt, expiresAt: $expiresAt, receiptUrl: $receiptUrl)';
}


}

/// @nodoc
abstract mixin class $PaymentSessionDTOCopyWith<$Res>  {
  factory $PaymentSessionDTOCopyWith(PaymentSessionDTO value, $Res Function(PaymentSessionDTO) _then) = _$PaymentSessionDTOCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'offering_id') String? offeringId, String currency,@JsonKey(name: 'amount_cents') int amountCents, String status,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'expires_at') DateTime? expiresAt,@JsonKey(name: 'receipt_url') String? receiptUrl
});




}
/// @nodoc
class _$PaymentSessionDTOCopyWithImpl<$Res>
    implements $PaymentSessionDTOCopyWith<$Res> {
  _$PaymentSessionDTOCopyWithImpl(this._self, this._then);

  final PaymentSessionDTO _self;
  final $Res Function(PaymentSessionDTO) _then;

/// Create a copy of PaymentSessionDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? productId = null,Object? offeringId = freezed,Object? currency = null,Object? amountCents = null,Object? status = null,Object? createdAt = null,Object? expiresAt = freezed,Object? receiptUrl = freezed,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,offeringId: freezed == offeringId ? _self.offeringId : offeringId // ignore: cast_nullable_to_non_nullable
as String?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,amountCents: null == amountCents ? _self.amountCents : amountCents // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,receiptUrl: freezed == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentSessionDTO].
extension PaymentSessionDTOPatterns on PaymentSessionDTO {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentSessionDTO value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentSessionDTO() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentSessionDTO value)  $default,){
final _that = this;
switch (_that) {
case _PaymentSessionDTO():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentSessionDTO value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentSessionDTO() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'offering_id')  String? offeringId,  String currency, @JsonKey(name: 'amount_cents')  int amountCents,  String status, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'expires_at')  DateTime? expiresAt, @JsonKey(name: 'receipt_url')  String? receiptUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentSessionDTO() when $default != null:
return $default(_that.sessionId,_that.productId,_that.offeringId,_that.currency,_that.amountCents,_that.status,_that.createdAt,_that.expiresAt,_that.receiptUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'offering_id')  String? offeringId,  String currency, @JsonKey(name: 'amount_cents')  int amountCents,  String status, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'expires_at')  DateTime? expiresAt, @JsonKey(name: 'receipt_url')  String? receiptUrl)  $default,) {final _that = this;
switch (_that) {
case _PaymentSessionDTO():
return $default(_that.sessionId,_that.productId,_that.offeringId,_that.currency,_that.amountCents,_that.status,_that.createdAt,_that.expiresAt,_that.receiptUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'offering_id')  String? offeringId,  String currency, @JsonKey(name: 'amount_cents')  int amountCents,  String status, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'expires_at')  DateTime? expiresAt, @JsonKey(name: 'receipt_url')  String? receiptUrl)?  $default,) {final _that = this;
switch (_that) {
case _PaymentSessionDTO() when $default != null:
return $default(_that.sessionId,_that.productId,_that.offeringId,_that.currency,_that.amountCents,_that.status,_that.createdAt,_that.expiresAt,_that.receiptUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentSessionDTO implements PaymentSessionDTO {
  const _PaymentSessionDTO({@JsonKey(name: 'session_id') required this.sessionId, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'offering_id') this.offeringId, required this.currency, @JsonKey(name: 'amount_cents') required this.amountCents, required this.status, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'expires_at') this.expiresAt, @JsonKey(name: 'receipt_url') this.receiptUrl});
  factory _PaymentSessionDTO.fromJson(Map<String, dynamic> json) => _$PaymentSessionDTOFromJson(json);

@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'offering_id') final  String? offeringId;
@override final  String currency;
@override@JsonKey(name: 'amount_cents') final  int amountCents;
/// One of: pending, completed, failed, refunded.
@override final  String status;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'expires_at') final  DateTime? expiresAt;
@override@JsonKey(name: 'receipt_url') final  String? receiptUrl;

/// Create a copy of PaymentSessionDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentSessionDTOCopyWith<_PaymentSessionDTO> get copyWith => __$PaymentSessionDTOCopyWithImpl<_PaymentSessionDTO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentSessionDTOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentSessionDTO&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.offeringId, offeringId) || other.offeringId == offeringId)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.amountCents, amountCents) || other.amountCents == amountCents)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.receiptUrl, receiptUrl) || other.receiptUrl == receiptUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,productId,offeringId,currency,amountCents,status,createdAt,expiresAt,receiptUrl);

@override
String toString() {
  return 'PaymentSessionDTO(sessionId: $sessionId, productId: $productId, offeringId: $offeringId, currency: $currency, amountCents: $amountCents, status: $status, createdAt: $createdAt, expiresAt: $expiresAt, receiptUrl: $receiptUrl)';
}


}

/// @nodoc
abstract mixin class _$PaymentSessionDTOCopyWith<$Res> implements $PaymentSessionDTOCopyWith<$Res> {
  factory _$PaymentSessionDTOCopyWith(_PaymentSessionDTO value, $Res Function(_PaymentSessionDTO) _then) = __$PaymentSessionDTOCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'offering_id') String? offeringId, String currency,@JsonKey(name: 'amount_cents') int amountCents, String status,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'expires_at') DateTime? expiresAt,@JsonKey(name: 'receipt_url') String? receiptUrl
});




}
/// @nodoc
class __$PaymentSessionDTOCopyWithImpl<$Res>
    implements _$PaymentSessionDTOCopyWith<$Res> {
  __$PaymentSessionDTOCopyWithImpl(this._self, this._then);

  final _PaymentSessionDTO _self;
  final $Res Function(_PaymentSessionDTO) _then;

/// Create a copy of PaymentSessionDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? productId = null,Object? offeringId = freezed,Object? currency = null,Object? amountCents = null,Object? status = null,Object? createdAt = null,Object? expiresAt = freezed,Object? receiptUrl = freezed,}) {
  return _then(_PaymentSessionDTO(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,offeringId: freezed == offeringId ? _self.offeringId : offeringId // ignore: cast_nullable_to_non_nullable
as String?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,amountCents: null == amountCents ? _self.amountCents : amountCents // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,receiptUrl: freezed == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
