import 'package:bloc_test/bloc_test.dart';
import 'package:kinnectai_app/cubits/memory_box_cubit.dart';
import 'package:kinnectai_app/models/dtos/memory_box_item_dto.dart';
import 'package:kinnectai_app/repositories/memory_box_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockMemoryBoxRepository extends Mock implements MemoryBoxRepository {}

void main() {
  late MemoryBoxRepository repository;

  final item = MemoryBoxItemDTO(
    id: 'm1',
    recipientName: 'Kin One',
    triggerType: 'time_capsule',
    status: MemoryBoxStatus.sealed,
    sealedAt: DateTime(2026, 1, 1),
  );

  setUp(() {
    repository = _MockMemoryBoxRepository();
  });

  blocTest<MemoryBoxCubit, MemoryBoxState>(
    'loadVault emits loading then loaded',
    build: () {
      when(() => repository.fetchVault()).thenAnswer((_) async => [item]);
      return MemoryBoxCubit(repository);
    },
    act: (cubit) => cubit.loadVault(),
    expect: () => [isA<MemoryBoxLoading>(), isA<MemoryBoxLoaded>()],
  );

  blocTest<MemoryBoxCubit, MemoryBoxState>(
    'sealMemory emits sealing then success and reload',
    build: () {
      when(() => repository.sealMemory(any())).thenAnswer((_) async {});
      when(() => repository.fetchVault()).thenAnswer((_) async => [item]);
      return MemoryBoxCubit(repository);
    },
    act: (cubit) => cubit.sealMemory('m1'),
    expect: () => [
      isA<MemoryBoxSealing>(),
      isA<MemoryBoxSuccess>(),
      isA<MemoryBoxLoading>(),
      isA<MemoryBoxLoaded>(),
    ],
  );
}
