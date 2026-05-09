import 'package:freezed_annotation/freezed_annotation.dart';

part 'inline_object2.freezed.dart';
part 'inline_object2.g.dart';

@freezed
abstract class InlineObject2 with _$InlineObject2 {
  const factory InlineObject2() = _InlineObject2;

  factory InlineObject2.fromJson(Map<String, dynamic> json) =>
      _$InlineObject2FromJson(json);
}
