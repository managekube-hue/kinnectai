import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/dtos/settings_state_dto.dart';
import '../repositories/settings_repository.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  const SettingsLoaded(this.settings);

  final SettingsStateDTO settings;

  @override
  List<Object?> get props => [settings];
}

class SettingsSaving extends SettingsState {}

class SettingsSaved extends SettingsState {
  const SettingsSaved(this.settings);

  final SettingsStateDTO settings;

  @override
  List<Object?> get props => [settings];
}

class SettingsError extends SettingsState {
  const SettingsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repository) : super(SettingsLoading());

  final SettingsRepository _repository;

  Future<void> load() async {
    emit(SettingsLoading());
    try {
      final settings = await _repository.loadSettings();
      emit(SettingsLoaded(settings));
    } catch (error) {
      emit(SettingsError(error.toString()));
    }
  }

  Future<void> togglePush(bool enabled) async {
    emit(SettingsSaving());
    try {
      final settings = await _repository.togglePush(enabled);
      emit(SettingsSaved(settings));
      emit(SettingsLoaded(settings));
    } catch (error) {
      emit(SettingsError(error.toString()));
    }
  }

  Future<void> updatePrivacy({
    bool? privateAccount,
    bool? discoveryEnabled,
  }) async {
    emit(SettingsSaving());
    try {
      final settings = await _repository.updatePrivacy(
        privateAccount: privateAccount,
        discoveryEnabled: discoveryEnabled,
      );
      emit(SettingsSaved(settings));
      emit(SettingsLoaded(settings));
    } catch (error) {
      emit(SettingsError(error.toString()));
    }
  }

  Future<void> requestDataExport() async {
    emit(SettingsSaving());
    try {
      await _repository.requestDataExport();
      final current = state;
      if (current is SettingsLoaded) {
        emit(SettingsSaved(current.settings));
        emit(current);
      } else {
        await load();
      }
    } catch (error) {
      emit(SettingsError(error.toString()));
    }
  }

  Future<void> revokeConsent(String consentType) async {
    emit(SettingsSaving());
    try {
      await _repository.revokeConsent(consentType);
      await load();
    } catch (error) {
      emit(SettingsError(error.toString()));
    }
  }
}
