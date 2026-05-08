import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/email_signup_screen.dart';
import '../screens/phone_signup_screen.dart';
import '../screens/landing_screen.dart';
import '../screens/legal_document_screen.dart';
import '../screens/home_screen.dart';
import '../screens/line_screen.dart';
import '../screens/creation_hub_screen.dart';
import '../screens/repost_stitch_screen.dart';
import '../screens/tree_graph_screen.dart';
import '../screens/root_profile_screen.dart';
import '../screens/pulse_inbox_screen.dart';
import '../screens/ancestral_marketplace_screen.dart';
import '../screens/branch_subgraph_screen.dart';
import '../screens/rewind_creator_screen.dart';
import '../screens/echoes_feed_screen.dart';
import '../screens/kinnections_feed_screen.dart';
import '../screens/discovery_page_screen.dart';
import '../screens/comment_thread_screen.dart';
import '../screens/kin_score_detail_screen.dart';
import '../screens/voiceprint_capture_screen.dart';
import '../screens/time_wellbeing_screen.dart';
import '../screens/memory_box_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/activity_center_screen.dart';
import '../screens/family_pairing_screen.dart';
import '../screens/help_center_screen.dart';
import '../screens/privacy_settings_screen.dart';
import '../screens/notifications_settings_screen.dart';
import '../screens/account_settings_screen.dart';
import '../screens/security_settings_screen.dart';
import '../screens/content_preferences_screen.dart';
import '../screens/business_tools_screen.dart';
import '../screens/balance_screen.dart';
import '../screens/personal_tools_screen.dart';
import '../screens/qr_code_screen.dart';
import '../screens/offline_videos_screen.dart';
import '../screens/night_mode_screen.dart';
import '../screens/steward_agreement_screen.dart';
import '../screens/kinship_alert_map_screen.dart';
import '../screens/guidelines_screen.dart';
import '../screens/data_export_screen.dart';
import '../screens/profile_edit_screen.dart';
import '../screens/memory_detail_screen.dart';
import '../screens/memory_edit_screen.dart';
import '../screens/strand_list_screen.dart';
import '../screens/strand_detail_screen.dart';
import '../screens/branch_discovery_screen.dart';
import '../screens/branch_detail_screen.dart';
import '../screens/branch_members_screen.dart';
import '../screens/gedcom_import_screen.dart';
import '../screens/subscription_screen.dart';
import '../screens/payment_history_screen.dart';
import '../screens/bloom_screen.dart';
import '../screens/tree_screen.dart';
import '../screens/pulse_screen.dart';
import '../screens/line_feed_screen.dart';
import '../screens/root_screen.dart';
import '../widgets/create_bottom_sheet.dart';
import '../widgets/strand_manager_sheet.dart';
import '../widgets/share_sheet.dart';
import '../widgets/pulse_reaction_sheet.dart';
import '../widgets/comment_composer_sheet.dart';
import '../widgets/kinship_badge_sheet.dart';

class AppRouter {
  // Main routes
  static const String welcome = '/';
  static const String theLine = '/line';
  static const String repostStitch = '/repost-stitch';
  static const String treeGraph = '/tree';
  static const String rootProfile = '/profile';
  static const String pulseInbox = '/pulse-inbox';
  static const String marketplace = '/marketplace';
  static const String branchSubgraph = '/branch';
  static const String rewindCreator = '/rewind';
  static const String echoes = '/echoes';
  static const String kinnections = '/kinnections';
  static const String discovery = '/discovery';
  static const String comments = '/comments';
  static const String kinScoreDetail = '/kin-score';
  static const String voiceprintCapture = '/voiceprint-capture';
  static const String timeWellbeing = '/time-wellbeing';
  
  // Settings routes
  static const String settings = '/settings';
  static const String activityCenter = '/settings/activity-center';
  static const String familyPairing = '/settings/family-pairing';
  static const String helpCenter = '/settings/help-center';
  static const String privacySettings = '/settings/privacy';
  static const String notificationsSettings = '/settings/notifications';
  static const String accountSettings = '/settings/account';
  static const String securitySettings = '/settings/security';
  static const String contentPreferences = '/settings/content-preferences';
  static const String businessTools = '/settings/business-tools';
  static const String balance = '/settings/balance';
  static const String personalTools = '/settings/personal-tools';
  static const String qrCode = '/settings/qr-code';
  static const String offlineVideos = '/settings/offline-videos';
  static const String nightMode = '/settings/night-mode';
  static const String stewardAgreement = '/settings/steward-agreement';
  static const String kinshipAlertMap = '/kinship-alert-map';
  static const String guidelines = '/settings/guidelines';
  static const String dataExport = '/settings/data-export';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;
    
