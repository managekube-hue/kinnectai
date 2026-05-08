import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/auth_service.dart';
import 'theme/design_system.dart';
import 'router/app_router.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
    return ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MaterialApp(
        title: 'KinnectAI',
        debugShowCheckedModeBanner: false,
        theme: createDesignTheme(isDark: true).copyWith(
          textTheme: GoogleFonts.dmSansTextTheme(
            createDesignTheme(isDark: true).textTheme,
          ).copyWith(
            displayLarge: GoogleFonts.nunito(textStyle: DesignTextStyles.headlineLarge),
            displayMedium: GoogleFonts.nunito(textStyle: DesignTextStyles.headlineMedium),
            titleLarge: GoogleFonts.nunito(textStyle: DesignTextStyles.titleLarge),
            titleMedium: GoogleFonts.dmSans(textStyle: DesignTextStyles.titleMedium),
            labelLarge: GoogleFonts.nunito(textStyle: DesignTextStyles.labelLarge),
            labelMedium: GoogleFonts.nunito(textStyle: DesignTextStyles.labelMedium),
            labelSmall: GoogleFonts.nunito(textStyle: DesignTextStyles.labelSmall),
          ),
        ),
        initialRoute: '/splash',
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}


