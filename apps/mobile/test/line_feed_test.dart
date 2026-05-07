import 'package:flutter_test/flutter_test.dart';
import 'package:kinnectai_app/models/memory.dart';
import 'package:kinnectai_app/services/feed_service.dart';
import 'package:kinnectai_app/services/interaction_service.dart';
import 'package:kinnectai_app/services/kernel_service.dart';

void main() {
  group('Memory Model Tests', () {
    test('Memory.fromJson creates valid object', () {
      final json = {
        'id': '1',
        'creator_id': 'user1',
        'creator_username': 'testuser',
        'creator_display_name': 'Test User',
        'video_url': 'https://example.com/video.mp4',
        'caption': 'Test caption',
        'pulse_count': 100,
        'comment_count': 50,
        'kin_score': 0.85,
        'created_at': '2024-01-01T00:00:00Z',
        'duration_seconds': 30,
      };

      final memory = Memory.fromJson(json);

      expect(memory.id, '1');
      expect(memory.creatorUsername, 'testuser');
      expect(memory.kinScore, 0.85);
      expect(memory.pulseCount, 100);
    });

    test('Memory.kinScorePercentage formats correctly', () {
      final memory = Memory(
        id: '1',
        creatorId: 'user1',
        creatorUsername: 'test',
        creatorDisplayName: 'Test',
        videoUrl: 'url',
        caption: 'caption',
        kinScore: 0.92,
        createdAt: DateTime.now(),
        duration: const Duration(seconds: 30),
      );

      expect(memory.kinScorePercentage, '92%');
    });

    test('Memory.formattedPulseCount formats large numbers', () {
      final memory = Memory(
        id: '1',
        creatorId: 'user1',
        creatorUsername: 'test',
        creatorDisplayName: 'Test',
        videoUrl: 'url',
        caption: 'caption',
        pulseCount: 1200,
        kinScore: 0.85,
        createdAt: DateTime.now(),
        duration: const Duration(seconds: 30),
      );

      expect(memory.formattedPulseCount, '1.2k');
    });

    test('Memory.copyWith creates new instance with updated values', () {
      final memory = Memory(
        id: '1',
        creatorId: 'user1',
        creatorUsername: 'test',
        creatorDisplayName: 'Test',
        videoUrl: 'url',
        caption: 'caption',
        isPulsed: false,
        kinScore: 0.85,
        createdAt: DateTime.now(),
        duration: const Duration(seconds: 30),
      );

      final updated = memory.copyWith(isPulsed: true);

      expect(updated.isPulsed, true);
      expect(updated.id, memory.id);
      expect(memory.isPulsed, false);
    });
  });

  group('Feed Service Tests', () {
    late FeedService feedService;

    setUp(() {
      feedService = FeedService();
    });

    test('getLine returns list of memories', () async {
      final feed = await feedService.getLine('user1');
      
      expect(feed, isA<List<Memory>>());
      expect(feed.isNotEmpty, true);
    });

    test('getLine with different tabs', () async {
      final allFeed = await feedService.getLine('user1', tab: LineTab.all);
      final branchFeed = await feedService.getLine('user1', tab: LineTab.branch);

      expect(allFeed, isA<List<Memory>>());
      expect(branchFeed, isA<List<Memory>>());
    });
  });

  group('Interaction Service Tests', () {
    late InteractionService interactionService;

    setUp(() {
      interactionService = InteractionService();
    });

    test('togglePulse changes state', () async {
      final result = await interactionService.togglePulse('memory1', currentState: false);
      expect(result, true);
    });

    test('toggleSave changes state', () async {
      final result = await interactionService.toggleSave('memory1', currentState: false);
      expect(result, true);
    });

    test('getComments returns list', () async {
      final comments = await interactionService.getComments('memory1');
      expect(comments, isA<List<Comment>>());
    });
  });

  group('Kernel Service Tests', () {
    late KernelService kernelService;

    setUp(() {
      kernelService = KernelService();
    });

    test('getKinScore returns valid score', () async {
      final score = await kernelService.getKinScore('user1', 'user2');
      
      expect(score, isA<double>());
      expect(score >= 0.0 && score <= 1.0, true);
    });

    test('getKinScoreBreakdown returns valid breakdown', () async {
      final breakdown = await kernelService.getKinScoreBreakdown('user1', 'user2');
      
      expect(breakdown, isA<KinScoreBreakdown>());
      expect(breakdown.score >= 0.0 && breakdown.score <= 1.0, true);
      expect(breakdown.relationship, isNotEmpty);
    });

    test('getConnectionPath returns valid path', () async {
      final path = await kernelService.getConnectionPath('user1', 'user2');
      
      expect(path, isA<List<String>>());
    });
  });
}
