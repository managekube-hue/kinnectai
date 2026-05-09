# Implementation Audit 1-91

Master Documentation Sections:
- M1 Backend Identity and Access
- M2 Backend Data and Storage
- M3 Backend Realtime and Media
- M4 Flutter Auth and Session
- M5 Flutter Integrations and Device
- M6 Flutter Screen Wiring and Repositories
- M7 UI Placeholder and Comment Hygiene
- M8 Documentation Cleanup
- M9 Validation and Release Workflow

Format per item: ID | File:Line | Exact Issue | Exact Resolution | Master Section | Status

1 | services/go/feed-service/internal/auth/service.go:170 | Google OAuth returned placeholder UID/email/name | Implemented Google token verification via tokeninfo endpoint and strict subject extraction | M1 | DONE
2 | services/go/feed-service/internal/auth/service.go:200 | Facebook OAuth returned placeholder identity | Implemented Facebook Graph /me verification with id/email/name extraction | M1 | DONE
3 | services/go/feed-service/internal/auth/service.go:231 | TikTok OAuth returned placeholder identity | Implemented TikTok auth-code exchange and profile lookup with env-gated credentials | M1 | DONE
4 | services/go/feed-service/internal/auth/handler.go:139 | Phone OTP send endpoint was stubbed | Wired endpoint to Twilio Verify send flow in service method | M1 | DONE
5 | services/go/feed-service/internal/auth/handler.go:158 | Phone OTP verify endpoint was stubbed | Wired endpoint to Twilio Verify check flow with approved status enforcement | M1 | DONE
6 | services/go/feed-service/internal/discovery/handler.go:52 | Discovery candidates returned empty static list | Implemented Redis ZSET fetch for per-user discovery pool | M2 | DONE
7 | services/go/feed-service/internal/discovery/handler.go:94 | Dismiss did not apply ranking penalty | Implemented score*0.30 penalty writeback and 30-day exclusion key in Redis | M2 | DONE
8 | services/go/feed-service/internal/discovery/handler.go:111 | Weekly endpoint always returned empty list | Implemented Redis weekly pool fetch with max 10 cards | M2 | DONE
9 | services/go/feed-service/internal/room/handler.go:54 | Room create returned placeholder SFU token | Implemented signed room JWT issuance using ROOM_TOKEN_SECRET/JWT_SECRET | M3 | DONE
10 | services/go/feed-service/internal/room/handler.go:82 | Room join returned placeholder token | Implemented signed join token generation per room and user | M3 | DONE
11 | services/go/feed-service/internal/room/handler.go:130 | Live endpoint returned placeholder HLS URL | Implemented deterministic HLS URL using ROOM_HLS_BASE_URL and room id | M3 | DONE
12 | services/go/feed-service/internal/moderation/handler.go:41 | Moderation check returned fixed toxicity/NSFW values | Implemented Perspective API call and action policy mapping allow/review/block | M1 | DONE
13 | services/go/feed-service/internal/payment/handler.go:39 | Checkout session creation was placeholder-only | Implemented Stripe PaymentIntent creation and client_secret response | M2 | DONE
14 | services/go/feed-service/internal/vault/handler.go:31 | Memory Box listing did not query persisted vault entries | Replace static list with SELECT from memory_box by user id and pagination | M2 | PENDING
15 | services/go/feed-service/internal/vault/handler.go:57 | Memory seal path skipped encryption and KMS wrapping | Add AES-256-GCM envelope encryption and KMS key wrapping workflow | M2 | PENDING
16 | services/go/feed-service/internal/vault/handler.go:83 | Trigger revoke path had no persisted state update | Persist trigger_revoked flag while preserving sealed payload | M2 | PENDING
17 | services/go/feed-service/internal/vault/handler.go:109 | GDPR export request did not enqueue work | Insert export job row and producer event for async export pipeline | M2 | PENDING
18 | services/go/feed-service/internal/interaction/handler.go:39 | Pulse add endpoint did not write interaction events | Add Cassandra/Astra interaction insert with memory_id, user_id, ts, action | M2 | PENDING
19 | services/go/feed-service/internal/interaction/handler.go:67 | Comment list endpoint ignored DB ordering query | Implement comments fetch ordered by kin_score desc with pagination cursor | M2 | PENDING
20 | services/go/feed-service/internal/messaging/handler.go:59 | Send message endpoint did not persist encrypted payload | Store ciphertext blob in object store and metadata row in postgres | M3 | PENDING
21 | services/go/feed-service/internal/messaging/handler.go:74 | Delete message endpoint lacked key-shred/tombstone flow | Implement key tombstoning and soft-delete marker transaction | M3 | PENDING
22 | services/go/feed-service/internal/settings/handler.go:87 | Account delete endpoint did not schedule purge workflow | Queue deletion request, steward notification, and purge_at in 30 days | M1 | PENDING
23 | services/go/feed-service/internal/voiceprint/handler.go:29 | Voiceprint create used clone placeholder and fake embedding | Accept multipart audio, call ElevenLabs clone endpoint, persist embeddings | M3 | PENDING
24 | services/go/feed-service/internal/voiceprint/handler.go:58 | Voiceprint revoke skipped external revoke and DB update | Call ElevenLabs delete voice endpoint and mark revoked in pgvector metadata | M3 | PENDING
25 | services/go/feed-service/internal/room/handler.go:36 | Room privacy gate not enforced at join | Validate kin_score_gate and membership before issuing join token | M3 | PENDING
26 | services/go/feed-service/internal/payment/handler.go:62 | Complete purchase endpoint does not verify provider confirmation | Validate PaymentIntent status and write ledger rows before completion | M2 | PENDING
27 | services/go/feed-service/internal/moderation/handler.go:17 | Report endpoint does not persist moderation reports | Insert report records and queue moderator review task | M1 | PENDING
28 | services/go/feed-service/cmd/api/main.go:112 | Backend integrations are handler-local without shared service abstraction | Introduce service layer for interaction, vault, messaging, voiceprint, settings | M9 | PENDING

