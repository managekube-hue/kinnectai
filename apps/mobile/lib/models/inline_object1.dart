import 'package:freezed_annotation/freezed_annotation.dart';

part 'inline_object1.freezed.dart';
part 'inline_object1.g.dart';

@freezed
abstract class InlineObject1 with _$InlineObject1 {
  const factory InlineObject1() = _InlineObject1;

  factory InlineObject1.fromJson(Map<String, dynamic> json) =>
      _$InlineObject1FromJson(json);
}
