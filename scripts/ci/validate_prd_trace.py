#!/usr/bin/env python3
"""
PRD Traceability Validation Script (Addendum 1.0 S7).

Validates that every PRD feature has corresponding implementation traceability.
Fails CI if coverage < 95% for required features.

Usage:
    python scripts/validate_prd_trace.py

Environment:
    TRACE_DB_URL: PostgreSQL connection string for traceability database.
    If not set, performs offline validation against local file inventory.
"""
import os
import sys
import glob
import re


# ---------------------------------------------------------------------------
# PRD Feature Registry (required features from PRD v1.0 + Addenda 1.0-3.0)
# ---------------------------------------------------------------------------

REQUIRED_FEATURES = {
    # Navigation (PRD 00)
    "home_tab": "apps/mobile/lib/screens/line_screen.dart",
    "repost_tab": "apps/mobile/lib/screens/repost_stitch_screen.dart",
    "create_tab": "apps/mobile/lib/widgets/create_bottom_sheet.dart",
    "tree_tab": "apps/mobile/lib/screens/tree_graph_screen.dart",
    "profile_tab": "apps/mobile/lib/screens/root_profile_screen.dart",

    # Core Screens (PRD 01-14)
    "the_line": "apps/mobile/lib/screens/line_screen.dart",
    "discovery_page": "apps/mobile/lib/screens/discovery_page_screen.dart",
    "bloom_studio": "apps/mobile/lib/screens/bloom_screen.dart",
    "memory_box": "apps/mobile/lib/screens/memory_box_screen.dart",
    "tree_graph": "apps/mobile/lib/screens/tree_graph_screen.dart",
    "branch_detail": "apps/mobile/lib/screens/branch_detail_screen.dart",
    "branch_members": "apps/mobile/lib/screens/branch_members_screen.dart",
    "voiceprint_capture": "apps/mobile/lib/screens/voiceprint_capture_screen.dart",
    "kin_score_detail": "apps/mobile/lib/screens/kin_score_detail_screen.dart",
    "comment_thread": "apps/mobile/lib/screens/comment_thread_screen.dart",
    "strand_list": "apps/mobile/lib/screens/strand_list_screen.dart",
    "strand_detail": "apps/mobile/lib/screens/strand_detail_screen.dart",
    "memory_detail": "apps/mobile/lib/screens/memory_detail_screen.dart",
    "memory_edit": "apps/mobile/lib/screens/memory_edit_screen.dart",
    "echoes_feed": "apps/mobile/lib/screens/echoes_feed_screen.dart",
    "kinnections_feed": "apps/mobile/lib/screens/kinnections_feed_screen.dart",
    "pulse_inbox": "apps/mobile/lib/screens/pulse_inbox_screen.dart",
    "steward_agreement": "apps/mobile/lib/screens/steward_agreement_screen.dart",
    "kinship_alert_map": "apps/mobile/lib/screens/kinship_alert_map_screen.dart",
    "gedcom_import": "apps/mobile/lib/screens/gedcom_import_screen.dart",
    "data_export": "apps/mobile/lib/screens/data_export_screen.dart",
    "support_chat": "apps/mobile/lib/screens/support_chat_screen.dart",

    # Auth (PRD 11)
    "splash": "apps/mobile/lib/screens/splash_screen.dart",
    "welcome": "apps/mobile/lib/screens/welcome_screen.dart",
    "login": "apps/mobile/lib/screens/login_screen.dart",
    "register": "apps/mobile/lib/screens/register_screen.dart",
    "email_signup": "apps/mobile/lib/screens/email_signup_screen.dart",
    "phone_signup": "apps/mobile/lib/screens/phone_signup_screen.dart",

    # Settings (PRD 12)
    "settings": "apps/mobile/lib/screens/settings_screen.dart",
    "account_settings": "apps/mobile/lib/screens/account_settings_screen.dart",
    "security_settings": "apps/mobile/lib/screens/security_settings_screen.dart",
    "privacy_settings": "apps/mobile/lib/screens/privacy_settings_screen.dart",
    "notifications_settings": "apps/mobile/lib/screens/notifications_settings_screen.dart",
    "content_preferences": "apps/mobile/lib/screens/content_preferences_screen.dart",
    "subscription": "apps/mobile/lib/screens/subscription_screen.dart",
    "payment_history": "apps/mobile/lib/screens/payment_history_screen.dart",
    "profile_edit": "apps/mobile/lib/screens/profile_edit_screen.dart",
    "guidelines": "apps/mobile/lib/screens/guidelines_screen.dart",

    # BLoCs/Cubits (Addendum 2.0 S3)
    "line_bloc": "apps/mobile/lib/cubits/line_bloc.dart",
    "discovery_bloc": "apps/mobile/lib/blocs/discovery/discovery_bloc.dart",
    "memory_box_cubit": "apps/mobile/lib/cubits/memory_box_cubit.dart",
    "tree_graph_bloc": "apps/mobile/lib/blocs/tree_graph/tree_graph_bloc.dart",
    "settings_cubit": "apps/mobile/lib/cubits/settings_cubit.dart",
    "voiceprint_cubit": "apps/mobile/lib/cubits/voiceprint_cubit.dart",
    "commerce_cubit": "apps/mobile/lib/cubits/commerce_cubit.dart",
    "messaging_bloc": "apps/mobile/lib/cubits/messaging_bloc.dart",
    "room_cubit": "apps/mobile/lib/cubits/room_cubit.dart",
    "steward_consent_cubit": "apps/mobile/lib/cubits/steward_consent_cubit.dart",
    "dna_kit_cubit": "apps/mobile/lib/cubits/dna_kit_cubit.dart",
    "export_cubit": "apps/mobile/lib/cubits/export_cubit.dart",
    "error_cubit": "apps/mobile/lib/cubits/error_cubit.dart",
    "subscription_cubit": "apps/mobile/lib/cubits/subscription_cubit.dart",

    # DTOs (Addendum 2.0 S2)
    "kin_score_dto": "apps/mobile/lib/models/dtos/kin_score_dto.dart",
    "memory_dto": "apps/mobile/lib/models/dtos/memory_dto.dart",
    "discovery_candidate_dto": "apps/mobile/lib/models/dtos/discovery_candidate_dto.dart",
    "graph_response_dto": "apps/mobile/lib/models/dtos/graph_response_dto.dart",
    "seal_confirmation_dto": "apps/mobile/lib/models/dtos/seal_confirmation_dto.dart",
    "voiceprint_creation_dto": "apps/mobile/lib/models/dtos/voiceprint_creation_dto.dart",
    "payment_session_dto": "apps/mobile/lib/models/dtos/payment_session_dto.dart",
    "branch_merge_evidence_dto": "apps/mobile/lib/models/dtos/branch_merge_evidence_dto.dart",

    # Services
    "auth_service": "apps/mobile/lib/services/auth_service.dart",
    "kernel_service": "apps/mobile/lib/services/kernel_service.dart",
    "interaction_service": "apps/mobile/lib/services/interaction_service.dart",
    "deep_link_service": "apps/mobile/lib/services/deep_link_service.dart",
    "error_boundary_service": "apps/mobile/lib/services/error_boundary_service.dart",
    "moderation_service": "apps/mobile/lib/services/moderation_service.dart",
    "voiceprint_service": "apps/mobile/lib/services/voiceprint_service.dart",
    "room_service": "apps/mobile/lib/services/room_service.dart",
    "dna_kit_service": "apps/mobile/lib/services/dna_kit_service.dart",

    # Infrastructure
    "icon_mapping": "apps/mobile/lib/theme/icon_mapping.dart",
    "motion_spec": "apps/mobile/lib/theme/motion_spec.dart",
    "error_registry": "apps/mobile/lib/core/errors/error_registry.yaml",
    "routing": "apps/mobile/lib/router/go_router_config.dart",
    "route_policy": "apps/mobile/lib/router/app_route_policy.dart",
}


