import 'package:freezed_annotation/freezed_annotation.dart';

part 'vault_sealed_response.freezed.dart';
part 'vault_sealed_response.g.dart';

@freezed
abstract class VaultSealedResponse with _$VaultSealedResponse {
  const factory VaultSealedResponse({
    required String memoryId,
    required String triggerId,
    required String auditLogId,
  }) = _VaultSealedResponse;

  factory VaultSealedResponse.fromJson(Map<String, dynamic> json) =>
      _$VaultSealedResponseFromJson(json);
}
