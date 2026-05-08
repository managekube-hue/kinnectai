import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// Handles deep links arriving via the `/kinnect/:path` route pattern.
///
/// Attempts to resolve the captured path segments to an internal route.
/// If the path maps to a known screen the user is redirected automatically;
/// otherwise a user-friendly "not found" message is shown.
class DeepLinkHandler extends StatefulWidget {
  const DeepLinkHandler({super.key, this.path});

  /// The remaining path segments captured from the deep link URL.
  final String? path;

  @override
  State<DeepLinkHandler> createState() => _DeepLinkHandlerState();
}

class _DeepLinkHandlerState extends State<DeepLinkHandler> {
  bool _notFound = false;

  static const Map<String, String> _staticRoutes = {
    'line': '/line',
    'home': '/line',
    'discover': '/discover',
    'tree': '/tree',
    'profile': '/profile',
    'settings': '/settings',
    'memory-box': '/memory-box',
    'strands': '/strands',
    'welcome': '/welcome',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _resolve());
  }

  void _resolve() {
    final path = widget.path;

    if (path == null || path.isEmpty) {
      context.go('/line');
      return;
    }

    // Direct static route match
    final staticTarget = _staticRoutes[path];
    if (staticTarget != null) {
      context.go(staticTarget);
      return;
    }

    // Dynamic segment patterns: branch/<id>, strand/<id>, root/<id>, etc.
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();

    if (segments.length >= 2) {
      final prefix = segments[0];
      final id = segments[1];
      final suffix = segments.length > 2 ? segments[2] : null;

      final resolved = _resolveDynamic(prefix, id, suffix);
      if (resolved != null) {
        context.go(resolved);
        return;
      }
    }

    // Single-segment dynamic: vault/<id>
    if (segments.length == 1) {
      // Fall through to not-found since we already checked static routes
    }

    setState(() => _notFound = true);
  }

  String? _resolveDynamic(String prefix, String id, String? suffix) {
    switch (prefix) {
      case 'branch':
        if (suffix == 'merge') return '/branch/$id/merge';
        if (suffix == 'members') return '/branch/$id/members';
        return '/branch/$id';
      case 'strand':
        return '/strand/$id';
      case 'root':
        if (suffix == 'profile') return '/root/$id/profile';
        return '/root/$id';
      case 'vault':
        return '/vault/$id';
      case 'alert':
        if (suffix == 'map') return '/alert/$id/map';
        return null;
      case 'memory':
        if (suffix == 'comments') return '/memory/$id/comments';
        return null;
      case 'line':
        if (suffix == 'echo') return '/line/$id/echo';
        return null;
      case 'legal':
        return '/legal/$id';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_notFound) {
      return Scaffold(
        backgroundColor: KinnectColors.background,
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(KinnectColors.accent),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: KinnectColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.link_off,
                  color: KinnectColors.textSecondary,
                  size: 64,
                ),
                const SizedBox(height: 24),
                Text(
                  'Link not found',
                  style: KinnectTextStyles.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  'The deep link you followed doesn\'t match any page in KinnectAI.',
                  textAlign: TextAlign.center,
                  style: KinnectTextStyles.bodyLarge.copyWith(
                    color: KinnectColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KinnectColors.accent,
                      foregroundColor: KinnectColors.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => context.go('/line'),
                    child: const Text('Go to Home'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
