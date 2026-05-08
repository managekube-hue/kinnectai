import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinnectai_app/models/memory.dart';
import 'package:kinnectai_app/screens/line_screen.dart';
import 'package:kinnectai_app/widgets/right_rail_buttons.dart';

void main() {
  group('Line Screen Widget Tests', () {
    testWidgets('LineScreen renders', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LineScreen(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(LineScreen), findsOneWidget);
      expect(find.byType(PageView), findsOneWidget);
    });
  });

  group('RightRailButtons', () {
    testWidgets('interaction buttons render', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RightRailButtons(
              memory: _testMemory(),
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

    testWidgets('pulse uses filled heart when pulsed', (WidgetTester tester) async {
      final memory = _testMemory().copyWith(isPulsed: true);

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

  group('Line feed', () {
    testWidgets('PageView is vertical', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LineScreen(),
        ),
      );

      await tester.pumpAndSettle();

      final pv = tester.widget<PageView>(find.byType(PageView));
      expect(pv.scrollDirection, Axis.vertical);
    });
  });
}

Memory _testMemory() => Memory(
      id: '1',
      creatorId: 'user1',
      creatorUsername: 'testuser',
      creatorDisplayName: 'Test User',
      videoUrl: 'https://example.com/video.mp4',
      caption: 'Test caption',
      pulseCount: 100,
      commentCount: 50,
      kinScore: 0.85,
      branchId: 'branch-1',
      createdAt: DateTime.now(),
      duration: const Duration(seconds: 30),
    );
