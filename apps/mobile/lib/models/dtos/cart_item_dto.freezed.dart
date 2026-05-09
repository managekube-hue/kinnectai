// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CartItemDTO {

@JsonKey(name: 'product_id') String get productId; String get title;@JsonKey(name: 'price_cents') int get priceCents; String get currency;@JsonKey(name: 'seller_name') String? get sellerName;@JsonKey(name: 'image_url') String? get imageUrl; int get quantity;
/// Create a copy of CartItemDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartItemDTOCopyWith<CartItemDTO> get copyWith => _$CartItemDTOCopyWithImpl<CartItemDTO>(this as CartItemDTO, _$identity);

  /// Serializes this CartItemDTO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartItemDTO&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.title, title) || other.title == title)&&(identical(other.priceCents, priceCents) || other.priceCents == priceCents)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.sellerName, sellerName) || other.sellerName == sellerName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,title,priceCents,currency,sellerName,imageUrl,quantity);

@override
String toString() {
  return 'CartItemDTO(productId: $productId, title: $title, priceCents: $priceCents, currency: $currency, sellerName: $sellerName, imageUrl: $imageUrl, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $CartItemDTOCopyWith<$Res>  {
  factory $CartItemDTOCopyWith(CartItemDTO value, $Res Function(CartItemDTO) _then) = _$CartItemDTOCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'product_id') String productId, String title,@JsonKey(name: 'price_cents') int priceCents, String currency,@JsonKey(name: 'seller_name') String? sellerName,@JsonKey(name: 'image_url') String? imageUrl, int quantity
});




}
/// @nodoc
class _$CartItemDTOCopyWithImpl<$Res>
    implements $CartItemDTOCopyWith<$Res> {
  _$CartItemDTOCopyWithImpl(this._self, this._then);

  final CartItemDTO _self;
  final $Res Function(CartItemDTO) _then;

/// Create a copy of CartItemDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? title = null,Object? priceCents = null,Object? currency = null,Object? sellerName = freezed,Object? imageUrl = freezed,Object? quantity = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,sellerName: freezed == sellerName ? _self.sellerName : sellerName // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CartItemDTO].
extension CartItemDTOPatterns on CartItemDTO {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartItemDTO value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartItemDTO() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartItemDTO value)  $default,){
final _that = this;
switch (_that) {
case _CartItemDTO():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartItemDTO value)?  $default,){
final _that = this;
switch (_that) {
case _CartItemDTO() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  String productId,  String title, @JsonKey(name: 'price_cents')  int priceCents,  String currency, @JsonKey(name: 'seller_name')  String? sellerName, @JsonKey(name: 'image_url')  String? imageUrl,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartItemDTO() when $default != null:
return $default(_that.productId,_that.title,_that.priceCents,_that.currency,_that.sellerName,_that.imageUrl,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  String productId,  String title, @JsonKey(name: 'price_cents')  int priceCents,  String currency, @JsonKey(name: 'seller_name')  String? sellerName, @JsonKey(name: 'image_url')  String? imageUrl,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _CartItemDTO():
return $default(_that.productId,_that.title,_that.priceCents,_that.currency,_that.sellerName,_that.imageUrl,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'product_id')  String productId,  String title, @JsonKey(name: 'price_cents')  int priceCents,  String currency, @JsonKey(name: 'seller_name')  String? sellerName, @JsonKey(name: 'image_url')  String? imageUrl,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _CartItemDTO() when $default != null:
return $default(_that.productId,_that.title,_that.priceCents,_that.currency,_that.sellerName,_that.imageUrl,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CartItemDTO implements CartItemDTO {
  const _CartItemDTO({@JsonKey(name: 'product_id') required this.productId, required this.title, @JsonKey(name: 'price_cents') required this.priceCents, this.currency = 'USD', @JsonKey(name: 'seller_name') this.sellerName, @JsonKey(name: 'image_url') this.imageUrl, this.quantity = 1});
  factory _CartItemDTO.fromJson(Map<String, dynamic> json) => _$CartItemDTOFromJson(json);

@override@JsonKey(name: 'product_id') final  String productId;
@override final  String title;
@override@JsonKey(name: 'price_cents') final  int priceCents;
@override@JsonKey() final  String currency;
@override@JsonKey(name: 'seller_name') final  String? sellerName;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override@JsonKey() final  int quantity;

/// Create a copy of CartItemDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartItemDTOCopyWith<_CartItemDTO> get copyWith => __$CartItemDTOCopyWithImpl<_CartItemDTO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CartItemDTOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartItemDTO&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.title, title) || other.title == title)&&(identical(other.priceCents, priceCents) || other.priceCents == priceCents)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.sellerName, sellerName) || other.sellerName == sellerName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,title,priceCents,currency,sellerName,imageUrl,quantity);

@override
String toString() {
  return 'CartItemDTO(productId: $productId, title: $title, priceCents: $priceCents, currency: $currency, sellerName: $sellerName, imageUrl: $imageUrl, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$CartItemDTOCopyWith<$Res> implements $CartItemDTOCopyWith<$Res> {
  factory _$CartItemDTOCopyWith(_CartItemDTO value, $Res Function(_CartItemDTO) _then) = __$CartItemDTOCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'product_id') String productId, String title,@JsonKey(name: 'price_cents') int priceCents, String currency,@JsonKey(name: 'seller_name') String? sellerName,@JsonKey(name: 'image_url') String? imageUrl, int quantity
});




}
/// @nodoc
class __$CartItemDTOCopyWithImpl<$Res>
    implements _$CartItemDTOCopyWith<$Res> {
  __$CartItemDTOCopyWithImpl(this._self, this._then);

  final _CartItemDTO _self;
  final $Res Function(_CartItemDTO) _then;

/// Create a copy of CartItemDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? title = null,Object? priceCents = null,Object? currency = null,Object? sellerName = freezed,Object? imageUrl = freezed,Object? quantity = null,}) {
  return _then(_CartItemDTO(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,sellerName: freezed == sellerName ? _self.sellerName : sellerName // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
