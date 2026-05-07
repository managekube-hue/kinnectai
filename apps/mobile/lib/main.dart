import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'screens/landing_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/email_signup_screen.dart';
import 'screens/phone_signup_screen.dart';
import 'screens/legal_document_screen.dart';
import 'screens/line_screen.dart';
import 'screens/comment_thread_screen.dart';
import 'screens/kin_score_detail_screen.dart';
import 'screens/voiceprint_capture_screen.dart';
import 'screens/time_wellbeing_screen.dart';
import 'theme/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: KinnectColors.darkBg,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // TODO: Initialize Firebase
  // await Firebase.initializeApp();
  
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
        theme: ThemeData(
          colorScheme: ColorScheme.dark(
            primary: KinnectColors.amber,
            secondary: KinnectColors.amberLight,
            surface: KinnectColors.darkSurface,
            background: KinnectColors.darkBg,
          ),
          scaffoldBackgroundColor: KinnectColors.darkBg,
          useMaterial3: true,
          fontFamily: 'Inter',
        ),
        initialRoute: '/line',
        routes: {
          '/line': (context) => const LineScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          '/landing': (context) => const LandingScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/email-signup': (context) => const EmailSignUpScreen(),
          '/phone-signup': (context) => const PhoneSignUpScreen(),
          '/home': (context) => const HomeScreen(),
          '/voiceprint-capture': (context) => const VoiceprintCaptureScreen(),
          '/time-wellbeing': (context) => const TimeWellbeingScreen(),
        },
        onGenerateRoute: (settings) {
          // Handle dynamic routes for legal documents
          if (settings.name?.startsWith('/legal/') ?? false) {
            final documentType = settings.name!.split('/').last;
            return MaterialPageRoute(
              builder: (context) => LegalDocumentScreen(
                documentType: documentType,
              ),
            );
          }
          
          // Handle comment threads
          if (settings.name?.startsWith('/memory/') ?? false) {
            final parts = settings.name!.split('/');
            if (parts.length >= 4 && parts[3] == 'comments') {
              final memoryId = parts[2];
              return MaterialPageRoute(
                builder: (context) => CommentThreadScreen(memoryId: memoryId),
              );
            }
          }
          
          // Handle kin score detail
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
