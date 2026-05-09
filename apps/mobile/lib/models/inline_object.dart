import 'package:freezed_annotation/freezed_annotation.dart';

part 'inline_object.freezed.dart';
part 'inline_object.g.dart';

@freezed
abstract class InlineObject with _$InlineObject {
  const factory InlineObject() = _InlineObject;

  factory InlineObject.fromJson(Map<String, dynamic> json) =>
      _$InlineObjectFromJson(json);
}
