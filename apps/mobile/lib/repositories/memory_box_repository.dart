import '../models/dtos/memory_box_item_dto.dart';

abstract class MemoryBoxRepository {
  Future<List<MemoryBoxItemDTO>> fetchVault();
  Future<void> sealMemory(String memoryId);
  Future<void> revokeTrigger(String memoryId);
  Future<void> requestExport();
}
