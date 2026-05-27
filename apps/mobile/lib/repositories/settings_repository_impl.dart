import 'package:dio/dio.dart';

import '../models/dtos/settings_state_dto.dart';
import 'settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({required Dio dio, this.basePath = '/v1'})
    : _dio = dio;

  final Dio _dio;
  final String basePath;

  @override
  Future<SettingsStateDTO> loadSettings() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$basePath/user/preferences',
    );
    final data =
        (response.data?['data'] as Map<String, dynamic>?) ??
        response.data ??
        <String, dynamic>{};
    return SettingsStateDTO.fromJson(data);
  }

  @override
  Future<SettingsStateDTO> togglePush(bool enabled) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '$basePath/user/preferences',
      data: {'push_enabled': enabled},
    );

    final data =
        (response.data?['data'] as Map<String, dynamic>?) ??
        response.data ??
        <String, dynamic>{};
    return SettingsStateDTO.fromJson(data);
  }

  @override
  Future<SettingsStateDTO> updatePrivacy({
    bool? privateAccount,
    bool? discoveryEnabled,
  }) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '$basePath/user/preferences/privacy',
      data: {
        'private_account': ?privateAccount,
        'discovery_enabled': ?discoveryEnabled,
      },
    );

    final data =
        (response.data?['data'] as Map<String, dynamic>?) ??
        response.data ??
        <String, dynamic>{};
    return SettingsStateDTO.fromJson(data);
  }

  @override
  Future<void> requestDataExport() async {
    await _dio.post<void>('$basePath/data/export/request');
  }

  @override
  Future<void> revokeConsent(String consentType) async {
    await _dio.post<void>(
      '$basePath/consent/revoke',
      data: {'consent_type': consentType},
    );
  }
}
