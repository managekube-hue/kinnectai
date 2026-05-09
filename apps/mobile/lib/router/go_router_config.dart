import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../screens/account_settings_screen.dart';
import '../screens/activity_center_screen.dart';
import '../screens/ancestral_marketplace_screen.dart';
import '../screens/balance_screen.dart';
import '../screens/bloom_screen.dart';
import '../screens/branch_detail_screen.dart';
import '../screens/branch_discovery_screen.dart';
import '../screens/branch_members_screen.dart';
import '../screens/branch_subgraph_screen.dart';
import '../screens/business_tools_screen.dart';
import '../screens/comment_thread_screen.dart';
import '../screens/content_preferences_screen.dart';
import '../screens/data_export_screen.dart';
import '../screens/deep_link_handler_screen.dart';
import '../screens/discovery_page_screen.dart';
import '../screens/echoes_feed_screen.dart';
import '../screens/email_signup_screen.dart';
import '../screens/family_pairing_screen.dart';
import '../screens/gedcom_import_screen.dart';
import '../screens/guidelines_screen.dart';
import '../screens/help_center_screen.dart';
import '../screens/kin_score_detail_screen.dart';
import '../screens/kin_score_required_screen.dart';
import '../screens/kinnections_feed_screen.dart';
import '../screens/kinship_alert_map_screen.dart';
import '../screens/legal_document_screen.dart';
import '../screens/line_screen.dart';
import '../screens/login_screen.dart';
import '../screens/memory_box_screen.dart';
import '../screens/memory_detail_screen.dart';
import '../screens/memory_edit_screen.dart';
import '../screens/night_mode_screen.dart';
import '../screens/notifications_settings_screen.dart';
import '../screens/offline_videos_screen.dart';
import '../screens/payment_history_screen.dart';
import '../screens/personal_tools_screen.dart';
import '../screens/phone_signup_screen.dart';
import '../screens/privacy_settings_screen.dart';
import '../screens/profile_edit_screen.dart';
import '../screens/register_screen.dart';
import '../screens/repost_stitch_screen.dart';
import '../screens/rewind_creator_screen.dart';
import '../screens/root_profile_screen.dart';
import '../screens/security_settings_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/steward_agreement_screen.dart';
import '../screens/strand_detail_screen.dart';
import '../screens/strand_list_screen.dart';
import '../screens/support_chat_screen.dart';
import '../screens/time_wellbeing_screen.dart';
import '../screens/tree_graph_screen.dart';
import '../screens/voiceprint_capture_screen.dart';
import '../screens/welcome_screen.dart';
import 'app_route_policy.dart';
import '../services/auth_service.dart';
import '../theme/colors.dart';
import '../widgets/create_bottom_sheet.dart';

class AppGoRouter {
  AppGoRouter._();

