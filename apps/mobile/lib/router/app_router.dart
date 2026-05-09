import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../guards/auth_route_guard.dart';
import '../guards/step_up_route_guard.dart';
import '../screens/account_settings_screen.dart';
import '../screens/activity_center_screen.dart';
import '../screens/ancestral_marketplace_screen.dart';
import '../screens/balance_screen.dart';
import '../features/create/screens/photplay_studio_screen.dart';
import '../screens/branch_detail_screen.dart';
import '../screens/branch_discovery_screen.dart';
import '../screens/branch_members_screen.dart';
import '../screens/branch_subgraph_screen.dart';
import '../screens/business_tools_screen.dart';
import '../screens/comment_thread_screen.dart';
import '../screens/content_preferences_screen.dart';
import '../screens/data_deletion_screen.dart';
import '../screens/data_export_screen.dart';
import '../screens/deep_link_handler_screen.dart';
import '../screens/discovery_card_screen.dart';
import '../screens/discovery_page_screen.dart';
import '../screens/dm_thread_screen.dart';
import '../screens/echoes_feed_screen.dart';
import '../screens/email_signup_screen.dart';
import '../screens/family_pairing_screen.dart';
import '../screens/family_pairing_setup_screen.dart';
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
import '../screens/marketplace_cart_screen.dart';
import '../screens/marketplace_create_listing_screen.dart';
import '../screens/marketplace_orders_screen.dart';
import '../screens/marketplace_product_detail_screen.dart';
import '../screens/marketplace_seller_dashboard_screen.dart';
import '../screens/marketplace_wishlist_screen.dart';
import '../screens/memory_box_screen.dart';
import '../screens/memory_box_settings_screen.dart';
import '../screens/memory_detail_screen.dart';
import '../screens/memory_edit_screen.dart';
import '../screens/messaging_screen.dart';
import '../screens/night_mode_screen.dart';
import '../screens/notifications_settings_screen.dart';
import '../screens/offline_videos_screen.dart';
import '../screens/otp_verification_screen.dart';
import '../screens/payment_history_screen.dart';
import '../screens/personal_tools_screen.dart';
import '../screens/phone_signup_screen.dart';
import '../screens/privacy_settings_screen.dart';
import '../screens/profile_edit_screen.dart';
import '../screens/pulse_inbox_screen.dart';
import '../screens/register_screen.dart';
import '../screens/repost_stitch_screen.dart';
import '../screens/rewind_creator_screen.dart';
import '../screens/root_profile_screen.dart';
import '../screens/room_list_screen.dart';
import '../screens/rooms_screen.dart';
import '../screens/root_screen.dart';
import '../screens/security_settings_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/steward_agreement_screen.dart';
import '../screens/steward_consent_screen_1.dart';
import '../screens/strand_detail_screen.dart';
import '../screens/strand_list_screen.dart';
import '../screens/subscription_screen.dart';
import '../screens/support_chat_screen.dart';
import '../screens/time_wellbeing_screen.dart';
import '../screens/tree_graph_screen.dart';
import '../screens/tree_screen.dart';
import '../screens/voiceprint_capture_screen.dart';
import '../screens/welcome_screen.dart';
import '../services/auth_service.dart';
import '../theme/colors.dart';
import '../widgets/create_bottom_sheet.dart';

final _rootKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

