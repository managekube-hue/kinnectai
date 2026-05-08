import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinnectai_app/widgets/auth_button.dart';
import 'package:kinnectai_app/screens/welcome_screen.dart';

void main() {
  group('Welcome Screen Tests', () {
    testWidgets('Welcome screen renders all auth buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: WelcomeScreen(),
        ),
      );
      
      // Wait for all animations to complete
      await tester.pumpAndSettle();
      
      // Verify all auth buttons are present
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with Facebook'), findsOneWidget);
      expect(find.text('Continue with TikTok'), findsOneWidget);
      expect(find.text('Sign up with Email'), findsOneWidget);
      expect(find.text('Sign up with Phone'), findsOneWidget);
    });
    
    testWidgets('Welcome screen shows KINNECTAI logo text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: WelcomeScreen(),
        ),
      );
      
      await tester.pumpAndSettle();
      
      expect(find.text('KINNECTAI'), findsOneWidget);
      expect(find.text('The Algorithm Is Your Bloodline'), findsOneWidget);
    });
    
    testWidgets('Welcome screen shows sign in link', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: WelcomeScreen(),
        ),
      );
      
      await tester.pumpAndSettle();
      
      expect(find.text('Already have an account? '), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
    });
    
    testWidgets('Welcome screen shows legal footer', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: WelcomeScreen(),
        ),
      );
      
      await tester.pumpAndSettle();
      
      expect(find.text('By continuing, you agree to'), findsOneWidget);
      expect(find.text('Terms of Service'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
    });
  });
  
  group('Auth Button Tests', () {
    testWidgets('Auth button responds to taps', (WidgetTester tester) async {
      bool tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthButton.email(
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );
      
      await tester.tap(find.byType(AuthButton));
      await tester.pumpAndSettle();
      
      expect(tapped, isTrue);
    });
    
    testWidgets('Auth button shows loading state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthButton.google(
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