    switch (settings.name) {
      // ============= Auth Routes =============
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/welcome':
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/email-signup':
        return MaterialPageRoute(builder: (_) => const EmailSignUpScreen());
      case '/phone-signup':
        return MaterialPageRoute(builder: (_) => const PhoneSignUpScreen());
      case '/landing':
        return MaterialPageRoute(builder: (_) => const LandingScreen());

      // ============= Core Navigation =============
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case welcome:
      case '/':
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case theLine:
        return MaterialPageRoute(builder: (_) => const LineScreen());
      case '/creation-hub':
        return MaterialPageRoute(builder: (_) => const CreationHubScreen());
      case treeGraph:
        return MaterialPageRoute(builder: (_) => const TreeGraphScreen());
      case rootProfile:
        final userId = args?['userId'] as String?;
        return MaterialPageRoute(builder: (_) => RootProfileScreen(userId: userId));

      // ============= Main Feeds =============
      case repostStitch:
        return MaterialPageRoute(builder: (_) => const RepostStitchScreen());
      case echoes:
        return MaterialPageRoute(builder: (_) => const EchoesFeedScreen());
      case kinnections:
        return MaterialPageRoute(builder: (_) => const KinnectionsFeedScreen());
      case discovery:
        return MaterialPageRoute(builder: (_) => const DiscoveryPageScreen());
      case pulseInbox:
        return MaterialPageRoute(builder: (_) => const PulseInboxScreen());
      case marketplace:
        return MaterialPageRoute(builder: (_) => const AncestralMarketplaceScreen());

      // ============= Memory & Content =============
      case '/memory-box':
        return MaterialPageRoute(builder: (_) => const MemoryBoxScreen());
      case comments:
        final memoryId = args?['memoryId'] as String?;
        return MaterialPageRoute(builder: (_) => CommentThreadScreen(memoryId: memoryId ?? ''));
      case kinScoreDetail:
        final targetUserId = args?['targetUserId'] as String? ?? '';
        return MaterialPageRoute(builder: (_) => KinScoreDetailScreen(targetUserId: targetUserId));

      // ============= Creation Tools =============
      case voiceprintCapture:
        return MaterialPageRoute(builder: (_) => const VoiceprintCaptureScreen());
      case timeWellbeing:
        return MaterialPageRoute(builder: (_) => const TimeWellbeingScreen());
      case rewindCreator:
        final memoryId = args?['memoryId'] as String? ?? '';
        return MaterialPageRoute(builder: (_) => RewindCreatorScreen(memoryId: memoryId));
      case branchSubgraph:
        final branchId = args?['branchId'] as String?;
        return MaterialPageRoute(
          builder: (_) => BranchSubgraphScreen(branchId: branchId),
          fullscreenDialog: true,
        );
      case '/bloom-studio':
        return MaterialPageRoute(builder: (_) => const BloomScreen());
      case '/tree-screen':
        return MaterialPageRoute(builder: (_) => const TreeScreen());
      case '/pulse-screen':
        return MaterialPageRoute(builder: (_) => const PulseScreen());

      // ============= Settings & Profile =============
      case '/settings':
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case '/profile/edit':
        return MaterialPageRoute(builder: (_) => const ProfileEditScreen());
      case '/settings/privacy':
      case privacySettings:
        return MaterialPageRoute(builder: (_) => const PrivacySettingsScreen());
      case '/settings/notifications':
      case notificationsSettings:
        return MaterialPageRoute(builder: (_) => const NotificationsSettingsScreen());
      case '/settings/account':
      case accountSettings:
        return MaterialPageRoute(builder: (_) => const AccountSettingsScreen());
      case '/settings/security':
      case securitySettings:
        return MaterialPageRoute(builder: (_) => const SecuritySettingsScreen());
      case '/settings/content-preferences':
      case contentPreferences:
        return MaterialPageRoute(builder: (_) => const ContentPreferencesScreen());
      case '/settings/business-tools':
      case businessTools:
        return MaterialPageRoute(builder: (_) => const BusinessToolsScreen());
      case '/settings/activity-center':
      case activityCenter:
        return MaterialPageRoute(builder: (_) => const ActivityCenterScreen());
      case '/settings/family-pairing':
      case familyPairing:
        return MaterialPageRoute(builder: (_) => const FamilyPairingScreen());
      case '/settings/help-center':
      case helpCenter:
        return MaterialPageRoute(builder: (_) => const HelpCenterScreen());

      // ============= Settings Sub-screens =============
      case '/settings/balance':
      case balance:
        return MaterialPageRoute(builder: (_) => const BalanceScreen());
      case '/settings/personal-tools':
      case personalTools:
        return MaterialPageRoute(builder: (_) => const PersonalToolsScreen());
      case '/settings/qr-code':
      case qrCode:
        return MaterialPageRoute(builder: (_) => const QRCodeScreen());
      case '/settings/offline-videos':
      case offlineVideos:
        return MaterialPageRoute(builder: (_) => const OfflineVideosScreen());
      case '/settings/night-mode':
      case nightMode:
        return MaterialPageRoute(builder: (_) => const NightModeScreen());

      // ============= Family & Kinship =============
      case '/steward-agreement':
      case stewardAgreement:
        return MaterialPageRoute(builder: (_) => const StewardAgreementScreen());
      case '/kinship-alert-map':
      case kinshipAlertMap:
        return MaterialPageRoute(builder: (_) => const KinshipAlertMapScreen());

      // ============= Strands & Branches =============
      case '/strands':
        return MaterialPageRoute(builder: (_) => const StrandListScreen());
      case '/branch-discovery':
        return MaterialPageRoute(builder: (_) => const BranchDiscoveryScreen());

      // ============= Data Management =============
      case '/import/gedcom':
        return MaterialPageRoute(builder: (_) => const GedcomImportScreen());
      case '/settings/data-export':
      case dataExport:
        return MaterialPageRoute(builder: (_) => const DataExportScreen());

      // ============= Subscription =============
      case '/subscription':
        return MaterialPageRoute(builder: (_) => const SubscriptionScreen());
      case '/payment-history':
        return MaterialPageRoute(builder: (_) => const PaymentHistoryScreen());

      // ============= Guidelines =============
      case '/settings/guidelines':
      case guidelines:
        return MaterialPageRoute(builder: (_) => const GuidelinesScreen());

      // ============= Dynamic Routes =============
      default:
        // Memory detail routes
        if (settings.name?.startsWith('/memory/') ?? false) {
          final parts = settings.name!.split('/');
          if (parts.length >= 3) {
            final memoryId = parts[2];
            if (parts.length >= 4 && parts[3] == 'comments') {
              return MaterialPageRoute(builder: (_) => CommentThreadScreen(memoryId: memoryId));
            }
            if (parts.length >= 4 && parts[3] == 'edit') {
              return MaterialPageRoute(builder: (_) => MemoryEditScreen(memoryId: memoryId));
            }
            return MaterialPageRoute(builder: (_) => MemoryDetailScreen(memoryId: memoryId));
          }
        }

        // Strand detail routes
        if (settings.name?.startsWith('/strand/') ?? false) {
          final parts = settings.name!.split('/');
          if (parts.length >= 3) {
            final strandId = parts[2];
            return MaterialPageRoute(builder: (_) => StrandDetailScreen(strandId: strandId));
          }
        }

        // Branch detail routes
        if (settings.name?.startsWith('/branch/') ?? false) {
          final parts = settings.name!.split('/');
          if (parts.length >= 3) {
            final branchId = parts[2];
            if (parts.length >= 4 && parts[3] == 'members') {
              return MaterialPageRoute(builder: (_) => BranchMembersScreen(branchId: branchId));
            }
            return MaterialPageRoute(builder: (_) => BranchDetailScreen(branchId: branchId));
          }
        }

        // Legal routes
        if (settings.name?.startsWith('/legal/') ?? false) {
          final documentType = settings.name!.split('/').last;
          return MaterialPageRoute(builder: (_) => LegalDocumentScreen(documentType: documentType));
        }

        // Unknown route fallback
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Route Not Found', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text('Route: ${settings.name}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }

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

  static void showShareSheet(BuildContext context, String memoryId, String memoryUrl) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ShareSheet(memoryId: memoryId, memoryUrl: memoryUrl),
    );
  }

  static void showPulseReactionSheet(BuildContext context, String memoryId, Function(bool) onPulseToggle) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => PulseReactionSheet(memoryId: memoryId, onPulseToggle: onPulseToggle),
    );
  }

  static void showCommentComposerSheet(BuildContext context, String memoryId, Function(String) onSubmit, {String? replyToCommentId}) {
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

  static void showKinshipBadgeSheet(BuildContext context, double kinScore, String relationshipType, String targetUserId) {
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