29 | apps/mobile/lib/screens/email_signup_screen.dart:29 | Email signup flow not implemented | Wire form submit to auth repository OTP email flow and error states | M4 | PENDING
30 | apps/mobile/lib/screens/phone_signup_screen.dart:30 | Phone signup SMS OTP flow not implemented | Wire screen to backend /auth/phone send+verify endpoints | M4 | PENDING
31 | apps/mobile/lib/screens/welcome_screen.dart:145 | TikTok Login Kit flow not implemented | Integrate tiktok auth plugin and pass auth_code to backend oauth endpoint | M4 | PENDING
32 | apps/mobile/lib/utils/step_up_auth.dart:70 | local_auth biometric integration missing | Add local_auth challenge path with fallback PIN gate | M5 | PENDING
33 | apps/mobile/lib/utils/step_up_auth.dart:95 | PIN verification placeholder uses no secure hash verification | Add secure hash compare against encrypted local credential store | M5 | PENDING
34 | apps/mobile/lib/services/api_service.dart:11 | JWT persistence disabled due shared_preferences TODO | Restore token storage using shared_preferences or flutter_secure_storage | M4 | PENDING
35 | apps/mobile/lib/services/push_notification_service.dart:15 | Push notification wiring missing | Integrate firebase_messaging registration, token sync, and foreground handling | M5 | PENDING
36 | apps/mobile/lib/services/analytics_service.dart:4 | Analytics provider integration is TODO | Implement Firebase Analytics adapter with typed event wrappers | M5 | PENDING
37 | apps/mobile/lib/services/analytics_service.dart:26 | Event tracking method is placeholder | Send concrete events with required params and privacy-safe defaults | M5 | PENDING
38 | apps/mobile/lib/services/analytics_service.dart:207 | setUserId is TODO | Bind auth user id to analytics identity lifecycle | M5 | PENDING
39 | apps/mobile/lib/services/analytics_service.dart:216 | setUserProperty is TODO | Persist and send user properties with null-safe coercion | M5 | PENDING
40 | apps/mobile/lib/services/analytics_service.dart:226 | clearUserData is TODO | Clear analytics identity and reset local analytics context | M5 | PENDING
41 | apps/mobile/lib/cubits/room_cubit.dart:77 | WebRTC/LiveKit connect path missing | Implement signalling join, transport creation, and state transitions | M5 | PENDING
42 | apps/mobile/lib/cubits/room_cubit.dart:105 | WebRTC disconnect path missing | Implement media teardown and room leave RPC with safe cleanup | M5 | PENDING
43 | apps/mobile/lib/cubits/wellbeing_cubit.dart:18 | Android UsageStats integration missing | Add platform channel UsageStats query with runtime permission flow | M5 | PENDING
44 | apps/mobile/lib/feed_service.dart:10 | Feed service still relies on stub memory generation | Replace with repository-backed API fetch and DTO mapping | M6 | PENDING
45 | apps/mobile/lib/feed_service.dart:24 | Stub call path still active for filter variants | Route filter handling to backend query params and cursor model | M6 | PENDING
46 | apps/mobile/lib/feed_service.dart:54 | _stubMemories remains in production path | Remove method and add test fixtures only in test scope | M6 | PENDING
47 | apps/mobile/lib/screens/bloom_screen.dart:28 | Bloom credits are hardcoded | Load credits from CommerceCubit state and refresh on purchase | M6 | PENDING
48 | apps/mobile/lib/screens/bloom_screen.dart:185 | Gallery picker uses placeholder path | Integrate image_picker gallery selection and actual file path | M5 | PENDING
49 | apps/mobile/lib/screens/bloom_screen.dart:191 | Camera picker uses placeholder path | Integrate image_picker camera capture and temp file persistence | M5 | PENDING
50 | apps/mobile/lib/screens/bloom_screen.dart:197 | Tree photo option uses placeholder path | Resolve to selected image source with branch attachment metadata | M5 | PENDING
51 | apps/mobile/lib/screens/branch_detail_screen.dart:23 | Branch detail screen uses TODO static data | Wire BranchRepository and load by route branch id | M6 | PENDING
52 | apps/mobile/lib/screens/branch_discovery_screen.dart:20 | Branch discovery screen uses TODO static list | Bind to BLoC/cubit data stream with loading and retry states | M6 | PENDING
53 | apps/mobile/lib/screens/branch_members_screen.dart:23 | Branch members are not repository-driven | Fetch members via repository and support pagination | M6 | PENDING
54 | apps/mobile/lib/screens/memory_detail_screen.dart:26 | Memory detail fetch remains TODO | Load memory via repository by memory id route arg | M6 | PENDING
55 | apps/mobile/lib/screens/memory_edit_screen.dart:38 | Memory edit save path does not call API | Implement update API call and optimistic UI rollback on failure | M6 | PENDING
56 | apps/mobile/lib/screens/memory_box_settings_screen.dart:20 | Memory Box settings use hardcoded defaults | Bind to MemoryBoxCubit/API settings payload | M6 | PENDING
57 | apps/mobile/lib/screens/payment_history_screen.dart:16 | Payment history screen is not API-driven | Bind to CommerceCubit transaction history endpoint | M6 | PENDING
58 | apps/mobile/lib/screens/profile_edit_screen.dart:27 | Profile form prefill not loaded from backend | Hydrate fields from profile endpoint before editing | M6 | PENDING
59 | apps/mobile/lib/screens/steward_agreement_screen.dart:29 | Steward candidates are mocked | Query confirmed kinnections and map to steward selections | M6 | PENDING
60 | apps/mobile/lib/screens/strand_detail_screen.dart:19 | Strand detail data remains mocked | Fetch strand metadata/items from repository by strand id | M6 | PENDING
61 | apps/mobile/lib/screens/strand_list_screen.dart:18 | Strand list uses TODO source | Bind strand list query to repository with refresh | M6 | PENDING
62 | apps/mobile/lib/screens/account_settings_screen.dart:36 | Password-change navigation TODO unresolved | Add route wiring to password change/step-up flow | M6 | PENDING
63 | apps/mobile/lib/screens/help_center_screen.dart:117 | Help search not implemented | Add local search index or backend query integration | M6 | PENDING
64 | apps/mobile/lib/screens/repost_stitch_screen.dart:229 | Repost logic is TODO | Implement repost create endpoint call and duplicate protection | M6 | PENDING
65 | apps/mobile/lib/screens/kinship_alert_map_screen.dart:18 | Map data not sourced from API/location | Integrate location service + kinship alert endpoint data | M6 | PENDING
66 | apps/mobile/lib/screens/legal_document_screen.dart:33 | Legal URLs still TODO placeholders | Replace with environment-configurable legal CDN URLs | M6 | PENDING
67 | apps/mobile/lib/utils/audit_logger.dart:103 | Audit logger does not forward to backend | Add buffered transport to audit endpoint with retry/backoff | M5 | PENDING
68 | apps/mobile/lib/foundation/offline/offline_sync_manager.dart:130 | Mutation router TODO unresolved | Route mutation types to concrete repository handlers | M6 | PENDING
69 | apps/mobile/lib/cubits/voiceprint_cubit.dart:71 | Authorization header uses Bearer TODO | Inject auth token provider and attach runtime token | M4 | PENDING
70 | apps/mobile/lib/cubits/voiceprint_cubit.dart:98 | Delete voiceprint call uses Bearer TODO | Reuse authenticated client/token middleware for delete path | M4 | PENDING
71 | apps/mobile/lib/screens/welcome_screen.dart:36 | Welcome analytics call is TODO | Emit launch/onboarding events via analytics service | M5 | PENDING
72 | apps/mobile/lib/services/error_boundary_service.dart:11 | Media placeholder fallback policy not fully surfaced in UI | Bind placeholder retry states to player widgets with action UX | M7 | PENDING

