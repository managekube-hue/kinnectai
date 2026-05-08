import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/auth_service.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/email_signup_screen.dart';
import 'screens/phone_signup_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/legal_document_screen.dart';
import 'screens/home_screen.dart';
import 'screens/line_screen.dart';
import 'screens/comment_thread_screen.dart';
import 'screens/kin_score_detail_screen.dart';
import 'screens/voiceprint_capture_screen.dart';
import 'screens/time_wellbeing_screen.dart';
import 'screens/creation_hub_screen.dart';
import 'screens/memory_box_screen.dart';
import 'theme/colors.dart';
import 'theme/design_system.dart';

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
        routes: {
          // Auth Flow (Section 11)
          '/splash': (context) => const SplashScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/email-signup': (context) => const EmailSignUpScreen(),
          '/phone-signup': (context) => const PhoneSignUpScreen(),
          '/landing': (context) => const LandingScreen(),
          
          // Bottom Bar Navigation (Section 00)
          '/home': (context) => const HomeScreen(), // Home = The Line
          '/line': (context) => const LineScreen(), // Direct Line access
          '/creation-hub': (context) => const CreationHubScreen(), // Create (+)
          
          // Secondary Features
          '/voiceprint-capture': (context) => const VoiceprintCaptureScreen(),
          '/time-wellbeing': (context) => const TimeWellbeingScreen(),
          '/memory-box': (context) => const MemoryBoxScreen(),
        },
        onGenerateRoute: (settings) {
          // Legal documents (Section 11)
          if (settings.name?.startsWith('/legal/') ?? false) {
            final documentType = settings.name!.split('/').last;
            return MaterialPageRoute(
              builder: (context) => LegalDocumentScreen(documentType: documentType),
            );
          }
          
          // Comment threads (Section 01.2)
          if (settings.name?.startsWith('/memory/') ?? false) {
            final parts = settings.name!.split('/');
            if (parts.length >= 4 && parts[3] == 'comments') {
              final memoryId = parts[2];
              return MaterialPageRoute(
                builder: (context) => CommentThreadScreen(memoryId: memoryId),
              );
            }
          }
          
          // Kin Score detail (Section 01.1)
          if (settings.name?.startsWith('/kin-score-detail') ?? false) {
            final uri = Uri.parse(settings.name!);
            final targetUserId = uri.queryParameters['target'] ?? '';
            return MaterialPageRoute(
              builder: (context) => KinScoreDetailScreen(targetUserId: targetUserId),
            );
          }
          
          return null;
        },
      ),
    );
  }
}
