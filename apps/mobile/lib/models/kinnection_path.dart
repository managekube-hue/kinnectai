import 'package:freezed_annotation/freezed_annotation.dart';

import 'kinnection_path_path_inner.dart';

part 'kinnection_path.freezed.dart';
part 'kinnection_path.g.dart';

@freezed
abstract class KinnectionPath with _$KinnectionPath {
  const factory KinnectionPath({
    required List<KinnectionPathPathInner> path,
    required int hopCount,
    required double totalKcScore,
  }) = _KinnectionPath;

  factory KinnectionPath.fromJson(Map<String, dynamic> json) =>
      _$KinnectionPathFromJson(json);
}
