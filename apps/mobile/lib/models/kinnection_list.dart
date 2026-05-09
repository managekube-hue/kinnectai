import 'package:freezed_annotation/freezed_annotation.dart';

import 'kinnection_list_kinnections_inner.dart';

part 'kinnection_list.freezed.dart';
part 'kinnection_list.g.dart';

@freezed
abstract class KinnectionList with _$KinnectionList {
  const factory KinnectionList({
    required List<KinnectionListKinnectionsInner> kinnections,
  }) = _KinnectionList;

  factory KinnectionList.fromJson(Map<String, dynamic> json) =>
      _$KinnectionListFromJson(json);
}
