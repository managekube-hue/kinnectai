import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Deep link service for handling kinnect:// and universal links.
/// PRD Addendum 2.0 S10.
///
/// Scheme: kinnect:// | Universal Link: app.kinnectai.app/
/// Integrates with go_router redirect in AppRoutePolicy.
class DeepLinkService {
  DeepLinkService._();

  static const _channel = MethodChannel('com.kinnectai.deeplinks');

  static String? _pendingDeepLink;

  /// Get and clear any pending deep link (e.g. from cold start).
  static String? consumePendingDeepLink() {
    final link = _pendingDeepLink;
    _pendingDeepLink = null;
    return link;
  }

  /// Initialize deep link listener.
  static void initialize() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onDeepLink') {
        final uri = call.arguments as String?;
        if (uri != null) {
          _pendingDeepLink = uri;
          debugPrint('Deep link received: $uri');
        }
      }
    });
  }

  /// Parse a deep link URI into an internal route path.
  /// Returns null if not a recognized KinnectAI link.
  static String? parseToRoute(Uri uri) {
    // Custom scheme: kinnect://vault/mem_123
    if (uri.scheme == 'kinnect') {
      return _parseCustomScheme(uri);
    }

    // Universal link: https://app.kinnectai.app/branch/br_1/merge
    if (uri.host == 'app.kinnectai.app') {
      final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
      final path = '/${segments.join('/')}';
      return path == '/' ? '/welcome' : path;
    }

    return null;
  }

  static String? _parseCustomScheme(Uri uri) {
    final host = uri.host;
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();

    switch (host) {
      case 'vault':
        return segments.isNotEmpty ? '/vault/${segments.first}' : null;
      case 'root':
        if (segments.length >= 2 && segments[1] == 'profile') {
          return '/root/${segments.first}/profile';
        }
        return segments.isNotEmpty ? '/root/${segments.first}' : null;
      case 'alert':
        if (segments.length >= 2 && segments[1] == 'map') {
          return '/alert/${segments.first}/map';
        }
        return null;
      case 'line':
        if (segments.length >= 2 && segments[1] == 'echo') {
          return '/line/${segments.first}/echo';
        }
        return null;
      case 'branch':
        if (segments.length >= 2 && segments[1] == 'merge') {
          return '/branch/${segments.first}/merge';
        }
        return segments.isNotEmpty ? '/branch/${segments.first}' : null;
      case 'room':
        return segments.isNotEmpty ? '/line?room=${segments.first}&required_kin_score=0.01' : null;
      case 'live':
        return segments.isNotEmpty ? '/line?live=${segments.first}&required_kin_score=0.01' : null;
      default:
        return null;
    }
  }
}