  static GoRouter router(AuthService authService) {
    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: authService,
      redirect: (context, state) {
        return AppRoutePolicy.resolveRedirect(
          uri: state.uri,
          matchedLocation: state.matchedLocation,
          isLoggedIn: authService.isLoggedIn,
        );
      },
      routes: <RouteBase>[
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return _MainShell(location: state.matchedLocation, child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/line',
            builder: (BuildContext context, GoRouterState state) =>
                const LineScreen(),
          ),
          GoRoute(
            path: '/repost-stitch',
            builder: (BuildContext context, GoRouterState state) =>
                const RepostStitchScreen(),
          ),
          GoRoute(
            path: '/discover',
            builder: (BuildContext context, GoRouterState state) =>
                const DiscoveryPageScreen(),
          ),
          GoRoute(
            path: '/tree',
            builder: (BuildContext context, GoRouterState state) =>
                const TreeGraphScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (BuildContext context, GoRouterState state) =>
                const RootProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/splash',
        builder: (BuildContext context, GoRouterState state) =>
            const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (BuildContext context, GoRouterState state) =>
            const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (BuildContext context, GoRouterState state) =>
            const RegisterScreen(),
      ),
      GoRoute(
        path: '/email-signup',
        builder: (BuildContext context, GoRouterState state) =>
            const EmailSignUpScreen(),
      ),
      GoRoute(
        path: '/phone-signup',
        builder: (BuildContext context, GoRouterState state) =>
            const PhoneSignUpScreen(),
      ),
      GoRoute(
        path: '/voiceprint-capture',
        builder: (BuildContext context, GoRouterState state) =>
            const VoiceprintCaptureScreen(),
      ),
      GoRoute(
        path: '/time-wellbeing',
        builder: (BuildContext context, GoRouterState state) =>
            const TimeWellbeingScreen(),
      ),
      GoRoute(
        path: '/memory-box',
        builder: (BuildContext context, GoRouterState state) =>
            const MemoryBoxScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (BuildContext context, GoRouterState state) =>
            const SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/account',
        builder: (BuildContext context, GoRouterState state) =>
            const AccountSettingsScreen(),
      ),
      GoRoute(
        path: '/settings/privacy',
        builder: (BuildContext context, GoRouterState state) =>
            const PrivacySettingsScreen(),
      ),
      GoRoute(
        path: '/settings/notifications',
        builder: (BuildContext context, GoRouterState state) =>
            const NotificationsSettingsScreen(),
      ),
      GoRoute(
        path: '/settings/security',
        builder: (BuildContext context, GoRouterState state) =>
            const SecuritySettingsScreen(),
      ),
      GoRoute(
        path: '/settings/content-preferences',
        builder: (BuildContext context, GoRouterState state) =>
            const ContentPreferencesScreen(),
      ),
      GoRoute(
        path: '/settings/business-tools',
        builder: (BuildContext context, GoRouterState state) =>
            const BusinessToolsScreen(),
      ),
      GoRoute(
        path: '/settings/balance',
        builder: (BuildContext context, GoRouterState state) =>
            const BalanceScreen(),
      ),
      GoRoute(
        path: '/settings/personal-tools',
        builder: (BuildContext context, GoRouterState state) =>
            const PersonalToolsScreen(),
      ),
      GoRoute(
        path: '/settings/offline-videos',
        builder: (BuildContext context, GoRouterState state) =>
            const OfflineVideosScreen(),
      ),
      GoRoute(
        path: '/settings/night-mode',
        builder: (BuildContext context, GoRouterState state) =>
            const NightModeScreen(),
      ),
      GoRoute(
        path: '/settings/activity-center',
        builder: (BuildContext context, GoRouterState state) =>
            const ActivityCenterScreen(),
      ),
      GoRoute(
        path: '/settings/family-pairing',
        builder: (BuildContext context, GoRouterState state) =>
            const FamilyPairingScreen(),
      ),
      GoRoute(
        path: '/settings/help-center',
        builder: (BuildContext context, GoRouterState state) =>
            const HelpCenterScreen(),
      ),
      GoRoute(
        path: '/settings/guidelines',
        builder: (BuildContext context, GoRouterState state) =>
            const GuidelinesScreen(),
      ),
      GoRoute(
        path: '/settings/data-export',
        builder: (BuildContext context, GoRouterState state) =>
            const DataExportScreen(),
      ),
      GoRoute(
        path: '/legal/:documentType',
        builder: (BuildContext context, GoRouterState state) {
          final documentType = state.pathParameters['documentType'] ?? 'terms';
          return LegalDocumentScreen(documentType: documentType);
        },
      ),
      GoRoute(
        path: '/vault/:memoryId',
        builder: (BuildContext context, GoRouterState state) =>
            const MemoryBoxScreen(),
      ),
      GoRoute(
        path: '/alert/:alertId/map',
        builder: (BuildContext context, GoRouterState state) =>
            const KinshipAlertMapScreen(),
      ),
      GoRoute(
        path: '/branch/:branchId/merge',
        builder: (BuildContext context, GoRouterState state) {
          final branchId = state.pathParameters['branchId'];
          return BranchSubgraphScreen(branchId: branchId);
        },
      ),
      GoRoute(
        path: '/memory/:memoryId/comments',
        builder: (BuildContext context, GoRouterState state) {
          final memoryId = state.pathParameters['memoryId'] ?? '';
          return CommentThreadScreen(memoryId: memoryId);
        },
      ),
      GoRoute(
        path: '/branch/:branchId',
        builder: (BuildContext context, GoRouterState state) {
          final branchId = state.pathParameters['branchId'] ?? '';
          return BranchDetailScreen(branchId: branchId);
        },
      ),
      GoRoute(
        path: '/branch/:branchId/members',
        builder: (BuildContext context, GoRouterState state) {
          final branchId = state.pathParameters['branchId'] ?? '';
          return BranchMembersScreen(branchId: branchId);
        },
      ),
      GoRoute(
        path: '/strand/:strandId',
        builder: (BuildContext context, GoRouterState state) {
          final strandId = state.pathParameters['strandId'] ?? '';
          return StrandDetailScreen(strandId: strandId);
        },
      ),
      GoRoute(
        path: '/strands',
        builder: (BuildContext context, GoRouterState state) =>
            const StrandListScreen(),
      ),
      GoRoute(
        path: '/create/rewind/:memoryId',
        builder: (BuildContext context, GoRouterState state) {
          final memoryId = state.pathParameters['memoryId'] ?? '';
          return RewindCreatorScreen(memoryId: memoryId);
        },
      ),
      GoRoute(
        path: '/rewind',
        builder: (BuildContext context, GoRouterState state) {
          final args = state.extra as Map<String, dynamic>?;
          final memoryId = (args?['memoryId'] ?? '').toString();
          return RewindCreatorScreen(memoryId: memoryId);
        },
      ),
      GoRoute(
        path: '/root/:userId',
        builder: (BuildContext context, GoRouterState state) {
          final userId = state.pathParameters['userId'];
          return RootProfileScreen(userId: userId);
        },
      ),
      GoRoute(
        path: '/root/:userId/profile',
        builder: (BuildContext context, GoRouterState state) {
          final userId = state.pathParameters['userId'];
          return RootProfileScreen(userId: userId);
        },
      ),
      GoRoute(
        path: '/line/:memoryId/echo',
        builder: (BuildContext context, GoRouterState state) =>
            const LineScreen(),
      ),
      GoRoute(
        path: '/kin-score-detail',
        builder: (BuildContext context, GoRouterState state) {
          final target = state.uri.queryParameters['target'] ?? '';
          return KinScoreDetailScreen(targetUserId: target);
        },
      ),
      // --- Bloom Studio ---
      GoRoute(
        path: '/create/bloom',
        builder: (BuildContext context, GoRouterState state) =>
            const BloomScreen(),
      ),
      // --- Echoes Feed ---
      GoRoute(
        path: '/echoes',
        builder: (BuildContext context, GoRouterState state) =>
            const EchoesFeedScreen(),
      ),
      // --- Kinnections Feed ---
      GoRoute(
        path: '/kinnections',
        builder: (BuildContext context, GoRouterState state) =>
            const KinnectionsFeedScreen(),
      ),
      // --- Memory Detail + Edit ---
      GoRoute(
        path: '/memory/:memoryId',
        builder: (BuildContext context, GoRouterState state) {
          final memoryId = state.pathParameters['memoryId'] ?? '';
          return MemoryDetailScreen(memoryId: memoryId);
        },
      ),
      GoRoute(
        path: '/memory/:memoryId/edit',
        builder: (BuildContext context, GoRouterState state) {
          final memoryId = state.pathParameters['memoryId'] ?? '';
          return MemoryEditScreen(memoryId: memoryId);
        },
      ),
      // --- Branch Discovery ---
      GoRoute(
        path: '/branches/discover',
        builder: (BuildContext context, GoRouterState state) =>
            const BranchDiscoveryScreen(),
      ),
      // --- GEDCOM Import ---
      GoRoute(
        path: '/import/gedcom',
        builder: (BuildContext context, GoRouterState state) =>
            const GedcomImportScreen(),
      ),
      // --- Profile Edit ---
      GoRoute(
        path: '/profile/edit',
        builder: (BuildContext context, GoRouterState state) =>
            const ProfileEditScreen(),
      ),
      // --- Steward Consent ---
      GoRoute(
        path: '/steward-consent',
        builder: (BuildContext context, GoRouterState state) {
          final memoryId = state.uri.queryParameters['memory_id'];
          return StewardAgreementScreen(memoryId: memoryId);
        },
      ),
      // --- Support Chat ---
      GoRoute(
        path: '/support',
        builder: (BuildContext context, GoRouterState state) =>
            const SupportChatScreen(),
      ),
      // --- Payment History ---
      GoRoute(
        path: '/settings/payment-history',
        builder: (BuildContext context, GoRouterState state) =>
            const PaymentHistoryScreen(),
      ),
      // --- Kinship Alerts ---
      GoRoute(
        path: '/kinship-alerts',
        builder: (BuildContext context, GoRouterState state) =>
            const KinshipAlertMapScreen(),
      ),
      // --- Ancestral Marketplace ---
      GoRoute(
        path: '/marketplace',
        builder: (BuildContext context, GoRouterState state) =>
            const AncestralMarketplaceScreen(),
      ),
      GoRoute(
        path: '/kinnect/:path(.*)',
        builder: (BuildContext context, GoRouterState state) {
          final path = state.pathParameters['path'];
          return DeepLinkHandler(path: path);
        },
      ),
      GoRoute(
        path: '/kin-score-required',
        builder: (BuildContext context, GoRouterState state) {
          final requiredScore = double.tryParse(
            state.uri.queryParameters['score'] ?? '',
          );
          return KinScoreRequiredScreen(requiredScore: requiredScore);
        },
      ),
      GoRoute(
        path: '/:rest(.*)',
        builder: (BuildContext context, GoRouterState state) {
          return Scaffold(
            backgroundColor: KinnectColors.background,
            body: Center(
              child: Text(
                'Route not implemented: /${state.pathParameters['rest'] ?? ''}',
                style: const TextStyle(color: KinnectColors.textPrimary),
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const WelcomeScreen();
        },
      ),
    ],
    );
  }

}

class _MainShell extends StatelessWidget {
  const _MainShell({required this.child, required this.location});

  final Widget child;
  final String location;

  int get _currentIndex {
    if (location.startsWith('/repost-stitch')) {
      return 1;
    }
    if (location.startsWith('/discover')) {
      return 2;
    }
    if (location.startsWith('/tree')) {
      return 3;
    }
    if (location.startsWith('/profile')) {
      return 4;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: SafeArea(
        child: Container(
          color: KinnectColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: PhosphorIcons.house(),
                label: 'Home',
                active: _currentIndex == 0,
                onTap: () => context.go('/line'),
              ),
              _NavItem(
                icon: PhosphorIcons.repeat(),
                label: 'Repost',
                active: _currentIndex == 1,
                onTap: () => context.go('/repost-stitch'),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (_) => const CreateBottomSheet(),
                  );
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: KinnectColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    PhosphorIcons.plus(),
                    color: KinnectColors.background,
                  ),
                ),
              ),
              _NavItem(
                icon: PhosphorIcons.treeStructure(),
                label: 'Tree',
                active: _currentIndex == 3,
                onTap: () => context.go('/tree'),
              ),
              _NavItem(
                icon: PhosphorIcons.user(),
                label: 'Root',
                active: _currentIndex == 4,
                onTap: () => context.go('/profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? KinnectColors.accent : KinnectColors.textSecondary;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: color, fontSize: 11)),
        ],
      ),
    );
  }
}


