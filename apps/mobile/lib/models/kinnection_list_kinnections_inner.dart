import 'package:freezed_annotation/freezed_annotation.dart';

part 'kinnection_list_kinnections_inner.freezed.dart';
part 'kinnection_list_kinnections_inner.g.dart';

@freezed
abstract class KinnectionListKinnectionsInner with _$KinnectionListKinnectionsInner {
  const factory KinnectionListKinnectionsInner({
    required String targetUserId,
    required double crScore,
    required String status,
  }) = _KinnectionListKinnectionsInner;

  factory KinnectionListKinnectionsInner.fromJson(Map<String, dynamic> json) =>
      _$KinnectionListKinnectionsInnerFromJson(json);
}
