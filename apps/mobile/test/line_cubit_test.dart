import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kinnectai_app/cubits/line_cubit.dart';
import 'package:kinnectai_app/models/memory.dart';
import 'package:kinnectai_app/feed_service.dart';

// Mock classes
class MockFeedService extends Mock implements FeedService {}

void main() {
  group('LineCubit Tests', () {
    late LineCubit cubit;
    late MockFeedService mockFeedService;

    final mockMemories = [
      Memory(
        id: '1',
        creatorId: 'user1',
        creatorUsername: 'testuser1',
        creatorDisplayName: 'Test User 1',
        videoUrl: 'https://example.com/video1.mp4',
        caption: 'Test caption 1',
        kinScore: 0.85,
        createdAt: DateTime(2024, 1, 1),
        duration: const Duration(seconds: 30),
      ),
      Memory(
        id: '2',
        creatorId: 'user2',
        creatorUsername: 'testuser2',
        creatorDisplayName: 'Test User 2',
        videoUrl: 'https://example.com/video2.mp4',
        caption: 'Test caption 2',
        kinScore: 0.92,
        createdAt: DateTime(2024, 1, 2),
        duration: const Duration(seconds: 45),
      ),
    ];

    setUp(() {
      mockFeedService = MockFeedService();
      cubit = LineCubit(mockFeedService);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is LineInitial', () {
      expect(cubit.state, isA<LineInitial>());
    });

    blocTest<LineCubit, LineState>(
      'emits [LineLoading, LineLoaded] when loadFeed succeeds',
      build: () {
        when(() => mockFeedService.getLine(any(), tab: any(named: 'tab')))
            .thenAnswer((_) async => mockMemories);
        return cubit;
      },
      act: (cubit) => cubit.loadFeed('testUser'),
      expect: () => [
        isA<LineLoading>(),
        isA<LineLoaded>()
            .having((s) => s.memories.length, 'memories length', 2)
            .having((s) => s.currentIndex, 'currentIndex', 0)
            .having((s) => s.hasMore, 'hasMore', true),
      ],
      verify: (_) {
        verify(() => mockFeedService.getLine('testUser', tab: LineTab.all))
            .called(1);
      },
    );

    blocTest<LineCubit, LineState>(
      'emits [LineLoading, LineError] when loadFeed fails',
      build: () {
        when(() => mockFeedService.getLine(any(), tab: any(named: 'tab')))
            .thenThrow(Exception('Network error'));
        return cubit;
      },
      act: (cubit) => cubit.loadFeed('testUser'),
      expect: () => [
        isA<LineLoading>(),
        isA<LineError>().having(
          (s) => s.message,
          'error message',
          contains('Failed to load feed'),
        ),
      ],
    );

    blocTest<LineCubit, LineState>(
      'refreshFeed replaces current feed with new data',
      build: () {
        when(() => mockFeedService.refreshFeed(any(), tab: any(named: 'tab')))
            .thenAnswer((_) async => mockMemories.reversed.toList());
        return cubit;
      },
      seed: () => LineLoaded(memories: mockMemories),
      act: (cubit) async {
        cubit.loadFeed('testUser'); // Set userId
        await Future.delayed(Duration.zero);
        await cubit.refreshFeed();
      },
      skip: 2, // Skip loading states
      expect: () => [
        isA<LineLoaded>()
            .having((s) => s.memories.first.id, 'first memory id', '2'),
      ],
    );

    blocTest<LineCubit, LineState>(
      'setCurrentIndex updates index and triggers preload',
      build: () => cubit,
      seed: () => LineLoaded(
        memories: List.generate(
          10,
          (i) => Memory(
            id: '$i',
            creatorId: 'user$i',
            creatorUsername: 'user$i',
            creatorDisplayName: 'User $i',
            videoUrl: 'url$i',
            caption: 'caption$i',
            kinScore: 0.8,
            createdAt: DateTime.now(),
            duration: const Duration(seconds: 30),
          ),
        ),
        currentIndex: 0,
        hasMore: true,
      ),
      act: (cubit) => cubit.setCurrentIndex(5),
      expect: () => [
        isA<LineLoaded>().having((s) => s.currentIndex, 'currentIndex', 5),
      ],
    );

    blocTest<LineCubit, LineState>(
      'loadMore appends new memories when available',
      build: () {
        when(() => mockFeedService.loadNext(
              any(),
              any(),
              tab: any(named: 'tab'),
            )).thenAnswer((_) async => [
              Memory(
                id: '3',
                creatorId: 'user3',
                creatorUsername: 'user3',
                creatorDisplayName: 'User 3',
                videoUrl: 'url3',
                caption: 'caption3',
                kinScore: 0.75,
                createdAt: DateTime.now(),
                duration: const Duration(seconds: 30),
              ),
            ]);
        return cubit;
      },
      seed: () => LineLoaded(memories: mockMemories, hasMore: true),
      act: (cubit) async {
        cubit.loadFeed('testUser'); // Set userId
        await Future.delayed(Duration.zero);
        await cubit.loadMore();
      },
      skip: 2,
      expect: () => [
        isA<LineLoaded>()
            .having((s) => s.memories.length, 'memories length', 3)
            .having((s) => s.hasMore, 'hasMore', false),
      ],
    );

    blocTest<LineCubit, LineState>(
      'updateMemory replaces memory with updated version',
      build: () => cubit,
      seed: () => LineLoaded(memories: mockMemories),
      act: (cubit) {
        final updated = mockMemories.first.copyWith(
          isPulsed: true,
          pulseCount: mockMemories.first.pulseCount + 1,
        );
        cubit.updateMemory(updated);
      },
      expect: () => [
        isA<LineLoaded>().having(
          (s) => s.memories.first.isPulsed,
          'first memory isPulsed',
          true,
        ),
      ],
    );

    blocTest<LineCubit, LineState>(
      'switchTab loads new feed for selected tab',
      build: () {
        when(() => mockFeedService.getLine(any(), tab: any(named: 'tab')))
            .thenAnswer((_) async => mockMemories);
        return cubit;
      },
      act: (cubit) async {
        await cubit.loadFeed('testUser');
        await cubit.switchTab(LineTab.following);
      },
      expect: () => [
        isA<LineLoading>(),
        isA<LineLoaded>(),
        isA<LineLoading>(),
        isA<LineLoaded>(),
      ],
      verify: (_) {
        verify(() => mockFeedService.getLine('testUser', tab: LineTab.all))
            .called(1);
        verify(() =>
                mockFeedService.getLine('testUser', tab: LineTab.following))
            .called(1);
      },
    );
  });
}
