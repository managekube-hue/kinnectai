import 'package:flutter_test/flutter_test.dart';
import 'package:kinnectai_app/router/app_route_policy.dart';

void main() {
  group('AppRoutePolicy.normalizeDeepLink', () {
    test('maps kinnect vault links', () {
      final result = AppRoutePolicy.normalizeDeepLink(
        Uri.parse('kinnect://vault/mem_123'),
      );

      expect(result, '/vault/mem_123');
    });

    test('maps kinnect root profile links', () {
      final result = AppRoutePolicy.normalizeDeepLink(
        Uri.parse('kinnect://root/user_42/profile'),
      );

      expect(result, '/root/user_42/profile');
    });

    test('maps kinnect alert map links', () {
      final result = AppRoutePolicy.normalizeDeepLink(
        Uri.parse('kinnect://alert/alert_7/map'),
      );

      expect(result, '/alert/alert_7/map');
    });

    test('maps universal links', () {
      final result = AppRoutePolicy.normalizeDeepLink(
        Uri.parse('https://app.kinnectai.app/branch/br_1/merge'),
      );

      expect(result, '/branch/br_1/merge');
    });

    test('ignores unrelated uris', () {
      final result = AppRoutePolicy.normalizeDeepLink(
        Uri.parse('https://example.com/foo'),
      );

      expect(result, isNull);
    });
  });

  group('AppRoutePolicy.passesKinScoreGate', () {
    test('passes when no gate is requested', () {
      expect(
        AppRoutePolicy.passesKinScoreGate(Uri.parse('kinnect://root/user_1')),
        isTrue,
      );
    });

    test('passes when kin score meets requirement', () {
      expect(
        AppRoutePolicy.passesKinScoreGate(
          Uri.parse('https://app.kinnectai.app/room/123?required_kin_score=0.2&kin_score=0.25'),
        ),
        isTrue,
      );
    });

    test('fails when kin score is below requirement', () {
      expect(
        AppRoutePolicy.passesKinScoreGate(
          Uri.parse('https://app.kinnectai.app/room/123?required_kin_score=0.2&kin_score=0.1'),
        ),
        isFalse,
      );
    });
  });

  group('AppRoutePolicy.resolveRedirect', () {
    test('redirects /home to /line', () {
      final result = AppRoutePolicy.resolveRedirect(
        uri: Uri.parse('/home'),
        matchedLocation: '/home',
        isLoggedIn: true,
      );

      expect(result, '/line');
    });

    test('redirects anonymous protected routes to welcome', () {
      final result = AppRoutePolicy.resolveRedirect(
        uri: Uri.parse('/settings'),
        matchedLocation: '/settings',
        isLoggedIn: false,
      );

      expect(result, '/welcome');
    });

    test('redirects logged in users away from auth routes', () {
      final result = AppRoutePolicy.resolveRedirect(
        uri: Uri.parse('/login'),
        matchedLocation: '/login',
        isLoggedIn: true,
      );

      expect(result, '/line');
    });

    test('redirects deep links before route evaluation', () {
      final result = AppRoutePolicy.resolveRedirect(
        uri: Uri.parse('kinnect://vault/mem_9'),
        matchedLocation: '/welcome',
        isLoggedIn: true,
      );

      expect(result, '/vault/mem_9');
    });

    test('redirects failed kin-score gate to line', () {
      final result = AppRoutePolicy.resolveRedirect(
        uri: Uri.parse('https://app.kinnectai.app/room/123?required_kin_score=0.8&kin_score=0.2'),
        matchedLocation: '/room/123',
        isLoggedIn: true,
      );

      expect(result, '/line');
    });
  });
}
