import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cubits/error_cubit.dart';
import 'cubits/settings_cubit.dart';
import 'repositories/settings_repository_impl.dart';
import 'foundation/app_bootstrap.dart';
import 'foundation/offline/offline_sync_manager.dart';
import 'services/push_notification_service.dart';
import 'utils/consent_store.dart';
import 'utils/performance_sla.dart';
import 'router/go_router_config.dart';
import 'services/auth_service.dart';
import 'theme/design_system.dart';
import 'widgets/accessible_scaffold.dart';

final AuthService appAuthService = AuthService();
final ErrorCubit appErrorCubit = ErrorCubit();
final OfflineSyncManager appOfflineSync = OfflineSyncManager();

void main() async {
  PerformanceSLA.markColdStartBegin();
  WidgetsFlutterBinding.ensureInitialized();
  await AppBootstrap.initialize();
  await appOfflineSync.initialize();
  await ConsentStore.initialize();
  await PushNotificationService.initialize();

  Bloc.observer = const AppBlocObserver();

  // Mark cold start end after first frame renders
  WidgetsBinding.instance.addPostFrameCallback((_) {
    PerformanceSLA.markColdStartEnd();
  });

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: DesignColors.darkBackground,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ErrorCubit>.value(value: appErrorCubit),
        BlocProvider<SettingsCubit>(
          create: (_) => SettingsCubit(SettingsRepositoryImpl(dio: Dio()))..load(),
        ),
      ],
      child: ChangeNotifierProvider<AuthService>.value(
        value: appAuthService,
        child: MaterialApp.router(
          title: 'KinnectAI',
          debugShowCheckedModeBanner: false,
          routerConfig: AppGoRouter.router(appAuthService),
          // Global accessibility wrapper: FocusTraversalGroup + Semantics +
          // reduced motion + AppErrorBoundary on every route
          builder: (context, child) => AccessibleApp(child: child ?? const SizedBox.shrink()),
        theme: createDesignTheme(isDark: true).copyWith(
          textTheme:
              GoogleFonts.dmSansTextTheme(
                createDesignTheme(isDark: true).textTheme,
              ).copyWith(
                displayLarge: GoogleFonts.nunito(
                  textStyle: DesignTextStyles.headlineLarge,
                ),
                displayMedium: GoogleFonts.nunito(
                  textStyle: DesignTextStyles.headlineMedium,
                ),
                titleLarge: GoogleFonts.nunito(
                  textStyle: DesignTextStyles.titleLarge,
                ),
                titleMedium: GoogleFonts.dmSans(
                  textStyle: DesignTextStyles.titleMedium,
                ),
                labelLarge: GoogleFonts.nunito(
                  textStyle: DesignTextStyles.labelLarge,
                ),
                labelMedium: GoogleFonts.nunito(
                  textStyle: DesignTextStyles.labelMedium,
                ),
                labelSmall: GoogleFonts.nunito(
                  textStyle: DesignTextStyles.labelSmall,
                ),
              ),
        ),
        ),
      ),
    );
  }
}