73 | apps/mobile/lib/widgets/enhanced_video_player.dart:182 | Generic placeholder branch dominates video state UX | Replace with actionable retry/loading states tied to media errors | M7 | PENDING
74 | apps/mobile/lib/widgets/enhanced_video_player.dart:223 | Error placeholder lacks context and recovery path | Add reason-specific copy and retry callback | M7 | PENDING
75 | apps/mobile/lib/widgets/line_video_player.dart:5 | Entire widget declared as placeholder implementation | Replace placeholder renderer with production playback controller | M7 | PENDING
76 | apps/mobile/lib/widgets/line_video_player.dart:76 | Gradient placeholder shown instead of video frame fallback | Add thumbnail-first fallback with play affordance | M7 | PENDING
77 | apps/mobile/lib/screens/splash_screen.dart:91 | Splash logo called placeholder | Replace comment and ensure brand asset uses production logo pipeline | M7 | PENDING
78 | apps/mobile/lib/screens/line_screen.dart:172 | Feed video slot comment signals temporary placeholder | Replace comment and enforce real player for all supported platforms | M7 | PENDING
79 | apps/mobile/lib/screens/kinship_alert_map_screen.dart:39 | Map widget comment marks temporary placeholder state | Integrate map provider widget and remove placeholder branch | M7 | PENDING
80 | apps/mobile/lib/screens/marketplace_cart_screen.dart:188 | Product image placeholder icon overused | Replace with product-specific fallback artwork and cache-aware loader | M7 | PENDING
81 | apps/mobile/lib/screens/marketplace_product_detail_screen.dart:305 | Product image placeholder container lacks semantic state | Introduce explicit unavailable-image component with a11y labels | M7 | PENDING
82 | apps/mobile/lib/blocs/tree_graph/tree_graph_bloc.dart:158 | Misleading placeholder comment in branch merge evidence hook | Rename comment to concrete integration contract and TODO reference id | M7 | PENDING

