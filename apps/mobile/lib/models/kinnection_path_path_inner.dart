import 'package:freezed_annotation/freezed_annotation.dart';

part 'kinnection_path_path_inner.freezed.dart';
part 'kinnection_path_path_inner.g.dart';

@freezed
abstract class KinnectionPathPathInner with _$KinnectionPathPathInner {
  const factory KinnectionPathPathInner({
    required String userId,
    required String edgeType,
    required double kcScore,
    required int hopCount,
  }) = _KinnectionPathPathInner;

  factory KinnectionPathPathInner.fromJson(Map<String, dynamic> json) =>
      _$KinnectionPathPathInnerFromJson(json);
}
