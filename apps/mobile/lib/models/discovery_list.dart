import 'package:freezed_annotation/freezed_annotation.dart';

import 'discovery_card.dart';

part 'discovery_list.freezed.dart';
part 'discovery_list.g.dart';

@freezed
abstract class DiscoveryList with _$DiscoveryList {
  const factory DiscoveryList({
    required List<DiscoveryCard> candidates,
  }) = _DiscoveryList;

  factory DiscoveryList.fromJson(Map<String, dynamic> json) =>
      _$DiscoveryListFromJson(json);
}