def check_local_traceability():
    """Check that all required feature files exist on disk."""
    total = len(REQUIRED_FEATURES)
    missing = []

    for feature_name, file_path in REQUIRED_FEATURES.items():
        if not os.path.exists(file_path):
            missing.append((feature_name, file_path))

    found = total - len(missing)
    coverage = (found / total) * 100 if total > 0 else 0

    if missing:
        print(f"\n  MISSING ({len(missing)}):")
        for name, path in missing:
            print(f"    - {name}: {path}")

    print(f"\n  Coverage: {coverage:.1f}% ({found}/{total} features mapped)")

    if coverage < 95.0:
        print(f"\n  TRACEABILITY FAIL: {coverage:.1f}% < 95% threshold")
        return False
    else:
        print(f"\n  TRACEABILITY PASS")
        return True


def check_routing_coverage():
    """Check that go_router_config.dart has routes for key screens."""
    router_path = "apps/mobile/lib/router/go_router_config.dart"
    if not os.path.exists(router_path):
        print("  Router config not found!")
        return False

    with open(router_path, "r") as f:
        content = f.read()

    required_routes = [
        "/line", "/discover", "/tree", "/profile", "/settings",
        "/splash", "/welcome", "/login", "/register",
        "/memory-box", "/voiceprint-capture", "/strands",
        "/create/bloom", "/echoes", "/kinnections",
        "/support", "/subscription", "/marketplace",
    ]

    missing_routes = [r for r in required_routes if f"path: '{r}'" not in content]

    if missing_routes:
        print(f"\n  MISSING ROUTES ({len(missing_routes)}):")
        for r in missing_routes:
            print(f"    - {r}")

    coverage = ((len(required_routes) - len(missing_routes)) / len(required_routes)) * 100
    print(f"\n  Route Coverage: {coverage:.1f}%")
    return coverage >= 90.0


if __name__ == "__main__":
    print("=" * 60)
    print("KinnectAI PRD Traceability Validation")
    print("=" * 60)

    print("\n[1/2] Feature File Coverage:")
    files_ok = check_local_traceability()

    print("\n[2/2] Routing Coverage:")
    routes_ok = check_routing_coverage()

    print("\n" + "=" * 60)
    if files_ok and routes_ok:
        print("RESULT: ALL CHECKS PASSED")
        sys.exit(0)
    else:
        print("RESULT: CHECKS FAILED")
        sys.exit(1)
