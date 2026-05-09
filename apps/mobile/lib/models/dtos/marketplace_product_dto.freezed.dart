// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'marketplace_product_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarketplaceProductDTO {

 String get id; String get title; String? get description; String get category;@JsonKey(name: 'price_cents') int get priceCents;@JsonKey(name: 'compare_at_cents') int? get compareAtCents; String get currency;@JsonKey(name: 'seller_id') String? get sellerId;@JsonKey(name: 'seller_name') String? get sellerName;@JsonKey(name: 'commission_percent') double? get commissionPercent;@JsonKey(name: 'rating_avg') double get ratingAvg;@JsonKey(name: 'rating_count') int get ratingCount;@JsonKey(name: 'sales_count') int get salesCount;@JsonKey(name: 'view_count') int get viewCount; bool get featured; List<ProductImageDTO> get images; String? get status;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of MarketplaceProductDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketplaceProductDTOCopyWith<MarketplaceProductDTO> get copyWith => _$MarketplaceProductDTOCopyWithImpl<MarketplaceProductDTO>(this as MarketplaceProductDTO, _$identity);

  /// Serializes this MarketplaceProductDTO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketplaceProductDTO&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.priceCents, priceCents) || other.priceCents == priceCents)&&(identical(other.compareAtCents, compareAtCents) || other.compareAtCents == compareAtCents)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.sellerId, sellerId) || other.sellerId == sellerId)&&(identical(other.sellerName, sellerName) || other.sellerName == sellerName)&&(identical(other.commissionPercent, commissionPercent) || other.commissionPercent == commissionPercent)&&(identical(other.ratingAvg, ratingAvg) || other.ratingAvg == ratingAvg)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.salesCount, salesCount) || other.salesCount == salesCount)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.featured, featured) || other.featured == featured)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,category,priceCents,compareAtCents,currency,sellerId,sellerName,commissionPercent,ratingAvg,ratingCount,salesCount,viewCount,featured,const DeepCollectionEquality().hash(images),status,createdAt);

@override
String toString() {
  return 'MarketplaceProductDTO(id: $id, title: $title, description: $description, category: $category, priceCents: $priceCents, compareAtCents: $compareAtCents, currency: $currency, sellerId: $sellerId, sellerName: $sellerName, commissionPercent: $commissionPercent, ratingAvg: $ratingAvg, ratingCount: $ratingCount, salesCount: $salesCount, viewCount: $viewCount, featured: $featured, images: $images, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MarketplaceProductDTOCopyWith<$Res>  {
  factory $MarketplaceProductDTOCopyWith(MarketplaceProductDTO value, $Res Function(MarketplaceProductDTO) _then) = _$MarketplaceProductDTOCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? description, String category,@JsonKey(name: 'price_cents') int priceCents,@JsonKey(name: 'compare_at_cents') int? compareAtCents, String currency,@JsonKey(name: 'seller_id') String? sellerId,@JsonKey(name: 'seller_name') String? sellerName,@JsonKey(name: 'commission_percent') double? commissionPercent,@JsonKey(name: 'rating_avg') double ratingAvg,@JsonKey(name: 'rating_count') int ratingCount,@JsonKey(name: 'sales_count') int salesCount,@JsonKey(name: 'view_count') int viewCount, bool featured, List<ProductImageDTO> images, String? status,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$MarketplaceProductDTOCopyWithImpl<$Res>
    implements $MarketplaceProductDTOCopyWith<$Res> {
  _$MarketplaceProductDTOCopyWithImpl(this._self, this._then);

  final MarketplaceProductDTO _self;
  final $Res Function(MarketplaceProductDTO) _then;

/// Create a copy of MarketplaceProductDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? category = null,Object? priceCents = null,Object? compareAtCents = freezed,Object? currency = null,Object? sellerId = freezed,Object? sellerName = freezed,Object? commissionPercent = freezed,Object? ratingAvg = null,Object? ratingCount = null,Object? salesCount = null,Object? viewCount = null,Object? featured = null,Object? images = null,Object? status = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,compareAtCents: freezed == compareAtCents ? _self.compareAtCents : compareAtCents // ignore: cast_nullable_to_non_nullable
as int?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,sellerId: freezed == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as String?,sellerName: freezed == sellerName ? _self.sellerName : sellerName // ignore: cast_nullable_to_non_nullable
as String?,commissionPercent: freezed == commissionPercent ? _self.commissionPercent : commissionPercent // ignore: cast_nullable_to_non_nullable
as double?,ratingAvg: null == ratingAvg ? _self.ratingAvg : ratingAvg // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,salesCount: null == salesCount ? _self.salesCount : salesCount // ignore: cast_nullable_to_non_nullable
as int,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as bool,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<ProductImageDTO>,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MarketplaceProductDTO].
extension MarketplaceProductDTOPatterns on MarketplaceProductDTO {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarketplaceProductDTO value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarketplaceProductDTO() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarketplaceProductDTO value)  $default,){
final _that = this;
switch (_that) {
case _MarketplaceProductDTO():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarketplaceProductDTO value)?  $default,){
final _that = this;
switch (_that) {
case _MarketplaceProductDTO() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  String category, @JsonKey(name: 'price_cents')  int priceCents, @JsonKey(name: 'compare_at_cents')  int? compareAtCents,  String currency, @JsonKey(name: 'seller_id')  String? sellerId, @JsonKey(name: 'seller_name')  String? sellerName, @JsonKey(name: 'commission_percent')  double? commissionPercent, @JsonKey(name: 'rating_avg')  double ratingAvg, @JsonKey(name: 'rating_count')  int ratingCount, @JsonKey(name: 'sales_count')  int salesCount, @JsonKey(name: 'view_count')  int viewCount,  bool featured,  List<ProductImageDTO> images,  String? status, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarketplaceProductDTO() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.category,_that.priceCents,_that.compareAtCents,_that.currency,_that.sellerId,_that.sellerName,_that.commissionPercent,_that.ratingAvg,_that.ratingCount,_that.salesCount,_that.viewCount,_that.featured,_that.images,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  String category, @JsonKey(name: 'price_cents')  int priceCents, @JsonKey(name: 'compare_at_cents')  int? compareAtCents,  String currency, @JsonKey(name: 'seller_id')  String? sellerId, @JsonKey(name: 'seller_name')  String? sellerName, @JsonKey(name: 'commission_percent')  double? commissionPercent, @JsonKey(name: 'rating_avg')  double ratingAvg, @JsonKey(name: 'rating_count')  int ratingCount, @JsonKey(name: 'sales_count')  int salesCount, @JsonKey(name: 'view_count')  int viewCount,  bool featured,  List<ProductImageDTO> images,  String? status, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _MarketplaceProductDTO():
return $default(_that.id,_that.title,_that.description,_that.category,_that.priceCents,_that.compareAtCents,_that.currency,_that.sellerId,_that.sellerName,_that.commissionPercent,_that.ratingAvg,_that.ratingCount,_that.salesCount,_that.viewCount,_that.featured,_that.images,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? description,  String category, @JsonKey(name: 'price_cents')  int priceCents, @JsonKey(name: 'compare_at_cents')  int? compareAtCents,  String currency, @JsonKey(name: 'seller_id')  String? sellerId, @JsonKey(name: 'seller_name')  String? sellerName, @JsonKey(name: 'commission_percent')  double? commissionPercent, @JsonKey(name: 'rating_avg')  double ratingAvg, @JsonKey(name: 'rating_count')  int ratingCount, @JsonKey(name: 'sales_count')  int salesCount, @JsonKey(name: 'view_count')  int viewCount,  bool featured,  List<ProductImageDTO> images,  String? status, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MarketplaceProductDTO() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.category,_that.priceCents,_that.compareAtCents,_that.currency,_that.sellerId,_that.sellerName,_that.commissionPercent,_that.ratingAvg,_that.ratingCount,_that.salesCount,_that.viewCount,_that.featured,_that.images,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MarketplaceProductDTO implements MarketplaceProductDTO {
  const _MarketplaceProductDTO({required this.id, required this.title, this.description, required this.category, @JsonKey(name: 'price_cents') required this.priceCents, @JsonKey(name: 'compare_at_cents') this.compareAtCents, this.currency = 'USD', @JsonKey(name: 'seller_id') this.sellerId, @JsonKey(name: 'seller_name') this.sellerName, @JsonKey(name: 'commission_percent') this.commissionPercent, @JsonKey(name: 'rating_avg') this.ratingAvg = 0, @JsonKey(name: 'rating_count') this.ratingCount = 0, @JsonKey(name: 'sales_count') this.salesCount = 0, @JsonKey(name: 'view_count') this.viewCount = 0, this.featured = false, final  List<ProductImageDTO> images = const [], this.status, @JsonKey(name: 'created_at') this.createdAt}): _images = images;
  factory _MarketplaceProductDTO.fromJson(Map<String, dynamic> json) => _$MarketplaceProductDTOFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? description;
@override final  String category;
@override@JsonKey(name: 'price_cents') final  int priceCents;
@override@JsonKey(name: 'compare_at_cents') final  int? compareAtCents;
@override@JsonKey() final  String currency;
@override@JsonKey(name: 'seller_id') final  String? sellerId;
@override@JsonKey(name: 'seller_name') final  String? sellerName;
@override@JsonKey(name: 'commission_percent') final  double? commissionPercent;
@override@JsonKey(name: 'rating_avg') final  double ratingAvg;
@override@JsonKey(name: 'rating_count') final  int ratingCount;
@override@JsonKey(name: 'sales_count') final  int salesCount;
@override@JsonKey(name: 'view_count') final  int viewCount;
@override@JsonKey() final  bool featured;
 final  List<ProductImageDTO> _images;
@override@JsonKey() List<ProductImageDTO> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

@override final  String? status;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of MarketplaceProductDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarketplaceProductDTOCopyWith<_MarketplaceProductDTO> get copyWith => __$MarketplaceProductDTOCopyWithImpl<_MarketplaceProductDTO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarketplaceProductDTOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarketplaceProductDTO&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.priceCents, priceCents) || other.priceCents == priceCents)&&(identical(other.compareAtCents, compareAtCents) || other.compareAtCents == compareAtCents)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.sellerId, sellerId) || other.sellerId == sellerId)&&(identical(other.sellerName, sellerName) || other.sellerName == sellerName)&&(identical(other.commissionPercent, commissionPercent) || other.commissionPercent == commissionPercent)&&(identical(other.ratingAvg, ratingAvg) || other.ratingAvg == ratingAvg)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.salesCount, salesCount) || other.salesCount == salesCount)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.featured, featured) || other.featured == featured)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,category,priceCents,compareAtCents,currency,sellerId,sellerName,commissionPercent,ratingAvg,ratingCount,salesCount,viewCount,featured,const DeepCollectionEquality().hash(_images),status,createdAt);

