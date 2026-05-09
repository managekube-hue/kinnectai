import '../../services/error_boundary_service.dart';

/// Error code -> UI behavior mapping table (Addendum 2.0 S6).
///
/// Used by AppErrorBoundary and ErrorCubit to determine the correct
/// UI response for each error type per screen.
class ErrorMap {
  ErrorMap._();

  /// Get the user-facing message for an error type.
  static String userMessage(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return 'No connection. Tap to retry.';
      case ErrorType.server:
        return 'KinnectAI servers are updating. We\'ll be back shortly.';
      case ErrorType.client:
        return 'Action not permitted. Please check permissions.';
      case ErrorType.rateLimit:
        return 'Too many requests. Please wait.';
      case ErrorType.graph:
        return 'Branch subgraph incomplete. Showing known connections.';
      case ErrorType.media:
        return 'Memory failed to load.';
      case ErrorType.unknown:
        return 'An unexpected error occurred.';
    }
  }

  /// Get the accessibility label for an error type.
  static String a11yLabel(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return 'Network error: content unavailable. Tap to retry connection.';
      case ErrorType.server:
        return 'Service temporarily unavailable. Tap to check status.';
      case ErrorType.client:
        return 'Action not permitted. Check your permissions in Settings.';
      case ErrorType.rateLimit:
        return 'Rate limited. Please wait before trying again.';
      case ErrorType.graph:
        return 'Graph data incomplete. Some connections may be missing.';
      case ErrorType.media:
        return 'Media failed to load. Will retry automatically.';
      case ErrorType.unknown:
        return 'An error occurred. Tap to retry or contact support.';
    }
  }

  /// Get the retry action for an error type.
  static RetryAction retryAction(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return RetryAction.exponentialBackoff;
      case ErrorType.server:
        return RetryAction.healthCheck;
      case ErrorType.client:
        return RetryAction.disableCta;
      case ErrorType.rateLimit:
        return RetryAction.exponentialBackoff;
      case ErrorType.graph:
        return RetryAction.retry;
      case ErrorType.media:
        return RetryAction.retry;
      case ErrorType.unknown:
        return RetryAction.retry;
    }
  }

  /// Whether to show cached fallback data for this error type.
  static bool showCachedFallback(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return true; // Show cached feed/settings
      case ErrorType.server:
        return true; // Show cached data if available
      case ErrorType.graph:
        return true; // Show partial graph
      default:
        return false;
    }
  }

  /// Whether to show a full-screen error vs inline banner.
  static bool isFullScreen(ErrorType type) {
    return type == ErrorType.server;
  }

  /// Screen-specific error overrides.
  static String screenMessage(String screenId, ErrorType type) {
    final overrides = _screenOverrides[screenId];
    if (overrides != null && overrides.containsKey(type)) {
      return overrides[type]!;
    }
    return userMessage(type);
  }

  static const Map<String, Map<ErrorType, String>> _screenOverrides = {
    'the_line_screen': {
      ErrorType.network:
          'Offline: Showing cached Line. Swipe to refresh when connected.',
    },
    'discovery_page_screen': {
      ErrorType.network:
          'Discovery unavailable offline. Showing cached results.',
    },
    'photplay_studio_screen': {
      ErrorType.server:
          'Premium animation service unavailable. Using standard quality.',
    },
    'memory_box_screen': {
      ErrorType.network:
          'Memory Box unavailable offline. Showing cached vault.',
    },
    'tree_graph_screen': {
      ErrorType.graph: 'Branch subgraph incomplete. Showing known connections.',
    },
    'rooms_screen': {
      ErrorType.client: 'Could not join Room. Check Kin Score requirement.',
    },
  };
}