/// Build the main GoRouter (call from MyApp.build).
///
/// Integrates:
/// - AuthRouteGuard for auto-redirect (unauthenticated â†’ /onboarding)
/// - ShellRoute preserving BLoC state across bottom-nav tabs (PRD Â§11.4)
/// - Deep-link routes for all entry points (kinnect://)
/// - StepUpRouteGuard wrapping sensitive operations
/// - 48+ screens with full routing structure
GoRouter buildAppRouter(AuthService authService) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/splash',
    redirect: (context, state) => AuthRouteGuard.redirect(context, state),
    refreshListenable: authService,
    routes: [
      // â”€â”€ Splash â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),

      // â”€â”€ Bottom Navigation Shell (PRD Â§11.4) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (_, __, child) => _MainShell(child: child),
        routes: [
          GoRoute(
            path: '/line',
            pageBuilder: (_, __) => const NoTransitionPage(child: LineScreen()),
          ),
          GoRoute(
            path: '/discover',
            pageBuilder: (_, __) =>
                const NoTransitionPage(child: DiscoveryPageScreen()),
          ),
          GoRoute(
            path: '/tree',
            pageBuilder: (_, __) => const NoTransitionPage(child: TreeScreen()),
          ),
          GoRoute(
            path: '/root',
            pageBuilder: (_, __) => const NoTransitionPage(child: RootScreen()),
          ),
        ],
      ),

      // â”€â”€ Authentication â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(
        path: '/email-signup',
        builder: (_, __) => const EmailSignUpScreen(),
      ),
      GoRoute(
        path: '/phone-signup',
        builder: (_, __) => const PhoneSignUpScreen(),
      ),
      GoRoute(
        path: '/otp-verification',
        builder: (_, __) => const OTPVerificationScreen(),
      ),
      GoRoute(
        path: '/voiceprint-capture',
        builder: (_, __) => const VoiceprintCaptureScreen(),
      ),
      GoRoute(
        path: '/time-wellbeing',
        builder: (_, __) => const TimeWellbeingScreen(),
      ),
      GoRoute(
        path: '/kin-score-required',
        builder: (ctx, state) {
          final score =
              double.tryParse(state.uri.queryParameters['score'] ?? '');
          return KinScoreRequiredScreen(requiredScore: score);
        },
      ),

      // â”€â”€ Deep Links (kinnect://) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      GoRoute(
        path: '/memory/:id',
        builder: (_, state) => MemoryDetailScreen(
          memoryId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/vault/seal',
        builder: (_, __) => const StepUpRouteGuard(
          reason: 'Sealing a Memory Box requires additional verification.',
          child: MemoryBoxScreen(),
        ),
      ),
      GoRoute(
        path: '/vault/:memoryId',
        builder: (_, state) =>
            MemoryBoxScreen(memoryId: state.pathParameters['memoryId']),
      ),
      GoRoute(
        path: '/discovery/:candidateId',
        builder: (_, state) => DiscoveryCardScreen(
          candidateId: state.pathParameters['candidateId']!,
        ),
      ),
      GoRoute(
        path: '/room/:roomId',
        builder: (_, state) =>
            RoomsScreen(roomId: state.pathParameters['roomId']!),
      ),
      GoRoute(
        path: '/rooms',
        builder: (_, __) => const RoomListScreen(),
      ),

      // â”€â”€ Memory Box â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      GoRoute(
        path: '/memory-box',
        builder: (_, __) => const MemoryBoxScreen(),
      ),
      GoRoute(
        path: '/memory/:memoryId/comments',
        builder: (_, state) => CommentThreadScreen(
          memoryId: state.pathParameters['memoryId']!,
        ),
      ),
      GoRoute(
        path: '/memory/:memoryId/edit',
        builder: (_, state) => MemoryEditScreen(
          memoryId: state.pathParameters['memoryId']!,
        ),
      ),
      GoRoute(
        path: '/settings/memory-box',
        builder: (_, __) => const MemoryBoxSettingsScreen(),
      ),

      // â”€â”€ Discovery & Community â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      GoRoute(
        path: '/branch/:branchId',
        builder: (_, state) =>
            BranchDetailScreen(branchId: state.pathParameters['branchId']!),
      ),
      GoRoute(
        path: '/branch/:branchId/members',
        builder: (_, state) => BranchMembersScreen(
          branchId: state.pathParameters['branchId']!,
        ),
      ),
      GoRoute(
        path: '/branch/:branchId/merge',
        builder: (_, state) => BranchSubgraphScreen(
          branchId: state.pathParameters['branchId']!,
        ),
      ),
      GoRoute(
        path: '/strand/:strandId',
        builder: (_, state) => StrandDetailScreen(
          strandId: state.pathParameters['strandId']!,
        ),
      ),
      GoRoute(
        path: '/strands',
        builder: (_, __) => const StrandListScreen(),
      ),

      // â”€â”€ Commerce (Marketplace & E-commerce) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      GoRoute(
        path: '/marketplace',
        builder: (_, __) => const AncestralMarketplaceScreen(),
      ),
      GoRoute(
        path: '/marketplace/product/:id',
        builder: (_, state) => MarketplaceProductDetailScreen(
          productId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/marketplace/cart',
        builder: (_, __) => const MarketplaceCartScreen(),
      ),
      GoRoute(
        path: '/marketplace/orders',
        builder: (_, __) => const MarketplaceOrdersScreen(),
      ),
      GoRoute(
        path: '/marketplace/wishlist',
        builder: (_, __) => const MarketplaceWishlistScreen(),
      ),
      GoRoute(
        path: '/marketplace/seller',
        builder: (_, __) => const MarketplaceSellerDashboardScreen(),
      ),
      GoRoute(
        path: '/marketplace/create-listing',
        builder: (_, __) => const MarketplaceCreateListingScreen(),
      ),
      GoRoute(
        path: '/settings/balance',
        builder: (_, __) => const BalanceScreen(),
      ),
      GoRoute(
        path: '/subscription',
        builder: (_, __) => const SubscriptionScreen(),
      ),
      GoRoute(
        path: '/payment-history',
        builder: (_, __) => const PaymentHistoryScreen(),
      ),
      GoRoute(
        path: '/photplay',
        builder: (_, __) => const PhotplayStudioScreen(),
      ),

      // â”€â”€ Messaging & Rooms â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      GoRoute(
        path: '/dm/:kinId',
        builder: (_, state) =>
            MessagingScreen(kinId: state.pathParameters['kinId']!),
      ),
      GoRoute(
        path: '/dm-thread/:threadId/:peerId',
        builder: (_, state) => DmThreadScreen(
          threadId: state.pathParameters['threadId']!,
          peerId: state.pathParameters['peerId']!,
          currentUserId: state.uri.queryParameters['me'] ?? 'current_user',
        ),
      ),
      GoRoute(
        path: '/pulse-inbox',
        builder: (_, __) => const PulseInboxScreen(),
      ),

      // â”€â”€ Settings & Account â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      GoRoute(
        path: '/settings',
        builder: (_, __) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/account',
        builder: (_, __) => const AccountSettingsScreen(),
      ),
      GoRoute(
        path: '/settings/privacy',
        builder: (_, __) => const PrivacySettingsScreen(),
      ),
      GoRoute(
        path: '/settings/security',
        builder: (_, __) => const SecuritySettingsScreen(),
      ),
      GoRoute(
        path: '/settings/notifications',
        builder: (_, __) => const NotificationsSettingsScreen(),
      ),
      GoRoute(
        path: '/settings/content-preferences',
        builder: (_, __) => const ContentPreferencesScreen(),
      ),
      GoRoute(
        path: '/settings/business-tools',
        builder: (_, __) => const BusinessToolsScreen(),
      ),
      GoRoute(
        path: '/settings/personal-tools',
        builder: (_, __) => const PersonalToolsScreen(),
      ),
      GoRoute(
        path: '/settings/offline-videos',
        builder: (_, __) => const OfflineVideosScreen(),
      ),
      GoRoute(
        path: '/settings/night-mode',
        builder: (_, __) => const NightModeScreen(),
      ),
      GoRoute(
        path: '/settings/activity-center',
        builder: (_, __) => const ActivityCenterScreen(),
      ),
      GoRoute(
        path: '/settings/family-pairing',
        builder: (_, __) => const FamilyPairingScreen(),
      ),
      GoRoute(
        path: '/settings/family-pairing/setup',
        builder: (_, __) => const FamilyPairingSetupScreen(),
      ),
      GoRoute(
        path: '/settings/help-center',
        builder: (_, __) => const HelpCenterScreen(),
      ),
      GoRoute(
        path: '/settings/guidelines',
        builder: (_, __) => const GuidelinesScreen(),
      ),
      GoRoute(
        path: '/settings/data-export',
        builder: (_, __) => const DataExportScreen(),
      ),
      GoRoute(
        path: '/settings/delete',
        builder: (_, __) => const StepUpRouteGuard(
          reason: 'Account deletion requires additional verification.',
          child: DataDeletionScreen(),
        ),
      ),
      GoRoute(
        path: '/settings/delete-account',
        builder: (_, __) => const DataDeletionScreen(),
      ),
      GoRoute(
        path: '/profile-edit',
        builder: (_, __) => const ProfileEditScreen(),
      ),

      // â”€â”€ Metadata & Info â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      GoRoute(
        path: '/legal/:documentType',
        builder: (_, state) {
          final docType = state.pathParameters['documentType'] ?? 'terms';
          return LegalDocumentScreen(documentType: docType);
        },
      ),
      GoRoute(
        path: '/steward-agreement',
        builder: (_, __) => const StewardAgreementScreen(),
      ),
      GoRoute(
        path: '/steward-consent-1',
        builder: (_, __) => const StewardConsentScreen1(
          userId: 'current_user',
          ipAddress: '0.0.0.0',
          userAgent: 'mobile-app',
        ),
      ),
      GoRoute(
        path: '/kinnections',
        builder: (_, __) => const KinnectionsFeedScreen(),
      ),

      // â”€â”€ Genomics â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      GoRoute(
        path: '/gedcom-import',
        builder: (_, __) => const GedcomImportScreen(),
      ),
      GoRoute(
        path: '/dna-kit',
        builder: (_, __) => const VoiceprintCaptureScreen(),
      ),

      // â”€â”€ Alert & Map â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      GoRoute(
        path: '/alert/:alertId/map',
        builder: (_, state) => KinshipAlertMapScreen(
          alertId: state.pathParameters['alertId']!,
        ),
      ),

      // â”€â”€ Kin Score â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      GoRoute(
        path: '/kin-score-detail',
        builder: (_, state) {
          final target = state.uri.queryParameters['target'] ?? '';
          return KinScoreDetailScreen(targetUserId: target);
        },
      ),

      // â”€â”€ Rewind & Content â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      GoRoute(
        path: '/rewind/:memoryId',
        builder: (_, state) =>
            RewindCreatorScreen(memoryId: state.pathParameters['memoryId']!),
      ),
      GoRoute(
        path: '/echoes',
        builder: (_, __) => const EchoesFeedScreen(),
      ),

      // â”€â”€ Catch-all 404 â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      GoRoute(
        path: '/:rest(.*)',
        builder: (_, state) {
          final path = state.pathParameters['rest'] ?? '';
          return Scaffold(
            body: Center(
              child: Text('Route not found: /$path'),
            ),
          );
        },
      ),
    ],
  );
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Shared Shells
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _MainShell extends StatefulWidget {
  const _MainShell({required this.child});

  final Widget child;

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  late GoRouter _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _router = GoRouter.of(context);
  }

  int _currentIndex(String location) {
    if (location.startsWith('/discover')) return 1;
    if (location.startsWith('/tree')) return 2;
    if (location.startsWith('/root')) return 3;
    return 0; // /line
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
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
                active: _currentIndex(GoRouterState.of(context).matchedLocation) ==
                    0,
                onTap: () => _router.go('/line'),
              ),
              _NavItem(
                icon: PhosphorIcons.binoculars(),
                label: 'Discover',
                active: _currentIndex(GoRouterState.of(context).matchedLocation) ==
                    1,
                onTap: () => _router.go('/discover'),
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
                  child:
                      Icon(PhosphorIcons.plus(), color: Colors.white, size: 24),
                ),
              ),
              _NavItem(
                icon: PhosphorIcons.treeStructure(),
                label: 'Tree',
                active: _currentIndex(GoRouterState.of(context).matchedLocation) ==
                    2,
                onTap: () => _router.go('/tree'),
              ),
              _NavItem(
                icon: PhosphorIcons.user(),
                label: 'Root',
                active: _currentIndex(GoRouterState.of(context).matchedLocation) ==
                    3,
                onTap: () => _router.go('/root'),
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
    final color =
        active ? KinnectColors.accent : KinnectColors.textSecondary;
    return Semantics(
      label: '$label${active ? ", selected" : ""}',
      button: true,
      selected: active,
      child: GestureDetector(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 2),
              Text(label,
                  style: TextStyle(fontSize: 10, color: color),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Deprecated: Old AppRouter class (kept for backwards compatibility)
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

@Deprecated(
  'Use buildAppRouter(authService) instead. '
  'Old AppRouter constants moved to router documentation.',
)
class AppRouter {
  AppRouter._();

  static const String welcome = '/welcome';
  static const String onboarding = '/onboarding';
  static const String line = '/line';
  static const String tree = '/tree';
  static const String root = '/root';
  static const String discover = '/discover';
  static const String settings = '/settings';
  static const String splash = '/splash';

  static void showCreateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const CreateBottomSheet(),
    );
  }

  static void showStrandSheet(BuildContext context, String memoryId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => StrandManagerSheet(memoryId: memoryId),
    );
  }

  static void showShareSheet(
    BuildContext context,
    String memoryId,
    String memoryUrl,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ShareSheet(memoryId: memoryId, memoryUrl: memoryUrl),
    );
  }

  static void showPulseReactionSheet(
    BuildContext context,
    String memoryId,
    Function(bool) onPulseToggle,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) =>
          PulseReactionSheet(memoryId: memoryId, onPulseToggle: onPulseToggle),
    );
  }

  static void showCommentComposerSheet(
    BuildContext context,
    String memoryId,
    Function(String) onSubmit, {
    String? replyToCommentId,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => CommentComposerSheet(
        memoryId: memoryId,
        replyToCommentId: replyToCommentId,
        onSubmit: onSubmit,
      ),
    );
  }

  static void showKinshipBadgeSheet(
    BuildContext context,
    double kinScore,
    String relationshipType,
    String targetUserId,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => KinshipBadgeSheet(
        kinScore: kinScore,
        relationshipType: relationshipType,
        targetUserId: targetUserId,
      ),
    );
  }
}