@override
String toString() {
  return 'MarketplaceProductDTO(id: $id, title: $title, description: $description, category: $category, priceCents: $priceCents, compareAtCents: $compareAtCents, currency: $currency, sellerId: $sellerId, sellerName: $sellerName, commissionPercent: $commissionPercent, ratingAvg: $ratingAvg, ratingCount: $ratingCount, salesCount: $salesCount, viewCount: $viewCount, featured: $featured, images: $images, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MarketplaceProductDTOCopyWith<$Res> implements $MarketplaceProductDTOCopyWith<$Res> {
  factory _$MarketplaceProductDTOCopyWith(_MarketplaceProductDTO value, $Res Function(_MarketplaceProductDTO) _then) = __$MarketplaceProductDTOCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? description, String category,@JsonKey(name: 'price_cents') int priceCents,@JsonKey(name: 'compare_at_cents') int? compareAtCents, String currency,@JsonKey(name: 'seller_id') String? sellerId,@JsonKey(name: 'seller_name') String? sellerName,@JsonKey(name: 'commission_percent') double? commissionPercent,@JsonKey(name: 'rating_avg') double ratingAvg,@JsonKey(name: 'rating_count') int ratingCount,@JsonKey(name: 'sales_count') int salesCount,@JsonKey(name: 'view_count') int viewCount, bool featured, List<ProductImageDTO> images, String? status,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$MarketplaceProductDTOCopyWithImpl<$Res>
    implements _$MarketplaceProductDTOCopyWith<$Res> {
  __$MarketplaceProductDTOCopyWithImpl(this._self, this._then);

  final _MarketplaceProductDTO _self;
  final $Res Function(_MarketplaceProductDTO) _then;

/// Create a copy of MarketplaceProductDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? category = null,Object? priceCents = null,Object? compareAtCents = freezed,Object? currency = null,Object? sellerId = freezed,Object? sellerName = freezed,Object? commissionPercent = freezed,Object? ratingAvg = null,Object? ratingCount = null,Object? salesCount = null,Object? viewCount = null,Object? featured = null,Object? images = null,Object? status = freezed,Object? createdAt = freezed,}) {
  return _then(_MarketplaceProductDTO(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,compareAtCents: freezed == compareAtCents ? _self.compareAtCents : compareAtCents // ignore: cast_nullable_to_non_nullable
as int?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,sellerId: freezed == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as String?,sellerName: freezed == sellerName ? _self.sellerName : sellerName // ignore: cast_nullable_to_non_nullable
as String?,commissionPercent: freezed == commissionPercent ? _self.commissionPercent : commissionPercent // ignore: cast_nullable_to_non_nullable
as double?,ratingAvg: null == ratingAvg ? _self.ratingAvg : ratingAvg // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,salesCount: null == salesCount ? _self.salesCount : salesCount // ignore: cast_nullable_to_non_nullable
as int,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as bool,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<ProductImageDTO>,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ProductImageDTO {

 String? get id; String get url;@JsonKey(name: 'alt_text') String? get altText;@JsonKey(name: 'sort_order') int get sortOrder;@JsonKey(name: 'is_primary') bool get isPrimary;
/// Create a copy of ProductImageDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductImageDTOCopyWith<ProductImageDTO> get copyWith => _$ProductImageDTOCopyWithImpl<ProductImageDTO>(this as ProductImageDTO, _$identity);

  /// Serializes this ProductImageDTO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductImageDTO&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.altText, altText) || other.altText == altText)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,altText,sortOrder,isPrimary);

@override
String toString() {
  return 'ProductImageDTO(id: $id, url: $url, altText: $altText, sortOrder: $sortOrder, isPrimary: $isPrimary)';
}


}

/// @nodoc
abstract mixin class $ProductImageDTOCopyWith<$Res>  {
  factory $ProductImageDTOCopyWith(ProductImageDTO value, $Res Function(ProductImageDTO) _then) = _$ProductImageDTOCopyWithImpl;
@useResult
$Res call({
 String? id, String url,@JsonKey(name: 'alt_text') String? altText,@JsonKey(name: 'sort_order') int sortOrder,@JsonKey(name: 'is_primary') bool isPrimary
});




}
/// @nodoc
class _$ProductImageDTOCopyWithImpl<$Res>
    implements $ProductImageDTOCopyWith<$Res> {
  _$ProductImageDTOCopyWithImpl(this._self, this._then);

  final ProductImageDTO _self;
  final $Res Function(ProductImageDTO) _then;

/// Create a copy of ProductImageDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? url = null,Object? altText = freezed,Object? sortOrder = null,Object? isPrimary = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,altText: freezed == altText ? _self.altText : altText // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductImageDTO].
extension ProductImageDTOPatterns on ProductImageDTO {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductImageDTO value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductImageDTO() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductImageDTO value)  $default,){
final _that = this;
switch (_that) {
case _ProductImageDTO():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductImageDTO value)?  $default,){
final _that = this;
switch (_that) {
case _ProductImageDTO() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String url, @JsonKey(name: 'alt_text')  String? altText, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_primary')  bool isPrimary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductImageDTO() when $default != null:
return $default(_that.id,_that.url,_that.altText,_that.sortOrder,_that.isPrimary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String url, @JsonKey(name: 'alt_text')  String? altText, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_primary')  bool isPrimary)  $default,) {final _that = this;
switch (_that) {
case _ProductImageDTO():
return $default(_that.id,_that.url,_that.altText,_that.sortOrder,_that.isPrimary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String url, @JsonKey(name: 'alt_text')  String? altText, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_primary')  bool isPrimary)?  $default,) {final _that = this;
switch (_that) {
case _ProductImageDTO() when $default != null:
return $default(_that.id,_that.url,_that.altText,_that.sortOrder,_that.isPrimary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductImageDTO implements ProductImageDTO {
  const _ProductImageDTO({this.id, required this.url, @JsonKey(name: 'alt_text') this.altText, @JsonKey(name: 'sort_order') this.sortOrder = 0, @JsonKey(name: 'is_primary') this.isPrimary = false});
  factory _ProductImageDTO.fromJson(Map<String, dynamic> json) => _$ProductImageDTOFromJson(json);

@override final  String? id;
@override final  String url;
@override@JsonKey(name: 'alt_text') final  String? altText;
@override@JsonKey(name: 'sort_order') final  int sortOrder;
@override@JsonKey(name: 'is_primary') final  bool isPrimary;

/// Create a copy of ProductImageDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductImageDTOCopyWith<_ProductImageDTO> get copyWith => __$ProductImageDTOCopyWithImpl<_ProductImageDTO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductImageDTOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductImageDTO&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.altText, altText) || other.altText == altText)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,altText,sortOrder,isPrimary);

@override
String toString() {
  return 'ProductImageDTO(id: $id, url: $url, altText: $altText, sortOrder: $sortOrder, isPrimary: $isPrimary)';
}


}

/// @nodoc
abstract mixin class _$ProductImageDTOCopyWith<$Res> implements $ProductImageDTOCopyWith<$Res> {
  factory _$ProductImageDTOCopyWith(_ProductImageDTO value, $Res Function(_ProductImageDTO) _then) = __$ProductImageDTOCopyWithImpl;
@override @useResult
$Res call({
 String? id, String url,@JsonKey(name: 'alt_text') String? altText,@JsonKey(name: 'sort_order') int sortOrder,@JsonKey(name: 'is_primary') bool isPrimary
});




}
/// @nodoc
class __$ProductImageDTOCopyWithImpl<$Res>
    implements _$ProductImageDTOCopyWith<$Res> {
  __$ProductImageDTOCopyWithImpl(this._self, this._then);

  final _ProductImageDTO _self;
  final $Res Function(_ProductImageDTO) _then;

/// Create a copy of ProductImageDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? url = null,Object? altText = freezed,Object? sortOrder = null,Object? isPrimary = null,}) {
  return _then(_ProductImageDTO(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,altText: freezed == altText ? _self.altText : altText // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$MarketplaceCategoryDTO {

 String get id; String get name; String get icon;@JsonKey(name: 'sort_order') int get sortOrder;@JsonKey(name: 'parent_id') String? get parentId; int get count;
/// Create a copy of MarketplaceCategoryDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketplaceCategoryDTOCopyWith<MarketplaceCategoryDTO> get copyWith => _$MarketplaceCategoryDTOCopyWithImpl<MarketplaceCategoryDTO>(this as MarketplaceCategoryDTO, _$identity);

  /// Serializes this MarketplaceCategoryDTO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketplaceCategoryDTO&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,icon,sortOrder,parentId,count);

@override
String toString() {
  return 'MarketplaceCategoryDTO(id: $id, name: $name, icon: $icon, sortOrder: $sortOrder, parentId: $parentId, count: $count)';
}


}

/// @nodoc
abstract mixin class $MarketplaceCategoryDTOCopyWith<$Res>  {
  factory $MarketplaceCategoryDTOCopyWith(MarketplaceCategoryDTO value, $Res Function(MarketplaceCategoryDTO) _then) = _$MarketplaceCategoryDTOCopyWithImpl;
@useResult
$Res call({
 String id, String name, String icon,@JsonKey(name: 'sort_order') int sortOrder,@JsonKey(name: 'parent_id') String? parentId, int count
});




}
/// @nodoc
class _$MarketplaceCategoryDTOCopyWithImpl<$Res>
    implements $MarketplaceCategoryDTOCopyWith<$Res> {
  _$MarketplaceCategoryDTOCopyWithImpl(this._self, this._then);

  final MarketplaceCategoryDTO _self;
  final $Res Function(MarketplaceCategoryDTO) _then;

/// Create a copy of MarketplaceCategoryDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? icon = null,Object? sortOrder = null,Object? parentId = freezed,Object? count = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MarketplaceCategoryDTO].
extension MarketplaceCategoryDTOPatterns on MarketplaceCategoryDTO {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarketplaceCategoryDTO value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarketplaceCategoryDTO() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarketplaceCategoryDTO value)  $default,){
final _that = this;
switch (_that) {
case _MarketplaceCategoryDTO():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarketplaceCategoryDTO value)?  $default,){
final _that = this;
switch (_that) {
case _MarketplaceCategoryDTO() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String icon, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'parent_id')  String? parentId,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarketplaceCategoryDTO() when $default != null:
return $default(_that.id,_that.name,_that.icon,_that.sortOrder,_that.parentId,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String icon, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'parent_id')  String? parentId,  int count)  $default,) {final _that = this;
switch (_that) {
case _MarketplaceCategoryDTO():
return $default(_that.id,_that.name,_that.icon,_that.sortOrder,_that.parentId,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String icon, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'parent_id')  String? parentId,  int count)?  $default,) {final _that = this;
switch (_that) {
case _MarketplaceCategoryDTO() when $default != null:
return $default(_that.id,_that.name,_that.icon,_that.sortOrder,_that.parentId,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MarketplaceCategoryDTO implements MarketplaceCategoryDTO {
  const _MarketplaceCategoryDTO({required this.id, required this.name, required this.icon, @JsonKey(name: 'sort_order') this.sortOrder = 0, @JsonKey(name: 'parent_id') this.parentId, this.count = 0});
  factory _MarketplaceCategoryDTO.fromJson(Map<String, dynamic> json) => _$MarketplaceCategoryDTOFromJson(json);

@override final  String id;
@override final  String name;
@override final  String icon;
@override@JsonKey(name: 'sort_order') final  int sortOrder;
@override@JsonKey(name: 'parent_id') final  String? parentId;
@override@JsonKey() final  int count;

/// Create a copy of MarketplaceCategoryDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarketplaceCategoryDTOCopyWith<_MarketplaceCategoryDTO> get copyWith => __$MarketplaceCategoryDTOCopyWithImpl<_MarketplaceCategoryDTO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarketplaceCategoryDTOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarketplaceCategoryDTO&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,icon,sortOrder,parentId,count);

@override
String toString() {
  return 'MarketplaceCategoryDTO(id: $id, name: $name, icon: $icon, sortOrder: $sortOrder, parentId: $parentId, count: $count)';
}


}

/// @nodoc
abstract mixin class _$MarketplaceCategoryDTOCopyWith<$Res> implements $MarketplaceCategoryDTOCopyWith<$Res> {
  factory _$MarketplaceCategoryDTOCopyWith(_MarketplaceCategoryDTO value, $Res Function(_MarketplaceCategoryDTO) _then) = __$MarketplaceCategoryDTOCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String icon,@JsonKey(name: 'sort_order') int sortOrder,@JsonKey(name: 'parent_id') String? parentId, int count
});




}
/// @nodoc
class __$MarketplaceCategoryDTOCopyWithImpl<$Res>
    implements _$MarketplaceCategoryDTOCopyWith<$Res> {
  __$MarketplaceCategoryDTOCopyWithImpl(this._self, this._then);

  final _MarketplaceCategoryDTO _self;
  final $Res Function(_MarketplaceCategoryDTO) _then;

/// Create a copy of MarketplaceCategoryDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? icon = null,Object? sortOrder = null,Object? parentId = freezed,Object? count = null,}) {
  return _then(_MarketplaceCategoryDTO(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MarketplaceOrderDTO {

@JsonKey(name: 'order_id') String get orderId;@JsonKey(name: 'buyer_id') String? get buyerId;@JsonKey(name: 'seller_id') String? get sellerId; String get status;@JsonKey(name: 'subtotal_cents') int get subtotalCents;@JsonKey(name: 'commission_cents') int get commissionCents;@JsonKey(name: 'seller_payout_cents') int get sellerPayoutCents;@JsonKey(name: 'shipping_cents') int get shippingCents;@JsonKey(name: 'total_cents') int get totalCents; String get currency;@JsonKey(name: 'tracking_number') String? get trackingNumber;@JsonKey(name: 'tracking_url') String? get trackingUrl; List<OrderItemDTO> get items;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'paid_at') DateTime? get paidAt;@JsonKey(name: 'shipped_at') DateTime? get shippedAt;@JsonKey(name: 'delivered_at') DateTime? get deliveredAt;
/// Create a copy of MarketplaceOrderDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketplaceOrderDTOCopyWith<MarketplaceOrderDTO> get copyWith => _$MarketplaceOrderDTOCopyWithImpl<MarketplaceOrderDTO>(this as MarketplaceOrderDTO, _$identity);

  /// Serializes this MarketplaceOrderDTO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketplaceOrderDTO&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.buyerId, buyerId) || other.buyerId == buyerId)&&(identical(other.sellerId, sellerId) || other.sellerId == sellerId)&&(identical(other.status, status) || other.status == status)&&(identical(other.subtotalCents, subtotalCents) || other.subtotalCents == subtotalCents)&&(identical(other.commissionCents, commissionCents) || other.commissionCents == commissionCents)&&(identical(other.sellerPayoutCents, sellerPayoutCents) || other.sellerPayoutCents == sellerPayoutCents)&&(identical(other.shippingCents, shippingCents) || other.shippingCents == shippingCents)&&(identical(other.totalCents, totalCents) || other.totalCents == totalCents)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.trackingNumber, trackingNumber) || other.trackingNumber == trackingNumber)&&(identical(other.trackingUrl, trackingUrl) || other.trackingUrl == trackingUrl)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.shippedAt, shippedAt) || other.shippedAt == shippedAt)&&(identical(other.deliveredAt, deliveredAt) || other.deliveredAt == deliveredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,buyerId,sellerId,status,subtotalCents,commissionCents,sellerPayoutCents,shippingCents,totalCents,currency,trackingNumber,trackingUrl,const DeepCollectionEquality().hash(items),createdAt,paidAt,shippedAt,deliveredAt);

@override
String toString() {
  return 'MarketplaceOrderDTO(orderId: $orderId, buyerId: $buyerId, sellerId: $sellerId, status: $status, subtotalCents: $subtotalCents, commissionCents: $commissionCents, sellerPayoutCents: $sellerPayoutCents, shippingCents: $shippingCents, totalCents: $totalCents, currency: $currency, trackingNumber: $trackingNumber, trackingUrl: $trackingUrl, items: $items, createdAt: $createdAt, paidAt: $paidAt, shippedAt: $shippedAt, deliveredAt: $deliveredAt)';
}


}

/// @nodoc
abstract mixin class $MarketplaceOrderDTOCopyWith<$Res>  {
  factory $MarketplaceOrderDTOCopyWith(MarketplaceOrderDTO value, $Res Function(MarketplaceOrderDTO) _then) = _$MarketplaceOrderDTOCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'order_id') String orderId,@JsonKey(name: 'buyer_id') String? buyerId,@JsonKey(name: 'seller_id') String? sellerId, String status,@JsonKey(name: 'subtotal_cents') int subtotalCents,@JsonKey(name: 'commission_cents') int commissionCents,@JsonKey(name: 'seller_payout_cents') int sellerPayoutCents,@JsonKey(name: 'shipping_cents') int shippingCents,@JsonKey(name: 'total_cents') int totalCents, String currency,@JsonKey(name: 'tracking_number') String? trackingNumber,@JsonKey(name: 'tracking_url') String? trackingUrl, List<OrderItemDTO> items,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'paid_at') DateTime? paidAt,@JsonKey(name: 'shipped_at') DateTime? shippedAt,@JsonKey(name: 'delivered_at') DateTime? deliveredAt
});




}
/// @nodoc
class _$MarketplaceOrderDTOCopyWithImpl<$Res>
    implements $MarketplaceOrderDTOCopyWith<$Res> {
  _$MarketplaceOrderDTOCopyWithImpl(this._self, this._then);

  final MarketplaceOrderDTO _self;
  final $Res Function(MarketplaceOrderDTO) _then;

/// Create a copy of MarketplaceOrderDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = null,Object? buyerId = freezed,Object? sellerId = freezed,Object? status = null,Object? subtotalCents = null,Object? commissionCents = null,Object? sellerPayoutCents = null,Object? shippingCents = null,Object? totalCents = null,Object? currency = null,Object? trackingNumber = freezed,Object? trackingUrl = freezed,Object? items = null,Object? createdAt = freezed,Object? paidAt = freezed,Object? shippedAt = freezed,Object? deliveredAt = freezed,}) {
  return _then(_self.copyWith(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,buyerId: freezed == buyerId ? _self.buyerId : buyerId // ignore: cast_nullable_to_non_nullable
as String?,sellerId: freezed == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,subtotalCents: null == subtotalCents ? _self.subtotalCents : subtotalCents // ignore: cast_nullable_to_non_nullable
as int,commissionCents: null == commissionCents ? _self.commissionCents : commissionCents // ignore: cast_nullable_to_non_nullable
as int,sellerPayoutCents: null == sellerPayoutCents ? _self.sellerPayoutCents : sellerPayoutCents // ignore: cast_nullable_to_non_nullable
as int,shippingCents: null == shippingCents ? _self.shippingCents : shippingCents // ignore: cast_nullable_to_non_nullable
as int,totalCents: null == totalCents ? _self.totalCents : totalCents // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,trackingNumber: freezed == trackingNumber ? _self.trackingNumber : trackingNumber // ignore: cast_nullable_to_non_nullable
as String?,trackingUrl: freezed == trackingUrl ? _self.trackingUrl : trackingUrl // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemDTO>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,shippedAt: freezed == shippedAt ? _self.shippedAt : shippedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveredAt: freezed == deliveredAt ? _self.deliveredAt : deliveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MarketplaceOrderDTO].
extension MarketplaceOrderDTOPatterns on MarketplaceOrderDTO {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarketplaceOrderDTO value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarketplaceOrderDTO() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarketplaceOrderDTO value)  $default,){
final _that = this;
switch (_that) {
case _MarketplaceOrderDTO():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarketplaceOrderDTO value)?  $default,){
final _that = this;
switch (_that) {
case _MarketplaceOrderDTO() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'order_id')  String orderId, @JsonKey(name: 'buyer_id')  String? buyerId, @JsonKey(name: 'seller_id')  String? sellerId,  String status, @JsonKey(name: 'subtotal_cents')  int subtotalCents, @JsonKey(name: 'commission_cents')  int commissionCents, @JsonKey(name: 'seller_payout_cents')  int sellerPayoutCents, @JsonKey(name: 'shipping_cents')  int shippingCents, @JsonKey(name: 'total_cents')  int totalCents,  String currency, @JsonKey(name: 'tracking_number')  String? trackingNumber, @JsonKey(name: 'tracking_url')  String? trackingUrl,  List<OrderItemDTO> items, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'paid_at')  DateTime? paidAt, @JsonKey(name: 'shipped_at')  DateTime? shippedAt, @JsonKey(name: 'delivered_at')  DateTime? deliveredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarketplaceOrderDTO() when $default != null:
return $default(_that.orderId,_that.buyerId,_that.sellerId,_that.status,_that.subtotalCents,_that.commissionCents,_that.sellerPayoutCents,_that.shippingCents,_that.totalCents,_that.currency,_that.trackingNumber,_that.trackingUrl,_that.items,_that.createdAt,_that.paidAt,_that.shippedAt,_that.deliveredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'order_id')  String orderId, @JsonKey(name: 'buyer_id')  String? buyerId, @JsonKey(name: 'seller_id')  String? sellerId,  String status, @JsonKey(name: 'subtotal_cents')  int subtotalCents, @JsonKey(name: 'commission_cents')  int commissionCents, @JsonKey(name: 'seller_payout_cents')  int sellerPayoutCents, @JsonKey(name: 'shipping_cents')  int shippingCents, @JsonKey(name: 'total_cents')  int totalCents,  String currency, @JsonKey(name: 'tracking_number')  String? trackingNumber, @JsonKey(name: 'tracking_url')  String? trackingUrl,  List<OrderItemDTO> items, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'paid_at')  DateTime? paidAt, @JsonKey(name: 'shipped_at')  DateTime? shippedAt, @JsonKey(name: 'delivered_at')  DateTime? deliveredAt)  $default,) {final _that = this;
switch (_that) {
case _MarketplaceOrderDTO():
return $default(_that.orderId,_that.buyerId,_that.sellerId,_that.status,_that.subtotalCents,_that.commissionCents,_that.sellerPayoutCents,_that.shippingCents,_that.totalCents,_that.currency,_that.trackingNumber,_that.trackingUrl,_that.items,_that.createdAt,_that.paidAt,_that.shippedAt,_that.deliveredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'order_id')  String orderId, @JsonKey(name: 'buyer_id')  String? buyerId, @JsonKey(name: 'seller_id')  String? sellerId,  String status, @JsonKey(name: 'subtotal_cents')  int subtotalCents, @JsonKey(name: 'commission_cents')  int commissionCents, @JsonKey(name: 'seller_payout_cents')  int sellerPayoutCents, @JsonKey(name: 'shipping_cents')  int shippingCents, @JsonKey(name: 'total_cents')  int totalCents,  String currency, @JsonKey(name: 'tracking_number')  String? trackingNumber, @JsonKey(name: 'tracking_url')  String? trackingUrl,  List<OrderItemDTO> items, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'paid_at')  DateTime? paidAt, @JsonKey(name: 'shipped_at')  DateTime? shippedAt, @JsonKey(name: 'delivered_at')  DateTime? deliveredAt)?  $default,) {final _that = this;
switch (_that) {
case _MarketplaceOrderDTO() when $default != null:
return $default(_that.orderId,_that.buyerId,_that.sellerId,_that.status,_that.subtotalCents,_that.commissionCents,_that.sellerPayoutCents,_that.shippingCents,_that.totalCents,_that.currency,_that.trackingNumber,_that.trackingUrl,_that.items,_that.createdAt,_that.paidAt,_that.shippedAt,_that.deliveredAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MarketplaceOrderDTO implements MarketplaceOrderDTO {
  const _MarketplaceOrderDTO({@JsonKey(name: 'order_id') required this.orderId, @JsonKey(name: 'buyer_id') this.buyerId, @JsonKey(name: 'seller_id') this.sellerId, required this.status, @JsonKey(name: 'subtotal_cents') this.subtotalCents = 0, @JsonKey(name: 'commission_cents') this.commissionCents = 0, @JsonKey(name: 'seller_payout_cents') this.sellerPayoutCents = 0, @JsonKey(name: 'shipping_cents') this.shippingCents = 0, @JsonKey(name: 'total_cents') this.totalCents = 0, this.currency = 'USD', @JsonKey(name: 'tracking_number') this.trackingNumber, @JsonKey(name: 'tracking_url') this.trackingUrl, final  List<OrderItemDTO> items = const [], @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'paid_at') this.paidAt, @JsonKey(name: 'shipped_at') this.shippedAt, @JsonKey(name: 'delivered_at') this.deliveredAt}): _items = items;
  factory _MarketplaceOrderDTO.fromJson(Map<String, dynamic> json) => _$MarketplaceOrderDTOFromJson(json);

@override@JsonKey(name: 'order_id') final  String orderId;
@override@JsonKey(name: 'buyer_id') final  String? buyerId;
@override@JsonKey(name: 'seller_id') final  String? sellerId;
@override final  String status;
@override@JsonKey(name: 'subtotal_cents') final  int subtotalCents;
@override@JsonKey(name: 'commission_cents') final  int commissionCents;
@override@JsonKey(name: 'seller_payout_cents') final  int sellerPayoutCents;
@override@JsonKey(name: 'shipping_cents') final  int shippingCents;
@override@JsonKey(name: 'total_cents') final  int totalCents;
@override@JsonKey() final  String currency;
@override@JsonKey(name: 'tracking_number') final  String? trackingNumber;
@override@JsonKey(name: 'tracking_url') final  String? trackingUrl;
 final  List<OrderItemDTO> _items;
@override@JsonKey() List<OrderItemDTO> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'paid_at') final  DateTime? paidAt;
@override@JsonKey(name: 'shipped_at') final  DateTime? shippedAt;
@override@JsonKey(name: 'delivered_at') final  DateTime? deliveredAt;

/// Create a copy of MarketplaceOrderDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarketplaceOrderDTOCopyWith<_MarketplaceOrderDTO> get copyWith => __$MarketplaceOrderDTOCopyWithImpl<_MarketplaceOrderDTO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarketplaceOrderDTOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarketplaceOrderDTO&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.buyerId, buyerId) || other.buyerId == buyerId)&&(identical(other.sellerId, sellerId) || other.sellerId == sellerId)&&(identical(other.status, status) || other.status == status)&&(identical(other.subtotalCents, subtotalCents) || other.subtotalCents == subtotalCents)&&(identical(other.commissionCents, commissionCents) || other.commissionCents == commissionCents)&&(identical(other.sellerPayoutCents, sellerPayoutCents) || other.sellerPayoutCents == sellerPayoutCents)&&(identical(other.shippingCents, shippingCents) || other.shippingCents == shippingCents)&&(identical(other.totalCents, totalCents) || other.totalCents == totalCents)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.trackingNumber, trackingNumber) || other.trackingNumber == trackingNumber)&&(identical(other.trackingUrl, trackingUrl) || other.trackingUrl == trackingUrl)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.shippedAt, shippedAt) || other.shippedAt == shippedAt)&&(identical(other.deliveredAt, deliveredAt) || other.deliveredAt == deliveredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,buyerId,sellerId,status,subtotalCents,commissionCents,sellerPayoutCents,shippingCents,totalCents,currency,trackingNumber,trackingUrl,const DeepCollectionEquality().hash(_items),createdAt,paidAt,shippedAt,deliveredAt);

@override
String toString() {
  return 'MarketplaceOrderDTO(orderId: $orderId, buyerId: $buyerId, sellerId: $sellerId, status: $status, subtotalCents: $subtotalCents, commissionCents: $commissionCents, sellerPayoutCents: $sellerPayoutCents, shippingCents: $shippingCents, totalCents: $totalCents, currency: $currency, trackingNumber: $trackingNumber, trackingUrl: $trackingUrl, items: $items, createdAt: $createdAt, paidAt: $paidAt, shippedAt: $shippedAt, deliveredAt: $deliveredAt)';
}


}

/// @nodoc
abstract mixin class _$MarketplaceOrderDTOCopyWith<$Res> implements $MarketplaceOrderDTOCopyWith<$Res> {
  factory _$MarketplaceOrderDTOCopyWith(_MarketplaceOrderDTO value, $Res Function(_MarketplaceOrderDTO) _then) = __$MarketplaceOrderDTOCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'order_id') String orderId,@JsonKey(name: 'buyer_id') String? buyerId,@JsonKey(name: 'seller_id') String? sellerId, String status,@JsonKey(name: 'subtotal_cents') int subtotalCents,@JsonKey(name: 'commission_cents') int commissionCents,@JsonKey(name: 'seller_payout_cents') int sellerPayoutCents,@JsonKey(name: 'shipping_cents') int shippingCents,@JsonKey(name: 'total_cents') int totalCents, String currency,@JsonKey(name: 'tracking_number') String? trackingNumber,@JsonKey(name: 'tracking_url') String? trackingUrl, List<OrderItemDTO> items,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'paid_at') DateTime? paidAt,@JsonKey(name: 'shipped_at') DateTime? shippedAt,@JsonKey(name: 'delivered_at') DateTime? deliveredAt
});




}
/// @nodoc
class __$MarketplaceOrderDTOCopyWithImpl<$Res>
    implements _$MarketplaceOrderDTOCopyWith<$Res> {
  __$MarketplaceOrderDTOCopyWithImpl(this._self, this._then);

  final _MarketplaceOrderDTO _self;
  final $Res Function(_MarketplaceOrderDTO) _then;

/// Create a copy of MarketplaceOrderDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? buyerId = freezed,Object? sellerId = freezed,Object? status = null,Object? subtotalCents = null,Object? commissionCents = null,Object? sellerPayoutCents = null,Object? shippingCents = null,Object? totalCents = null,Object? currency = null,Object? trackingNumber = freezed,Object? trackingUrl = freezed,Object? items = null,Object? createdAt = freezed,Object? paidAt = freezed,Object? shippedAt = freezed,Object? deliveredAt = freezed,}) {
  return _then(_MarketplaceOrderDTO(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,buyerId: freezed == buyerId ? _self.buyerId : buyerId // ignore: cast_nullable_to_non_nullable
as String?,sellerId: freezed == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,subtotalCents: null == subtotalCents ? _self.subtotalCents : subtotalCents // ignore: cast_nullable_to_non_nullable
as int,commissionCents: null == commissionCents ? _self.commissionCents : commissionCents // ignore: cast_nullable_to_non_nullable
as int,sellerPayoutCents: null == sellerPayoutCents ? _self.sellerPayoutCents : sellerPayoutCents // ignore: cast_nullable_to_non_nullable
as int,shippingCents: null == shippingCents ? _self.shippingCents : shippingCents // ignore: cast_nullable_to_non_nullable
as int,totalCents: null == totalCents ? _self.totalCents : totalCents // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,trackingNumber: freezed == trackingNumber ? _self.trackingNumber : trackingNumber // ignore: cast_nullable_to_non_nullable
as String?,trackingUrl: freezed == trackingUrl ? _self.trackingUrl : trackingUrl // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemDTO>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,shippedAt: freezed == shippedAt ? _self.shippedAt : shippedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveredAt: freezed == deliveredAt ? _self.deliveredAt : deliveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$OrderItemDTO {

@JsonKey(name: 'item_id') String? get itemId;@JsonKey(name: 'product_id') String get productId; String get title;@JsonKey(name: 'price_cents') int get priceCents; int get quantity;@JsonKey(name: 'image_url') String? get imageUrl;
/// Create a copy of OrderItemDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderItemDTOCopyWith<OrderItemDTO> get copyWith => _$OrderItemDTOCopyWithImpl<OrderItemDTO>(this as OrderItemDTO, _$identity);

  /// Serializes this OrderItemDTO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderItemDTO&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.title, title) || other.title == title)&&(identical(other.priceCents, priceCents) || other.priceCents == priceCents)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,productId,title,priceCents,quantity,imageUrl);

@override
String toString() {
  return 'OrderItemDTO(itemId: $itemId, productId: $productId, title: $title, priceCents: $priceCents, quantity: $quantity, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $OrderItemDTOCopyWith<$Res>  {
  factory $OrderItemDTOCopyWith(OrderItemDTO value, $Res Function(OrderItemDTO) _then) = _$OrderItemDTOCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'item_id') String? itemId,@JsonKey(name: 'product_id') String productId, String title,@JsonKey(name: 'price_cents') int priceCents, int quantity,@JsonKey(name: 'image_url') String? imageUrl
});




}
/// @nodoc
class _$OrderItemDTOCopyWithImpl<$Res>
    implements $OrderItemDTOCopyWith<$Res> {
  _$OrderItemDTOCopyWithImpl(this._self, this._then);

  final OrderItemDTO _self;
  final $Res Function(OrderItemDTO) _then;

/// Create a copy of OrderItemDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = freezed,Object? productId = null,Object? title = null,Object? priceCents = null,Object? quantity = null,Object? imageUrl = freezed,}) {
  return _then(_self.copyWith(
itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderItemDTO].
extension OrderItemDTOPatterns on OrderItemDTO {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderItemDTO value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderItemDTO() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderItemDTO value)  $default,){
final _that = this;
switch (_that) {
case _OrderItemDTO():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderItemDTO value)?  $default,){
final _that = this;
switch (_that) {
case _OrderItemDTO() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'item_id')  String? itemId, @JsonKey(name: 'product_id')  String productId,  String title, @JsonKey(name: 'price_cents')  int priceCents,  int quantity, @JsonKey(name: 'image_url')  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderItemDTO() when $default != null:
return $default(_that.itemId,_that.productId,_that.title,_that.priceCents,_that.quantity,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'item_id')  String? itemId, @JsonKey(name: 'product_id')  String productId,  String title, @JsonKey(name: 'price_cents')  int priceCents,  int quantity, @JsonKey(name: 'image_url')  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _OrderItemDTO():
return $default(_that.itemId,_that.productId,_that.title,_that.priceCents,_that.quantity,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'item_id')  String? itemId, @JsonKey(name: 'product_id')  String productId,  String title, @JsonKey(name: 'price_cents')  int priceCents,  int quantity, @JsonKey(name: 'image_url')  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _OrderItemDTO() when $default != null:
return $default(_that.itemId,_that.productId,_that.title,_that.priceCents,_that.quantity,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderItemDTO implements OrderItemDTO {
  const _OrderItemDTO({@JsonKey(name: 'item_id') this.itemId, @JsonKey(name: 'product_id') required this.productId, required this.title, @JsonKey(name: 'price_cents') required this.priceCents, this.quantity = 1, @JsonKey(name: 'image_url') this.imageUrl});
  factory _OrderItemDTO.fromJson(Map<String, dynamic> json) => _$OrderItemDTOFromJson(json);

@override@JsonKey(name: 'item_id') final  String? itemId;
@override@JsonKey(name: 'product_id') final  String productId;
@override final  String title;
@override@JsonKey(name: 'price_cents') final  int priceCents;
@override@JsonKey() final  int quantity;
@override@JsonKey(name: 'image_url') final  String? imageUrl;

/// Create a copy of OrderItemDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderItemDTOCopyWith<_OrderItemDTO> get copyWith => __$OrderItemDTOCopyWithImpl<_OrderItemDTO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderItemDTOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderItemDTO&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.title, title) || other.title == title)&&(identical(other.priceCents, priceCents) || other.priceCents == priceCents)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,productId,title,priceCents,quantity,imageUrl);

@override
String toString() {
  return 'OrderItemDTO(itemId: $itemId, productId: $productId, title: $title, priceCents: $priceCents, quantity: $quantity, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$OrderItemDTOCopyWith<$Res> implements $OrderItemDTOCopyWith<$Res> {
  factory _$OrderItemDTOCopyWith(_OrderItemDTO value, $Res Function(_OrderItemDTO) _then) = __$OrderItemDTOCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'item_id') String? itemId,@JsonKey(name: 'product_id') String productId, String title,@JsonKey(name: 'price_cents') int priceCents, int quantity,@JsonKey(name: 'image_url') String? imageUrl
});




}
/// @nodoc
class __$OrderItemDTOCopyWithImpl<$Res>
    implements _$OrderItemDTOCopyWith<$Res> {
  __$OrderItemDTOCopyWithImpl(this._self, this._then);

  final _OrderItemDTO _self;
  final $Res Function(_OrderItemDTO) _then;

/// Create a copy of OrderItemDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = freezed,Object? productId = null,Object? title = null,Object? priceCents = null,Object? quantity = null,Object? imageUrl = freezed,}) {
  return _then(_OrderItemDTO(
itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ReviewDTO {

@JsonKey(name: 'review_id') String get reviewId;@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'reviewer_id') String? get reviewerId;@JsonKey(name: 'reviewer_name') String? get reviewerName; int get rating; String? get title; String? get body;@JsonKey(name: 'helpful_count') int get helpfulCount;@JsonKey(name: 'verified_purchase') bool get verifiedPurchase;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of ReviewDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewDTOCopyWith<ReviewDTO> get copyWith => _$ReviewDTOCopyWithImpl<ReviewDTO>(this as ReviewDTO, _$identity);

  /// Serializes this ReviewDTO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewDTO&&(identical(other.reviewId, reviewId) || other.reviewId == reviewId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.reviewerId, reviewerId) || other.reviewerId == reviewerId)&&(identical(other.reviewerName, reviewerName) || other.reviewerName == reviewerName)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.helpfulCount, helpfulCount) || other.helpfulCount == helpfulCount)&&(identical(other.verifiedPurchase, verifiedPurchase) || other.verifiedPurchase == verifiedPurchase)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reviewId,productId,reviewerId,reviewerName,rating,title,body,helpfulCount,verifiedPurchase,createdAt);

@override
String toString() {
  return 'ReviewDTO(reviewId: $reviewId, productId: $productId, reviewerId: $reviewerId, reviewerName: $reviewerName, rating: $rating, title: $title, body: $body, helpfulCount: $helpfulCount, verifiedPurchase: $verifiedPurchase, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ReviewDTOCopyWith<$Res>  {
  factory $ReviewDTOCopyWith(ReviewDTO value, $Res Function(ReviewDTO) _then) = _$ReviewDTOCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'review_id') String reviewId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'reviewer_id') String? reviewerId,@JsonKey(name: 'reviewer_name') String? reviewerName, int rating, String? title, String? body,@JsonKey(name: 'helpful_count') int helpfulCount,@JsonKey(name: 'verified_purchase') bool verifiedPurchase,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$ReviewDTOCopyWithImpl<$Res>
    implements $ReviewDTOCopyWith<$Res> {
  _$ReviewDTOCopyWithImpl(this._self, this._then);

  final ReviewDTO _self;
  final $Res Function(ReviewDTO) _then;

/// Create a copy of ReviewDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reviewId = null,Object? productId = null,Object? reviewerId = freezed,Object? reviewerName = freezed,Object? rating = null,Object? title = freezed,Object? body = freezed,Object? helpfulCount = null,Object? verifiedPurchase = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
reviewId: null == reviewId ? _self.reviewId : reviewId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,reviewerId: freezed == reviewerId ? _self.reviewerId : reviewerId // ignore: cast_nullable_to_non_nullable
as String?,reviewerName: freezed == reviewerName ? _self.reviewerName : reviewerName // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,helpfulCount: null == helpfulCount ? _self.helpfulCount : helpfulCount // ignore: cast_nullable_to_non_nullable
as int,verifiedPurchase: null == verifiedPurchase ? _self.verifiedPurchase : verifiedPurchase // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewDTO].
extension ReviewDTOPatterns on ReviewDTO {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewDTO value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewDTO() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewDTO value)  $default,){
final _that = this;
switch (_that) {
case _ReviewDTO():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewDTO value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewDTO() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'review_id')  String reviewId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'reviewer_id')  String? reviewerId, @JsonKey(name: 'reviewer_name')  String? reviewerName,  int rating,  String? title,  String? body, @JsonKey(name: 'helpful_count')  int helpfulCount, @JsonKey(name: 'verified_purchase')  bool verifiedPurchase, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewDTO() when $default != null:
return $default(_that.reviewId,_that.productId,_that.reviewerId,_that.reviewerName,_that.rating,_that.title,_that.body,_that.helpfulCount,_that.verifiedPurchase,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'review_id')  String reviewId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'reviewer_id')  String? reviewerId, @JsonKey(name: 'reviewer_name')  String? reviewerName,  int rating,  String? title,  String? body, @JsonKey(name: 'helpful_count')  int helpfulCount, @JsonKey(name: 'verified_purchase')  bool verifiedPurchase, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ReviewDTO():
return $default(_that.reviewId,_that.productId,_that.reviewerId,_that.reviewerName,_that.rating,_that.title,_that.body,_that.helpfulCount,_that.verifiedPurchase,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'review_id')  String reviewId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'reviewer_id')  String? reviewerId, @JsonKey(name: 'reviewer_name')  String? reviewerName,  int rating,  String? title,  String? body, @JsonKey(name: 'helpful_count')  int helpfulCount, @JsonKey(name: 'verified_purchase')  bool verifiedPurchase, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ReviewDTO() when $default != null:
return $default(_that.reviewId,_that.productId,_that.reviewerId,_that.reviewerName,_that.rating,_that.title,_that.body,_that.helpfulCount,_that.verifiedPurchase,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReviewDTO implements ReviewDTO {
  const _ReviewDTO({@JsonKey(name: 'review_id') required this.reviewId, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'reviewer_id') this.reviewerId, @JsonKey(name: 'reviewer_name') this.reviewerName, required this.rating, this.title, this.body, @JsonKey(name: 'helpful_count') this.helpfulCount = 0, @JsonKey(name: 'verified_purchase') this.verifiedPurchase = false, @JsonKey(name: 'created_at') this.createdAt});
  factory _ReviewDTO.fromJson(Map<String, dynamic> json) => _$ReviewDTOFromJson(json);

@override@JsonKey(name: 'review_id') final  String reviewId;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'reviewer_id') final  String? reviewerId;
@override@JsonKey(name: 'reviewer_name') final  String? reviewerName;
@override final  int rating;
@override final  String? title;
@override final  String? body;
@override@JsonKey(name: 'helpful_count') final  int helpfulCount;
@override@JsonKey(name: 'verified_purchase') final  bool verifiedPurchase;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of ReviewDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewDTOCopyWith<_ReviewDTO> get copyWith => __$ReviewDTOCopyWithImpl<_ReviewDTO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewDTOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewDTO&&(identical(other.reviewId, reviewId) || other.reviewId == reviewId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.reviewerId, reviewerId) || other.reviewerId == reviewerId)&&(identical(other.reviewerName, reviewerName) || other.reviewerName == reviewerName)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.helpfulCount, helpfulCount) || other.helpfulCount == helpfulCount)&&(identical(other.verifiedPurchase, verifiedPurchase) || other.verifiedPurchase == verifiedPurchase)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reviewId,productId,reviewerId,reviewerName,rating,title,body,helpfulCount,verifiedPurchase,createdAt);

@override
String toString() {
  return 'ReviewDTO(reviewId: $reviewId, productId: $productId, reviewerId: $reviewerId, reviewerName: $reviewerName, rating: $rating, title: $title, body: $body, helpfulCount: $helpfulCount, verifiedPurchase: $verifiedPurchase, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ReviewDTOCopyWith<$Res> implements $ReviewDTOCopyWith<$Res> {
  factory _$ReviewDTOCopyWith(_ReviewDTO value, $Res Function(_ReviewDTO) _then) = __$ReviewDTOCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'review_id') String reviewId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'reviewer_id') String? reviewerId,@JsonKey(name: 'reviewer_name') String? reviewerName, int rating, String? title, String? body,@JsonKey(name: 'helpful_count') int helpfulCount,@JsonKey(name: 'verified_purchase') bool verifiedPurchase,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$ReviewDTOCopyWithImpl<$Res>
    implements _$ReviewDTOCopyWith<$Res> {
  __$ReviewDTOCopyWithImpl(this._self, this._then);

  final _ReviewDTO _self;
  final $Res Function(_ReviewDTO) _then;

/// Create a copy of ReviewDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reviewId = null,Object? productId = null,Object? reviewerId = freezed,Object? reviewerName = freezed,Object? rating = null,Object? title = freezed,Object? body = freezed,Object? helpfulCount = null,Object? verifiedPurchase = null,Object? createdAt = freezed,}) {
  return _then(_ReviewDTO(
reviewId: null == reviewId ? _self.reviewId : reviewId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,reviewerId: freezed == reviewerId ? _self.reviewerId : reviewerId // ignore: cast_nullable_to_non_nullable
as String?,reviewerName: freezed == reviewerName ? _self.reviewerName : reviewerName // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,helpfulCount: null == helpfulCount ? _self.helpfulCount : helpfulCount // ignore: cast_nullable_to_non_nullable
as int,verifiedPurchase: null == verifiedPurchase ? _self.verifiedPurchase : verifiedPurchase // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$SellerDashboardDTO {

@JsonKey(name: 'seller_id') String? get sellerId;@JsonKey(name: 'store_name') String? get storeName;@JsonKey(name: 'store_slug') String? get storeSlug; String? get description;@JsonKey(name: 'logo_url') String? get logoUrl;@JsonKey(name: 'stripe_onboarded') bool get stripeOnboarded;@JsonKey(name: 'commission_rate') double get commissionRate;@JsonKey(name: 'rating_avg') double get ratingAvg;@JsonKey(name: 'rating_count') int get ratingCount; String get status;@JsonKey(name: 'active_listings') int get activeListings;@JsonKey(name: 'total_sales') int get totalSales;@JsonKey(name: 'total_earnings_cents') int get totalEarningsCents;@JsonKey(name: 'pending_orders') int get pendingOrders;
/// Create a copy of SellerDashboardDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SellerDashboardDTOCopyWith<SellerDashboardDTO> get copyWith => _$SellerDashboardDTOCopyWithImpl<SellerDashboardDTO>(this as SellerDashboardDTO, _$identity);

  /// Serializes this SellerDashboardDTO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SellerDashboardDTO&&(identical(other.sellerId, sellerId) || other.sellerId == sellerId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.storeSlug, storeSlug) || other.storeSlug == storeSlug)&&(identical(other.description, description) || other.description == description)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.stripeOnboarded, stripeOnboarded) || other.stripeOnboarded == stripeOnboarded)&&(identical(other.commissionRate, commissionRate) || other.commissionRate == commissionRate)&&(identical(other.ratingAvg, ratingAvg) || other.ratingAvg == ratingAvg)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.status, status) || other.status == status)&&(identical(other.activeListings, activeListings) || other.activeListings == activeListings)&&(identical(other.totalSales, totalSales) || other.totalSales == totalSales)&&(identical(other.totalEarningsCents, totalEarningsCents) || other.totalEarningsCents == totalEarningsCents)&&(identical(other.pendingOrders, pendingOrders) || other.pendingOrders == pendingOrders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sellerId,storeName,storeSlug,description,logoUrl,stripeOnboarded,commissionRate,ratingAvg,ratingCount,status,activeListings,totalSales,totalEarningsCents,pendingOrders);

@override
String toString() {
  return 'SellerDashboardDTO(sellerId: $sellerId, storeName: $storeName, storeSlug: $storeSlug, description: $description, logoUrl: $logoUrl, stripeOnboarded: $stripeOnboarded, commissionRate: $commissionRate, ratingAvg: $ratingAvg, ratingCount: $ratingCount, status: $status, activeListings: $activeListings, totalSales: $totalSales, totalEarningsCents: $totalEarningsCents, pendingOrders: $pendingOrders)';
}


}

/// @nodoc
abstract mixin class $SellerDashboardDTOCopyWith<$Res>  {
  factory $SellerDashboardDTOCopyWith(SellerDashboardDTO value, $Res Function(SellerDashboardDTO) _then) = _$SellerDashboardDTOCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'seller_id') String? sellerId,@JsonKey(name: 'store_name') String? storeName,@JsonKey(name: 'store_slug') String? storeSlug, String? description,@JsonKey(name: 'logo_url') String? logoUrl,@JsonKey(name: 'stripe_onboarded') bool stripeOnboarded,@JsonKey(name: 'commission_rate') double commissionRate,@JsonKey(name: 'rating_avg') double ratingAvg,@JsonKey(name: 'rating_count') int ratingCount, String status,@JsonKey(name: 'active_listings') int activeListings,@JsonKey(name: 'total_sales') int totalSales,@JsonKey(name: 'total_earnings_cents') int totalEarningsCents,@JsonKey(name: 'pending_orders') int pendingOrders
});




}
/// @nodoc
class _$SellerDashboardDTOCopyWithImpl<$Res>
    implements $SellerDashboardDTOCopyWith<$Res> {
  _$SellerDashboardDTOCopyWithImpl(this._self, this._then);

  final SellerDashboardDTO _self;
  final $Res Function(SellerDashboardDTO) _then;

/// Create a copy of SellerDashboardDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sellerId = freezed,Object? storeName = freezed,Object? storeSlug = freezed,Object? description = freezed,Object? logoUrl = freezed,Object? stripeOnboarded = null,Object? commissionRate = null,Object? ratingAvg = null,Object? ratingCount = null,Object? status = null,Object? activeListings = null,Object? totalSales = null,Object? totalEarningsCents = null,Object? pendingOrders = null,}) {
  return _then(_self.copyWith(
sellerId: freezed == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as String?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,storeSlug: freezed == storeSlug ? _self.storeSlug : storeSlug // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,stripeOnboarded: null == stripeOnboarded ? _self.stripeOnboarded : stripeOnboarded // ignore: cast_nullable_to_non_nullable
as bool,commissionRate: null == commissionRate ? _self.commissionRate : commissionRate // ignore: cast_nullable_to_non_nullable
as double,ratingAvg: null == ratingAvg ? _self.ratingAvg : ratingAvg // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,activeListings: null == activeListings ? _self.activeListings : activeListings // ignore: cast_nullable_to_non_nullable
as int,totalSales: null == totalSales ? _self.totalSales : totalSales // ignore: cast_nullable_to_non_nullable
as int,totalEarningsCents: null == totalEarningsCents ? _self.totalEarningsCents : totalEarningsCents // ignore: cast_nullable_to_non_nullable
as int,pendingOrders: null == pendingOrders ? _self.pendingOrders : pendingOrders // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SellerDashboardDTO].
extension SellerDashboardDTOPatterns on SellerDashboardDTO {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SellerDashboardDTO value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SellerDashboardDTO() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SellerDashboardDTO value)  $default,){
final _that = this;
switch (_that) {
case _SellerDashboardDTO():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SellerDashboardDTO value)?  $default,){
final _that = this;
switch (_that) {
case _SellerDashboardDTO() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'seller_id')  String? sellerId, @JsonKey(name: 'store_name')  String? storeName, @JsonKey(name: 'store_slug')  String? storeSlug,  String? description, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'stripe_onboarded')  bool stripeOnboarded, @JsonKey(name: 'commission_rate')  double commissionRate, @JsonKey(name: 'rating_avg')  double ratingAvg, @JsonKey(name: 'rating_count')  int ratingCount,  String status, @JsonKey(name: 'active_listings')  int activeListings, @JsonKey(name: 'total_sales')  int totalSales, @JsonKey(name: 'total_earnings_cents')  int totalEarningsCents, @JsonKey(name: 'pending_orders')  int pendingOrders)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SellerDashboardDTO() when $default != null:
return $default(_that.sellerId,_that.storeName,_that.storeSlug,_that.description,_that.logoUrl,_that.stripeOnboarded,_that.commissionRate,_that.ratingAvg,_that.ratingCount,_that.status,_that.activeListings,_that.totalSales,_that.totalEarningsCents,_that.pendingOrders);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'seller_id')  String? sellerId, @JsonKey(name: 'store_name')  String? storeName, @JsonKey(name: 'store_slug')  String? storeSlug,  String? description, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'stripe_onboarded')  bool stripeOnboarded, @JsonKey(name: 'commission_rate')  double commissionRate, @JsonKey(name: 'rating_avg')  double ratingAvg, @JsonKey(name: 'rating_count')  int ratingCount,  String status, @JsonKey(name: 'active_listings')  int activeListings, @JsonKey(name: 'total_sales')  int totalSales, @JsonKey(name: 'total_earnings_cents')  int totalEarningsCents, @JsonKey(name: 'pending_orders')  int pendingOrders)  $default,) {final _that = this;
switch (_that) {
case _SellerDashboardDTO():
return $default(_that.sellerId,_that.storeName,_that.storeSlug,_that.description,_that.logoUrl,_that.stripeOnboarded,_that.commissionRate,_that.ratingAvg,_that.ratingCount,_that.status,_that.activeListings,_that.totalSales,_that.totalEarningsCents,_that.pendingOrders);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'seller_id')  String? sellerId, @JsonKey(name: 'store_name')  String? storeName, @JsonKey(name: 'store_slug')  String? storeSlug,  String? description, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'stripe_onboarded')  bool stripeOnboarded, @JsonKey(name: 'commission_rate')  double commissionRate, @JsonKey(name: 'rating_avg')  double ratingAvg, @JsonKey(name: 'rating_count')  int ratingCount,  String status, @JsonKey(name: 'active_listings')  int activeListings, @JsonKey(name: 'total_sales')  int totalSales, @JsonKey(name: 'total_earnings_cents')  int totalEarningsCents, @JsonKey(name: 'pending_orders')  int pendingOrders)?  $default,) {final _that = this;
switch (_that) {
case _SellerDashboardDTO() when $default != null:
return $default(_that.sellerId,_that.storeName,_that.storeSlug,_that.description,_that.logoUrl,_that.stripeOnboarded,_that.commissionRate,_that.ratingAvg,_that.ratingCount,_that.status,_that.activeListings,_that.totalSales,_that.totalEarningsCents,_that.pendingOrders);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SellerDashboardDTO implements SellerDashboardDTO {
  const _SellerDashboardDTO({@JsonKey(name: 'seller_id') this.sellerId, @JsonKey(name: 'store_name') this.storeName, @JsonKey(name: 'store_slug') this.storeSlug, this.description, @JsonKey(name: 'logo_url') this.logoUrl, @JsonKey(name: 'stripe_onboarded') this.stripeOnboarded = false, @JsonKey(name: 'commission_rate') this.commissionRate = 12.0, @JsonKey(name: 'rating_avg') this.ratingAvg = 0, @JsonKey(name: 'rating_count') this.ratingCount = 0, this.status = 'pending', @JsonKey(name: 'active_listings') this.activeListings = 0, @JsonKey(name: 'total_sales') this.totalSales = 0, @JsonKey(name: 'total_earnings_cents') this.totalEarningsCents = 0, @JsonKey(name: 'pending_orders') this.pendingOrders = 0});
  factory _SellerDashboardDTO.fromJson(Map<String, dynamic> json) => _$SellerDashboardDTOFromJson(json);

@override@JsonKey(name: 'seller_id') final  String? sellerId;
@override@JsonKey(name: 'store_name') final  String? storeName;
@override@JsonKey(name: 'store_slug') final  String? storeSlug;
@override final  String? description;
@override@JsonKey(name: 'logo_url') final  String? logoUrl;
@override@JsonKey(name: 'stripe_onboarded') final  bool stripeOnboarded;
@override@JsonKey(name: 'commission_rate') final  double commissionRate;
@override@JsonKey(name: 'rating_avg') final  double ratingAvg;
@override@JsonKey(name: 'rating_count') final  int ratingCount;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'active_listings') final  int activeListings;
@override@JsonKey(name: 'total_sales') final  int totalSales;
@override@JsonKey(name: 'total_earnings_cents') final  int totalEarningsCents;
@override@JsonKey(name: 'pending_orders') final  int pendingOrders;

/// Create a copy of SellerDashboardDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SellerDashboardDTOCopyWith<_SellerDashboardDTO> get copyWith => __$SellerDashboardDTOCopyWithImpl<_SellerDashboardDTO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SellerDashboardDTOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SellerDashboardDTO&&(identical(other.sellerId, sellerId) || other.sellerId == sellerId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.storeSlug, storeSlug) || other.storeSlug == storeSlug)&&(identical(other.description, description) || other.description == description)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.stripeOnboarded, stripeOnboarded) || other.stripeOnboarded == stripeOnboarded)&&(identical(other.commissionRate, commissionRate) || other.commissionRate == commissionRate)&&(identical(other.ratingAvg, ratingAvg) || other.ratingAvg == ratingAvg)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.status, status) || other.status == status)&&(identical(other.activeListings, activeListings) || other.activeListings == activeListings)&&(identical(other.totalSales, totalSales) || other.totalSales == totalSales)&&(identical(other.totalEarningsCents, totalEarningsCents) || other.totalEarningsCents == totalEarningsCents)&&(identical(other.pendingOrders, pendingOrders) || other.pendingOrders == pendingOrders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sellerId,storeName,storeSlug,description,logoUrl,stripeOnboarded,commissionRate,ratingAvg,ratingCount,status,activeListings,totalSales,totalEarningsCents,pendingOrders);

@override
String toString() {
  return 'SellerDashboardDTO(sellerId: $sellerId, storeName: $storeName, storeSlug: $storeSlug, description: $description, logoUrl: $logoUrl, stripeOnboarded: $stripeOnboarded, commissionRate: $commissionRate, ratingAvg: $ratingAvg, ratingCount: $ratingCount, status: $status, activeListings: $activeListings, totalSales: $totalSales, totalEarningsCents: $totalEarningsCents, pendingOrders: $pendingOrders)';
}


}

/// @nodoc
abstract mixin class _$SellerDashboardDTOCopyWith<$Res> implements $SellerDashboardDTOCopyWith<$Res> {
  factory _$SellerDashboardDTOCopyWith(_SellerDashboardDTO value, $Res Function(_SellerDashboardDTO) _then) = __$SellerDashboardDTOCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'seller_id') String? sellerId,@JsonKey(name: 'store_name') String? storeName,@JsonKey(name: 'store_slug') String? storeSlug, String? description,@JsonKey(name: 'logo_url') String? logoUrl,@JsonKey(name: 'stripe_onboarded') bool stripeOnboarded,@JsonKey(name: 'commission_rate') double commissionRate,@JsonKey(name: 'rating_avg') double ratingAvg,@JsonKey(name: 'rating_count') int ratingCount, String status,@JsonKey(name: 'active_listings') int activeListings,@JsonKey(name: 'total_sales') int totalSales,@JsonKey(name: 'total_earnings_cents') int totalEarningsCents,@JsonKey(name: 'pending_orders') int pendingOrders
});




}
/// @nodoc
class __$SellerDashboardDTOCopyWithImpl<$Res>
    implements _$SellerDashboardDTOCopyWith<$Res> {
  __$SellerDashboardDTOCopyWithImpl(this._self, this._then);

  final _SellerDashboardDTO _self;
  final $Res Function(_SellerDashboardDTO) _then;

/// Create a copy of SellerDashboardDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sellerId = freezed,Object? storeName = freezed,Object? storeSlug = freezed,Object? description = freezed,Object? logoUrl = freezed,Object? stripeOnboarded = null,Object? commissionRate = null,Object? ratingAvg = null,Object? ratingCount = null,Object? status = null,Object? activeListings = null,Object? totalSales = null,Object? totalEarningsCents = null,Object? pendingOrders = null,}) {
  return _then(_SellerDashboardDTO(
sellerId: freezed == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as String?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,storeSlug: freezed == storeSlug ? _self.storeSlug : storeSlug // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,stripeOnboarded: null == stripeOnboarded ? _self.stripeOnboarded : stripeOnboarded // ignore: cast_nullable_to_non_nullable
as bool,commissionRate: null == commissionRate ? _self.commissionRate : commissionRate // ignore: cast_nullable_to_non_nullable
as double,ratingAvg: null == ratingAvg ? _self.ratingAvg : ratingAvg // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,activeListings: null == activeListings ? _self.activeListings : activeListings // ignore: cast_nullable_to_non_nullable
as int,totalSales: null == totalSales ? _self.totalSales : totalSales // ignore: cast_nullable_to_non_nullable
as int,totalEarningsCents: null == totalEarningsCents ? _self.totalEarningsCents : totalEarningsCents // ignore: cast_nullable_to_non_nullable
as int,pendingOrders: null == pendingOrders ? _self.pendingOrders : pendingOrders // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CheckoutSessionDTO {

@JsonKey(name: 'session_id') String get sessionId;@JsonKey(name: 'client_secret') String get clientSecret;@JsonKey(name: 'ephemeral_key') String get ephemeralKey;@JsonKey(name: 'customer_id') String get customerId;@JsonKey(name: 'total_cents') int get totalCents; String get currency;
/// Create a copy of CheckoutSessionDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutSessionDTOCopyWith<CheckoutSessionDTO> get copyWith => _$CheckoutSessionDTOCopyWithImpl<CheckoutSessionDTO>(this as CheckoutSessionDTO, _$identity);

  /// Serializes this CheckoutSessionDTO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutSessionDTO&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.clientSecret, clientSecret) || other.clientSecret == clientSecret)&&(identical(other.ephemeralKey, ephemeralKey) || other.ephemeralKey == ephemeralKey)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.totalCents, totalCents) || other.totalCents == totalCents)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,clientSecret,ephemeralKey,customerId,totalCents,currency);

@override
String toString() {
  return 'CheckoutSessionDTO(sessionId: $sessionId, clientSecret: $clientSecret, ephemeralKey: $ephemeralKey, customerId: $customerId, totalCents: $totalCents, currency: $currency)';
}


}

/// @nodoc
abstract mixin class $CheckoutSessionDTOCopyWith<$Res>  {
  factory $CheckoutSessionDTOCopyWith(CheckoutSessionDTO value, $Res Function(CheckoutSessionDTO) _then) = _$CheckoutSessionDTOCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'client_secret') String clientSecret,@JsonKey(name: 'ephemeral_key') String ephemeralKey,@JsonKey(name: 'customer_id') String customerId,@JsonKey(name: 'total_cents') int totalCents, String currency
});




}
/// @nodoc
class _$CheckoutSessionDTOCopyWithImpl<$Res>
    implements $CheckoutSessionDTOCopyWith<$Res> {
  _$CheckoutSessionDTOCopyWithImpl(this._self, this._then);

  final CheckoutSessionDTO _self;
  final $Res Function(CheckoutSessionDTO) _then;

/// Create a copy of CheckoutSessionDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? clientSecret = null,Object? ephemeralKey = null,Object? customerId = null,Object? totalCents = null,Object? currency = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,clientSecret: null == clientSecret ? _self.clientSecret : clientSecret // ignore: cast_nullable_to_non_nullable
as String,ephemeralKey: null == ephemeralKey ? _self.ephemeralKey : ephemeralKey // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,totalCents: null == totalCents ? _self.totalCents : totalCents // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckoutSessionDTO].
extension CheckoutSessionDTOPatterns on CheckoutSessionDTO {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckoutSessionDTO value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckoutSessionDTO() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckoutSessionDTO value)  $default,){
final _that = this;
switch (_that) {
case _CheckoutSessionDTO():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckoutSessionDTO value)?  $default,){
final _that = this;
switch (_that) {
case _CheckoutSessionDTO() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'client_secret')  String clientSecret, @JsonKey(name: 'ephemeral_key')  String ephemeralKey, @JsonKey(name: 'customer_id')  String customerId, @JsonKey(name: 'total_cents')  int totalCents,  String currency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckoutSessionDTO() when $default != null:
return $default(_that.sessionId,_that.clientSecret,_that.ephemeralKey,_that.customerId,_that.totalCents,_that.currency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'client_secret')  String clientSecret, @JsonKey(name: 'ephemeral_key')  String ephemeralKey, @JsonKey(name: 'customer_id')  String customerId, @JsonKey(name: 'total_cents')  int totalCents,  String currency)  $default,) {final _that = this;
switch (_that) {
case _CheckoutSessionDTO():
return $default(_that.sessionId,_that.clientSecret,_that.ephemeralKey,_that.customerId,_that.totalCents,_that.currency);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'client_secret')  String clientSecret, @JsonKey(name: 'ephemeral_key')  String ephemeralKey, @JsonKey(name: 'customer_id')  String customerId, @JsonKey(name: 'total_cents')  int totalCents,  String currency)?  $default,) {final _that = this;
switch (_that) {
case _CheckoutSessionDTO() when $default != null:
return $default(_that.sessionId,_that.clientSecret,_that.ephemeralKey,_that.customerId,_that.totalCents,_that.currency);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CheckoutSessionDTO implements CheckoutSessionDTO {
  const _CheckoutSessionDTO({@JsonKey(name: 'session_id') required this.sessionId, @JsonKey(name: 'client_secret') required this.clientSecret, @JsonKey(name: 'ephemeral_key') required this.ephemeralKey, @JsonKey(name: 'customer_id') required this.customerId, @JsonKey(name: 'total_cents') required this.totalCents, this.currency = 'USD'});
  factory _CheckoutSessionDTO.fromJson(Map<String, dynamic> json) => _$CheckoutSessionDTOFromJson(json);

@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey(name: 'client_secret') final  String clientSecret;
@override@JsonKey(name: 'ephemeral_key') final  String ephemeralKey;
@override@JsonKey(name: 'customer_id') final  String customerId;
@override@JsonKey(name: 'total_cents') final  int totalCents;
@override@JsonKey() final  String currency;

/// Create a copy of CheckoutSessionDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckoutSessionDTOCopyWith<_CheckoutSessionDTO> get copyWith => __$CheckoutSessionDTOCopyWithImpl<_CheckoutSessionDTO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CheckoutSessionDTOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckoutSessionDTO&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.clientSecret, clientSecret) || other.clientSecret == clientSecret)&&(identical(other.ephemeralKey, ephemeralKey) || other.ephemeralKey == ephemeralKey)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.totalCents, totalCents) || other.totalCents == totalCents)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,clientSecret,ephemeralKey,customerId,totalCents,currency);

@override
String toString() {
  return 'CheckoutSessionDTO(sessionId: $sessionId, clientSecret: $clientSecret, ephemeralKey: $ephemeralKey, customerId: $customerId, totalCents: $totalCents, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$CheckoutSessionDTOCopyWith<$Res> implements $CheckoutSessionDTOCopyWith<$Res> {
  factory _$CheckoutSessionDTOCopyWith(_CheckoutSessionDTO value, $Res Function(_CheckoutSessionDTO) _then) = __$CheckoutSessionDTOCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'client_secret') String clientSecret,@JsonKey(name: 'ephemeral_key') String ephemeralKey,@JsonKey(name: 'customer_id') String customerId,@JsonKey(name: 'total_cents') int totalCents, String currency
});




}
/// @nodoc
class __$CheckoutSessionDTOCopyWithImpl<$Res>
    implements _$CheckoutSessionDTOCopyWith<$Res> {
  __$CheckoutSessionDTOCopyWithImpl(this._self, this._then);

  final _CheckoutSessionDTO _self;
  final $Res Function(_CheckoutSessionDTO) _then;

/// Create a copy of CheckoutSessionDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? clientSecret = null,Object? ephemeralKey = null,Object? customerId = null,Object? totalCents = null,Object? currency = null,}) {
  return _then(_CheckoutSessionDTO(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,clientSecret: null == clientSecret ? _self.clientSecret : clientSecret // ignore: cast_nullable_to_non_nullable
as String,ephemeralKey: null == ephemeralKey ? _self.ephemeralKey : ephemeralKey // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,totalCents: null == totalCents ? _self.totalCents : totalCents // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
