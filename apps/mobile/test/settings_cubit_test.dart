import 'package:bloc_test/bloc_test.dart';
import 'package:kinnectai_app/cubits/settings_cubit.dart';
import 'package:kinnectai_app/models/dtos/settings_state_dto.dart';
import 'package:kinnectai_app/repositories/settings_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late SettingsRepository repository;

  const settings = SettingsStateDTO(
    pushEnabled: true,
    privateAccount: true,
    discoveryEnabled: true,
  );

  setUp(() {
    repository = _MockSettingsRepository();
  });

  blocTest<SettingsCubit, SettingsState>(
    'load emits loading then loaded',
    build: () {
      when(() => repository.loadSettings()).thenAnswer((_) async => settings);
      return SettingsCubit(repository);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<SettingsLoading>(),
      isA<SettingsLoaded>(),
    ],
  );

  blocTest<SettingsCubit, SettingsState>(
    'toggle push emits saving/saved/loaded',
    build: () {
      when(() => repository.togglePush(false)).thenAnswer((_) async => settings.copyWith(pushEnabled: false));
      return SettingsCubit(repository);
    },
    act: (cubit) => cubit.togglePush(false),
    expect: () => [
      isA<SettingsSaving>(),
      isA<SettingsSaved>(),
      isA<SettingsLoaded>(),
    ],
  );
}
