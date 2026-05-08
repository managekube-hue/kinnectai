import 'dart:developer' as developer;

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../services/background_sync_service.dart';
import 'offline/offline_database.dart';

class AppBootstrap {
  AppBootstrap._();

  static Future<void> initialize() async {
    final storageDir = await getTemporaryDirectory();
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: storageDir,
    );

    await BackgroundSyncService.initialize();

    // Initialize a lazy Drift connection once at startup to fail fast.
    OfflineDatabase.openConnection();
  }
}

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    developer.log(
      'Bloc error in ${bloc.runtimeType}',
      error: error,
      stackTrace: stackTrace,
      name: 'AppBlocObserver',
    );
    super.onError(bloc, error, stackTrace);
  }
}
