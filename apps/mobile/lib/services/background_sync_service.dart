import 'dart:developer' as developer;
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';

const String _syncQueueTask = 'kinnectai.offline_sync_queue';
const String _syncQueueBox = 'offline_sync_queue';

typedef MutationDispatcher = Future<bool> Function({
  required String id,
  required String type,
  required Map<String, dynamic> payload,
});

MutationDispatcher? _dispatcher;

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == _syncQueueTask) {
      await Hive.initFlutter();
      final queue = await Hive.openBox<String>(_syncQueueBox);
      final keys = queue.keys.cast<String>().toList();
      for (final id in keys) {
        final raw = queue.get(id);
        if (raw == null) {
          continue;
        }
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        final type = decoded['type'] as String? ?? 'unknown';
        final payload =
            (decoded['payload'] as Map<String, dynamic>?) ?? <String, dynamic>{};

        final dispatcher = _dispatcher;
        if (dispatcher == null) {
          developer.log('No dispatcher registered. Skipping sync.', name: 'Workmanager');
          return Future.value(true);
        }

        final delivered = await dispatcher(id: id, type: type, payload: payload);
        if (delivered) {
          await queue.delete(id);
        }
      }
    }
    return Future.value(true);
  });
}

class BackgroundSyncService {
  BackgroundSyncService._();

  static Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_syncQueueBox);
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  }

  static Future<void> enqueueMutation({
    required String id,
    required String type,
    required Map<String, dynamic> payload,
  }) async {
    final queue = await Hive.openBox<String>(_syncQueueBox);
    final encoded = jsonEncode(<String, dynamic>{'type': type, 'payload': payload});
    await queue.put(id, encoded);
  }

  static void registerDispatcher(MutationDispatcher dispatcher) {
    _dispatcher = dispatcher;
  }

  static Future<void> registerSyncTask() {
    return Workmanager().registerOneOffTask(
      'sync-${DateTime.now().millisecondsSinceEpoch}',
      _syncQueueTask,
      initialDelay: const Duration(seconds: 1),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }
}

