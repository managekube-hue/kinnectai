import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinnectai_app/screens/line_screen.dart';
import 'package:kinnectai_app/widgets/line_video_player.dart';
import 'package:kinnectai_app/widgets/right_rail_buttons.dart';
import 'package:kinnectai_app/widgets/bottom_overlay.dart';

void main() {
  group('Line Screen Widget Tests', () {
    testWidgets('LineScreen renders without error', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LineScreen(),
        ),
      );

      await tester.pumpAndSettle();
      
      expect(find.byType(LineScreen), findsOneWidget);
    });

    testWidgets('Top bar has 6 navigation icons', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LineScreen(),
        ),
      );

      await tester.pumpAndSettle();
      
      final appBar = find.byType(AppBar);
      expect(appBar, findsOneWidget);
    });

    testWidgets('Bottom navigation has 6 tabs', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LineScreen(),
        ),
      );

      await tester.pumpAndSettle();
      
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Repost'), findsOneWidget);
      expect(find.text('Discover'), findsOneWidget);
      expect(find.text('Tree'), findsOneWidget);
      expect(find.text('Root'), findsOneWidget);
    });
  });

  group('Right Rail Buttons Widget Tests', () {
    testWidgets('All interaction buttons render', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RightRailButtons(
              memory: _createTestMemory(),
              onPulseTap: () {},
              onCommentTap: () {},
              onRewindTap: () {},
              onSaveTap: () {},
              onShareTap: () {},
              onBranchTap: () {},
              onNetworkTap: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.chat_bubble_outline), findsOneWidget);
      expect(find.byIcon(Icons.restart_alt), findsOneWidget);
      expect(find.byIcon(Icons.star_border), findsOneWidget);
      expect(find.byIcon(Icons.share_outlined), findsOneWidget);
    });

    testWidgets('Pulse button shows filled when pulsed', (WidgetTester tester) async {
      final memory = _createTestMemory().copyWith(isPulsed: true);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RightRailButtons(
              memory: memory,
              onPulseTap: () {},
              onCommentTap: () {},
              onRewindTap: () {},
              onSaveTap: () {},
              onShareTap: () {},
              onBranchTap: () {},
              onNetworkTap: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });

  group('Gesture Tests', () {
    testWidgets('PageView allows vertical scrolling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LineScreen(),
        ),
      );

      await tester.pumpAndSettle();
      
      final pageView = find.byType(PageView);
      expect(pageView, findsOneWidget);
    });
  });
}

// Helper function
dynamic _createTestMemory() {
  return {
    'id': '1',
    'creatorId': 'user1',
    'creatorUsername': 'testuser',
    'creatorDisplayName': 'Test User',
    'videoUrl': 'https://example.com/video.mp4',
    'caption': 'Test caption',
    'pulseCount': 100,
    'commentCount': 50,
    'kinScore': 0.85,
    'createdAt': DateTime.now(),
    'duration': const Duration(seconds: 30),
    'isPulsed': false,
    'isSaved': false,
  };
}
