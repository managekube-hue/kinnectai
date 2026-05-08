class AppRoutePolicy {
  AppRoutePolicy._();

  static const Set<String> publicRoutes = <String>{
    '/splash',
    '/welcome',
    '/login',
    '/register',
    '/email-signup',
    '/phone-signup',
    '/kin-score-required',
    '/',
  };

  static const Set<String> authRoutes = <String>{
    '/welcome',
    '/login',
    '/register',
    '/email-signup',
    '/phone-signup',
    '/',
  };

  static String? resolveRedirect({
    required Uri uri,
    required String matchedLocation,
    required bool isLoggedIn,
  }) {
    final normalizedDeepLink = normalizeDeepLink(uri);
    if (normalizedDeepLink != null && normalizedDeepLink != matchedLocation) {
      return normalizedDeepLink;
    }

    if (matchedLocation == '/home') {
      return '/line';
    }

    final isPublicRoute =
        publicRoutes.contains(matchedLocation) || matchedLocation.startsWith('/legal/');

    if (!isLoggedIn && !isPublicRoute) {
      return '/welcome';
    }

    if (isLoggedIn && authRoutes.contains(matchedLocation)) {
      return '/line';
    }

    if (!passesKinScoreGate(uri)) {
      final required = uri.queryParameters['required_kin_score'] ??
          uri.queryParameters['requiredKinScore'];
      final scoreParam = required != null ? '?score=$required' : '';
      return '/kin-score-required$scoreParam';
    }

    return null;
  }

  static bool passesKinScoreGate(Uri uri) {
    final required = double.tryParse(
      uri.queryParameters['required_kin_score'] ??
          uri.queryParameters['requiredKinScore'] ??
          '',
    );
    if (required == null) {
      return true;
    }

    final actual = double.tryParse(
      uri.queryParameters['kin_score'] ??
          uri.queryParameters['kinScore'] ??
          '',
    );
    return actual != null && actual >= required;
  }

  static String? normalizeDeepLink(Uri uri) {
    final isCustomScheme = uri.scheme == 'kinnect';
    final isUniversalLinkHost = uri.host == 'app.kinnectai.app';
    if (!isCustomScheme && !isUniversalLinkHost) {
      return null;
    }

    final host = uri.host;
    final segments = uri.pathSegments.where((segment) => segment.isNotEmpty).toList();

    if (isCustomScheme) {
      if (host == 'vault' && segments.isNotEmpty) {
        return '/vault/${segments.first}';
      }
      if (host == 'root' && segments.length >= 2 && segments[1] == 'profile') {
        return '/root/${segments.first}/profile';
      }
      if (host == 'alert' && segments.length >= 2 && segments[1] == 'map') {
        return '/alert/${segments.first}/map';
      }
      if (host == 'line' && segments.length >= 2 && segments[1] == 'echo') {
        return '/line/${segments.first}/echo';
      }
      if (host == 'branch' && segments.length >= 2 && segments[1] == 'merge') {
        return '/branch/${segments.first}/merge';
      }
      if (host == 'room' && segments.isNotEmpty) {
        return '/line?room=${segments.first}&required_kin_score=0.01';
      }
      if (host == 'live' && segments.isNotEmpty) {
        return '/line?live=${segments.first}&required_kin_score=0.01';
      }
    }

    if (isUniversalLinkHost) {
      final normalizedPath = '/${segments.join('/')}';
      return normalizedPath == '/' ? '/welcome' : normalizedPath;
    }

    return null;
  }
}