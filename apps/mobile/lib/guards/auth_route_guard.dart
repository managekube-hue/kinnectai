import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../router/app_route_policy.dart';
import '../services/auth_service.dart';

/// Route guard that redirects unauthenticated users to /onboarding
/// and authenticated users away from onboarding to /line (PRD §11.4).
///
/// Delegates to [AppRoutePolicy] for the actual redirect logic so that
/// KinScore gating and deep-link normalisation remain in one place.
class AuthRouteGuard {
  AuthRouteGuard._();

  /// Returns a redirect path, or null if navigation should proceed.
  ///
  /// Usage — pass as [GoRouter.redirect]:
  /// ```dart
  /// redirect: (context, state) => AuthRouteGuard.redirect(context, state),
  /// ```
  static String? redirect(BuildContext context, GoRouterState state) {
    final authService = context.read<AuthService>();
    return AppRoutePolicy.resolveRedirect(
      uri: state.uri,
      matchedLocation: state.matchedLocation,
      isLoggedIn: authService.isLoggedIn,
    );
  }
}