83 | apps/mobile/THE_LINE_CHECKLIST.md:1 | Internal dev note file is empty and non-actionable | Delete file and migrate required checklists into docs release notes | M8 | PENDING
84 | apps/mobile/THE_LINE_EXECUTIVE_SUMMARY.md:1 | Internal dev note file is empty and non-actionable | Delete file and preserve required summary in top-level docs | M8 | PENDING
85 | apps/mobile/THE_LINE_IMPROVEMENTS.md:1 | Internal dev note file is empty and non-actionable | Delete file and move surviving action items into audit doc | M8 | PENDING
86 | apps/mobile/THE_LINE_QUICK_REFERENCE.md:1 | Internal dev note file is empty and non-actionable | Delete file and merge references into README sections | M8 | PENDING
87 | README.md:1 | Root README lacks current placeholder-closure status and rollout notes | Update with implementation status, env requirements, and runbook links | M8 | PENDING
88 | services/go/feed-service/README.md:1 | Backend README missing new OAuth/OTP/moderation/payment requirements | Add provider env vars, endpoint behavior, and failure modes | M8 | PENDING
89 | services/python/kernel-service/README.md:1 | Kernel README still labels service as placeholder | Update to actual scope and integration contract with backend | M8 | PENDING
90 | apps/mobile/assets/README.md:1 | Assets README does not document production placeholders policy | Add fallback asset policy and naming conventions | M8 | PENDING
91 | apps/mobile/ios/Runner/Assets.xcassets/LaunchImage.imageset/README.md:1 | Launch image README is stale and not mapped to branding standards | Update with current launch asset requirements and pipeline notes | M8 | PENDING

Execution Notes:
- Batch 1 committed and pushed to main: 2b58ea0.
- Focused validation passed for modified backend packages.
- Full go test currently blocked by existing unrelated marketplace compile issue in internal/marketplace/service.go (stripe payout schedule type).
