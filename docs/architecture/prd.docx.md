

**KINNECTAI**

Product Requirements Document

*Complete Screen Map — Every Page · Every Button · Every State*

Version 1.0  ·  Confidential  ·  Engineering \+ Design  ·  2026  
kinnectai.app  ·  mykinnectai.com  ·  unspokenmemories.com

# **00  Navigation Architecture**

Every feature in KinnectAI is reachable within two taps from the Home screen. The navigation system has three layers: the Bottom Bar (always visible), the Top Bar (context-sensitive on Home), and the Right Rail (overlaid on video). All secondary features open as full-screen pages or bottom sheets from these three entry points.

## **Bottom Bar  5 Tabs (Always Visible)**

| Element / Setting | KinnectAI Label | What It Does |
| :---- | :---- | :---- |
| **🏠  Home** | Home | The Line — full-screen vertical video feed. Primary entry to all content surfaces. |
| **🔁  Repost** | Repost / Stitch | Dual-purpose: one-tap repost to Branch, or open Stitch editor to compile multi-Kin reels. |
| **➕  Create** | Create | Opens creation bottom sheet — all AI tools, video recording, Memory Box, Photoplay, Restore, Stitch, Flickers, Voiceprint, Family Crest. |
| **🌳  Tree** | Tree | Interactive genealogical graph — all nodes, edges, degrees of separation. Entry to Branch Map. |
| **👤  Profile** | Root | User profile — Memories, Photoplays, Strands, mini-Tree, Vault count. Settings gear top-right. |

## **Home Top Bar  3 Tabs \+ 2 Icons**

| Element / Setting | KinnectAI Label | What It Does |
| :---- | :---- | :---- |
| **Echoes** | Echoes | Date-matched memory surfacing — 'on this day' content elevated from biological graph. |
| **Kinnections** | Kinnections | Filters The Line to confirmed biological connections only. |
| **Discover** | Discovery | Surfaces probable kin with visible Connection Score %. Each card has relationship guess \+ path. |
| **🔔 Bell** | Notifications | Opens full notification drawer — Pulses, Kinnection requests, Vault alerts, Branch Merges, Kinship Alerts. |
| **🛒 Store** | Store | Opens  Marketplace — genealogy books, heritage travel, DNA wellness, Kinnect Kit order. |

## **Home Right Rail 6 Icons (overlaid on video)**

| Element / Setting | KinnectAI Label | What It Does |
| :---- | :---- | :---- |
| **❤️  Pulse** | Pulse | Lightweight reaction. Writes to Cassandra. Feeds Ripple detection. Count shown below icon. |
| **💬  Comment** | Comment | Comment sheet slides up. Threaded comments from Kin. CR-sorted, not chronological. |
| **↩️  Rewind** | Rewind | Opens camera in PIP mode — record reaction while original plays alongside. Entry to Rewind feature. |
| **⭐  Favorite** | Favorite | Saves to Strand collection. Tapping opens Strand manager to select or create a Strand. |
| **↗️  Share** | Share | Share sheet: post to Branch / send to specific Kin / copy link. Never shares outside biology graph. |
| **🌿  Branch** | Branch | Opens Branch subgraph this memory belongs to — geographic map \+ member list \+ Memories tab. |

## **Home Bottom Overlay — Video Controls**

| Element / Setting | KinnectAI Label | What It Does |
| :---- | :---- | :---- |
| **Creator name** | Root link | Tapping opens creator's Root profile page. |
| **Kin Score %** | Kin Score badge | Biological proximity % to this creator. Always visible on video. |
| **Caption text** | Memory description | Expandable. Tapping 'more' expands full text. |
| **Audio bar** | Voiceprint bar | Tapping shows Voiceprint details or audio source. Plays audio preview. |
| **⏩  Fast Forward** | Fast Forward | Scrub bar for longer memories. Shows timestamp. Tap \+ hold to scrub. |

# **01 Home / The Line**

Full-screen vertical scroll video feed. Content sorted by Coefficient of Relationship — biological closeness, not engagement or recency. Never called 'feed' in UI copy. Always 'The Line'.

*P1 Constraint: Content from a full sibling (CR 0.50) always outranks content from a third cousin (CR 0.0625) regardless of engagement velocity. The algorithm is the bloodline.*

## **01.1 The Line States**

| Setting | Description |
| :---- | :---- |
| **Empty state (new user)** | Shows Name Map animation \+ CTA: 'Invite your first Kin to activate The Line.' Invite button links to contact sync / share link / search. |
| **Loading state** | Skeleton cards with biological amber shimmer. Reads from Redis cache first (\<100ms target). Falls back to live CR computation. |
| **Kinnections tab active** | Feed filters to confirmed Kinnections only. No Discovery cards injected. |
| **Echoes tab active** | Date-matched memories elevated to top. 'On this day' banner shown above first Echo card. |
| **Discover tab active** | Full Discovery page — Connection Score cards only. No confirmed Kinnection content shown. |
| **Pull to refresh** | Re-fetches The Line. Does NOT reset behavioral weights. Shows last-refreshed timestamp. |
| **Rippling memory** | Memory with high engagement velocity. Amber 'Rippling' badge top-left of video. Still CR-gated — only spreads through biological graph. |
| **Heartbeat card (daily)** | Special card injected at top of Line each morning. Shows overnight summary: new Kinnections, new Photoplays, upcoming Gatherings, new Markers. |

## **01.2  Video Interaction States**

| Setting | Description |
| :---- | :---- |
| **Single tap** | Pause / resume video. |
| **Double tap (right)** | Pulse (like). Icon animates. Count increments. |
| **Double tap (left)** | Rewind 5 seconds. |
| **Swipe up** | Next memory in The Line. |
| **Swipe down** | Previous memory. |
| **Swipe right** | Opens sidebar / drawer. |
| **Long press** | Share sheet appears. |
| **Swipe left on creator** | Opens graph path view — shows biological connection path to this creator. |

## **01.3 Discovery Card (injected into The Line)**

Injected at a ratio of 1 Discovery card per 7 organic Kinnection posts. Each card shows:

| Setting | Description |
| :---- | :---- |
| **Connection Score %** | Large badge top-right. 0–100% scale derived from Kin Score normalisation. |
| **Relationship guess** | e.g. 'Possible 2nd Cousin' · 'Likely 3rd Cousin Once Removed' · ' Connection'. |
| **Primary signal** | 'DNA Match' / 'Tree Match' / 'Name \+ Location Signal'. |
| **Explore Connection CTA** | Opens Graph Path View — left: your Tree nodes / center: inferred path / right: their Tree nodes. Dashed \= inferred. Confidence % on each segment. |
| **Kinnect button** | Sends Kinnection request. Confirmation sheet slides up with relationship type selector. |
| **Dismiss** | Swipe left. Score × 0.30 penalty applied. Card does not reappear for 30 days. |

# **02  Create (➕ Bottom Bar)**

Tapping ➕ opens a full-screen bottom sheet. Dark background. Grid of creation tools. All tools are entry points — each opens a dedicated full-screen creation flow.

## **02.1 Creation Tool Menu**

| Element / Setting | KinnectAI Label | What It Does |
| :---- | :---- | :---- |
| **🌸  Photoplay** | Photoplay | Animate a static photo with voice \+ lip-sync. Standard (free) or Premium (Photoplay Credit). Opens Photoplay Studio. |
| **🔐  Memory Box** | Memory Box | Record a sealed memory with delivery trigger — date, life event, death, or geofence. Opens Memory Box Composer. |
| **🎥  Video** | Memory | Record or upload a standard memory video. Opens camera with recording controls. |
| **🖼️  Image** | Image Upload | Upload photo to Tree, Photoplay pipeline, or Branch feed. Opens photo picker with crop \+ tag tools. |
| **🧵  Stitch** | Stitch | Compile multiple Kin contributions into one reel. Opens Stitch editor with clip selector. |
| **✨  Restore** | Restore | Upload old photo — DeOldify colorisation \+ Real-ESRGAN 4x upscale. Opens Restore tool. |
| **🎬  Flickers** | Flickers | AI generates narrated biographical documentary from Vault memories \+ Tree data. GPT-4o script \+ ElevenLabs \+ FFmpeg. |
| **🛡️  Family Crest** | Family Crest | AI generates crest from surname \+ haplogroup \+ geographic origin. SVG output. Shareable. |
| **🎙️  Voiceprint** | Voiceprint | Capture and store a voice clone via ElevenLabs. Stored as clone ID \+ 256-dim embedding. Requires explicit biometric consent. |

## **02.2  Photoplay Studio (full screen)**

| Setting | Description |
| :---- | :---- |
| **Step 1 — Photo Selection** | Upload from camera roll / Take new photo / Select from Tree photos. Face detection preview starts immediately (on-device TFLite — no server call, no cloud face storage). |
| **Step 2 — Voice Selection** | Option A: Record live voice message (mic, max 2 min). Option B: Select saved Voiceprint from dropdown. Option C: Type text — ElevenLabs synthesises speech. |
| **Step 3 — Quality** | Standard: SadTalker OSS — 2–4 min processing, free. Premium: D-ID API — 60–90 sec, higher quality, costs 1 Photoplay Credit. Credit balance shown. Buy Credits CTA if balance \= 0\. |
| **Step 4 — Rendering** | Progress bar with estimated time. Cancel button. Push notification sent when complete (user can leave app). |
| **Step 5 — Output** | Preview plays on loop. Share options: The Line / Branch / specific Kin / Memory Box (sealed delivery). Save to Camera Roll toggle. |
| **Error state** | If D-ID API fails: auto-falls back to SadTalker. User notified. Credit NOT charged on fallback. |

## **02.3 Memory Box Composer (full screen)**

| Setting | Description |
| :---- | :---- |
| **Record / Upload** | Full camera recorder or video file upload. Max 10 min. Audio normalised. Shows storage used vs. tier limit. |
| **Recipient picker** | Search Kin by name. Must be a confirmed Kinnection or valid email/phone (for off-platform Kin). Maps to biological graph node. |
| **Trigger type selector** | Four radio options (see trigger table below). |
| **Seal button** | Encrypts and locks. Requires step-up biometric re-auth (Face ID / fingerprint) or 2FA. Cannot be unsealed by creator after sealing — only trigger fires it. |
| **Draft state** | Auto-saved as draft if user exits before sealing. Draft badge shown in Memory Box vault list. |

### **Memory Box Trigger Types**

| Element / Setting | KinnectAI Label | What It Does |
| :---- | :---- | :---- |
| **📅  Time Capsule** | Calendar date | Date \+ time picker. Memory releases at that exact moment. Encrypted until trigger fires. |
| **🎓  Milestone** | Life event | Dropdown: Graduation / Wedding / New Child / Other. Detected via Layer 4 transaction signals \+ identity record updates. |
| **🕯️  Unspoken Memories** | After death | Posthumous. SSDI match \+ obituary signal \+ Steward confirmation. Steward designation required — opens Steward consent flow. |
| **📍  Kinship Alert** | Geofence | Map pin picker \+ radius slider (100m–5km). Fires when recipient is within radius of pinned location. |

## **02.4  Stitch Editor (full screen)**

| Setting | Description |
| :---- | :---- |
| **Clip selector** | Browse Memories from your Kin with Stitch permission enabled. Permission flag shown per clip. Max 10 clips per Stitch. |
| **Timeline** | Drag-to-reorder horizontal strip. Tap clip to preview. Pinch to trim start/end. Shows total runtime. |
| **Narration track** | Option to record voice narration over the full Stitch OR select a Voiceprint for AI narration. |
| **Transition picker** | Per-clip: Cut / Fade / Overlap (500ms dissolve). |
| **Render \+ publish** | FFmpeg cloud worker. Progress bar. Push notification on complete. Auto-notifies all contributing Kin when published. |

## **02.5 Restore Tool (full screen)**

| Setting | Description |
| :---- | :---- |
| **Upload** | Photo picker. Accepts JPG / PNG. Max 20MB. Preview shown immediately. |
| **Processing** | Stage 1: Real-ESRGAN 4x upscale \+ noise reduction. Stage 2: DeOldify colorisation. Both GPU cloud workers. Progress bar with stage labels. |
| **Output** | Side-by-side toggle: Original / Restored. Save restored \+ save original. Add to Tree profile or publish to The Line as a Photoplay source. |

# **03  Memory Box (Vault Management)**

The Memory Box is KinnectAI's encrypted posthumous and time-triggered memory delivery system. Patent filed: US 19/186,947. This is the most legally sensitive feature surface in the product.

*All Memory Box actions require step-up authentication — Passkey (Face ID / fingerprint) or 2FA prompt. Changes to Steward designation and death-trigger settings also require the Steward to confirm via their own account.*

## **03.1  Memory Box Vault List Screen**

| Setting | Description |
| :---- | :---- |
| **Header** | Storage usage bar — free 5GB / Vault+ 500GB. Upgrade CTA appears at 80% capacity. |
| **Memory list** | Each row: thumbnail / recipient name / trigger type icon / status badge / date sealed. |
| **Status badges** | Draft (grey) / Sealed (amber lock) / Triggered (blue clock) / Delivered (green check). |
| **Tap a memory** | Opens Memory Box Detail — trigger info, recipient, encrypted status. Cannot preview content after sealing. |
| **Swipe left on memory** | Delete option (before sealing only). After sealing: Revoke trigger option (removes trigger, memory stays sealed but never fires). |
| **\+ Add Memory button** | Opens Memory Box Composer — same as ➕ → Memory Box. |

## **03.2  Memory Box Detail Screen (post-seal)**

| Setting | Description |
| :---- | :---- |
| **Content status** | Shows: 'Sealed and encrypted. Contents inaccessible until trigger fires.' No preview. No edit. |
| **Recipient** | Name \+ Kin Score \+ relationship type. Tap to view their Root (if public). |
| **Trigger summary** | Type / scheduled date or life event / verification signals selected. |
| **Steward info** | Steward name \+ contact. Status: Confirmed / Pending consent. |
| **Delivery log** | After delivery: timestamp / verification method / confirmation record. |
| **Export button** | GDPR Art. 20 — download encrypted archive. Decryption key sent to verified email separately. |

# **04  Repost / Stitch (2nd Bottom Bar Icon)**

Dual-purpose tab. Default view is Repost mode. Stitch editor accessible via tab toggle at the top.

## **04.1 Repost Mode**

| Setting | Description |
| :---- | :---- |
| **Content list** | Memories from The Line eligible for repost. Shows original creator name \+ Kin Score. |
| **Repost CTA** | One-tap repost to your Branch feed. Optional caption field before posting. |
| **Share to Kin** | Alternative: send directly to specific Kin via DM rather than posting to Branch. |

## **04.2  Stitch Mode**

| Setting | Description |
| :---- | :---- |
| **Tab toggle** | 'Repost' / 'Stitch' toggle at top of screen. |
| **Clip browser** | Grid of Kin Memories with Stitch permission enabled. Permission badge on each. Tap to add to timeline. |
| **Timeline strip** | Horizontal drag-to-reorder. Shows clip order and total runtime. |
| **Trim controls** | Tap clip in timeline to open trim handles. Pinch to resize. |
| **Narration** | Record over full Stitch OR type text for ElevenLabs synthesis. |
| **Publish** | Renders via FFmpeg. Push notification on complete. All contributing Kin notified. |

# **05  Tree (4th Bottom Bar Icon)**

Interactive genealogical graph. Full biological graph stored in Neo4j. This is the structural backbone of the entire platform — every Discovery, Branch, and CR calculation starts here.

## **05.1 Tree View**

| Element / Setting | KinnectAI Label | What It Does |
| :---- | :---- | :---- |
| **Green nodes** | Living users | Confirmed KinnectAI users. Tap to open their Root profile. Shows Kin Score \+ relationship type on tap. |
| **Grey nodes** | Deceased relatives | Added manually or via FamilySearch import. Tap to view memory archive \+ dates \+ obituary link. |
| **Amber nodes** | Historical (AADR) | Ancient DNA matches. Tap to see haplogroup connection path \+ origin region \+ date range. |
| **Gold-ring nodes** | Celebrity / namesake | WikiTree/Wikidata bridge — famous descendants of shared ancestors. Tap to see connection path. |
| **Blue edges** | DNA-confirmed | Kinnection verified by DNA upload. Shows CR score on edge label. |
| **Grey dashed edges** | Identity-inferred | Kinnection inferred from identity graph. Confidence % shown. CTA to verify with DNA. |
| **Red edges** | Pending | Kinnection request sent, not yet confirmed. |

## **05.2  Tree Gestures**

| Setting | Description |
| :---- | :---- |
| **Pinch zoom** | Zoom in/out on graph canvas. |
| **Drag** | Pan around the graph. |
| **Double tap node** | Centre \+ zoom to that node. Expands to show all connected edges. |
| **Long press node** | Context menu: View Root / Add Memory / Photoplay This Person / Remove from Tree. |
| **Long press edge** | Shows edge details: relationship type / CR score / confirmation method / date added. |

## **05.3 Tree Actions Bar (bottom)**

| Setting | Description |
| :---- | :---- |
| **＋  Add Kin** | Manual entry form: name / relationship type / birth \+ death dates / location. Creates unconfirmed node until Kinnected. |
| **🔗  Kinnect** | Send Kinnection request to existing KinnectAI user by name / phone / email search. |
| **📤  Import** | Upload GEDCOM file from Ancestry / FamilySearch. Parsed and merged into Neo4j graph. Conflict resolution UI for duplicate nodes. |
| **🗺️  Branch Map** | Switches to geographic view — all Branch members pinned on world map. Colour-coded by haplogroup. |
| **🔍  Search** | Search nodes by: name / haplogroup / birth year / location / relationship type. |

# **06 Branch Page**

A Branch is not a group. It is the living expression of a shared  line — all descendants at any degree of separation, bounded only by biological truth. Entry points: Home Right Rail Branch icon / Tree / Sidebar.

## **06.1 Branch Header**

| Setting | Description |
| :---- | :---- |
| **Branch name** | e.g. 'The Harrington Branch' — surname \+  origin. |
| **Member count** | Total confirmed members \+ active in last 30 days. |
| **Geographic badge** | 'Members in 14 countries' — derived from member location data. |
| **Branch Steward** | Name \+ avatar. Steward badge (shield icon). Tap to view Root. |
| **Join / Request CTA** | Shown if user is a Discovery candidate for this Branch. Sends Branch membership request. |

## **06.2 Branch Tabs**

| Element / Setting | KinnectAI Label | What It Does |
| :---- | :---- | :---- |
| **Memories** | Memories | Collective feed of all Branch memories. CR-sorted — not chronological. Closest kin content first. |
| **Map** | Branch Map | World map — all Branch members pinned by location. Colour-coded by haplogroup. Tap pin to see member profile. |
| **Merge** | Merge | Pending Branch Merge requests — two biologically related Branches proposed for unification. Confirm or reject. Shows evidence: shared haplogroup / facial match / surname overlap. |
| **Markers** | Markers | Historical markers: Ellis Island records / NARA / county of origin / AADR ancient DNA samples. Timeline view. |

# **07 Discover Page**

Entry point: Top Bar 'Discover' tab on Home. Unlike TikTok's For You Page, every card is biologically curated. Each card has a calculated Connection Score. Discovery runs hourly via the discovery-service.

## **07.1 Discovery Card**

| Setting | Description |
| :---- | :---- |
| **Video preview** | Muted autoplay of the candidate's most recent Memory. |
| **Connection Score %** | Large badge top-right. Normalised Kin Score 0–100%. |
| **Relationship guess** | 'Possible 2nd Cousin' / 'Likely 3rd Cousin Once Removed' / ' Connection'. |
| **Primary signal** | 'DNA Match' / 'Tree Match' / 'Name \+ Location Signal'. |
| **Explore Connection CTA** | Opens Graph Path View — see below. |
| **Kinnect button** | Sends Kinnection request. Confirmation sheet with relationship type selector. |
| **Dismiss (swipe left)** | Score × 0.30 penalty. Card absent for 30 days. Undo available for 5 seconds after swipe. |

## **07.2  Graph Path View**

| Setting | Description |
| :---- | :---- |
| **Left panel** | Your known Tree nodes. |
| **Centre** | Algorithm's best-guess connecting path. Solid lines \= confirmed. Dashed lines \= inferred (confidence % shown). |
| **Right panel** | Discovery candidate's known Tree nodes. |
| **Node labels** | Name / estimated dates / relationship type. |
| **Kinnect CTA** | Bottom of screen — always visible. Sends request from this screen. |

## **07.3  Discover Filters Bar**

| Setting | Description |
| :---- | :---- |
| **All** | Full candidate pool ranked by Kin Score. |
| **DNA Matches** | Candidates with verified DNA Coefficient of Relationship. |
| **Name Matches** | Candidates matched via surname \+ geography signals. |
| **Branch Overlaps** | Candidates sharing a Branch subgraph. |
| **Facial Matches** | Candidates matched via facial embedding cosine similarity. |

## **07.4 Name Map (entry via Sidebar or Onboarding)**

| Setting | Description |
| :---- | :---- |
| **Map view** | Geographic biodensity map showing surname concentration. Heatmap overlay. |
| **KinnectAI users** | Blue pins — users on platform with this surname. |
| **Whitepages data** | Grey density overlay — surname presence in external identity graph. |
| **Historical markers** | Amber pins — Ellis Island arrivals / NARA records / county of origin / AADR samples. |
| **Migration routes** | Animated lines showing  migration paths from historical data. |
| **Tap a region** | Shows list of Branch members or Discovery candidates in that region. |

# **08 Rooms**

Private, encrypted peer-to-peer video/audio calls hosting up to 50 Kin simultaneously. WebRTC \+ mediasoup SFU. JWT \+ Kin Score gate authentication. Entry point: Sidebar → Rooms.

## **08.1 Rooms List Screen**

| Element / Setting | KinnectAI Label | What It Does |
| :---- | :---- | :---- |
| **Active Now** | Active Rooms | Live Rooms user can join (Kin Score gated). Shows host name / participant count / duration. |
| **Scheduled** | Gatherings | Upcoming Rooms with RSVP. Shows date / time / host / invited Kin count. Calendar notification toggle. |
| **Past** | Past Rooms | Recorded Rooms if host enabled recording. Link to Memory Box if sealed. Play or view transcript. |
| **\+ Create** | Start Room | Opens Room setup — name / invite Kin / private vs. Kin-Score-gated / schedule or start now. |

## **08.2 Inside a Room**

| Element / Setting | KinnectAI Label | What It Does |
| :---- | :---- | :---- |
| **Video grid** | Layout | Up to 50 participants in grid. Active speaker highlighted with amber border. Pinch to focus on one speaker. |
| **Mute / Camera** | Self controls | Mic on/off \+ camera on/off. Bottom left. Status visible to all participants. |
| **Participant list** | Kin list | Slide-out panel. Shows each Kin's Kin Score to host. Host controls per participant. |
| **Host controls** | Originator only | Mute all / Remove / Admit from waiting room / Assign co-host. Shown only to Originator. |
| **💬  Chat** | Room Chat | In-room text chat. Pulse reactions as emoji overlay on video. Persisted for session only unless recorded. |
| **🔴  Go Live** | Live Broadcast | Converts Room to public HLS broadcast. SFU switches to broadcast mode. Live card injected to The Line for top 500 Kin by Kin Score. |
| **⏺  Record** | Record Room | Opt-in recording. At session end: option to seal to Memory Box with trigger or publish as Memory. |
| **📅  Schedule next** | Gathering | Schedule next Gathering from within this Room. Sends calendar notifications to all current participants. |

# **09  Inbox / Notifications**

Entry point: 🔔 Notification Bell (top-right of Home). Shows notification drawer first. Full inbox accessible from drawer header. In-app notifications mirror push — always shown in the Pulse tab regardless of push settings.

## **09.1 Inbox Tabs**

| Element / Setting | KinnectAI Label | What It Does |
| :---- | :---- | :---- |
| **All** | All | Everything chronological. Unread badge count shown on tab. |
| **Kinnections** | Kinnections | New Kinnection requests \+ confirmations. Connection Score % shown on each request. |
| **Pulses** | Pulses | Reactions and comments on your Memories. Shows excerpt of Memory \+ reactor name \+ Kin Score. |
| **Memory Box** | Memory Box | Vault delivery alerts — memories sealed for you are ready. Steward notifications. Death verification progress. |
| **Branch** | Branch | Branch Merge notifications / new Branch members / Steward requests / significant new Markers. |
| **Kinship Alerts** | Kinship Alerts | Geofence proximity alerts — 'A Kin is 0.4 miles away right now.' Shows Kin name \+ Kin Score \+ distance. |
| **Rooms** | Rooms | Room invites / Gathering RSVPs / Live notifications from top Kin. |

## **09.2  Push Notification Types (Full List)**

| Element | Label | Feature Ref | Description |
| :---- | :---- | :---- | :---- |
| **Pulses** | Pulses | Interaction — Pulse | When another Kin reacts or comments on your Memory or Photoplay. |
| **New Kinnections** | New Kinnections | Social Graph | Kinnection request confirmed OR high-confidence Discovery match found. |
| **Mentions** | Mentions | Interaction | Another Kin tags you in a Memory, comment, or Branch post. |
| **Comments** | Comments | Interaction | Kin comments on your Memory. Separate from Pulses (lightweight reactions). |
| **Messages** | Messages | Direct Messaging | DMs from confirmed Kinnections. Filtered by message permission setting. |
| **Gatherings** | Gatherings | Rooms / Events | Gathering invitation. Reminder 24h and 1h before start. |
| **Branch activity** | Branch Activity | Branch | New Memories / Branch Merges / Markers. Batched into Heartbeat by default. |
| **Heartbeat** | Heartbeat | Feed — Daily Digest | Single morning push. All overnight Branch \+ Kinnection activity. |
| **Echoes** | Echoes | Temporal Graph | Fires when a Memory's date metadata matches today across any year. |
| **Memory Box delivery** | Memory Box | Vault — Triggers | Memory about to deliver or has delivered. Also fires for Stewards. |
| **Kinship Alerts** | Kinship Alert | Discovery — Geofence | Two Kin with high Kin Score within defined radius. Location-based. |
| **Ripples** | Rippling | Feed — Engagement | Your Memory reaches Ripple threshold. High engagement across Branches. |
| **Lost Branches** | Lost Branches match | Discovery Engine | New probable Kinnection above Discovery threshold found for you. |
| **Live broadcasts** | Live | Rooms — Live | A Kin converts Room to Live. Top 500 Kin by Kin Score notified only. |

# **10  Profile / Root (5th Bottom Bar Icon)**

The user's own Root profile. Other users see this page when they tap on a creator's name. Layout adapts based on: own profile / other user's profile / business account.

## **10.1Profile Header**

| Setting | Description |
| :---- | :---- |
| **Profile photo** | Tap to change (own) / view full size (other). Photoplay badge if a Voiceprint is captured. |
| **Display name** | Shows surname in accent colour if DNA haplogroup verified. |
| **Kin Score** | Shown only on other users' profiles. '12.5% Kin Score — Estimated 2nd Cousin.' Not shown on own profile. |
| **Kinnection count** | '47 Kinnections' — tap to see list, sorted by CR score. |
| **Branch memberships** | Chip row: 'Harrington · O'Sullivan' — tap chip to open that Branch. |
| **Haplogroup badge** | Shown if DNA connected: e.g. 'H1c3' — tap to see lineage map. |
| **Voiceprint indicator** | Mic icon green \= captured / grey \= not captured. |

## **10.2  Profile Tabs**

| Setting | Description |
| :---- | :---- |
| **Memories** | All public Memories — grid view. Tap to play full screen in Line context. |
| **Photoplays** | All Photoplay animations created. Grid view. Tap to play \+ see source photo. |
| **Strands** | Themed memory collections. Shows Strand name \+ cover image \+ count. Tap to open Strand player. |
| **Tree** | Mini tree view — first 3 generations. Tap to expand to full Tree page. |
| **Vault** | Own profile only: shows sealed memory count \+ storage usage. No content visible. Link to Memory Box management. |

## **10.3 Profile Actions (viewing another user's profile)**

| Setting | Description |
| :---- | :---- |
| **Kinnect** | Send Kinnection request. Shows estimated relationship type \+ Connection Score. |
| **Explore Connection** | Opens Graph Path View between your Tree and theirs. |
| **Room** | Start a private Room with this Kin immediately. Sends push notification to them. |
| **Message** | Open DM thread (only available to confirmed Kinnections). |
| **Gift** | Send Photoplay Credits or Kinnect Kit as a gift. Opens commerce sheet. |
| **Block / Report** | Block: removes from Kin graph, hides all content. Report: sends to content review. |

# **11  Auth Screens (Entry Point)**

These screens appear before any other screen. New users see Welcome → Sign Up → Onboarding. Returning users see Welcome → Sign In → Home.

*Auth layer: Firebase Auth handles OAuth tokens (Google, Facebook, TikTok), phone OTP, email/password, and Passkey (FIDO2). All app data (profiles, graph, memories) stored in Astra DB. Firebase Auth issues JWTs consumed by all backend services.*

## **11.1 Welcome / Splash Screen**

| Setting | Description |
| :---- | :---- |
| **Logo \+ tagline** | 'The Algorithm Is Your Bloodline' — centred, dark background, amber accent. |
| **Continue with Google** | OAuth 2.0 via Firebase Auth. One tap. Creates account or signs in existing user. |
| **Continue with Facebook** | OAuth 2.0 via Firebase Auth. Opens Facebook auth sheet. |
| **Continue with TikTok** | OAuth 2.0 via TikTok Login Kit. Opens TikTok auth sheet. |
| **Sign up with Email** | Opens Email Sign Up screen. |
| **Sign up with Phone** | Opens Phone Sign Up screen (SMS OTP). |
| **Sign in** | Opens Sign In screen for returning users. |
| **Terms \+ Privacy** | Small text: 'By continuing you agree to Terms of Service and Privacy Policy.' Both links active. |

## **11.2  Email Sign Up Screen**

| Setting | Description |
| :---- | :---- |
| **Email field** | Standard keyboard. Validates format on blur. Checks for existing account. |
| **Password field** | Show/hide toggle. Min 8 chars / 1 number / 1 special character. Strength meter shown. |
| **Confirm password** | Must match. Error shown inline if mismatch. |
| **Full name** | First \+ Last. Used for identity Layer 1 seeding. |
| **Date of birth** | Date picker. Required. Used for age gate (18+ for biometric features). Under 13 routes to Family Pairing. |
| **Create Account CTA** | Sends OTP verification email. Disabled until all fields valid. |
| **Verify email screen** | 6-digit OTP entry. Resend button (60s cooldown). Expires in 10 min. |

## **11.3 Phone Sign Up Screen**

| Setting | Description |
| :---- | :---- |
| **Country code selector** | Flag \+ dial code dropdown. Searchable. |
| **Phone number field** | Numeric keyboard. Formats as user types. |
| **Send Code CTA** | Sends SMS OTP via Firebase Auth. |
| **OTP entry** | 6-digit input. Auto-advance. Resend button (60s cooldown). Expires in 10 min. |
| **Name \+ DOB** | After OTP verified — same fields as email sign up. |

## **11.4 Onboarding Flow (all sign-up paths converge here)**

| Setting | Description |
| :---- | :---- |
| **Step 1 — Surname** | Enter your mother's maiden name. Name Map animates immediately showing global surname density. Emotional hook — seeing your name on a world map. |
| **Step 2 — DNA (optional)** | Connect Sequencing.com (OAuth) / Upload 23andMe or AncestryDNA file / Order free Kinnect Kit / Skip for now. Skip does not block onboarding. |
| **Step 3 — First photo** | Upload or take a profile photo. On-device DeepFace landmark detection runs. Photoplay tutorial: 'Animate this photo.' Standard Photoplay created as first memory. |
| **Step 4 — Invite Kin** | Sync contacts (permission prompt) / Share invite link / Search by name on platform / Skip. |
| **Step 5 — The Line** | Feed activates. First Kinnections appear. Heartbeat card at top if 0 connections: 'Invite more Kin to fill your Line.' |

## **11.5User Database Schema (Astra DB)**

| Element | Label | Feature Ref | Description |
| :---- | :---- | :---- | :---- |
| **user\_auth** | user\_id, provider, provider\_uid, access\_token (encrypted), created\_at | Auth | OAuth tokens — Google / Facebook / TikTok per user. |
| **user\_credentials** | user\_id, email, password\_hash (bcrypt), email\_verified, phone, phone\_verified | Auth | Email \+ phone credentials. Never plaintext. |
| **otp\_sessions** | session\_id, user\_id, otp\_hash, expires\_at (TTL 10 min), purpose | Auth | OTP session records. Auto-deleted after 10 min. |
| **user\_passkeys** | user\_id, credential\_id, public\_key, device\_name, created\_at | FIDO2 | WebAuthn Passkey credentials per device. |
| **user\_profiles** | user\_id, display\_name, dob, surname, haplogroup, dna\_verified, created\_at | App Data | Core profile data. Astra DB — not Firebase. |

\---

# **12 Settings & Privacy (Full Map)**

Entry point: Profile (Root) → ⚙️ gear icon top-right. Clean scrollable list. Groups are visually separated but no hard section headers at top level. All items in order exactly as specified.

## **12.0  Top-Level Settings Menu**

Eight items in exact order. Each item expands inline or navigates to a sub-screen.

| Setting | Description |
| :---- | :---- |
| **Balance** | Shows Photoplay Credits balance \+ Vault+ storage status \+ balance. Tap to open Commerce screen. |
| **Personal tools** | Quick access: Voiceprint / Family Crest / Restore / Flickers / DNA Kit settings. |
| **Activity Center** | Expands inline — History, Time & Engagement, Content Permissions. See Section 12.1. |
| **Offline videos** | Download Memories for offline playback. Manage downloaded files. Storage used shown. |
| **Your QR code** | Full-screen QR displaying user's Root profile link. Save to camera roll / Share. Respects Public/Private toggle. |
| **Creation & business tools** | Branch analytics /Marketplace seller tools / KinnectAI Insights API. Available on Business Account. |
| **Memory Box** | Opens Memory Box settings — storage, Steward, triggers, export. See Section 12.8. |
| **Settings and privacy** | Expands to full settings menu — Content Preferences, Time & Well-being, Family Pairing, Account, Security, Notifications, Privacy. See Sections 12.1–12.7. |

## **12.1 Activity Center**

### **History**

| Element | Label | Feature Ref | Description |
| :---- | :---- | :---- | :---- |
| **Watch history** | Watch history | Layer 4 — Behavioral | All videos and Photoplays viewed. Clearable. Feeds behavioral signals. |
| **Comment history** | Comment history | Pulses / Comments | All comments made across Memories, Lines, Branches. Clearable. |
| **Search history** | Search history | Discovery / Name Map | Search terms in Lost Branches, Name Map, Tree. Clearable. |
| **Mention history** | Mention history | Kinnections / Pulses | @mentions by other Kin. Read-only. |
| **Account history** | Account history | Security / Audit | Login events, device changes, email/password changes. Read-only audit log. |

### **Time & Engagement**

| Element | Label | Feature Ref | Description |
| :---- | :---- | :---- | :---- |
| **Screen time** | Screen time | Time & Well-being | Daily and weekly usage stats. Set daily limits. Part of Family Pairing for minors. |

### **Content Permissions**

| Element | Label | Feature Ref | Description |
| :---- | :---- | :---- | :---- |
| **Reuse of content history** | Memory reuse history | IP / Content Policy | Which Memories have been Stitched or Rewound by other Kin. |
| **Recently deleted** | Recently deleted | Media / Memory | Deleted Memories, Photoplays, Strands held 30 days before permanent removal. |
| **Manage post visibility** | Manage Memory visibility | Privacy / Feed | Per-Memory control: which Kinnections or Branches can see each Memory. |
| **Manage comments permission** | Manage Pulse permissions | Privacy / Interactions | Who can Pulse on your Memories: All Kin / Confirmed Kinnections / Off. |
| **Manage post reuse** | Manage Memory reuse permission | IP / Privacy | Toggle per Memory type: whether other Kin can Stitch or Rewind it. |

## **12.2  Content Preferences**

| Element | Label | Feature Ref | Description |
| :---- | :---- | :---- | :---- |
| **Filter keywords** | Filter keywords | Content / Feed | Block specific words from The Line feed, comments, Branch activity. |
| **Restricted Mode** | Restricted Mode | Content / Moderation | Limits mature or sensitive content in The Line and Photoplays. |
| **Manage topics** | Manage topics | Layer 4 — Behavioral | Topic interests that modulate ContentTypeBoost in feed ranking. User-editable. |
| **Refresh your Line** | Refresh your Line | Feed / Kinship Algorithm | Resets behavioral weighting signals. Does NOT affect Kin Scores or Kinnections. |
| **Muted accounts/Branches** | Muted Kin / Branches | Social Graph / Privacy | Suppress content from specific Kin or Branches without removing Kinnection. |

## **12.3Time & Well-being**

| Element | Label | Feature Ref | Description |
| :---- | :---- | :---- | :---- |
| **Daily screen time limit** | Daily time limit | Time & Well-being | Hard daily cap. Push notification at 80% of limit. |
| **Break reminders** | Break reminders | Time & Well-being | Timed nudges during extended sessions. Interval configurable. |
| **Night mode schedule** | Night mode schedule | Time & Well-being | Auto-enables grayscale display and mutes push notifications during sleep hours. |

## **12.4 Family Pairing**

*Minor accounts cannot upload DNA kits, Voiceprints, or facial biometric data. COPPA-compliant parental consent required for users under 13\. Parental consent collected via guardian account at setup.*

| Element | Label | Feature Ref | Description |
| :---- | :---- | :---- | :---- |
| **Teen safety controls** | Teen safety controls | Family Pairing / COPPA | Guardian-managed. Controls content visibility, discoverability, Kinnection permissions for teen. |
| **Screen time dashboard** | Screen time dashboard | Family Pairing | Guardian view of teen's daily and weekly usage. Read-only for guardian. |
| **Daily time limits** | Daily time limits | Family Pairing | Guardian sets teen's maximum daily usage. Teen warned at 80%. |
| **Message restrictions** | Message restrictions | Family Pairing / Privacy | Who can DM the teen: Confirmed Kinnections only / Off entirely. |
| **Account type management** | Account type management | Family Pairing | Private/Public toggle for teen account. Default: Private. Guardian approval to switch. |

## **12.5  Account**

### **Account Information**

| Element | Label | Feature Ref | Description |
| :---- | :---- | :---- | :---- |
| **Password** | Password | Security / Auth | Change account password. Step-up 2FA prompt required before change. |
| **Passkey** | Passkey | Security / FIDO2 | Add or remove FIDO2/WebAuthn biometric login (Face ID, fingerprint). Primary login. No password stored. |
| **Verification** | Verification | Identity / Layer 1 | Phone and email verification status. Fraud prevention \+ step-up auth. |
| **Download your data** | Download your data | GDPR / CCPA | Export ZIP of all user data: Memories, Tree, Kinnections, Photoplays, Voiceprints, behavioral data. |
| **Deactivate or delete** | Deactivate or delete | Data Retention | Deactivate: hides account, retains data 30 days. Delete: permanent. Triggers Memory Box Steward notification if active Vault memories exist. |

### **Account Type**

| Element | Label | Feature Ref | Description |
| :---- | :---- | :---- | :---- |
| **Switch to Business** | Switch to Business Account | Business / Monetization | Enables: analytics dashboard, Gathering ticketing,  Marketplace seller tools, KinnectAI Insights API. |
| **Switch to Steward** | Switch to Steward Account | Memory Box / Posthumous | Designates this user as Steward for another Kin's Memory Box. Requires Steward Agreement consent. Authority to confirm death events. |

### **Profile Sharing**

| Element | Label | Feature Ref | Description |
| :---- | :---- | :---- | :---- |
| **Share profile** | Share Root | Discovery / Kinnections | Share link or QR code to Root profile. Respects Public/Private toggle. |

## **12.6  Security & Permissions**

*Step-up authentication required before any change to: DNA kit connections, Voiceprint capture, Memory Box creation, and account deletion. Enforced at application layer, not just UI.*

| Element | Label | Feature Ref | Description |
| :---- | :---- | :---- | :---- |
| **Security alerts** | Security alerts | Security / Monitoring | Push \+ email for anomalous login attempts, new device logins, sensitive action events. Device fingerprinting powered. |
| **Manage devices** | Manage devices | Security / Sessions | View all active sessions by device and location. Revoke any session remotely. Triggers security alert to email. |
| **2-step verification** | 2-step verification | Security / Auth | TOTP (authenticator app) or SMS-based 2FA. Required for Steward actions and Memory Box management. |
| **App permissions** | App permissions | Privacy / ATT | Review \+ revoke permissions granted to third-party apps via KinnectAI SDK 'Log in with KinnectAI'. Last-active date shown. |
| **Browser settings** | Browser settings | Privacy / Pixel | KinnectAI Tracking Pixel opt-out. Controls Layer 4 off-platform signal ingestion. Core product unaffected by opt-out. |

## **12.7Notifications**

### **Push Notification Toggles**

Each notification type has two independent toggles: Push (device-level) and In-App (Pulse tab). All are ON by default. In-App Pulse tab always shows full unfiltered log regardless of push settings.

| Notification Type | Toggle State |
| :---- | :---- |
| **Pulses** | ON/OFF — Push · In-App |
| **New Kinnections** | ON/OFF — Push · In-App |
| **Mentions** | ON/OFF — Push · In-App |
| **Comments** | ON/OFF — Push · In-App |
| **Messages** | ON/OFF — Push · In-App |
| **Gatherings** | ON/OFF — Push · In-App |
| **Branch activity** | ON/OFF — Push · In-App |
| **Heartbeat** | ON/OFF — Push · In-App (always ON recommended) |
| **Echoes** | ON/OFF — Push · In-App |
| **Memory Box delivery** | ON/OFF — Push · In-App (cannot fully disable — legal requirement) |
| **Kinship Alerts** | ON/OFF — Push · In-App |
| **Ripples** | ON/OFF — Push · In-App |
| **Lost Branches** | ON/OFF — Push · In-App |
| **Live broadcasts** | ON/OFF — Push · In-App |

## **12.8  Privacy Controls**

### **Account Visibility**

| Element | Label | Feature Ref | Description |
| :---- | :---- | :---- | :---- |
| **Private / Public** | Private / Public Root | Privacy — Account | Private: only confirmed Kinnections see Memories. Public: visible to all Kin in Kin Score display range. Default: Private. |
| **Activity status** | Activity status | Privacy — Presence | Show/hide real-time active status. Disabling does not affect Heartbeat delivery. |
| **Discoverability** | Discoverability | Discovery / Lost Branches | Whether Root can be surfaced as Discovery card or Lost Branch suggestion. Disabling removes from discovery-service pool. |

### **Data Controls**

| Element | Label | Feature Ref | Description |
| :---- | :---- | :---- | :---- |
| **Sync contacts** | Sync contacts | Identity / Layer 1 | Cross-reference phone contacts against identity graph. Explicit permission. Clearable at any time. |
| **Interaction perms** | Interaction permissions | Privacy — Interactions | Who can Pulse on Memories / send DMs / Stitch or Rewind. Granular per action. |

### **Genomic Data Controls**

| Element | Label | Feature Ref | Description |
| :---- | :---- | :---- | :---- |
| **DNA kit connection** | DNA kit connection | Layer 2 — Bioidentity | Connect/disconnect Sequencing.com OAuth. Disconnecting removes from live Kin Score but does not delete stored embeddings. |
| **Haplogroup visibility** | Haplogroup visibility | Layer 2 — Bioidentity | Control whether haplogroup info is visible on Discovery cards and public Root profile. |
| **Kin Score display range** | Kin Score display range | Kinship Algorithm | Minimum Kin Score threshold for showing Connection Score % to other users. Default: 0.2% (\~6th cousin). |
| **Raw data deletion** | Raw data deletion request | GDPR / Data Retention | Request deletion of raw FASTQ/BAM files from Kinnect Kit. Processed within 30 days. Irreversible. |
| **Third-party opt-out** | Third-party sharing opt-out | GDPR / CCPA | Opt out of genomic/behavioral data sharing with NielsenIQ, Facteus. Does not affect Sequencing.com or Kinnect Kit. |

### **Off-Platform Tracking**

| Element | Label | Feature Ref | Description |
| :---- | :---- | :---- | :---- |
| **Off-platform data** | Off-platform data management | Layer 4 — Behavioral / Pixel | Manage Tracking Pixel opt-out and SDK signal ingestion. Opting out reduces Discovery precision. Does not affect Kin Scores or Memory Box. |
| **Ad preferences** | Contextual ad preferences | Revenue / Ads | Bio-Identity-based contextual offer preferences. KinnectAI does not sell ad inventory. |
| **Partner muting** | Partner muting | Revenue / Ads | Mute specific partner brands from surfacing contextual offers. |
| **Feedback sharing** | Feedback sharing | Product / Analytics | Allow anonymised usage data to improve product. Opt-in. No PII or genomic data shared. |

## **12.9  Memory Box Settings**

*All Memory Box settings require step-up authentication. Steward designation changes require the Steward to confirm via their own account.*

| Element | Label | Feature Ref | Description |
| :---- | :---- | :---- | :---- |
| **Vault storage usage** | Memory Box storage | Memory Box / Storage | Current usage vs. tier. Free: 5GB. Vault+: 500GB ($4.99/mo). Upgrade prompt at 80%. |
| **Manage Vault Memories** | Manage Memory Box Memories | Memory Box / CRUD | View, edit (before sealing), or delete. Shows trigger type / scheduled date / recipient per Memory. |
| **Steward designation** | Steward designation | Memory Box / Posthumous | Assign Steward — the Kin who confirms death and manages posthumous delivery. Steward Agreement consent required from both parties. |
| **Death trigger settings** | Posthumous delivery settings | Memory Box / Posthumous | Configure death verification signals accepted: SSDI match / obituary ingestion / Steward confirmation / biometric inactivity. |
| **Time Capsule delivery** | Time Capsule settings | Memory Box — Calendar | Review \+ edit calendar-triggered Memories. Shows recipient / scheduled date / encryption status. |
| **Milestone Memory triggers** | Milestone Memory triggers | Memory Box — Life Event | Review life event triggers. Shows which Layer 5 signals are active per trigger. |
| **Kinship Alert radius** | Kinship Alert radius | Discovery — Geofence | Set geofence radius for Kinship Alert triggers. Default: 500m. Adjustable 100m–5km. |
| **Memory Box export** | Memory Box export | GDPR / Data Portability | Download encrypted archive of all Memory Box Memories. Decryption key sent to verified email separately. |

# **13 Brand Term Reference (Non-Negotiable Lexicon)**

Every term in KinnectAI maps directly to an algorithmic concept. This lexicon is enforced in all UI copy, push notification strings, support documentation, and API response strings. Deviating from this lexicon is a brand integrity violation.

| Element / Setting | KinnectAI Label | What It Does |
| :---- | :---- | :---- |
| **Profile** | Root | The user's profile page and Bio-Identity anchor node. |
| **Feed** | The Line | Primary CR-sorted feed. Never called 'feed' in UI copy. |
| **Like / React** | Pulse | Lightweight acknowledgment. Count shown as 'Pulses'. |
| **Follow / Connection** | Kinnection | Confirmed biological link. Never 'follow' or 'friend'. |
| **Group** | Branch | Distinct family group within a lineage. Not a generic group. |
| **Story / Reel / Post** | Memory | Atomic content unit with delivery triggers. Never 'post' or 'story'. |
| **Saved / Archive** | Memory Box | Encrypted conditional delivery system. Not a passive archive. |
| **On This Day** | Echoes | Date-triggered Memory surfacing. Always 'Echoes'. |
| **Viral / Trending** | Rippling | High-engagement Memories spreading across Branches. Capped multiplier. |
| **Notification center** | Pulse tab | The notification tab. Named 'Pulse' in bottom navigation. |
| **Animate photo** | Photoplay | AI-powered talking photo animation. Never 'animate' in UI. |
| **Suggested connections** | Lost Branches | AI relative discovery results. Never 'people you may know'. |
| **Discover / Explore** | Discovery | The biological connection discovery surface. Not a content explore page. |
| **Relationship score** | Kin Score | Coefficient of Relationship displayed as percentage. Never 'match score'. |
| **Video call / Group call** | Room | Private encrypted peer-to-peer family call. Up to 50 Kin. |
| **Event / Meeting** | Gathering | Scheduled Room session. Can include Gathering Pass ticketing. |
| **Duet / Collab video** | Stitch | Multi-Kin compiled video. Requires Stitch permission from Memory owner. |
| **Reply video** | Rewind | Alternative-perspective video attached to a Memory. |
| **Playlist / Collection** | Strand | Thematic Memory collection. e.g. 'Your Wedding Strand'. |
| **DNA results** | Bioidentity / Layer 2 | Haplogroups, SNP markers, admixture. Always Layer name in dev docs. |
| **Follower count / Likes** | \[Not displayed\] | KinnectAI displays NO follower counts, like counts, or vanity metrics anywhere. |

# **14 Sidebar / Drawer (Swipe Right from Home)**

Accessed by swiping right from The Line or tapping the hamburger / avatar area top-left. Slides in from left. Closes on swipe left or tap outside. Contains quick-access to all major secondary features.

| Setting | Description |
| :---- | :---- |
| **Heartbeat** | Daily digest card — all overnight Branch activity, new Kinnections, Markers found. Tapping expands full Heartbeat screen. |
| **Strands** | Your themed Memory collections. Shows Strand names \+ cover image \+ count. Tap to open Strand player. |
| **Rooms** | Active and scheduled Rooms. Join live family calls. Create new Room. See Section 08\. |
| **Kinship Alerts** | Geofence proximity notifications. List of recent alerts with distance \+ Kin name \+ Kin Score. Tap to open that Kin's Root. |
| **Name Map** | Biodensity map — surname concentration globally. Entry to Discovery via geographic exploration. See Section 07.4. |
| **Lost Branches** | AI discovery engine — probable relatives ranked by Connection Score. Shortcut to Discover tab with DNA Matches filter active. |
| **Kinnect Kit** | Order free DNA kit / connect existing 23andMe or AncestryDNA account / check Kit status (shipped / received / processing). |

**15Architecture & Client-Server Boundary**

**⚠  CRITICAL:** The Flutter client NEVER communicates directly with Neo4j, Astra DB, Redis, or Cassandra. All data access routes through api.kinnectai.app/v1 via REST or GraphQL. Violations fail CI/CD.

**15.1 Service-to-Feature Ownership Map**

| PRD Feature | SRS Service | Port | Protocol | Auth Requirement |
| :---- | :---- | :---- | :---- | :---- |
| The Line / Feed | feed-service | 8082 | REST GET /v1/feed | JWT \+ scope:feed:read |
| Discovery Cards | discovery-service | 8091 | REST POST /v1/discovery/candidates | JWT \+ scope:discovery:read |
| Tree & Branch Graph | kin-graph-service | 8081 | GraphQL treeGraph resolver | JWT \+ scope:graph:read \+ consent bit 2 |
| Photoplay Studio | photoplay-service | 8084 | REST POST /v1/photoplay | JWT \+ scope:media:write \+ biometric:face \+ consent bit 5 |
| Memory Box (seal) | memorybox-service | 8090 | REST POST /v1/memorybox | JWT \+ scope:vault:write \+ step-up auth |
| Voiceprint Capture | photoplay-service | 8084 | REST POST /v1/voiceprint/capture | JWT \+ scope:media:write \+ consent bit 6 (BIPA) |
| Rooms / Gatherings | rooms-service | 8089 | WebRTC \+ REST POST /v1/rooms | JWT \+ scope:rooms:write |
| Kinnection Requests | kin-graph-service | 8081 | REST POST /v1/kinnections | JWT \+ scope:graph:write |
| DNA Ingestion | dna-ingest-service | 8085 | REST POST /v1/dna | JWT \+ scope:dna:write \+ step-up \+ consent bit 1 |
| Notifications / Push | notification-service | 8092 | FCM/APNS \+ REST | JWT \+ scope:notification:read |
| Commerce / Credits | payment-service | 8093 | REST POST /v1/payments/checkout | JWT \+ scope:payment:write \+ step-up \>$10 |
| Kin Score Display | kernel-service | 8083 | REST GET /v1/kin-score/{user\_id} | JWT \+ scope:feed:read |
| Family Crest (SVG) | photoplay-service | 8084 | REST POST /v1/family-crest | JWT \+ scope:media:write |
| Restore Tool | media-service | 8088 | REST POST /v1/restore | JWT \+ scope:media:write |
| Flickers | photoplay-service | 8084 | REST POST /v1/flickers | JWT \+ scope:media:write |
| Name Map | identity-service | 8086 | REST GET /v1/namemap | JWT \+ scope:discovery:read |

**15.2 Step-Up Authentication Requirement Map**

| PRD Action | Step-Up Reason (X-Stepup-Reason header) | Method | Token TTL |
| :---- | :---- | :---- | :---- |
| Memory Box — Seal | vault\_write | biometric | totp | 300s |
| Memory Box — Revoke trigger | vault\_write | biometric | totp | 300s |
| DNA Kit connection | dna\_upload | biometric | 300s |
| Voiceprint capture | biometric\_capture | biometric | 300s |
| Account deletion | account\_delete | biometric | totp | 300s |
| Steward designation change | vault\_write | biometric | totp | 300s |
| Commerce purchase \>$10 | payment\_write | biometric | 300s |
| Password change | account\_delete | totp | 300s |
| Raw genomic data deletion | dna\_upload | biometric | totp | 300s |

**16 Kin Score Algorithm: PRD↔SRS Alignment**

**16.1 Kin Score Computation (Client-Consumable Summary)**

**ℹ  NOTE:** The client NEVER computes Kin Score. It consumes a server-computed, normalized 0–100 value from GET /v1/kin-score/{user\_id}. Cache TTL: 300s active / 3600s stale-while-revalidate.

| Signal Layer | SRS Layer | Max UI Contribution | PRD Surface |
| :---- | :---- | :---- | :---- |
| DNA Coefficient of Relationship (PI\_HAT) | Layer 2 Bioidentity | 40 points | Blue edge in Tree, DNA Match badge on Discovery card |
| Tree Proximity (Neo4j shortest path) | Layer 3 Social Graph | 25 points | Graph Path View degrees, dashed/solid edge distinction |
| Behavioral Similarity (vector cosine) | Layer 4 Behavioral | 15 points | ContentTypeBoost in The Line ranking (never shown raw) |
| Identity Overlap (surname \+ geo \+ associate) | Layer 1 Identity | 10 points | Name \+ Location Signal badge on Discovery card |
| Temporal Recency (exponential decay) | Layer 5 / Recency | 10 points | Ripple detection, Heartbeat weighting |

**16.2 Kin Score UI Display Rules**

| Display Score | Color Token (Addendum 1.0) | Hex | PRD Surfaces |
| :---- | :---- | :---- | :---- |
| ≥ 80% | kinnect\_accent | \#FF6B1A | Discovery card badge, Tree node highlight, Kinnection request CTA |
| 50–79% | kinnect\_primary | \#00C2D4 | In-line Kin Score badge on video overlay, Profile Kin Score chip |
| \< 50% | kinnect\_text\_secondary (60% opacity) | \#B0B0D0 | Background Discovery candidates, grey nodes in Tree |
| null / calculating | skeleton shimmer | N/A | Biological amber shimmer (loading state in The Line) |
| offline / stale | last known @ 60% opacity | N/A | Feed offline banner \+ tooltip 'Score cached offline' |

**16.3 ContentTypeBoost — Definition Resolved**

| Term | Definition | SRS Reference | PRD Impact |
| :---- | :---- | :---- | :---- |
| ContentTypeBoost | clamp(0.8, 1.3, 1.0 \+ Σ(topic\_pref\_i × engagement\_velocity\_i)) | §4.1 Step 5 | Adjusts rank within same CR band only. Never elevates lower-CR content above higher-CR content. |
| Ripple | ≥40 unique Kin interactions within 2h AND avg\_interaction\_CR ≥ 0.20 | §4.1 / Addendum 3.0 §2 | 2× visibility boost within CR band. Amber 'Rippling' badge. 1 notification/user/day cap. |
| Anti-feedback loop | Discovery exposure raises behavioral weight ≤5% per 30-day window | §4.2 | Dismissing a Discovery card (×0.30 penalty) suppresses card 30 days but cannot game Kin Score. |

**17  Memory Box: Patent, Encryption & Trigger Gaps Resolved**

**⚠  CRITICAL:** Memory Box is the highest legal-risk surface. Every action (seal, revoke, export, steward designation) requires step-up authentication and produces an immutable CloudTrail audit entry.

**17.1 Trigger Type → SRS Implementation Mapping**

| PRD Trigger Name | SRS trigger\_type value | Detection Source | Verification SLA | Fallback Chain |
| :---- | :---- | :---- | :---- | :---- |
| Time Capsule (📅) | time\_capsule | Server-side scheduler (cron) | Fires at exact UTC datetime | If delivery fails: retry 3× (1h, 6h, 24h) → Steward notification |
| Milestone (🎓) | milestone | Layer 5 transaction signals (NielsenIQ / Amazon SP-API opt-in) | Category-level trigger only (no raw txn data stored) | If signal absent after 90 days: prompt user to confirm manually |
| Unspoken Memories (🕯️) | unspoken | SSDI poll 02:00 UTC daily \+ LexisNexis obituary NLP (72h) | SSDI ≥95% → auto-verify. 70–94% → obituary search. \<70% → Steward contact | Primary → Backup Stewards → Legal DPO → Court → 365d auto-release |
| Kinship Alert (📍) | geofence | iOS CLLocationManager (region monitoring, max 20 regions) | Fires when recipient enters radius (100m–5km) | Foreground-only if location permission denied. No continuous GPS. |

**17.2 Zero-Knowledge Encryption — PRD UX Implications**.

| SRS ZK Step | PRD UX State | User-Visible Feedback | Failure Behavior |
| :---- | :---- | :---- | :---- |
| 1\. Client generates 256-bit DEK (Web Crypto API) | Seal CTA tapped → step-up auth prompt | Biometric prompt appears | Auth failure → VaultComposerState.auth\_failed → 'Authentication required' |
| 2–4. Encrypt content \+ upload to S3 via presigned URL | Sealing… progress state | Progress indicator 'Sealing your Memory…' | Upload failure → retry 3× → 'Sealing failed. Your draft is preserved.' |
| 5–6. DEK wrapped by KMS \+ stored as encrypted\_dek | Backend confirmation | Progress continues | KMS failure → 503 → user sees server error state (Addendum 2.0 §6) |
| 7\. Server stores metadata only — never plaintext | VaultComposerState.sealed | 'Memory sealed. Contents inaccessible until trigger fires.' | N/A — success state |
| Trigger execution: KMS unwrap \+ presigned GET URL to recipient | Status badge: Triggered → Delivered | Recipient: push notification \+ Vault tab alert | Delivery failure → retry 3× → Steward notification |

**17.3 Steward Designation — Screen Sequence & Legal Basis**

| Step | Screen | PRD Section | SRS Contract | Legal Basis |
| :---- | :---- | :---- | :---- | :---- |
| 1 | Steward Selection (search confirmed Kinnections only) | §02.3 Memory Box Composer | steward\_id field in vault\_memories schema | GDPR Art. 6(1)(a) explicit consent |
| 2 | Steward Agreement (immutable copy — see Addendum 3.0 §6) | §12.9 Memory Box Settings | Steward Agreement consent flags (bit 9 \= 0x0200) | State probate law \+ KinnectAI ToS |
| 3 | Steward Confirmation (push \+ biometric re-auth required) | §12.9 | steward\_user\_id FK in users table | GDPR Art. 7 — consent record retained separately |
| 4 | Completion (both parties notified) | §03.2 Memory Box Detail | Audit log entry \+ DynamoDB HMAC ledger | SOC 2 immutable audit requirement |

**18.1 Discovery Score Formula (PRD-Level View)**

| Input | Weight | SRS Source | PRD Badge Label |
| :---- | :---- | :---- | :---- |
| DNA Coefficient of Relationship (Layer 2\) | 50 pts | §4.1 Layer 2 / §8.1 VCF pipeline | 'DNA Match' |
| Facial Embedding Cosine Similarity (FaceNet 128-dim, pgvector) | 30 pts | §7.1 TS-003, consent bit 5 | 'Facial Match' |
| Tree Confidence (Neo4j path depth × confidence per segment) | 20 pts | §3.6 GraphQL treeGraph resolver | 'Tree Match' |
| Name \+ Location Signal (Whitepages/LexisNexis Layer 1\) | Modifier only | §1.2 identity-service | 'Name \+ Location Signal' |

**ℹ  NOTE:** Display score \= clamp(0, 100, formula above). Sigmoid normalization applied. PRD 'Connection Score %' and 'Kin Score %' are the same field (kc\_score\_display) rendered differently by surface context.

**18.2 Discovery Cadence — Conflict Resolved**

| Mechanism | Cadence | Client Behavior | SRS Reference |
| :---- | :---- | :---- | :---- |
| discovery-service candidate generation | Hourly (background) | Client does not poll this directly | §1.2 discovery-service port 8091 |
| Client-visible card pool | Refreshes Sunday 06:00 local device time | Max 10 new cards per week surfaced to user | Addendum 3.0 §2 |
| Dismiss penalty | Immediate on swipe left | score × 0.30, card hidden 30 days, undo 5s | §01.3 \+ POST /v1/discovery/dismiss |
| Lost Branches (Sidebar) | Pulls from same weekly pool | Filtered to DNA Match signal type by default | §14 Sidebar / PRD v1.0 |
| Heartbeat daily digest | 02:00 UTC generated, 06:00 local injected | Includes new Discovery matches as 'Lost Branches match' notification | SRS §4.2 Kernel Downtime Fallback |

**18.3 Graph Path View — Confidence Display**

| Path Element | Display | Data Source | Solid vs Dashed Rule |
| :---- | :---- | :---- | :---- |
| DNA-confirmed edge | Solid blue line \+ CR % label | Blue edge in Neo4j (DNA-verified) | Solid |
| Identity-inferred edge | Dashed grey line \+ confidence % | Grey dashed edge (identity graph) | Dashed |
| Pending Kinnection edge | Dashed red line | Red edge (pending request) | Dashed |
| AADR ancient DNA node | Amber node \+ haplogroup label | AADR v54.1 derived embedding | Dashed always |
| Overall path confidence | Product of segment confidences shown at bottom | Per-segment \= 1 \- (uncertainty/edge\_confidence) | N/A |

**19 Database Schema: PRD Feature → SRS Table Mapping**

**⚠  CRITICAL:** SRS §11.5 (PRD) references Astra DB for user\_profiles. This is superseded by SRS v1.0 §2.1 which defines Aurora PostgreSQL (pgvector) as the authoritative user data store. Astra DB / Cassandra is used exclusively for behavioral events (behavioral.events, behavioral.pulses tables).

**19.1 Authoritative Data Store by Feature**

| PRD Feature / Data | Authoritative Store | SRS Schema Reference | Key Fields |
| :---- | :---- | :---- | :---- |
| User profiles (display name, surname, haplogroup, DOB) | Aurora PostgreSQL | §2.1 users table | user\_id, display\_name, surname, haplogroup\_embedding, consent\_flags |
| Biological graph (nodes, edges, CR scores) | Neo4j Aura Enterprise | §2.2 Neo4j constraints | User, TreePerson, KINNECTION, Branch nodes \+ edges |
| Memory Box vault memories | Aurora PostgreSQL \+ S3 Glacier | §2.1 vault\_memories table | memory\_id, encrypted\_dek, content\_s3\_key, trigger\_type, steward\_id |
| Behavioral events (Pulses, views, interactions) | Cassandra (Keyspaces) | §2.3 behavioral.pulses / behavioral.events | user\_id, hour\_bucket, event\_type, sampled |
| Feed cache (pre-computed KC-sorted) | Redis (ElastiCache) | §2.3 feed:{user\_id} ZADD TTL 300s | score=KC, member=memory\_id |
| Haplogroup \+ facial embeddings (vector) | Aurora PostgreSQL (pgvector) | §2.1 HNSW index on haplogroup\_embedding | haplogroup\_embedding vector(512), facial embedding vector(128) |
| KC score cache (pair computations) | Redis | §2.3 kernel:cache:{user\_pair\_id} TTL 1800s | score, model\_version, computed\_at, confidence\_ci |
| Auth tokens (OAuth, passkeys) | Aurora PostgreSQL | §11.5 user\_auth, user\_passkeys | provider\_uid, public\_key, credential\_id |
| OTP sessions | Aurora PostgreSQL TTL 10min | §11.5 otp\_sessions | session\_id, otp\_hash, expires\_at |
| Room state (WebRTC, participants) | Redis STREAM TTL 7200s | §2.3 room:{room\_id} | participants, SFU routing state, ICE candidate cache |

**19.2 Consent Flags (consent\_flags INTEGER Bitmask) — PRD Surface Map**

| PRD Consent Moment | Bit | Hex | Compliance |
| :---- | :---- | :---- | :---- |
| Onboarding: Whitepages/LexisNexis identity enrichment consent | 0 | 0x0001 | GDPR Art. 6 |
| Onboarding Step 2: DNA kit / 23andMe upload | 1 | 0x0002 | HIPAA / GINA |
| Tree sharing / Branch membership visibility | 2 | 0x0004 | GDPR Art. 6 |
| In-app behavioral tracking (The Line, interactions) | 3 | 0x0008 | ATT / CCPA |
| Transaction / life-stage signal processing (Milestone triggers) | 4 | 0x0010 | GDPR Art. 6 |
| Photoplay Studio: facial embedding capture | 5 | 0x0020 | BIPA / Illinois |
| Voiceprint capture (ElevenLabs clone) | 6 | 0x0040 | BIPA / Texas |
| Settings: Off-Platform Tracking Pixel / SDK | 7 | 0x0080 | ATT / GDPR |
| Settings: Third-party data sharing (NielsenIQ/Factus) | 8 | 0x0100 | CCPA Opt-Out |
| Memory Box: Steward / posthumous delivery consent | 9 | 0x0200 | State Probate |
| Family Pairing: guardian consent for minor account | 10 | 0x0400 | COPPA |
| Settings: Research / model training opt-in | 11 | 0x0800 | GDPR Art. 9 |
| Settings: Sunday Stitch auto-publish | 12 | 0x1000 | GDPR Purpose Limitation |

**20 Rooms, Gatherings & Live Broadcast: Implementation Gaps**

**20.1 WebRTC Connection States → PRD UX States**

| WebRTC Event | SRS Protocol | PRD UX State | User-Visible Behavior |
| :---- | :---- | :---- | :---- |
| ICE candidate gathering | ICECandidateTimeout: 30s | Connecting… | 'Joining Room…' spinner |
| Connection established | ICEConnectionTimeout: 45s | Active | Video grid renders, amber border on active speaker |
| Keepalive ping | ICEKeepaliveInterval: 15s | Active (background) | No UI change |
| Participant disconnect | onconnectionstatechange: disconnected | Reconnecting… | Tile shows 'Reconnecting' overlay, 30s patience window |
| Originator disconnect (no co-host) | 5-min countdown after disconnect | Room paused | 'Waiting for host to return. Room ends in 5:00' countdown |
| Originator disconnect (co-host assigned) | Auto-promote co-host \<2s | Seamless | '\[Name\] is now hosting' toast notification |
| SFU node crash | LB reroute \+ RTP replay from last keyframe, \<3s | Brief freeze | Client-side HLS retry: 1s, 2s, 4s, 8s, 16s backoff |
| TURN bandwidth exceeded | Downgrade 1080p→720p→360p | Quality badge changes | 'Adjusting video quality for connection' toast |

**20.2 Room Recording Consent Flow — Legal Requirement**

| Step | Trigger | Modal Copy (Immutable) | Non-Consent Action |
| :---- | :---- | :---- | :---- |
| 1\. Originator taps ⏺ Record | RoomCubit.record() called | 'This Room will be recorded. All participants must consent to continue recording. Tap Agree or Leave.' | N/A (originator initiates) |
| 2\. Participant prompt | system modal pushed to all participants | Same copy above | Tap Leave → removed from stream. Recording continues. |
| 3\. Majority opt-out (\>50%) | Auto-abort trigger | 'Recording stopped. Majority declined consent.' | Recording aborted, no data retained |
| 4\. Post-session choice | Session ends or host stops recording | Choose: Seal to Memory Box / Publish to Line / Discard | Default: Discard if no choice within 10 minutes |

**20.3 Live Broadcast → The Line Injection**

| PRD Behavior | SRS Implementation | Constraint |
| :---- | :---- | :---- |
| 'Go Live' converts Room to public HLS broadcast | SFU switches to broadcast mode via mediasoup HLS worker | Only the top 500 Kin by Kin Score receive the Live push notification |
| Live card injected to The Line | notification-service dispatches rooms.signaling Kafka event | Live card only shown to Kin within KC threshold (not public internet) |
| HLS stream recovery | CDN 503 → exponential backoff 1s/2s/4s/8s/16s | Max 10 Mbps aggregate per room, 2 Mbps per participant |

**21 Push Notification System: Deep Link & Delivery Contracts**

**⚠  CRITICAL:** Memory Box delivery notifications CANNOT be fully disabled — this is a legal requirement (PRD §12.7). The in-app Pulse tab always shows the full unfiltered log regardless of push settings.

| Notification Type | Kafka Topic | FCM/APNS Priority | Deep Link | Can Disable Push? |
| :---- | :---- | :---- | :---- | :---- |
| Pulses | notification.dispatch | NORMAL | kinnect://memory/{memory\_id} | Yes |
| New Kinnections | notification.dispatch | HIGH | kinnect://root/{candidate\_id}/profile | Yes |
| Mentions | notification.dispatch | NORMAL | kinnect://pulse?filter=mentions | Yes |
| Comments | notification.dispatch | NORMAL | kinnect://memory/{memory\_id}\#comment-{comment\_id} | Yes |
| Messages (DM) | notification.dispatch | HIGH | kinnect://dm/{thread\_id} | Yes |
| Gatherings | notification.dispatch | HIGH | kinnect://room/{room\_id} | Yes |
| Branch Activity | notification.dispatch | NORMAL (batched) | kinnect://branch/{branch\_id} | Yes |
| Heartbeat (daily digest) | notification.dispatch | NORMAL (batched) | kinnect://line?tab=heartbeat | Yes (recommended ON) |
| Echoes | notification.dispatch | NORMAL | kinnect://memory/{memory\_id}?echo=true | Yes |
| Memory Box Delivery | vault.triggers | HIGH | kinnect://vault/{memory\_id} | NO — legal requirement |
| Kinship Alerts | notification.dispatch | HIGH | kinnect://alert/{alert\_id}/map | Yes |
| Ripples | notification.dispatch | NORMAL | kinnect://memory/{memory\_id}?ripple=true | Yes |
| Lost Branches matches | discovery.matches | NORMAL | kinnect://discovery/{candidate\_id}?source=lost\_branches | Yes |
| Live Broadcasts | rooms.signaling | HIGH | kinnect://live/{room\_id} | Yes (top 500 by KC only) |

**22 Commerce: Photoplay Credits, Vault+, Marketplace** 

**8.1 Photoplay Credits — Definitive Pricing & Entitlements**

| Tier | Price | Credits | RevenueCat Product ID | Entitlement | Refund Policy |
| :---- | :---- | :---- | :---- | :---- | :---- |
| Starter | $0.99 | 1 | photoplay\_credits\_tier\_1 | scope:media:write:1 | 48h if render fails |
| Standard | $4.49 | 5 | photoplay\_credits\_tier\_2 | scope:media:write:5 | 48h if render fails |
| Premium | $8.99 | 12 (was 10 in PRD) | photoplay\_credits\_tier\_3 | scope:media:write:12 | 48h if render fails |
| Unlimited | $16.99/mo | Unlimited | photoplay\_credits\_monthly | scope:media:write:unlimited | Pro-rata on cancellation |

**⚠  CRITICAL:** PRD v1.0 listed 20 credits at $16.99. Addendum 3.0 corrected this to 12 credits at $8.99 (tier 3\) and Unlimited subscription at $16.99/mo. Addendum 4.0 (this document) is authoritative.

**22.2 Vault+ Storage Subscription**

| Tier | Storage | Price | RevenueCat Product ID | Upgrade Trigger |
| :---- | :---- | :---- | :---- | :---- |
| Free | 5GB | $0 | N/A | Upgrade prompt at 80% capacity |
| Vault+ | 500GB | $4.99/mo | vault\_expanded\_500gb | Settings → Balance → Vault+ upgrade CTA |

**22.3 Kinnect Kit Fulfillment — Chain of Custody**

| Stage | System | Data Captured | Compliance |
| :---- | :---- | :---- | :---- |
| Order placed | Stripe \+ kit\_fulfillment table (PG) | kit\_id, user\_id, shipping\_addr\_hash | PCI-DSS (Stripe handles card) |
| Shipped | Carrier API (FedEx/DHL/AusPost by region) | tracking\_number, carrier\_status | Data minimization |
| Lab received | Sequencing.com / LabCorp | qr\_scan\_timestamp, lab\_id, temp\_log | HIPAA chain of custody |
| DNA processing | Arvados \+ PLINK pipeline → dna-ingest-service | fastq\_s3\_key, vcf\_status, haplogroup\_assigned | FASTQ → S3 Glacier 7-year lock |
| App delivery | dna-ingest-service → KC recompute trigger (cr.recompute Kafka) | kc\_score\_update | Consent bit 1 (0x0002) must be set |
| Raw deletion request | S3 Object Lock expiry set to 30d \+ audit | deletion\_request\_id | GDPR Art. 17 / 30-day SLA |

**24 Compliance: GDPR, BIPA, COPPA, HIPAA & AADR**

**24.1 Regulatory Compliance — PRD Surface Map**

| Standard | PRD Feature Affected | UI Requirement | SRS Reference |
| :---- | :---- | :---- | :---- |
| GDPR Art. 6/9 | DNA upload, Voiceprint, Off-platform tracking | Explicit opt-in checkbox per feature before activation. Cannot bundle consents. | §12.1 \+ Appendix J |
| GDPR Art. 17 (Erasure) | Settings → Genomic Data Controls → Raw Deletion | Request must process within 30 days. Step-up auth required. | §12.8 Memory Box Settings / §5.4 |
| GDPR Art. 20 (Portability) | Settings → Download Your Data | ZIP export within 24h. All stores: PG, Neo4j, Cassandra, S3 keys, audit ledger. | §11.2 GDPR Art. 15 Data Export |
| GDPR Art. 22 (Explainability) | Discovery card Connection Score badge tap | Opens modal from GET /v1/kc/explain/{pair\_id} — top-3 features, layer weights, CI, model version. | §4.2 Engineering Safeguards |
| BIPA (Illinois) | Photoplay Studio facial detection, Voiceprint | Explicit written consent required before facial embedding or voice clone. On-device TFLite only for preview (no cloud face storage). | §12.1 \+ Appendix J bit 5/6 |
| HIPAA/GINA | DNA ingestion, haplogroup display | Genetic data isolated in separate schema. No cross-query with insurance features. T4 data: no human access, service accounts only. | §12.1 \+ §5.1 T4 classification |
| COPPA | Family Pairing, under-13 accounts | No DNA, no voiceprint, no public profile, no off-platform tracking for under-13. Guardian verifiable consent required. | §12.4 Family Pairing \+ §2.4 |
| ATT (iOS) | Off-platform behavioral tracking | ATT prompt shown after Onboarding Step 4 (Invite Kin). Approved copy mandatory (see SRS §12.2). | §12.2 iOS ATT Prompt |
| AADR Commercial Use | Tree: Amber nodes (historical/ancient DNA) | Attribution badge required on all historical match surfaces: 'Historical DNA data courtesy of AADR (Reich Lab, Harvard)'. | §8.2 \+ Legal Appendix |
| WikiTree (CC BY 4.0) | Tree: Gold-ring nodes (celebrity/namesake) | Auto-append 'Source: WikiTree (CC BY 4.0)' to all gold-ring node tooltips. | Addendum 3.0 §10 |

**24.2 Biometric Jurisdiction Routing**

| User Region | Governing Law | UI Consent Routing | Retention / Deletion |
| :---- | :---- | :---- | :---- |
| Illinois, USA | BIPA | Explicit written consent modal \+ $1M penalty disclosure required before facial/voice capture | 3-year max, auto-purge at 36 months |
| EU / UK | GDPR Art. 9 | Explicit Art. 9 checkbox \+ DPO contact link | Right to erasure within 30 days. eu-west-1 data residency enforced. |
| California, USA | CCPA / CPRA | 'Limit Use of Sensitive Info' toggle visible at account creation and in Settings | 12-month lookback deletion on request |
| Texas, USA | CUBI (voice) | Voice biometric explicit consent modal required before Voiceprint capture | 30-day purge from revocation |
| All other regions | KinnectAI Baseline | Standard explicit consent modal | 7-year retention, user-controlled deletion portal |

**25 — AI/ML Pipeline: Photoplay, Flickers, Restore & Family Crest**

**25.1 AI Feature Pipeline Map**

| PRD Feature | AI Pipeline | Quality Tier | C2PA Required | Cost / Unit | Fallback |
| :---- | :---- | :---- | :---- | :---- | :---- |
| Photoplay (Standard) | SadTalker OSS (GPU worker, EKS) | Free | Yes | \~$0.01 compute | N/A (this is the fallback tier) |
| Photoplay (Premium) | D-ID API → SadTalker on 503 | 1 Photoplay Credit | Yes | 1 credit / D-ID API cost | Auto-fallback to SadTalker. Credit NOT charged on fallback. |
| Voiceprint | ElevenLabs (≤10 clones/day) → OpenVoice-V2 (self-hosted EKS GPU) | Free (P1 queue) / Vault+ (P0) | No | \~$0.002/min (ElevenLabs) | OpenVoice-V2 replicates timbre/prosody — not generic TTS |
| Flickers | GPT-4o script (family\_safe:true) \+ ElevenLabs narration \+ FFmpeg | Free (1/month?) | Yes | \~$0.04/reel | Template-based narration if AI safety filter triggers |
| Restore (colorise) | Real-ESRGAN 4× upscale → DeOldify colorisation (GPU cloud workers) | Free | No | \~$0.005/image | Stage 1 (upscale) can succeed if Stage 2 (colorise) fails |
| Family Crest (SVG) | GPT-4o SVG generation \+ go-sanitize XSS strip \+ C2PA embed | Free | Yes | \~$0.002/crest | Template crest from haplogroup lookup if GPT-4o fails |

**25.2 C2PA Synthetic Media Disclosure — PRD UX Requirements**

| Requirement | PRD Surface | UI Behavior | SRS Reference |
| :---- | :---- | :---- | :---- |
| 'AI-Generated Media' badge | All Photoplay, Flickers, Family Crest outputs in The Line and profile | Badge renders when content.is\_ai\_generated=true. Screen reader announces badge. | §7.2 SYN-004 |
| C2PA Verified indicator | Tap on AI badge | Opens modal: 'This content was created with KinnectAI AI tools. Provenance verified.' \+ manifest details. | §7.2 / Appendix N |
| Voice challenge-response | Voiceprint capture Step 2 (consent) | User reads 10 random words. Hash of audio \+ transcript stored for verification. | §7.2 SYN-002 |
| Liveness check (Photoplay) | Photoplay Studio Step 1 (photo selection) | TFLite blink \+ head movement check before pipeline starts. On-device only. | §7.2 SYN-003 |

**26 Settings & Privacy: SRS-Aligned Control Mapping**

| Settings Action | PRD Location | Backend Consequence | SRS Reference |
| :---- | :---- | :---- | :---- |
| Toggle DNA kit connection OFF | §12.8 Genomic Data Controls | Disconnects Sequencing.com OAuth. Removes Layer 2 from KC computation. Does NOT delete stored embeddings unless raw deletion also requested. | Appendix J bit 1 (0x0002) |
| Revoke Voiceprint | §12.0 Personal Tools → Voiceprint | POST /v1/voiceprints/{id}/revoke → ElevenLabs DELETE. Retry 3×. Blocks Photoplay voice dropdown until confirmed. 30-day GDPR purge window. | §8.3 / Appendix L |
| Revoke facial biometric consent (bit 5\) | §12.8 Genomic Data Controls | Blocks DeepFace cloud processing. On-device only thereafter. Existing Photoplays unaffected. | Appendix J bit 5 (0x0020) |
| Toggle Off-Platform Tracking OFF | §12.8 Off-Platform Data / §12.6 Browser Settings | behavioral-service ignores Pixel/SDK events. Sets att\_status=denied (iOS). KC computation continues with in-app signals only. | §12.2 ATT / Appendix J bit 7 |
| Third-party sharing opt-out | §12.8 Third-party opt-out | Blocks NielsenIQ/Factus data export. Does NOT affect Sequencing.com or Kinnect Kit. | Appendix J bit 8 (0x0100) |
| Refresh Your Line | §12.2 Content Preferences | Resets ContentTypeBoost behavioral weighting only. Does NOT reset Kin Scores, Kinnections, or CR computations. | §4.1 KC Kernel / PRD §01.1 |
| Consent revocation (any bit) | §12.8 various | consent\_flags updated in PG → async job scans active sessions → revoked JTIs written to Redis. Latency \<2ms via Redis cluster. | Appendix D JWT Revocation |
| Download Your Data | §12.5 Account | GET /v1/user/{id}/export aggregates: PG, Neo4j, Cassandra, S3 keys, audit ledger. ZIP via presigned URL (24h expiry). SLA: 24h. | §11.2 GDPR Art. 15 Export |
| Deactivate account | §12.5 Account | Hides account 30 days. Memory Box Steward notified if active Vault memories exist. Data retained 30 days before permanent delete. | §2.1 users table ON DELETE CASCADE |
| Switch to Steward Account | §12.5 Account Type | Steward Agreement consent (bit 9 \= 0x0200) required from both parties. 2FA required for all future Memory Box steward actions. | §3.2 vault:write scope \+ step-up |

**27 Onboarding Flow: SRS-Aligned Step Specification**

| Step | PRD Label | SRS Implementation | Consent Bits Set | Fallback / Skip Behavior |
| :---- | :---- | :---- | :---- | :---- |
| 1 | Surname Entry | identity-service seeds Layer 1 confidence. Name Map visualization via GET /v1/namemap. Emotional hook loads immediately. | None at this step | Cannot skip — surname required for Layer 1 seeding |
| 2 | DNA (optional) | dna-ingest-service OAuth flow or VCF upload. Consent bit 1 (0x0002) explicit checkbox required. Kinnect Kit order triggers fulfillment pipeline. | Bit 1 if DNA connected | Skip does not block onboarding. KC computation runs on identity layers only. |
| 3 | First Photo | On-device TFLite face landmark detection (no cloud call). Consent bit 5 (0x0020) BIPA disclosure required before any facial processing. Standard Photoplay created as first Memory. | Bit 5 (BIPA — explicit) | Can skip photo. Photoplay tutorial skipped. Default avatar assigned. |
| 4 | Invite Kin | Contact sync requires explicit permission prompt (iOS/Android). iOS ATT prompt fires here (post Step 4, pre Step 5). Consent bit 7 (0x0080) set if ATT granted. | Bit 7 if ATT granted | Skip allowed. The Line shows empty state with 'Invite more Kin' Heartbeat card. |
| 5 | The Line Activation | feed-service assembles first Line from kernel-service. If 0 Kinnections: Heartbeat card injected at top. Discovery cards injected at 1:7 ratio from first load. | None | N/A — terminal step |

**29\. Messaging (DM) Screen Specification**

The PRD references Direct Messaging in notifications, profile actions, and sidebar but provides no dedicated screen map. This section is the authoritative UI and API specification for all DM flows.

**29.1 Route & Entry Points**

| Entry Point | Route | Route Type | Auth Requirement |
| :---- | :---- | :---- | :---- |
| Profile → Message button | kinnect://dm/{kin\_id} | Push Route | Confirmed Kinnection only |
| Notification → Messages | kinnect://dm/{thread\_id} | Push Route | JWT \+ scope:messages:read |
| Sidebar → Messages | kinnect://messages | Push Route | JWT \+ scope:messages:read |
| Pulse inbox filter: Messages | kinnect://messages?filter=unread | In-Surface Filter | JWT |

**29.2 Screen Layout & Components**

| Component | KinnectAI Label | Behavior | Accessibility |
| :---- | :---- | :---- | :---- |
| Thread header | Kin header | Avatar \+ name \+ Kin Score badge \+ online indicator | Semantics: '{name}, Kin Score {score}%' |
| Message list | Conversation | ListView: sent right, received left. Timestamp \+ read receipt per message. | Screen reader: '{sender}: {message}, {time}' |
| Input field | Message field | TextField \+ Attach (Memory/Stitch) \+ Send (disabled if empty) | Label: 'Type a message to {name}' |
| E2EE badge | Encrypted indicator | Lock icon \+ tooltip: 'End-to-end encrypted. Not readable by KinnectAI or Stewards.' | Semantics: 'Conversation is end-to-end encrypted' |
| Attach button | Attach Memory | Opens picker: Memory / Stitch / file (max 50MB). Client-side AES-256-GCM before upload. | Label: 'Attach a Memory or file' |

**29.3 Interaction Spec**

| Gesture | Behavior | State Change | Fallback |
| :---- | :---- | :---- | :---- |
| Tap Send | Encrypt → queue in drift → sync via WebSocket | Sending → Sent | Offline: Queued \+ banner 'Waiting for connection' |
| Swipe message left | Delete for everyone (5s undo snackbar) | Cryptographic key shred \+ tombstone | No network: queue deletion, sync on reconnect |
| Long press message | Context menu: Copy / Forward to Branch / Memory Box trigger | Modal appears | Haptic feedback |
| Pull to refresh | Force sync pending/outgoing | Loading → Synced | Network error → inline retry banner |
| Hold-to-record input | Voice message (hold to record, release to send) | Recording → Queued → Sent | Permission denied → Settings redirect |

**29.4 API & Cryptographic Contract**

POST /v1/messages  
Payload: { thread\_id, encrypted\_payload, sender\_device\_id, timestamp }  
Response: { message\_id, server\_timestamp, delivery\_status }

Protocol: Libsignal (Signal Protocol) \+ Double Ratchet algorithm  
Metadata (sender, recipient, timestamp): PostgreSQL  
Content: S3 with separate per-message encryption key  
Deletion: cryptographic key shred \+ tombstone marker propagated to all devices

**29.5 Compliance**

| Standard | Requirement | Implementation |
| :---- | :---- | :---- |
| COPPA | Minors cannot initiate DMs | UI shows 'Messaging disabled for guardian safety' if is\_minor=true. Can receive from Confirmed Kinnections only. |
| GDPR Art. 17 | 'Delete for everyone' \= cryptographic key shred \+ tombstone propagation | 24h SLA for cross-device sync. Immutable audit entry. |
| Retention | Auto-purge after 24 months | Messages flagged for Memory Box trigger move to memory\_box\_drafts with separate KMS key. |

**29.6 BLoC State Machine**

| BLoC | Events | States | Repository |
| :---- | :---- | :---- | :---- |
| MessagingBloc | LoadThread, SendMessage, DeleteMessage, AttachMemory | Loading, Loaded(Thread), Sending, Queued, Error | MessagingRepository → POST /v1/messages |

**30\. Full Error State Registry (48 Screens)**

Addendum 2.0 §6 defines the error taxonomy but does not enumerate all error states per screen. This section is the authoritative error registry. Every error state must be implemented before a screen is marked live in prd\_traceability.

**30.1 Error State Matrix**

| Screen | Error Code | User Message | Retry Action | Accessibility Label |
| :---- | :---- | :---- | :---- | :---- |
| The Line | FEED\_CACHE\_MISS | Loading your biological feed… | Auto-retry with exponential backoff (1s, 2s, 4s, 8s) | Feed loading, please wait |
| The Line | NETWORK\_ERROR | No connection. Tap to retry. | Tap banner → exponential backoff \+ connectivity\_plus listener | Network error: feed unavailable. Tap to retry. |
| The Line | SERVER\_ERROR\_5XX | KinnectAI servers are updating. We'll be back shortly. | Retry button \+ background health check every 30s | Service temporarily unavailable. Tap to check status. |
| Photoplay Studio | D\_ID\_API\_FAILURE | Using standard quality — Premium service temporarily unavailable. | Auto-fallback to SadTalker. Credit NOT charged. | Premium animation unavailable. Using standard quality. |
| Photoplay Studio | VOICEPRINT\_MISSING | Record a voice message or type text to continue. | Navigate to Voiceprint capture flow | Voiceprint required. Record voice or type text. |
| Photoplay Studio | CREDIT\_BALANCE\_ZERO | No Photoplay Credits remaining. | Show Buy Credits CTA. Disable Premium option. | Insufficient credits. Purchase credits to continue. |
| Memory Box Composer | VAULT\_SEAL\_AUTH\_FAILED | Step-up authentication required to seal this Memory. | Re-prompt biometric/2FA. Max 3 attempts before lockout. | Authentication required for secure action. |
| Memory Box Composer | KMS\_FAILURE\_503 | Memory sealing temporarily unavailable. Your draft is preserved. | Retry button (max 3×). Draft auto-saved to drift. | Sealing service unavailable. Draft preserved. |
| Memory Box Composer | STEWARD\_UNCONFIRMED | Your designated Steward hasn't confirmed yet. Memory cannot be sealed. | Re-send Steward request. Awaiting confirmation 14-day window. | Steward confirmation pending. Cannot seal yet. |
| Discovery | CANDIDATES\_EMPTY | No new probable Kin found this week. Check back Sunday. | Pull-to-refresh. Next batch unlocks Sunday 06:00 local. | Discovery empty state. Refresh available Sunday. |
| Discovery | KIN\_SCORE\_STALE | Connection Score cached. Recalculating… | GET /v1/kin-score background refresh. | Score cached offline. Updating when connected. |
| Rooms | ROOM\_JOIN\_FAILED | Couldn't join the Room. Check your connection. | Retry / Fallback to audio-only (camera off) | Room connection error. Retry or join audio-only. |
| Rooms | ICE\_TIMEOUT | Connection unstable. Switching to audio-only. | Auto-downgrade from video to audio. User notified. | Video unavailable. Switched to audio. |
| Rooms | TURN\_BANDWIDTH\_EXCEEDED | Adjusting video quality for your connection. | Auto-downgrade: 1080p → 720p → 360p → audio-only | Video quality reduced for connection speed. |
| Tree / Graph | NEO4J\_PARTIAL | Branch subgraph incomplete. Showing known connections. | Fetch fallback via identity layer. CTA: Verify with DNA. | Partial family tree loaded. Some connections unavailable. |
| Tree / Graph | GEDCOM\_PARSE\_ERROR | Some imported records could not be merged. Review conflicts. | Conflict resolution UI. Confidence \<0.70 → new node. | Import complete with conflicts requiring review. |
| Settings | CONSENT\_REVOKE\_FAILED | We couldn't update your consent preferences. Try again. | Retry. If persistent → Contact Support CTA. | Consent update error. Retry available. |
| Settings | DATA\_EXPORT\_TIMEOUT | Your data export is taking longer than expected. We'll email you when ready. | Background polling every 30s. Email on completion. | Data export in progress. Email notification pending. |
| DNA Ingestion | VCF\_MALFORMED | Your DNA file couldn't be read. Please re-upload a valid file. | Layer 2 excluded. KC runs on L1/L3/L4/L5 only. | DNA file unreadable. Re-upload required. |
| DNA Ingestion | SNP\_LOW\_COVERAGE | DNA data partially processed. Connection Scores may be lower than expected. | Reduce L2 weight 50%. Prompt re-upload. | Low DNA coverage. Scores may be reduced. |
| Voiceprint | ELEVENLABS\_RATE\_LIMIT | Your Voiceprint is being processed using our secure fallback engine. | Auto-route to OpenVoice-V2. User notified of provider switch. | Voice processing via fallback. No action needed. |
| Voiceprint | REVOCATION\_FAILED | Voiceprint revocation pending. Contact support if this persists. | Retry 3× (1s, 5s, 15s). Manual ticket. Block Photoplay voice until confirmed. | Revocation in progress. Photoplay voice disabled. |
| Commerce | PAYMENT\_DECLINED | Payment unsuccessful. Check your payment method and try again. | Re-open payment sheet. Restore Purchases fallback. | Payment failed. Review payment method. |
| Commerce | ENTITLEMENT\_SYNC\_FAILED | Purchase confirmed but features may take a moment to activate. | RevenueCat poll every 5min. Manual Restore Purchases CTA. | Purchase pending activation. Refreshing entitlements. |
| Messaging | MESSAGE\_SEND\_FAILED | Message queued. Will send when connection is restored. | Queue in drift. Retry on reconnect. Banner: 'Waiting for connection' | Message queued. Will deliver when online. |
| Kinship Alert Map | LOCATION\_PERMISSION\_DENIED | Enable location to receive Kinship Alerts. | Settings redirect. Foreground-only fallback active. | Location access needed for Kinship Alerts. |

**30.2 CI Gate: Error Coverage Validation**

Every screen in prd\_traceability must declare ≥3 error states in error\_registry.yaml before implementation\_status can be set to 'live'. The CI gate script validate\_error\_coverage.py enforces this requirement on every pull request targeting main.

**31\. Steward Consent Flow — Complete Screen Sequence**

The Memory Box posthumous delivery flow requires Steward consent, but the exact screen sequence, legal copy, and state machine were not fully mapped in prior documents. This section is the authoritative specification.

**31.1 Entry Points**

| Trigger | Route | Auth Requirement |
| :---- | :---- | :---- |
| Memory Box Composer → Unspoken trigger selected | kinnect://memory-box/steward-consent/{memory\_id} | JWT \+ scope:vault:write \+ step-up (biometric/TOTP) |
| Settings → Memory Box → Steward designation | kinnect://settings/memory-box/steward | JWT \+ step-up |
| Notification: Steward request received | kinnect://steward-confirm/{request\_id} | JWT \+ step-up (Steward account) |

**31.2 Screen Sequence (4-Step Flow)**

| Step | Screen | Key Components | State Machine Event |
| :---- | :---- | :---- | :---- |
| 1 | Steward Selection | Search bar (Confirmed Kinnections only). Each row: Avatar \+ name \+ Kin Score \+ relationship. CTA: 'Select as Steward' (disabled until selection). | StewardConsentCubit.selectSteward(stewardId) |
| 2 | Steward Agreement | Immutable legal copy (see §31.3). Checkbox required before 'Send Steward Request' CTA. Link: 'View full Steward Agreement' → webview PDF. | StewardConsentCubit.acceptAgreement() |
| 3 | Awaiting Confirmation | Status: 'Waiting for {Steward Name} to confirm.' Steward receives: push \+ in-app alert \+ email. Steward must confirm via biometric re-auth. 14-day timeout. | StewardConsentCubit.awaitConfirmation() |
| 4 | Completion | 'Steward designation confirmed. Memory sealed.' Both parties notified. Revocation available in Settings until sealing. | StewardConsentCubit.confirmationReceived(memoryId) |

**31.3 Steward Agreement — Immutable Legal Copy**

This copy must not be altered without sign-off from Legal/DPO. It must appear verbatim in the Steward Agreement screen and the webview PDF.

Steward Agreement for Posthumous Memory Delivery

You are designating \[Steward Name\] as the custodian of this Memory Box item.  
Upon verification of your death, \[Steward Name\] will have the authority to:  
  • Confirm death signals (SSDI match, obituary, biometric inactivity)  
  • Authorize delivery of this encrypted Memory to \[Recipient Name\]  
  • Manage trigger settings if circumstances change

This designation is legally binding per the KinnectAI Steward Agreement.  
\[Steward Name\] must independently confirm this designation via their account  
before this Memory can be sealed.

\[ \] I understand and authorize this Steward designation.

**31.4 BLoC State Machine**

| State | Description | Transitions |
| :---- | :---- | :---- |
| initial | No steward selected | → stewardSelected on selectSteward() |
| stewardSelected | Kin chosen, agreement not yet accepted | → agreementPending on acceptAgreement() |
| agreementPending | Request sent, awaiting Steward confirmation (14d window) | → confirmed or expired |
| confirmed | Both parties confirmed. Memory can be sealed. | → Terminal state |
| expired | 14-day window elapsed with no response. | → Request cancelled. Creator notified. |
| revoked | Either party revoked before sealing. | → Returns to initial |

**31.5 Audit & Legal Basis**

| Requirement | Implementation |
| :---- | :---- |
| GDPR Art. 6(1)(a) — explicit consent | Consent record stored separately from user data in consent\_audit\_log table. Retrievable on Subject Access Request. |
| GDPR Art. 7 — revocability | Either party can revoke before sealing. Revocation logs timestamp \+ initiating party in DynamoDB HMAC ledger. |
| State probate law | Steward designation produces signed PDF agreement. Stored in S3 with 7-year retention. Reference: steward\_agreements/{user\_id}/{memory\_id}.pdf |
| SOC 2 immutable audit | All 4 flow steps produce CloudTrail entries. HMAC of user\_id \+ steward\_id \+ action \+ timestamp appended to DynamoDB audit ledger. |

**32\. Animation & Motion Specification**

Brand colors and interaction states were defined in Addendum 1.0 but no animation easing, duration tokens, or transition rules were specified. This section is the authoritative motion system. All animations must use these tokens — hardcoded durations and curves fail CI lint.

**32.1 Duration Tokens**

| Token | Duration | Use Case |
| :---- | :---- | :---- |
| durationMicro | 100ms | Icon color shifts, small state changes (Pulse burst, toggle flick) |
| durationStandard | 200ms | Button presses, tab switches, card appearance |
| durationEmphasis | 300ms | Photoplay complete, Kinnection confirmed, Kin Score threshold crossed |
| durationMacro | 500ms | Screen transitions, Branch Map load, graph render |
| adaptiveDuration | 0ms (if reduceMotion) else durationStandard | All animations must check MediaQuery.of(context).disableAnimations |

**32.2 Easing Curves**

| Curve | Type | Use Case |
| :---- | :---- | :---- |
| standardEasing | Curves.fastOutSlowIn | Default. Button presses, tab switches, dismissals. |
| emphasisEasing | Curves.elasticInOut | Celebratory moments: Kinnection confirmed, Photoplay complete, Memory sealed. |
| decelerateEasing | Curves.decelerate | Dismissals, sheet close, card swipe-out. |

**32.3 Component-Level Animation Rules**

| Component | Animation | Duration | Curve | Reduced Motion |
| :---- | :---- | :---- | :---- | :---- |
| Kin Score badge (score threshold cross) | AnimatedContainer color: \#B0B0D0 → \#00C2D4 → \#FF6B1A. BoxShadow appears at ≥80. | durationEmphasis (300ms) | emphasisEasing | Instant color change, no glow |
| Pulse icon burst | AnimatedScale: 1.0 → 1.2 → 1.0. Color: default → \#FF6B1A. | durationMicro (100ms) | standardEasing | No scale. Color only. |
| Memory sealed confirmation | Lottie lock animation (seal close). Then: VaultComposerState.sealed card fade in. | durationEmphasis (300ms) | emphasisEasing | Static lock icon \+ state text only. |
| Feed card swipe-up | SlideTransition: Offset(0,0) → Offset(0,-1). Background card scales 0.95 → 1.0. | durationStandard (200ms) | standardEasing | Instant swap |
| Kinnection confirmed | Confetti burst (Lottie) \+ card border glow (kinnect\_accent). | durationEmphasis (300ms) | emphasisEasing | Static success banner only |
| Room join | Fade-in grid tiles (staggered 50ms per participant). | durationMacro (500ms) | decelerateEasing | All tiles appear simultaneously |
| Rippling badge | Amber pulse ring radiates from badge (2x ring, 600ms loop). | 600ms loop | standardEasing | Static badge only |

**⚠** *Lint rule: no\_hardcoded\_animations — CI fails if Duration() or Curve used directly instead of KinnectAIMotion tokens. All animation code must import lib/theme/motion\_spec.dart.*

**33\. Moderation Pipeline — Escalation SLAs & UI States**

SRS §7.1 and Addendum 3.0 §9 define moderation controls, but the UI states, creator-facing copy, and escalation flows visible to end users were not specified. This section resolves those gaps.

**33.1 Automated Scoring Thresholds & User States**

| Signal | Engine | Threshold | Action | Creator-Facing UI |
| :---- | :---- | :---- | :---- | :---- |
| Toxicity | Perspective API | ≥ 0.80 | Auto-hide \+ P0 queue | 'Your Memory was hidden pending review. You'll hear back within 2 hours.' |
| Toxicity borderline | Perspective API | 0.50–0.79 | P1 human review queue | No UI change until reviewer acts. |
| NSFW | CLIP | ≥ 0.70 | Auto-hide \+ P0 queue | 'Your Memory was hidden for review. Sensitive content detected.' |
| CSAM / Hash match | PhotoDNA | Any match | Immediate removal \+ NCMEC report. Account suspended. | Account suspended. Legal hold. |
| Spam / bot pattern | Behavioral heuristic | ≥ 3 rapid posts | Rate limit \+ P2 queue | Toast: 'Posting too quickly. Please wait a moment.' |

**33.2 Escalation SLAs**

| Priority | Definition | Response SLA | Resolution SLA | Escalation Path |
| :---- | :---- | :---- | :---- | :---- |
| P0 | CSAM, threats of violence, deepfake impersonation | 30 min | 2h | Trust & Safety Lead → Legal → DPO |
| P1 | Toxicity 0.5–0.8, NSFW borderline, harassment | 2h | 24h | Moderation Queue → Senior Reviewer |
| P2 | Spam, policy edge cases, user appeals | 24h | 72h | Community Guidelines Team |

**33.3 Appeal Flow**

| Step | Screen | Action | SRS Reference |
| :---- | :---- | :---- | :---- |
| 1 | Hidden Memory detail | Banner: 'Content hidden. Tap to appeal.' CTA always visible. | TS-001 P1/P2 |
| 2 | Appeal sheet (bottom sheet) | Free text field: 'Tell us why this content doesn't violate guidelines.' Submit. Max 500 chars. | Trust & Safety queue |
| 3 | Appeal confirmed | Toast: 'Appeal received. We'll review within 24h.' In-app Pulse tab: 'Appeal under review' status badge. | P2 SLA 24h |
| 4 | Outcome | Push: 'Appeal approved — Memory restored' OR 'Appeal reviewed — decision upheld.' Detailed reason in Pulse tab. | Immutable audit log |

**34\. Room Recording Consent — Complete Legal Flow**

Addendum 3.0 §3 references recording consent but the complete screen states, storage choices, and GDPR basis were not mapped to UI components. This section is authoritative.

**34.1 Consent Flow Sequence**

| Step | Trigger | Modal Copy (Immutable) | Non-Consent Action |
| :---- | :---- | :---- | :---- |
| 1\. Originator initiates | Originator taps ⏺ Record | N/A — originator initiates |  |
| 2\. Participant prompt | System modal pushed to all participants | 'This Room will be recorded. All participants must consent to continue recording. Tap Agree or Leave.' | Tap Leave → removed from stream. Recording continues. |
| 3\. Majority opt-out | \>50% tap Leave | Toast to originator: 'Recording stopped. Majority declined consent.' | Recording auto-aborted. No data retained. |
| 4\. Post-session choice | Session ends or host stops recording | Sheet: 'Seal to Memory Box / Publish to The Line / Discard' Default: Discard if no action within 10 minutes. | Default discard after 10 min timeout. |

**34.2 Storage Routing by Choice**

| Choice | Destination | Encryption | Retention | Access |
| :---- | :---- | :---- | :---- | :---- |
| Seal to Memory Box | AES-256-GCM client-side → S3 → KMS wrap | ZK architecture (SRS §5.2) | Until trigger fires | Steward \+ Recipient only |
| Publish to The Line | CDN \+ transcoded tiers (360p/720p/1080p) | TLS in transit, AES-256 at rest | 24 months | Branch/Kin per visibility settings |
| Discard | Secure delete from SFU worker disk | N/A | 0 — immediate purge | N/A |

**34.3 BLoC State Machine**

| State | Description |
| :---- | :---- |
| idle | Recording not active |
| awaitingConsent | Participant consent modal displayed. Timeout: 30s per participant. |
| consentMajorityRejected | Recording aborted. Toast displayed to originator. |
| recording | Active recording. SFU worker writing RTP to disk. |
| processingChoice | Session ended. Storage choice sheet displayed (10 min timeout). |
| sealed | Recording sealed to Memory Box via ZK flow (SRS §5.2). |
| published | Recording transcoded and published to The Line. |
| discarded | Recording securely deleted from SFU worker. |

**35\. Voiceprint Revocation — Complete Flow & ElevenLabs API Contract**

Addendum 3.0 §6 defines revocation at a high level. This section provides the complete screen sequence, API contract, state machine, and compliance requirements for production implementation.

**35.1 Revocation Screen Sequence**

| Step | Screen | Action | State |
| :---- | :---- | :---- | :---- |
| 1 | Settings → Personal Tools → Voiceprint | Current status: green mic (captured) / grey (not captured). CTA: 'Revoke & Delete'. | VoiceprintCubit.initial |
| 2 | Step-up auth prompt | Biometric/2FA required before proceeding. | VoiceprintCubit.authenticating |
| 3 | Confirm revocation modal | 'Revoking your Voiceprint will delete your voice clone from all services. Photoplay voice will be disabled until a new Voiceprint is captured. This cannot be undone.' CTA: Confirm / Cancel. | VoiceprintCubit.revocationRequested |
| 4a | Success | Toast: 'Voiceprint revoked. Voice clone deletion scheduled within 30 days.' Photoplay Studio voice dropdown disabled. | VoiceprintCubit.revocationConfirmed |
| 4b | Failure (after 3 retries) | Banner: 'Revocation pending. Contact support if this persists.' Support ticket auto-created. | VoiceprintCubit.revocationFailed |

**35.2 API & Retry Contract**

POST /v1/voiceprints/{id}/revoke  
  → Backend: DELETE /v1/voices/{voice\_id} (ElevenLabs API)  
  → Response 200: { revocation\_id, scheduled\_deletion\_date (30d from now) }  
  → Response 4xx/5xx: Retry 3× (1s, 5s, 15s) → escalate to manual ticket

Client-side block on failure:  
  \- VoiceprintCubit emits RevocationPending  
  \- Photoplay Studio disables voice dropdown  
  \- Tooltip: 'Voiceprint revocation in progress. Use text or record live.'

Data isolation:  
  \- Voice embedding (256-dim) marked deleted=true in pgvector  
  \- Raw clone ID removed from ElevenLabs within 30-day GDPR purge window  
  \- Audit log retained per legal requirement (SOC 2 immutable)

**36\. Kinnect Kit — Chain of Custody & Raw Deletion**

Commerce section §22.3 defines the fulfillment pipeline at a high level. This section provides the authoritative chain of custody table, raw deletion flow, and PostgreSQL schema for production implementation.

**36.1 Chain of Custody Pipeline**

| Stage | System | Data Captured | SLA | Compliance |
| :---- | :---- | :---- | :---- | :---- |
| Order placed | Stripe \+ kit\_fulfillment PG table | kit\_id, user\_id, shipping\_addr\_hash | Immediate | PCI-DSS (Stripe handles card) |
| Shipped | Carrier API (FedEx/DHL/AusPost by region) | tracking\_number, carrier\_status | 48h dispatch | Data minimization |
| Lab received | Sequencing.com / LabCorp webhook | qr\_scan\_timestamp, lab\_id, temp\_log | 7-day delivery | HIPAA chain of custody |
| DNA processing | Arvados \+ PLINK → dna-ingest-service | fastq\_s3\_key, vcf\_status, haplogroup\_assigned | 14-day processing | FASTQ → S3 Glacier 7-year lock |
| App delivery | dna-ingest-service → cr.recompute Kafka | kc\_score\_update, consent\_bit\_1\_verified | KC recompute within 5min | Consent bit 1 (0x0002) must be set |
| Raw deletion | S3 Object Lock \+ audit | deletion\_request\_id, scheduled\_purge\_date | 30-day SLA | GDPR Art. 17 |

**36.2 PostgreSQL Schema: kit\_chain\_of\_custody**

CREATE TABLE kit\_chain\_of\_custody (  
    kit\_id UUID PRIMARY KEY,  
    user\_id UUID NOT NULL REFERENCES users(user\_id),  
    status VARCHAR(20) CHECK (status IN (  
        'ordered','shipped','received','processing','completed','deleted'  
    )),  
    tracking\_number VARCHAR(50),  
    lab\_receipt\_timestamp TIMESTAMPTZ,  
    fastq\_s3\_key VARCHAR(255),  
    object\_lock\_expiry TIMESTAMPTZ,  
    deletion\_request\_id UUID,  
    audit\_log JSONB  \-- CloudTrail reference  
);

**36.3 Raw Deletion Flow**

| Step | Action | SLA | Failure Handling |
| :---- | :---- | :---- | :---- |
| 1\. User requests | Settings → Genomic Data Controls → Request Raw Deletion. Step-up auth required. | Immediate | Auth failure → retry prompt (3×) |
| 2\. Mark S3 Object Lock | POST /v1/dna/raw/{kit\_id}/delete → sets S3 Object Lock expiration \= 30d | Within 1h | Object lock delay → retry 2× → legal ticket if \>30d |
| 3\. Delete VCF/FASTQ refs | Remove fastq\_s3\_key and vcf refs from pgvector. Mark kit status \= 'deleted'. | Within 24h | Audit log entry regardless of outcome |
| 4\. Confirm to user | 'Raw genomic data purged within 30 days. Processed haplogroup embeddings retained for Kin Score unless DNA kit is also disconnected.' | Same session | N/A |

**37\. Prd Traceability Schema — Implementation & CI Gate**

Addendum 1.0 §7 defines the prd\_traceability database schema. This section provides the implementation script, CI gate, and query interface so engineering teams can actually enforce traceability.

**37.1 CI Gate Script: validate\_prd\_trace.py**

\#\!/usr/bin/env python3  
\# scripts/validate\_prd\_trace.py — CI/CD GATE SCRIPT  
\# Fails CI if required feature coverage \< 95%

import psycopg2, sys, os

def check\_traceability():  
    conn \= psycopg2.connect(os.environ\['TRACE\_DB\_URL'\])  
    cur \= conn.cursor()

    cur.execute('''  
        SELECT COUNT(\*) FROM prd\_feature pf  
        LEFT JOIN prd\_traceability pt ON pf.feature\_id \= pt.feature\_id  
        WHERE pf.status \= 'required'  
        AND (pt.implementation\_status IS NULL  
             OR pt.implementation\_status \!= 'live')  
    ''')  
    missing \= cur.fetchone()\[0\]

    cur.execute("SELECT COUNT(\*) FROM prd\_feature WHERE status \= 'required'")  
    total \= cur.fetchone()\[0\]

    coverage \= (total \- missing) / total \* 100  
    if coverage \< 95.0:  
        print(f'TRACEABILITY FAIL: {coverage:.1f}% ({missing}/{total} missing)')  
        sys.exit(1)  
    print(f'TRACEABILITY PASS: {coverage:.1f}%')  
    sys.exit(0)

if \_\_name\_\_ \== '\_\_main\_\_':  
    check\_traceability()

**37.2 GitHub Actions Gate**

\# .github/workflows/traceability-gate.yml  
name: PRD Traceability Gate  
on: \[pull\_request\]  
jobs:  
  validate:  
    runs-on: ubuntu-latest  
    steps:  
      \- uses: actions/checkout@v4  
      \- name: Run traceability check  
        run: python scripts/validate\_prd\_trace.py  
        env:  
          TRACE\_DB\_URL: ${{ secrets.TRACE\_DB\_URL }}

**37.3 Icon-to-Feature Mapping — Complete Reference**

Addendum 1.0 §8 mandated phosphor\_flutter but did not enumerate all icon mappings. The following table is the authoritative reference. All icons must be sourced from this table — unmapped icons fail CI lint.

| KinnectAI Feature | PhosphorIcons Reference | Weight | Size |
| :---- | :---- | :---- | :---- |
| Home (The Line) | PhosphorIcons.house | regular | 24×24 |
| Repost / Stitch tab | PhosphorIcons.arrowCounterClockwise | regular | 24×24 |
| Create (+) | PhosphorIcons.plus | bold | 24×24 |
| Tree | PhosphorIcons.treeStructure | regular | 24×24 |
| Root (Profile) | PhosphorIcons.user | regular | 24×24 |
| Pulse (reaction) | PhosphorIcons.heart | regular | 24×24 |
| Comment | PhosphorIcons.chatCircleText | regular | 24×24 |
| Rewind (reply video) | PhosphorIcons.arrowUDownLeft | regular | 24×24 |
| Favorite / Strand | PhosphorIcons.star | regular | 24×24 |
| Share (Ripple) | PhosphorIcons.shareNetwork | regular | 24×24 |
| Branch | PhosphorIcons.usersThree | regular | 24×24 |
| Notifications / Bell | PhosphorIcons.bell | regular | 24×24 |
| Marketplace / Store | PhosphorIcons.storefront | regular | 24×24 |
| Photoplay | PhosphorIcons.flower | regular | 24×24 |
| Memory Box | PhosphorIcons.lock | regular | 24×24 |
| Voiceprint | PhosphorIcons.microphone | regular | 24×24 |
| Restore tool | PhosphorIcons.magicWand | regular | 24×24 |
| Flickers | PhosphorIcons.filmStrip | regular | 24×24 |
| Family Crest | PhosphorIcons.shield | regular | 24×24 |
| Discovery / Discover | PhosphorIcons.magnifyingGlass | regular | 24×24 |
| Settings gear | PhosphorIcons.gear | regular | 24×24 |
| Steward | PhosphorIcons.userCheck | regular | 24×24 |
| Rooms | PhosphorIcons.videoCamera | regular | 24×24 |
| Gathering / Event | PhosphorIcons.calendarBlank | regular | 24×24 |
| DNA / Bioidentity | PhosphorIcons.dna | regular | 24×24 |
| Echoes | PhosphorIcons.clockCounterClockwise | regular | 24×24 |
| Kinship Alert | PhosphorIcons.mapPin | regular | 24×24 |
| Name Map | PhosphorIcons.globe | regular | 24×24 |
| Lost Branches | PhosphorIcons.gitBranch | regular | 24×24 |
| Heartbeat / Digest | PhosphorIcons.heartbeat | regular | 24×24 |
| E2EE / Encrypted | PhosphorIcons.lockSimple | regular | 16×16 |
| C2PA verified badge | PhosphorIcons.sealCheck | regular | 16×16 |
| Rippling badge | PhosphorIcons.flame | bold | 16×16 |
| AI-Generated badge | PhosphorIcons.robot | regular | 16×16 |
| Haplogroup / DNA verified | PhosphorIcons.sparkle | regular | 16×16 |
| Recording active | PhosphorIcons.recordFill | regular | 24×24 |
| Messages / DM | PhosphorIcons.chatTeardropText | regular | 24×24 |

**38\. Discovery Cadence — Resolved Conflict**

PRD v1.0 §07 describes an hourly Discovery service. Addendum 3.0 §2 specifies a weekly cap of 10 cards. This section resolves the conflict and defines the authoritative cadence.

| Mechanism | Cadence | Client Behavior | SRS Reference |
| :---- | :---- | :---- | :---- |
| discovery-service candidate generation | Hourly (background) | Client does not poll directly. Candidates stored in Redis sorted set. | SRS §1.2 discovery-service port 8091 |
| Client-visible card pool | Refreshes Sunday 06:00 local device time | GET /v1/discovery/weekly returns max 10 cards. New batch unlocks weekly. | Addendum 3.0 §2 |
| Dismiss penalty | Immediate on swipe left | score × 0.30, card hidden 30 days, undo 5s | POST /v1/discovery/dismiss (SRS §22.2) |
| Lost Branches (Sidebar) | Pulls from same weekly pool | Filtered to DNA Match signal type by default. Same 10-card weekly cap. | PRD §14 Sidebar |
| Heartbeat daily digest | Generated 02:00 UTC, injected 06:00 local | Includes new Discovery matches as 'Lost Branches match' notification if new candidates exist. | SRS §4.2 Kernel Fallback |
| Anti-feedback cap | Per 30-day rolling window | Discovery exposure raises behavioral weight ≤5%. Enforced by Kafka stream validator. | SRS §4.2 Engineering Safeguards |

**39\. Consent Flags — Complete PRD Surface Map (Authoritative)**

Appendix J of the SRS defines the consent\_flags bitmask in full. This section maps each bit to the exact PRD screen moment, user-facing copy, and revocation impact for product and QA teams.

| Bit | Hex | PRD Consent Moment | Consent Copy (Abbreviated) | Revocation Impact |
| :---- | :---- | :---- | :---- | :---- |
| 0 | 0x0001 | Onboarding Step 1: Whitepages/LexisNexis identity enrichment | Allow KinnectAI to enrich your profile with public identity records to improve Kin matching. | Disables Whitepages/LexisNexis enrichment. Layer 1 confidence drops to 0\. |
| 1 | 0x0002 | Onboarding Step 2: DNA kit / 23andMe / VCF upload | Allow KinnectAI to process your DNA data to discover biological Kin connections. | Blocks Sequencing.com OAuth. Removes Layer 2 from KC. Raw data not deleted unless also requested. |
| 2 | 0x0004 | Tree: Branch sharing / Branch membership visibility | Allow your family Tree to be shared with Branch members for collective mapping. | Hides Tree from Discovery. Disables Branch Merge participation. |
| 3 | 0x0008 | In-app: The Line interaction tracking (ATT) | Allow KinnectAI to use your in-app activity to personalise The Line and improve Kin discovery. | Ignores Pixel/SDK events. Layer 4 uses in-app signals only. Reduces Discovery precision. |
| 4 | 0x0010 | Memory Box Milestone trigger: Life-stage signal processing | Allow KinnectAI to detect life events (graduation, marriage, new child) to deliver Milestone Memories automatically. | Excludes NielsenIQ/Factus signals. Milestone triggers require manual confirmation. |
| 5 | 0x0020 | Photoplay Studio Step 1: Facial embedding capture (BIPA) | Allow KinnectAI to analyse facial features in this photo to create your Photoplay. (On-device only. No cloud storage of raw image.) | Blocks DeepFace cloud processing. On-device TFLite preview only. Existing Photoplays unaffected. |
| 6 | 0x0040 | Voiceprint capture: Voice clone (BIPA/Texas) | Allow KinnectAI to create a voice model from this recording for use in Photoplays and Flickers. Your voice data is encrypted and only used with your permission. | Triggers ElevenLabs DELETE. Blocks Photoplay voice dropdown until revocation confirmed. 30-day GDPR purge. |
| 7 | 0x0080 | Settings → Off-Platform Data / iOS ATT prompt (post Onboarding Step 4\) | Allow KinnectAI to use your activity across other apps and websites to help discover family connections. (Apple-approved copy.) | behavioral-service ignores Pixel/SDK events. att\_status=denied. KC continues on in-app signals. |
| 8 | 0x0100 | Settings → Privacy → Third-party sharing opt-out | Allow KinnectAI to share anonymised insights with data partners (NielsenIQ, Factus) to support the service. | Blocks NielsenIQ/Factus data export. Does not affect Sequencing.com or Kinnect Kit. |
| 9 | 0x0200 | Memory Box Steward Designation (Unspoken/Posthumous trigger) | Designate a Steward to confirm your death and authorise delivery of your sealed Memories. | Vaults remain sealed until manual court order. Fallback chain: Backup Stewards → Legal DPO → Court → 365d auto-release. |
| 10 | 0x0400 | Family Pairing: Guardian consent for minor account (COPPA) | I confirm I am the parent or legal guardian of this account and consent to their participation in KinnectAI with the following restrictions. | Required for all \<13 accounts. No DNA, no voiceprint, no public profile, no off-platform tracking without this bit. |
| 11 | 0x0800 | Settings → Privacy → Research / model training opt-in | Allow KinnectAI to use your anonymised data to improve Kin discovery for everyone. No PII or genomic data shared. | Excludes user from GNN training pool. Anonymised behavioral aggregates excluded from Databricks feature snapshots. |
| 12 | 0x1000 | Settings → Content Permissions → Sunday Stitch auto-publish | Allow your Memory clips to be included in automated Sunday Stitches shared within your Branch. You can change this anytime. | Future Stitches exclude clip. Existing Stitches remain published (GDPR Art. 7(3) — irrevocable once published). |

**40\. Sunday Stitch — Selection Criteria & Auto-Publish Rules**

Addendum 3.0 §10 defines the Sunday Stitch cadence but does not specify clip selection criteria, ranking logic, or auto-publish rules. This section resolves those gaps.

**40.1 Clip Selection Criteria**

| Criterion | Rule | Weight |
| :---- | :---- | :---- |
| Stitch consent flag | consent\_flags & 0x1000 must be set. Clips without bit 12 are ineligible regardless of score. | Gate (must pass) |
| CR × Pulse score | clip\_score \= CR\_of\_creator × pulse\_count. Top 5 clips by this score selected. | Primary ranking |
| Recency | Clips older than 90 days down-weighted by 50%. | Modifier |
| Diversity | Max 2 clips per creator per Stitch to ensure Branch breadth. | Cap |
| Content moderation | Clips with any active P0/P1 moderation flag excluded automatically. | Gate (must pass) |

**40.2 Auto-Publish Timing & User Notifications**

| Event | Timing | User Notification | User Action Available |
| :---- | :---- | :---- | :---- |
| Clip selected for Sunday Stitch | Friday 18:00 UTC | Push: 'Your Memory has been selected for this Sunday's Branch Stitch. Tap to preview or opt out.' | Opt out (removes clip, next-ranked clip substituted) |
| Stitch auto-publishes | Sunday 09:00 local Branch time | Push to all contributing Kin: '{Branch Name} Sunday Stitch is live.' | None — irrevocable once published |
| User opts out before publish | Before Sunday 09:00 | Confirmation: 'Your clip won't be included in this Stitch.' | N/A |
| User ignores selection notice | After 14 days of no action | Auto-include with no further notification. | N/A — inaction \= consent per bit 12 |

**41\. Offline Mode — Complete Sync & Conflict Resolution Strategy**

Addendum 2.0 §5 defines offline mode at a high level. This section provides the complete conflict resolution rules, mutation queue schema, and reconciliation logic required for production implementation.

**41.1 Local Storage Architecture**

| Component | Library | Purpose | Sync Strategy |
| :---- | :---- | :---- | :---- |
| Local DB | drift v2.13+ | Store Memories, Tree nodes, Kinnections offline | Bi-directional sync via workmanager on connectivity restore |
| Cache | hive v2.2+ | Session data, feed cache, BLoC state, rate-limit state | TTL-based eviction: 5 min active, 1h inactive |
| Mutation Queue | workmanager v0.5+ | Queue offline actions: Pulse, Memory creation, Kinnect request | FIFO. Exponential backoff retry (1s, 5s, 15s). DLQ after 3 failures. |
| Asset Cache | flutter\_cache\_manager | Pre-cache Photoplay thumbnails, profile photos, Branch map tiles | LRU cache, 100MB max, 7-day TTL |

**41.2 Conflict Resolution Rules**

| Data Domain | Conflict Strategy | Rationale |
| :---- | :---- | :---- |
| Feed / Memories | Server-wins. Stale local cache shown with 'Offline — cached' banner. | CR scores and content visibility are server-authoritative. |
| Kinnection graph | Server-wins. Pending local Kinnect requests shown with 'Pending sync' badge. | Graph integrity requires server consensus. |
| Memory Box drafts | Local-wins. Draft content preserved on server sync. User prompted to review if server version differs. | Unsealed drafts are creator-owned until sealed. |
| Photoplay Credits balance | Optimistic local decrement. Reconcile on sync. If mismatch: server value wins, toast: 'Credit balance updated.' | Prevents double-spend on reconnect. |
| Consent flags | Server-wins always. Local consent state is a read-only cache. Never modify consent\_flags offline. | Compliance requirement. Consent changes must produce server-side audit entries. |
| Behavioral events (Pulses, views) | Local queue → batch upload on reconnect. No conflict possible — append-only. | Cassandra table is append-only. No merge needed. |

**41.3 Mutation Queue Schema (drift)**

CREATE TABLE mutation\_queue (  
    id INTEGER PRIMARY KEY AUTOINCREMENT,  
    action\_type TEXT NOT NULL,  \-- 'pulse', 'kinnect\_request', 'memory\_create', 'dismiss'  
    payload TEXT NOT NULL,      \-- JSON-encoded action payload  
    created\_at INTEGER NOT NULL, \-- Unix timestamp  
    retry\_count INTEGER DEFAULT 0,  
    status TEXT DEFAULT 'pending', \-- 'pending', 'failed', 'synced'  
    error\_message TEXT  
);

\-- DLQ: After 3 retries, status \= 'failed'  
\-- User notified: 'Action pending. Tap to retry.'  
\-- Tap → moves back to pending, retry counter reset

**42\. Compliance Checklist — Pre-Release Gate**

This checklist must be completed and signed off by Engineering Lead, Legal/DPO, and QA Lead before any release to production. It consolidates all compliance requirements across the SRS, PRD, and all addenda.

| \# | Requirement | Owner | Sign-off Required | Reference |
| :---- | :---- | :---- | :---- | :---- |
| 1 | BIPA consent logs verified for facial and voice biometric capture (bits 5 and 6\) | Legal/DPO | DPO | Appendix J, SRS §12.1 |
| 2 | GDPR DPA mappings complete for all T1–T5 data tiers | Legal/DPO | DPO | SRS §5.1 |
| 3 | COPPA guardian verification proofs tested with synthetic minor accounts | QA Lead | QA \+ Legal | SRS §12.1, PRD §12.4 |
| 4 | Shamir share distribution logs verified (3/5 threshold test) | Engineering Lead | Engineering \+ Legal | SRS §5.3, Appendix F |
| 5 | iOS ATT prompt approved copy implemented verbatim | Engineering Lead | Legal \+ App Store Review | SRS §12.2, Appendix M |
| 6 | AADR attribution badge present on all historical match surfaces | Engineering Lead | Legal | SRS §8.2, Legal Appendix |
| 7 | WikiTree CC BY 4.0 attribution appended to all gold-ring node tooltips | Engineering Lead | Legal | Addendum 3.0 §10 |
| 8 | GDPR Art. 15 export tested: all stores (PG, Neo4j, Cassandra, S3, audit) included within 24h SLA | QA Lead | QA \+ DPO | SRS §11.2 |
| 9 | GDPR Art. 22 explainability modal tested: GET /v1/kc/explain/{pair\_id} returns top-3 features | QA Lead | QA | SRS §4.2 |
| 10 | GDPR Art. 17 raw genomic deletion tested: S3 Object Lock \+ pgvector purge within 30d SLA | QA Lead | QA \+ DPO | SRS §5.4, PRD §12.8 |
| 11 | Memory Box ZK encryption cycle test passed (DEK wrap/unwrap, no plaintext in server logs) | Engineering Lead | Engineering \+ DPO | SRS §5.2, Appendix E |
| 12 | Death verification state machine tested with synthetic SSDI/obituary signals | QA Lead | QA \+ Legal | SRS §4.3, Appendix H |
| 13 | Steward consent flow complete: both-party biometric confirmation, immutable audit log | QA Lead | QA \+ Legal | SRS §4.4, PRD §17.3, §31 |
| 14 | SVG XSS sanitization verified on Family Crest output (no script/event handlers) | Engineering Lead | Engineering \+ Security | SRS §7.3 |
| 15 | C2PA manifest embedded and verified in all AI-generated Photoplay, Flickers, Family Crest outputs | QA Lead | QA | SRS §7.2, Appendix N |
| 16 | Brand lexicon CI gate active: no forbidden terms in lib/ui/ | Engineering Lead | Engineering | SRS §18.1, PRD §13 |
| 17 | Error coverage gate active: all 48 screens have ≥3 error states in error\_registry.yaml | Engineering Lead | Engineering \+ QA | §30, Addendum 2.0 §6 |
| 18 | PRD traceability coverage ≥95% (validate\_prd\_trace.py passing) | Engineering Lead | Engineering | §37, Addendum 1.0 §7 |
| 19 | Voiceprint revocation lag \<30 days: ElevenLabs DELETE confirmed in test environment | Engineering Lead | Engineering \+ Legal | §35 |
| 20 | Room recording consent: majority opt-out auto-abort tested. Storage routing verified. | QA Lead | QA \+ Legal | §34 |
| 21 | Consent revocation → JWT invalidation latency \<2ms via Redis cluster (tested) | Engineering Lead | Engineering | Appendix D, SRS §3.2 |
| 22 | SAST/DAST clean: 0 High/Critical CVEs. Dependency scan passed. | Security Lead | Security | SRS §10.2 |
| 23 | Canary deployment gates passing: error rate \<0.1%, KC score distribution within ±0.02 baseline | Engineering Lead | Engineering | SRS §10.2 |
| 24 | Rollback procedure tested: kubectl rollout undo \+ Flyway undo \+ feature flag disable (\<5 min) | Engineering Lead | Engineering | SRS §10.3 |

**43\. Algorithmic Core & Feed Assembly**

**ContentTypeBoost Clamp Bounds Conflict**

| ContentTypeBoost \= clamp(0.8, 1.3, 1.0 \+ Σ(topic\_pref\_i × engagement\_velocity\_i)) Where Σ \= 0 (no behavioral signal or new user):   ContentTypeBoost \= clamp(0.8, 1.3, 1.0) \= 1.0   // neutral multiplier Where user has zero consent flags (consent\_flags \= 0x00):   All topic\_pref\_i \= 0.0 → ContentTypeBoost \= 1.0  // no boost, no penalty ContentTypeBoost NEVER overrides CR ordering. It adjusts rank within the same CR decile band only. |
| :---- |

| ℹ  NOTE: The client receives a pre-ranked feed from feed-service. ContentTypeBoost is applied server-side before Redis ZADD insertion. The mobile layer consumes the sorted set as-is. |
| :---- |

**Feed Tab Filter Behavior on Tab Switch**

| Tab | On Activate | Scroll Position | Cache Behavior | BLoC Event |
| :---- | :---- | :---- | :---- | :---- |
| Echoes | Inject date-matched memories at top of existing feed. Do not re-fetch full feed. | Reset to top | Read from existing LineCubit.state.feed. Elevate echo items. | TabChanged(tab: echoes) |
| Kinnections | Filter LineCubit.state.feed to confirmed Kinnections only. Remove Discovery cards. | Reset to top | No network call. Client-side filter on crScore \> 0 AND status \== confirmed. | TabChanged(tab: kinnections) |
| Discover | Navigate to DiscoveryScreen. Separate BLoC scope (DiscoveryBloc). | Independent scroll | Separate Redis pool. GET /v1/discovery/weekly. | Navigation — not a tab filter |
| Home (default) | Show full CR-sorted feed including Discovery injection at 1:7 ratio. | Preserved on return | Redis ZADD feed:{user\_id} TTL 300s. | TabChanged(tab: home) |

**Ripple Propagation Cap & Branch Boundary**

* Ripple visibility boost: 2× within the creator's primary Branch only. Does NOT propagate to sibling Branches.

* Cross-Branch propagation: Only if the viewer's CR to the creator is ≥0.10 (approximately 4th cousin or closer). No Ripple badge shown to viewers below this threshold.

* Ripple cap: A single Memory may only Ripple once per 24-hour window. Subsequent threshold crossings within the same window are no-ops.

* Notification cap: One 'Rippling' push notification per user per Memory per day. Batched into Heartbeat if the user's notification frequency preference is set to 'digest'.

* Amber badge: Rendered only when content.ripple\_active \== true AND viewer.cr\_to\_creator \>= 0.10. Evaluated client-side from MemoryDTO fields.

**Heartbeat Card Injection Logic & Deduplication**

* Injection time: Server generates at 02:00 UTC. Client injects at 06:00 local device time via WorkManager scheduled task.

* Position: Always index 0 in the feed. Never displaced by CR-sorting. Stickied for the first 4 hours after injection (06:00–10:00 local).

* Read state: Marked read when the user scrolls past or taps the card. Stored in Hive as heartbeat\_read\_{date}. Once read, not re-injected on pull-to-refresh.

* Deduplication: One Heartbeat card per calendar day per user. If the app is opened multiple times, the same card is shown until read or until 23:59 local time.

* Empty state: If the Heartbeat has zero overnight events (zero new Kinnections, zero new Photoplays, zero Markers), the card is suppressed entirely for that day.

* Tab switch: Heartbeat card is only shown on the default Home tab. Echoes and Kinnections tabs suppress it.

 **Pull-to-Refresh Behavioral Weight Isolation**

| Signal Category | Reset on Pull-to-Refresh? | Reset on 'Refresh Your Line'? | Never Reset |
| :---- | :---- | :---- | :---- |
| ContentTypeBoost (topic\_pref × engagement\_velocity) | No | Yes — zeroes all topic\_pref\_i vectors | — |
| Temporal Recency Decay (e^−λΔt) | No — decay is time-based, not action-based | No | — |
| KC / CR Scores (PLINK PI\_HAT, Neo4j path) | No | No | Never reset by any UI action |
| Kinnection status (confirmed / pending) | No | No | Never reset by any UI action |
| Discovery penalty (×0.30 after dismiss) | No | No | Expires after 30 days only |
| Feed cursor position | Yes — resets to top of sorted set | Yes | — |
| Redis feed cache | No — reads from existing cache. Re-fetches only on cache miss or TTL expiry. | No | — |

**44 Discovery Engine & Graph Path View (GAP-06 – GAP-10)**

**Discovery Card Weekly Pool Refresh Timezone Handling**

* Server-side: discovery-service runs hourly candidate generation continuously. The 'weekly pool' is a Redis sorted set keyed discovery:weekly:{user\_id} that is refreshed every Sunday at 02:00 UTC.

* Client-side: The app evaluates the pool availability check at first-open each day. If the server returns a new pool (version\_token mismatch in response header), the client replaces the local cache regardless of local time.

* Timezone crossing: The client uses the device locale for display only. The server determines freshness via the pool\_generated\_at timestamp in the GET /v1/discovery/weekly response. If pool\_generated\_at is within the last 7 days, the pool is current.

* UTC+ edge case: Users in UTC+12 will receive Sunday's pool on their Saturday evening. This is acceptable and by design — the biological relevance of the pool is not time-sensitive to within hours.

* Maximum pool age: The client must not display a pool older than 8 days. If GET /v1/discovery/weekly returns pool\_age\_days \> 8, render empty state with 'Scanning biological graph…' and retry after 1 hour.

**Graph Path View: Confidence Calculation for Multi-Hop Paths**

| Per-segment confidence:   segment\_confidence \= 1.0 \- (uncertainty\_factor / edge\_confidence)   Where:     edge\_confidence   \= Neo4j relationship property confidence\_score (0.0-1.0)     uncertainty\_factor \= 1.0 \- edge\_confidence  // complement of edge certainty   Simplified: segment\_confidence \= edge\_confidence^2   (This is the canonical form. Use edge\_confidence^2 in all implementations.) Overall path confidence:   path\_confidence \= Π(segment\_confidence\_i) for all i in path Minimum display threshold: path\_confidence \>= 0.05 (5%)   Below 5%: Show 'Connection path uncertain' label. CTA changes to 'Explore Anyway'. Zero DNA edges (identity-only path):   All edges use grey dashed rendering regardless of confidence.   path\_confidence label: 'Identity-inferred only. No DNA confirmation.'   Kinnect CTA: Still enabled. Sends request with relationship\_type: 'identity\_inferred'. |
| :---- |

**GEDCOM Import Conflict Resolution UI**

* Trigger: After GEDCOM file is parsed and uploaded, dna-ingest-service returns a conflict\_review\_required: true flag with an array of conflicting node pairs.

* Screen: GEDCOMConflictReviewScreen pushed modally after upload completes. Route: kinnect://tree/gedcom/conflicts/{import\_id}.

* Layout per conflict: Two-column card. Left: existing node (name, birth year, geo, data\_source). Right: incoming node (same fields). Confidence % shown between columns.

* Actions: 'Merge' (auto-applies the merge, highest-confidence properties win) / 'Keep Both' (creates new node with relationship inferred) / 'Skip' (defers to next session, stored in gedcom\_deferred table).

* Batch action: 'Merge All Suggested' button applies Merge to all conflicts above 0.75 confidence in one tap. Confirmation modal required.

* Deferred conflicts: Surfaced in Tree Actions Bar as a badge count. Route: kinnect://tree/gedcom/deferred.

* SLA: Conflicts older than 90 days with no user action are auto-resolved to 'Keep Both' and the user is notified via Heartbeat.

**Kinnection Request Relationship Type Selector**

| Relationship Type | Display Label | When Pre-Selected | Stored Value |
| :---- | :---- | :---- | :---- |
| parent\_child | Parent / Child | Neo4j path shows IS\_PARENT\_OF edge with confidence ≥0.80 | parent\_child |
| grandparent\_grandchild | Grandparent / Grandchild | Neo4j path length \= 2 via IS\_PARENT\_OF | grandparent\_grandchild |
| sibling | Sibling | SIBLING\_OF edge exists with confidence ≥0.70 | sibling |
| first\_cousin | 1st Cousin | Tree path \= 2 generations up, 2 down | first\_cousin |
| second\_cousin | 2nd Cousin | Tree path \= 3 generations up, 3 down | second\_cousin |
| distant\_relative | Distant Relative | Default — any path not matching above | distant\_relative |
| unknown | I'm Not Sure | Selected by user manually | unknown |

* If the user submits without selecting: relationship\_type defaults to unknown. This does not block the request.

* The selector is a bottom sheet with a single-select radio list. Dismiss on selection or tap outside. 'Send Kinnection Request' CTA at the bottom is always enabled.

**Lost Branches vs. Discovery Deduplication**

* The weekly discovery pool is a single source of truth. Lost Branches is a filtered view of the same pool.

* Deduplication rule: If a candidate appears in both the Discover tab and Lost Branches, the Discover tab is the canonical interaction surface. Tapping the Lost Branches entry routes to the same DiscoveryCardScreen as the Discover tab.

* Dismiss parity: Dismissing from either surface applies the same ×0.30 penalty and 30-day suppression. The suppression flag is keyed on candidate\_id, not surface.

* Badge count in Sidebar: Shows count of Lost Branches candidates not yet seen on the Discover tab. Seeing a card on Discover (scroll-past \= seen) removes it from the Lost Branches badge count.

* Kinnect from Lost Branches: Routes through the same POST /v1/kinnections endpoint. No behavioral difference from Kinnecting on the Discover tab.

**45 Memory Box & Vault (GAP-11 – GAP-15)**

**Memory Box Draft Auto-Save Contrac** 

* Auto-save trigger: Debounced 3 seconds after any field change. Fires immediately on app backgrounding or navigation away.

* Storage: Drift local database table memory\_box\_drafts. Columns: draft\_id (UUID), user\_id, recipient\_id (nullable), trigger\_type (nullable), trigger\_value (JSON, nullable), media\_s3\_temp\_key (nullable), caption (nullable), updated\_at (TIMESTAMPTZ).

* Media handling: If the user recorded/uploaded video before exiting, the raw (unencrypted) media is stored at a temporary S3 key prefixed membox/drafts/{user\_id}/{draft\_id}. This key is distinct from the sealed membox/enc/ prefix. Temporary drafts expire after 30 days via S3 lifecycle policy.

* Maximum drafts: 10 per user. If the user has 10 drafts, attempting to create an 11th shows a modal: 'You have 10 unsent Memories. Seal or delete one before creating a new one.'

* Conflict resolution: If the user opens the composer with an existing draft for the same recipient and trigger type, the existing draft is loaded with a banner: 'You have an unsent Memory for this person. Continue where you left off?'

* Draft badge: Shown in the Vault List screen as a yellow 'Draft' status pill. Draft count shown on the Memory Box icon in the creation bottom sheet.

**Geofence Trigger: Background Location Architecture**

| Platform | API | Max Regions | Battery Model | Accuracy |
| :---- | :---- | :---- | :---- | :---- |
| iOS | CLLocationManager.startMonitoring(for: CLCircularRegion) | 20 system limit | \<1%/day (OS-managed) | \~100m typical. Minimum radius enforced: 100m. |
| Android | GeofencingClient (Google Play Services) | 100 system limit | \<1%/day (batched) | \~150m typical. Minimum radius enforced: 150m on Android. |
| Foreground fallback (permission denied) | CLLocationManager.requestLocation() on app open | N/A | Minimal — only fires on app open | Varies. User shown: 'Location permission required for Kinship Alerts.' |

* 20-region limit on iOS: When the user has 20 active geofence triggers and attempts to add a 21st, show a modal: 'You have reached the maximum of 20 active Kinship Alert locations. Remove one to add a new one.' Link to Memory Box Settings → Kinship Alert radius management.

* Trigger accuracy: A geofence trigger fires when the OS delivers a region entry event. No additional proximity check is performed client-side. The minimum radius is 100m (iOS) / 150m (Android) — enforced in the radius slider UI.

* Privacy: Location data is never transmitted to the KinnectAI server for geofence evaluation. All geofence monitoring is OS-level. Only the trigger event (not coordinates) is sent to memorybox-service to initiate delivery.

**Memory Box Export: Decryption Key Delivery**

* Export initiation: POST /v1/user/{id}/export?include\_vault=true. Requires step-up authentication (biometric or TOTP).

* Content archive: ZIP file containing encrypted Memory content references (S3 keys, not actual content), all vault metadata, trigger configurations, and audit logs. Delivered via presigned S3 URL (24-hour expiry).

* Decryption key delivery: A separate encrypted key package is emailed to the user's verified primary email address. The package contains the user's wrapped DEKs for all vault memories, formatted as a JSON file with structure: {memory\_id, dek\_key\_id, encrypted\_dek\_b64, kms\_key\_arn}.

* Key package format: AES-256-GCM encrypted with a password the user sets at export initiation time. Password is never transmitted to KinnectAI servers. The user must enter the password to decrypt the key package locally.

* Unverified email: If the user's email is unverified, the export CTA is disabled. Banner: 'Verify your email address to enable Memory Box export.' Routes to Settings → Account → Verification.

* Key package expiry: The key package email link expires after 7 days. After expiry, the user must initiate a new export. The content archive link (24h) and key package link (7d) have independent expiry timers.

**Memory Box Revoke Trigger Behavior Post-Seal**

* Revocation requires step-up authentication (biometric or TOTP). Same X-Stepup-Reason: vault\_write header as sealing.

* API: DELETE /v1/memorybox/{memory\_id}/trigger. Server sets vault\_memories.status \= revoked, vault\_memories.delivered\_at \= NULL. Trigger entry deleted from vault\_triggers table.

* Recipient notification: If the recipient was previously notified of a pending delivery (status was triggered), they receive a push: 'A Memory intended for you has been recalled by the sender.' No content is revealed. No reason is given.

* Steward notification: If the memory had a Steward assigned, the Steward receives a push: 'A Memory you were stewarding has been recalled.' The Steward's designation is also revoked automatically.

* Creator-side: Memory remains in the Vault List with status badge: 'Revoked'. The creator can view metadata but cannot preview content. A 'Delete Memory' option appears (requires step-up). Deletion is permanent and cascades to S3 via a background Lambda within 24 hours.

* Cannot re-seal: Once revoked, a memory cannot be re-triggered. The creator must create a new Memory Box entry. This is enforced at the API layer (409 Conflict if POST /v1/memorybox/{memory\_id}/trigger is called on a revoked memory).

**Milestone Trigger: Life Event Signal Latency**

* Signal ingestion latency: NielsenIQ transaction panel signals arrive via Kafka behavioral.events with a typical latency of 24–72 hours from the real-world transaction. Amazon SP-API opt-in signals have a latency of 48–96 hours.

* Trigger evaluation: behavioral-service evaluates incoming signals against active vault\_triggers where trigger\_type \= milestone. Evaluation runs every 6 hours via a scheduled cron on the behavioral-service.

* Consent gate: If the signal arrives but the user's consent\_flags & 0x0010 \== 0 (Layer 5 transaction consent not set), the signal is discarded. The trigger remains in PENDING state. A push notification is sent: 'A Milestone Memory for \[recipient\] may be ready to deliver. Confirm manually in Memory Box.'

* Manual confirmation flow: The user taps the notification, is taken to the Memory Box Detail screen, and sees a 'Confirm Milestone' button. Tapping initiates delivery with manual\_confirmation: true logged to the audit trail.

* Confidence threshold: A life event signal must appear from at least two independent signal sources (e.g., NielsenIQ \+ a public social announcement, or SP-API \+ identity record update) to trigger automatically. Single-source signals always require manual confirmation.

* 90-day fallback: If no signal is detected within 90 days of the milestone trigger being created, a push is sent to the creator: 'No Milestone signal detected for your Memory. Confirm delivery manually or update the trigger.' PRD v1.0 §17.1 confirmed this behavior.

**46\. Rooms, Gatherings & Live Broadcast (GAP-16 – GAP-20)**

**Room KC Gate: Minimum Score for Join**

| Room Privacy Mode | Minimum KC to Join | Who Sets It | Gate Failure UX |
| :---- | :---- | :---- | :---- |
| private | No KC gate. Explicit invite list only. | Originator | 'You were not invited to this Room.' Dismiss button. |
| kc\_gated | Configurable by Originator: 5% / 10% / 25% / 50%. Default: 10%. | Originator at room creation | 'Your connection to this family is below the required threshold.' Shows user's actual KC to host. 'Request Invite' CTA sends push to Originator. |
| branch | Must be a confirmed member of the Branch associated with the Room. | Auto-enforced by Branch membership | 'You must join the \[Branch Name\] Branch to attend this Room.' CTA: 'Request Branch Access'. |

* Originator always has access regardless of KC score.

* Co-host promoted during failover inherits the Originator's access privileges. KC gate is not re-evaluated on co-host promotion.

**Gathering RSVP State Machine**

| Gathering RSVP States:   INVITED → ACCEPTED | DECLINED | NO\_RESPONSE (after 24h reminder, auto-NO\_RESPONSE at event start)   ACCEPTED → ATTENDED (on join) | NO\_SHOW (15min post-start, not joined)   WAITLISTED → ACCEPTED (if capacity opens) | EXPIRED (event starts) Capacity:   Default: 50 participants (mediasoup SFU limit per room)   Originator can set lower cap at Gathering creation (minimum: 2\)   At capacity: New RSVPs enter WAITLISTED state. Waitlist shown to Originator. Reminders:   \- 24h before: Push \+ in-app to all INVITED (not yet responded)   \- 1h before: Push to ACCEPTED   \- 15min before: Push to ACCEPTED with 'Join Now' deep link RSVP API: POST /v1/rooms/{room\_id}/rsvp { status: 'accepted' | 'declined' } Capacity check: GET /v1/rooms/{room\_id} returns { capacity, rsvp\_count, waitlist\_count } |
| :---- |

**Live Broadcast: HLS Viewer Count & Top-500 KC Selection**

* Top-500 list computation: At the moment the Originator taps 'Go Live', rooms-service requests the user's confirmed Kinnections from kin-graph-service, sorted by kc\_score DESC, LIMIT 500\.

* Fewer than 500 Kinnections: All confirmed Kinnections receive the Live notification. No synthetic padding.

* List is not refreshed mid-broadcast: The top-500 list is computed once at broadcast start and cached in Redis (room:{room\_id}:live\_notify\_list). New Kinnections confirmed during the broadcast do not receive the Live notification.

* Viewer count: rooms-service maintains a Redis counter room:{room\_id}:viewer\_count (INCR on HLS stream segment request, DECR on 30s inactivity timeout). Displayed to Originator only. Viewers do not see each other's count.

* Public discoverability: Live broadcasts are NOT publicly discoverable. Only the top-500 KC list can see the Live card in The Line. The HLS stream URL is signed (CloudFront signed URL, 4h TTL) and not shared outside the KC gate.

**Room Recording: Post-Session Storage Choice Timeout**

* Timer start: The 10-minute countdown begins immediately when the session ends (either Originator taps 'End' or the 5-minute co-host-absent countdown completes).

* UI: A persistent bottom sheet appears over the Root screen showing three options and a countdown timer: 'Recording will be discarded in 9:47'. Timer is visible and ticking.

* If app is backgrounded during window: A push notification fires immediately: 'Your Room recording is pending. Open KinnectAI to save or discard it. It will be automatically deleted in X minutes.' Push fires once only.

* At timeout: Secure delete. S3 object deletion request fired. Redis recording metadata TTL set to 0\. No recovery possible after this point. A final push fires: 'Your Room recording from \[time\] was automatically discarded.'

* Seal to Memory Box: Opens a pre-populated Memory Box Composer with the recording loaded, step-up auth immediately required. The recording is held in a temporary S3 key (membox/room-recordings/{room\_id}) for up to 1 hour while the composer is open.

* Publish to Line: Triggers media-service transcoding pipeline. memory\_type \= 'room\_recording'. Routing through media.transcode Kafka topic. C2PA manifest is NOT required for room recordings (not AI-generated). is\_ai\_generated \= false.

**WebRTC TURN Credential Rotation During Active Session**

* TURN credential TTL: 3600 seconds (1 hour). Credentials are time-limited HMAC-SHA1 tokens generated by Coturn per RFC 5766 §4.2.

* Pre-rotation: rooms-service sends new TURN credentials to the client via the rooms.signaling Kafka event (event\_type: TURN\_REFRESH) at T-300s (5 minutes before expiry).

* Client handling: On receiving TURN\_REFRESH, the WebRTC peer connection is updated with the new ICE server credentials via RTCPeerConnection.setConfiguration(). No renegotiation or media interruption occurs.

* Session \> 1 hour: Credentials are refreshed automatically every 55 minutes for sessions exceeding 1 hour. The client subscribes to the rooms.signaling WebSocket stream for the duration of the session.

* Credential failure: If the TURN refresh fails (network error, Coturn unreachable), the existing credentials remain valid until their original TTL. The client retries the credential fetch every 30 seconds. If the session's ICE connection drops during this window, reconnection follows the standard ICE Originator Failover Protocol (SRS v1.0 §9.1).

**47\. Authentication, Security & Consent (GAP-21 – GAP-26)**

**Passkey Fallback: Password \+ 2FA When Biometric Unavailable**

* Step-up auth priority order: (1) FIDO2 Passkey (biometric). (2) TOTP authenticator app. (3) SMS OTP (6-digit, 10-minute TTL). (4) Email OTP (6-digit, 10-minute TTL, only if phone not verified).

* No biometric enrolled: If the device has no Face ID / fingerprint enrolled, step-up auth skips directly to TOTP. The biometric option is greyed out in the step-up modal with: 'Set up Face ID in Device Settings to use biometric authentication.'

* 2FA not configured: If the user has no TOTP configured, step-up auth falls through to SMS OTP. A persistent settings reminder is injected into the next Heartbeat: 'Add an authenticator app for faster secure actions.'

* Step-up token lifecycle: 300-second TTL, single-use, HMAC-signed. The token is validated by the API Gateway middleware. A consumed token cannot be replayed. On replay attempt, the gateway returns 401 with error: step\_up\_token\_consumed.

* Max step-up failures: 5 consecutive failures within 15 minutes locks the specific action (not the account) for 30 minutes. Counter stored in Redis: stepup\_fail:{user\_id}:{action}. After lockout, the user can still use the app for non-step-up actions.

**Consent Revocation: JWT Invalidation Timing & UX**

* Revocation initiation: User toggles a consent bit OFF in Settings → Privacy Controls. PUT /v1/user/{id}/consent { consent\_flags: \<new\_value\> } is called immediately on toggle.

* Backend propagation: consent\_flags updated in PostgreSQL. Async job (behavioral-service) scans active sessions in Redis (session:{session\_id}) and writes revoked\_jti entries. Latency: \<2ms per JWT via Redis cluster. Total propagation: \<5 seconds for users with \<10 active sessions.

* Client experience: The currently active JWT remains valid until its natural expiry (typically 1 hour). On the NEXT API call after the JWT expires and is refreshed, the new JWT is issued without the revoked consent tier. Features gated on the revoked consent flag return 403 on the next attempt.

* Immediate enforcement for sensitive bits: Consent bits 1 (DNA), 5 (facial biometric), and 6 (voice biometric) are enforced immediately without waiting for JWT expiry. The API Gateway checks consent\_flags directly from PostgreSQL (via a 30-second Redis cache of the user's flags) for these endpoints.

* UX feedback: After toggling, the user sees a banner: 'Your privacy settings have been updated. Some features may be unavailable until your session refreshes.' If the user continues and hits a 403, the error message is: 'This feature requires consent that was recently revoked. Update your privacy settings to re-enable it.'

**Family Pairing: Guardian Account Verification Flow**

1. Guardian initiates: From the guardian's account, Settings → Family Pairing → 'Add a Child Account'. Guardian enters child's name and date of birth.

2. Verification method selection: Guardian chooses one of three verification paths: (A) Credit card authorization ($0.00 hold, released immediately — card-not-present COPPA verification). (B) Government ID upload (hash of document stored, raw image immediately deleted). (C) Knowledge-based authentication (KBA via LexisNexis — 5 questions, 80% pass threshold).

3. Child account creation: After guardian verification, a child account is created with is\_minor: true, guardian\_user\_id: {guardian\_id}, coppa\_consent\_verified\_at: {timestamp}, coppa\_verification\_method: {method}.

4. Restricted feature set: Child accounts cannot access DNA ingestion, Voiceprint capture, Photoplay facial embedding, public profile mode, off-platform tracking, or the Ancestral Marketplace.

5. Guardian dashboard: Guardian sees a Family Pairing tab in their Settings showing all linked child accounts, screen time data (read-only), and the ability to approve or reject Kinnection requests on behalf of the child.

6. Age transition at 13: A push notification fires to both the guardian and the child 30 days before the child's 13th birthday: 'Child's account will transition to standard teen mode on \[date\]. Guardian controls will remain until age 16.' At age 13, COPPA restrictions are lifted but Family Pairing controls (screen time, message restrictions) remain until the guardian disables them or the child turns 18\.

**Step-Up Auth for Commerce Purchases: Threshold Behavior**

| Purchase Type | Amount | Step-Up Required? | Step-Up Reason Header |
| :---- | :---- | :---- | :---- |
| Photoplay Credits — Starter | $0.99 | No | — |
| Photoplay Credits — Standard | $4.49 | No | — |
| Photoplay Credits — Premium | $8.99 | No | — |
| Photoplay Credits — Unlimited (monthly) | $16.99/mo | Yes — first purchase only. Renewals: No. | payment\_write |
| Vault+ Subscription | $4.99/mo | No | — |
| Kinnect Kit (physical) | Free \+ shipping variable | Yes if shipping \>$10 | payment\_write |
| Ancestral Marketplace affiliate purchase | Any | No — handled by affiliate partner | — |
| Gathering Fund contribution | \>$10 total contribution | Yes | payment\_write |
| Gift (Photoplay Credits or Kinnect Kit) | \>$10 total | Yes | payment\_write |

**Security Alert: Anomalous Login Detection Thresholds**

| Event | Detection Condition | Alert Channel | Required Action |
| :---- | :---- | :---- | :---- |
| New device login | Device fingerprint not in user's known\_devices list | Push \+ Email | None required. User can revoke via Manage Devices. |
| Geographic anomaly | Login from country not seen in last 90 days AND IP risk score \>0.7 (via LexisNexis) | Push \+ Email (High Priority) | User shown modal on next app open: 'Was this you?' Yes/No. No → forced password reset \+ all JWTs revoked. |
| Rapid failed logins | 5 failed attempts in 10 minutes from same IP | Email only | Account locked 30 minutes. CAPTCHA required on unlock. |
| Step-up auth failure spike | 5 step-up failures in 15 minutes for sensitive action | In-app banner | Action locked 30 minutes. No account lock. |
| Impossible travel | Two logins from locations \>500km apart within 1 hour | Push \+ Email (High Priority) | Second session revoked. User must re-authenticate. |
| Steward action without consent | Steward attempts Memory Box action without verified Steward Agreement (bit 9 \= 0x0200 not set) | Push \+ Email to Memory Box creator | Action blocked. 403 returned to Steward. |

**Consent Flags Bitmask: UI Presentation Order & Bundling Rules**

| Bit | Presented At | Can Bundle? | GDPR Basis | Default State |
| :---- | :---- | :---- | :---- | :---- |
| 0 (0x0001) — Layer 1 Identity | Onboarding Step 1 (Surname entry) | No — standalone checkbox | Art. 6(1)(a) | Unchecked. Required for Name Map feature. |
| 1 (0x0002) — DNA / Bioidentity | Onboarding Step 2 (DNA) | No — standalone, explicit | HIPAA/GINA \+ Art. 9 | Unchecked. Feature blocked until set. |
| 2 (0x0004) — Social Graph Sharing | Onboarding Step 4 (Invite Kin) | No — standalone checkbox | Art. 6(1)(a) | Unchecked. Tree hidden from Discovery until set. |
| 3 (0x0008) — Behavioral Tracking | Onboarding Step 5 (Line Activation) | No — standalone | ATT/CCPA | Unchecked on iOS (ATT gate). Checked on Android (user can revoke in Settings). |
| 4 (0x0010) — Transaction Intelligence | Settings → Privacy Controls only | No — standalone | Art. 6(1)(a) | Unchecked. Milestone triggers require this bit. |
| 5 (0x0020) — Facial Biometric | Photoplay Studio first use | No — standalone, BIPA modal | BIPA/Art. 9 | Unchecked. Photoplay blocked until set. |
| 6 (0x0040) — Voice Biometric | Voiceprint capture first use | No — standalone, BIPA modal | BIPA/CUBI/Art. 9 | Unchecked. Voiceprint blocked until set. |
| 7 (0x0080) — Off-Platform Tracking | iOS: ATT system prompt post-Step 4\. Android: Settings only. | No — OS-level on iOS | ATT/GDPR | Unchecked. |
| 8 (0x0100) — Third-Party Sharing | Settings → Privacy Controls → Third-party opt-out only | No | CCPA Opt-Out | Unchecked. |
| 9 (0x0200) — Posthumous / Steward | Memory Box Composer → Steward designation flow | No — Steward Agreement modal | State Probate \+ Art. 6 | Unchecked. Memory Box Unspoken trigger blocked. |
| 10 (0x0400) — Minor Guardian | Family Pairing setup only | No — COPPA modal | COPPA | Unchecked. Set on guardian verification. |
| 11 (0x0800) — Research Opt-In | Settings → Privacy Controls → Research section | No — opt-in only | Art. 9 | Unchecked. User must actively opt in. |
| 12 (0x1000) — Stitch Auto-Publish | Settings → Content Permissions → Memory reuse permission | No | GDPR Purpose Limitation | Unchecked. User must actively enable. |

**48\. Commerce, Notifications & Brand Enforcement (GAP-27 – GAP-31)**

**Photoplay Credit: Consumption & Refund Edge Cases**

* Credit consumption timing: One credit is consumed when the Photoplay job is submitted (POST /v1/photoplay), not when it completes. This is an optimistic deduction. If the render fails AND the fallback to SadTalker also fails (both D-ID and SadTalker return errors), the credit is automatically refunded within 60 seconds.

* D-ID API fail, SadTalker succeeds: Credit is consumed. Output uses SadTalker quality. User is notified: 'Your Photoplay was created using Standard quality. No credit was charged — check your balance.' Despite this message, the credit was already consumed. The platform absorbs the cost difference. This copy must be corrected: 'Your Photoplay used Standard quality due to a service issue. Your credit has been refunded.'

* Credit balance display: Shown in three locations: (1) Settings → Balance. (2) Photoplay Studio Step 3\. (3) Commerce sheet header. All three read from the same server-authoritative balance, not a local cache. GET /v1/user/balance is called on each of these screens' mount.

* Gifted credits: Credits gifted to another user (via Profile → Gift) are non-refundable. The recipient cannot re-gift. Gifted credits are tagged gift: true in the entitlement record and excluded from standard refund policies.

* Subscription Unlimited → downgrade: If a user cancels the Unlimited subscription, any Photoplays in-flight at cancellation time complete successfully. After the subscription period ends, the user reverts to a credit balance of 0\. Existing credits purchased before the Unlimited subscription are reinstated.

**Marketplace: Affiliate Link Generation & Deep Link Routing**

* Link generation: Affiliate links are generated server-side by payment-service and cached in Redis (affiliate:link:{product\_id}:{user\_id} TTL 3600s). The client always fetches links from GET /v1/marketplace/link/{product\_id} — never hardcodes affiliate URLs.

* Click attribution: On tap of an affiliate product, the client calls POST /v1/marketplace/click {product\_id, user\_id, affiliate\_network} before opening the external URL. This click event is logged to the analytics pipeline for commission reconciliation.

* In-app browser: Affiliate links open in SFSafariViewController (iOS) / Chrome Custom Tab (Android). Never in the system browser. The user can tap 'Done' to return to KinnectAI without losing their place in the Marketplace.

* Deep link return: After an affiliate conversion (purchase on partner site), the partner fires a postback to POST /v1/marketplace/conversion?affiliate\_id={id}\&order\_id={id}. payment-service records the conversion for commission tracking.

* Amazon SP-API: Product listings from Amazon Associates are fetched via the Product Advertising API 5.0 (PA-API 5.0). Results are cached for 1 hour. Items out of stock are hidden automatically via the availability field in the PA-API response.

**Push Notification: Memory Box Delivery Cannot-Disable Enforcement**

* OS-level denial: If the user revokes push notification permission at the OS level (iOS Settings / Android App Info), KinnectAI cannot override this. This is a system-level restriction.

* Fallback delivery chain for Memory Box: When a Memory Box delivery trigger fires and the recipient has push notifications disabled at OS level, notification-service executes the following fallback chain in order: (1) In-app Pulse tab alert (always fires regardless of push settings). (2) Email to verified email address (if email verified). (3) SMS to verified phone number (if phone verified and user has not opted out of SMS). (4) If all channels fail: delivery\_status \= pending\_notification. Retry the chain every 24 hours for up to 7 days.

* In-app enforcement: The toggle for Memory Box delivery in Settings → Notifications is rendered as a disabled toggle (greyed, non-interactive) with an explanatory label: 'Memory Box delivery alerts cannot be disabled. These are required for legal and estate management purposes.' The toggle shows as ON.

* Legal basis: This requirement is grounded in state probate law obligations and the KinnectAI Steward Agreement. The DPO has reviewed and approved this implementation as consistent with GDPR Art. 6(1)(c) (legal obligation) and Art. 6(1)(b) (performance of contract with the Steward).

**Brand Lexicon CI Gate: Exact Forbidden Term List**

| \# .github/workflows/lexicon-check.yml — COMPLETE FORBIDDEN TERM LIST FORBIDDEN\_TERMS=(   'follower' 'followers' 'following' 'follow'   'like' 'likes' 'liked' 'heart' 'hearts'   'trending' 'trend' 'viral' 'for you' 'foryou' 'for\_you'   'feed' 'feeds'   \# Exception: internal API variable names in services/ allowed   'post' 'posts' 'posting' 'posted'   'story' 'stories'   'group' 'groups'   'live stream' 'livestream' 'go live'  \# Use: Gathering / Room / Broadcast   'duet' 'collab video' 'collaboration video'   'explore' 'for you page' 'fyp'   'match score' 'match percentage' 'compatibility score'   'comment' 'comments'  \# Exception: code comments (// or \#) are excluded   'friend' 'friends' 'friendship'   'subscribe' 'subscriber' 'subscribers'   'creator fund' 'monetize' 'monetization'  \# Use: Gathering Fund / Commerce ) \# Scan scope: lib/ui/ (Flutter), apps/web/src/screens/ (Web) \# Exclusions: \*.g.dart, \*.freezed.dart, test/ directories, services/ API internals \# Case-insensitive matching (-i flag) |
| :---- |

* The word 'feed' in UI-facing copy is forbidden. In backend service names (feed-service, feedApi.ts) and API route paths (/v1/feed), it is acceptable as a technical identifier. The grep scan targets lib/ui/ and apps/web/src/screens/ only.

* The word 'comment' is forbidden in UI copy. In code comments (// Comment, \# Comment) it is excluded from scanning via grep's ability to distinguish code context using \--include patterns.

**Strand: Cover Image Selection & Player Behavior**

* Playback order: Chronological by Memory.created\_at ASC by default. User can reorder via long-press \+ drag in the Strand editor (separate from the viewer). Reordered Strands save a custom\_order JSON array to the strand\_members table.

* Strand Player: Full-screen video player, same interaction model as The Line. Right rail icons are suppressed (no Pulse, no Comment, no Branch). Share icon is the only right rail action, and it shares the Strand (not individual Memory). Swipe up \= next Memory in Strand. Swipe down \= previous. Swipe left \= exit Strand Player back to Profile → Strands tab.

* Public vs. private Strands: Strands inherit the visibility of the owning user's account (Public/Private toggle in Settings → Account Visibility). No per-Strand visibility control. This is consistent with the design principle that the Root profile is the visibility unit.

* Sharing a Strand: The Share action generates a deep link kinnect://strand/{strand\_id}. Opening this link routes to the Strand Player at the first Memory. If the viewer does not have a KinnectAI account, they see a web preview (web.kinnectai.app/strand/{strand\_id}) with the first 3 Memories visible and a 'Join KinnectAI' CTA.

* Maximum Memories per Strand: 200\. Enforced at the API layer. UI shows a count: '47/200 Memories'. At 200, the 'Add to Strand' option is greyed out with tooltip: 'Strand full. Remove a Memory to add more.'

**49\. Biometric, DNA & Voiceprint Pipelines (GAP-32 – GAP-37)**

**Voiceprint: Challenge-Response Word List & Hash Storage**

* Word list: 1,000 common English words filtered to: 2–3 syllables, phonetically distinct from each other, no proper nouns, no homophones of other list words. Stored server-side in voiceprint-service. GET /v1/voiceprint/challenge returns 10 words selected via cryptographically random sampling without replacement.

* Recording: The user reads all 10 words in sequence. Minimum recording duration: 8 seconds. Maximum: 60 seconds. The raw audio is encrypted client-side (AES-256-GCM) before upload to S3 (voiceprints/challenge/{user\_id}/{challenge\_id}).

* Hash computation: HMAC-SHA256(audio\_sha256\_hash || transcript\_sha256\_hash, user\_id\_bytes). Stored in users.voiceprint\_challenge\_hmac. The transcript is generated by ElevenLabs speech-to-text on the challenge audio (separate API call from the clone creation).

* Verification use: The challenge HMAC is used to verify that the voice clone was created from the user's own voice. Before any ElevenLabs clone is used in Photoplay generation, voiceprint-service computes a new HMAC from the stored clone's reference audio and compares it to users.voiceprint\_challenge\_hmac. Mismatch → clone rejected, moderation.queue event fired (violation\_type: SYNTHETIC\_VOICE\_MISMATCH).

* Challenge expiry: Challenge tokens (GET /v1/voiceprint/challenge response) expire after 10 minutes. If the user takes longer than 10 minutes to complete the recording, they must fetch a new challenge set.

**Haplogroup: Display Format & Ancient DNA Attribution**

* Haplogroup nomenclature: ISOGG 2024 tree nomenclature for Y-chromosome (paternal) haplogroups and PhyloTree Build 17 for mtDNA (maternal) haplogroups. No proprietary naming.

* Display format on profile: Haplogroup badge shows the top-level clade (e.g., 'H' for mtDNA haplogroup H1c3). Full haplogroup path shown on tap: 'H → H1 → H1c → H1c3'. Tap navigates to a Haplogroup Detail screen showing geographic distribution map.

* AADR attribution placement: Attribution badge ('Historical DNA courtesy of AADR — Reich Lab, Harvard') must appear in the following locations: (1) Tooltip of any amber Tree node on tap. (2) Footer of the Haplogroup Detail screen. (3) Footer of the Discovery card when primary\_signal \= HAPLOGROUP. (4) Footer of the Name Map when AADR historical markers are visible.

* WikiTree gold-ring node attribution: 'Source: WikiTree (CC BY 4.0)' appended to the node tooltip and the Graph Path View node label. No separate screen required.

* Ancient DNA date display: AADR samples show estimated date as a range: e.g., '4,200–4,400 years BP' (Before Present). Never a specific year. Source: AADR metadata field average\_BP ± 100 years.

**Facial Embedding: On-Device vs. Cloud Processing Boundary**

| Processing Step | Location | Data Transmitted? | Consent Bit Required |
| :---- | :---- | :---- | :---- |
| Face detection (bounding box, landmark) | On-device TFLite (MobileNetV3) | No | None |
| Liveness check (blink, head movement) | On-device TFLite | No | None |
| Facial embedding extraction (128-dim FaceNet vector) | On-device TFLite | No | None — extraction is local |
| Facial embedding storage in pgvector (for Discovery matching) | Server-side — embedding transmitted to dna-ingest-service | Yes — embedding only, never raw image | Bit 5 (0x0020) REQUIRED before transmission |
| Facial similarity search (Discovery matching) | Server-side pgvector cosine search | No new data transmitted | Bit 5 (0x0020) REQUIRED |
| Photoplay lip-sync animation | SadTalker/D-ID server-side — photo transmitted | Yes — photo S3 key transmitted | Bit 5 (0x0020) REQUIRED |
| DeepFace impersonation check (TS-003) | Server-side (trust & safety pipeline) | Embedding only | Bit 5 (0x0020) REQUIRED |

| ℹ  NOTE: The raw photo or video frame is NEVER transmitted to the server except for Photoplay animation (Step 6 above). All other facial processing uses the 128-dim embedding vector only. |
| :---- |

**DNA Kit: QR Code Chain of Custody Scanning**

* QR code content: Encodes a unique kit\_id (UUID v4) in the format kinnect://kit/{kit\_id}. The kit\_id is generated at order placement and printed on the tube label.

* Scanning flow: The app detects the deep link kinnect://kit/{kit\_id} when the camera scans the QR code. This requires camera permission. If camera permission is denied, the user can manually enter the kit\_id from the printed alphanumeric code on the packaging.

* Validation: The app calls POST /v1/dna/kit/register {kit\_id, user\_id}. dna-ingest-service validates that the kit\_id exists in the kit\_fulfillment table, has status \= shipped, and is not already registered to another user. On success, status is updated to registered.

* KIT\_QR\_UNREADABLE failure state: If the lab receives a tube with a damaged or unreadable QR code, the fulfillment system fires a webhook to dna-ingest-service: POST /v1/dna/kit/failure {kit\_id, reason: 'qr\_unreadable'}. This triggers the auto-void and replacement dispatch flow defined in SRS §7.4.

* Temperature exceedance: temp\_log is uploaded by the carrier via FedEx API integration when the kit is delivered to the lab. If any reading exceeds 8°C for \>2 continuous hours, the same failure webhook fires with reason: 'temp\_exceeded'.

**Voiceprint Queue: Priority Tier Assignment Logic**

* Vault+ eligibility: A user is classified as Vault+ (P0 queue) if their RevenueCat entitlement vault\_500gb is active at the time of voiceprint job submission. This is evaluated at job creation time (INSERT into voiceprint\_queue), not at processing time.

* Mid-queue upgrade: If a user upgrades to Vault+ while their job is in the P1 queue, the job is promoted to P0 on the next queue evaluation cycle (every 5 minutes). A push notification fires: 'Your Voiceprint has been moved to the priority queue. Estimated completion: 12 hours.'

* Mid-queue downgrade (cancellation): If a user cancels Vault+ while their job is in the P0 queue, the job is NOT demoted. It completes at P0 priority using the entitlement status at submission time.

* ElevenLabs daily clone limit (10/day): The 10-clone limit is evaluated per calendar day (UTC). The voiceprint\_queue processor tracks elevenlabs\_clones\_today in Redis (ElevenLabs daily counter, reset at 00:00 UTC). Jobs submitted when the counter is at 10 are routed to OpenVoice-V2 regardless of tier.

* Maximum queue wait SLA: P0 ≤12h, P1 ≤48h. If a job exceeds its SLA, a push fires to the user and the job is escalated to a manual review queue with a credit refund initiated automatically.

**Family Crest: SVG Output Dimensions & Asset Delivery**

* SVG canvas: 512×512 viewBox. Output file size cap: 150KB after go-sanitize XSS processing. If GPT-4o generates an SVG exceeding 150KB, photoplay-service retries with a simplified prompt: 'Simpler geometric elements only, reduce path complexity.' Maximum 3 retries before template fallback.

* C2PA manifest: Required per SRS §7.2 (SYN-001). Embedded as XMP metadata in the SVG. The manifest includes: user\_id hash, generation timestamp, prompt hash (not the prompt text), pipeline\_version.

* Delivery: POST /v1/family-crest returns {crest\_id, svg\_url, c2pa\_manifest\_url}. svg\_url is a CloudFront signed URL (7-day TTL). The SVG is stored at S3 key crests/{user\_id}/{crest\_id}.svg.

* Sharing options: (1) Save to Camera Roll — converted to PNG (512×512, 96 DPI) client-side using flutter\_svg's Picture.toImage(). (2) Share to The Line — published as a memory with type: 'family\_crest'. (3) Copy SVG link — copies the svg\_url to clipboard for use on external websites. (4) Set as Profile Badge — stored as users.crest\_svg\_url, rendered in Profile Header below haplogroup badge.

* Regeneration: Users can regenerate their crest at any time. Each regeneration creates a new crest\_id. Previous crests are retained for 90 days in S3 and accessible via GET /v1/family-crest/history. Old crests set as Profile Badge are automatically replaced.

**50\. Infrastructure, Testing & Observability (GAP-38 – GAP-43)**

**Flickers: Script Generation Prompt Contract & Safety Filter**

| GPT-4o Prompt Contract for Flickers (photoplay-service): {   'model': 'gpt-4o',   'max\_tokens': 1200,   'temperature': 0.7,   'response\_format': { 'type': 'json\_object' },   'system': 'You are a family documentary narrator. Generate warm, respectful,              factual biographical narration from the provided family data.              Never speculate about living persons. Never include sensitive medical,              legal, or financial information. Output must be G-rated.              Return JSON only.',   'user': '{     tree\_data: { persons: \[...\], relationships: \[...\] },     vault\_memories\_summary: \[...\],     duration\_seconds: 90,     tone: family\_safe   }' } Required output schema: {   'title': string (max 60 chars),   'segments': \[     { 'text': string (max 200 chars), 'duration\_s': number, 'memory\_id': string|null }   \],   'total\_duration\_s': number (target: 90s ± 15s) } |
| :---- |

* Safety filter bypass: If GPT-4o's safety filter rejects the prompt (returns a refusal), photoplay-service falls back to a template-based narration engine. The template uses the user's surname, oldest known ancestor names and dates, and country of origin from the tree data to generate a generic 60-second narration. Template output is not AI-generated; is\_ai\_generated is set to false and no C2PA manifest is required.

* Free tier: One Flickers generation per user per calendar month. Additional generations cost 1 Photoplay Credit each. Enforced via entitlement check at POST /v1/flickers. The monthly free generation resets on the 1st of each month at 00:00 UTC.

**Performance SLO: KC Computation Cache Invalidation Strategy**

| Invalidation Trigger | Pairs Invalidated | Method | SLA for Re-computation |
| :---- | :---- | :---- | :---- |
| DNA ingestion complete (new VCF processed) | All pairs where user is user\_a OR user\_b | Kafka event cr.recompute with trigger\_source: DNA\_INGEST. Batch of up to 500 pair\_ids per event. | High priority queue. p99 \<5 minutes. |
| New Kinnection confirmed | The newly confirmed pair only | Synchronous cache DELETE on kin-graph-service confirmation. Immediate re-compute. | p99 \<200ms (within SLO). |
| Consent flag bit 1 (DNA) revoked | All pairs for this user | Same as DNA ingestion invalidation. KC recomputed without Layer 2\. | Normal priority. p99 \<30 minutes. |
| Consent flag bit 2 (Social Graph) revoked | All pairs for this user | Same batch invalidation via Kafka. | Normal priority. p99 \<30 minutes. |
| User profile update (surname, geo\_region) | All Layer 1 pairs — users sharing surname or geo | Identity enrichment Kafka event. Batched. | Low priority. p99 \<2 hours. |
| Discovery dismiss (×0.30 penalty) | The dismissed pair only | Redis ZADD update only. No kernel re-compute. | Immediate (Redis write). |

**Observability: Structured Log Field Completeness**

| Canonical log envelope (JSON) — ALL services: {   'timestamp':         ISO8601 UTC,   'level':             'DEBUG' | 'INFO' | 'WARN' | 'ERROR' | 'FATAL',   'service':           'feed-service' | 'kernel-service' | ... (service name),   'version':           semantic version string (e.g. '1.4.2'),   'correlation\_id':    UUID v4 (propagated via X-Correlation-ID header),   'trace\_id':          Jaeger/X-Ray trace ID,   'span\_id':           Jaeger/X-Ray span ID,   'user\_id\_hash':      HMAC-SHA256(user\_id, LOG\_HMAC\_SECRET) — first 16 hex chars,   'region':            'us-east-1' | 'eu-west-1' | 'ap-south-1',   'consent\_flags\_snapshot': integer (current value at time of log),   'event':             string (snake\_case event name, e.g. 'feed.assembled'),   'duration\_ms':       integer (optional — for timed operations),   'error\_code':        string | null,   'meta':              {} // service-specific additional fields } LOG\_HMAC\_SECRET: Rotated quarterly. Stored in AWS SSM Parameter Store. Never log: raw user\_id, plaintext JWT, DEK, passkey credential, raw genomic data. |
| :---- |

**CI/CD: PRD Coverage Gate Threshold & Enforcement**

| Gate Type | Threshold | Scope | Fail Behavior |
| :---- | :---- | :---- | :---- |
| PRD Traceability | ≥95% of required features in prd\_feature table have implementation\_status \= live | All features where status \= required | Block merge to main. Output list of un-traced features. |
| Unit Test Coverage (Go) | ≥80% statement coverage per package | services/go/\*\*/\*.go excluding \*\_test.go | Block merge. Output uncovered packages. |
| Unit Test Coverage (Dart) | ≥80% line coverage per lib/ package | apps/mobile/lib/\*\*/\*.dart excluding \*.g.dart and \*.freezed.dart | Block merge. Output uncovered files. |
| Integration Test Coverage | ≥70% of critical path flows defined in §20.3 pass | Staging environment test suite | Block canary promotion. Allow merge to staging. |
| SAST/DAST | Zero High or Critical findings | All services and apps | Block merge. Output CVE list. |
| Brand Lexicon | Zero forbidden terms in lib/ui/ and apps/web/src/screens/ | See GAP-30 | Block merge. Output file:line of violation. |
| Accessibility | ≥95% WCAG 2.2 AA pass rate on integration test snapshots | All 48 screens | Block merge. Output failing elements. |

**Error Registry: Authoritative Error Code Index**

| Error Code | HTTP / BLoC State | Description | Retry Behavior |
| :---- | :---- | :---- | :---- |
| ERR\_NET\_001 | NetworkError | No internet connectivity | Exponential backoff \+ connectivity\_plus listener. Max 5 retries. |
| ERR\_SRV\_5XX | ServerError | 5xx response from any service | Retry 3× (1s, 5s, 15s). After 3 failures: full-screen error state. |
| ERR\_AUTH\_401 | AuthError | JWT expired or revoked | Silent re-auth via Firebase refresh token. If refresh fails: route to Login. |
| ERR\_AUTH\_403 | InsufficientScope | Missing OAuth scope or consent flag | No retry. Show contextual error with Settings deep link. |
| ERR\_AUTH\_SUB | StepUpRequired | Step-up authentication required | Trigger step-up modal. On success: retry original request. |
| ERR\_CONSENT\_BIT | ConsentMissing | consent\_flags bit not set | No retry. Show consent prompt for the specific bit required. |
| ERR\_RATE\_429 | RateLimitError | Rate limit exceeded | Respect Retry-After header. Show 'Too many requests. Try again in Xs.' |
| ERR\_VAULT\_SEAL | VaultSealError | Memory Box sealing failed | Preserve draft. Show: 'Sealing failed. Your draft is preserved.' Retry button. |
| ERR\_MEDIA\_001 | MediaLoadError | Video/image failed to load | Preload next 3 items. Retry failed item in background. |
| ERR\_DNA\_VCF | DNAProcessingError | VCF parsing or alignment failure | Show specific VCF error code from SRS §8.1. Prompt re-upload. |
| ERR\_PHOTO\_001 | PhotoplayRenderError | D-ID \+ SadTalker both failed | Credit refunded. Show: 'Photoplay creation failed. Credit refunded.' No retry. |
| ERR\_ROOM\_ICE | RoomConnectionError | WebRTC ICE failure | Retry ICE negotiation. Offer audio-only fallback after 3 failures. |
| ERR\_GRAPH\_001 | GraphLoadError | Neo4j subgraph query failed or partial | Show partial graph with warning. Fetch identity layer as fallback. |
| ERR\_SYNC\_001 | OfflineSyncError | Mutation queue flush failed on reconnect | Move to failed\_mutations table. Show 'Action pending. Tap to retry.' banner. |

**Chaos Engineering: Runbook Coverage for All Critical Dependencies**

| Experiment | Scope | Injection Method | Success Criteria | Owner |
| :---- | :---- | :---- | :---- | :---- |
| kernel-service total outage | feed-service \+ discovery-service fallback | kubectl scale deployment/kernel-service \--replicas=0 | feed-service serves kc\_cached fallback within 5s. discovery-service returns cached candidates. No 5xx to clients. | Feed Engineering |
| Neo4j Aura connectivity loss | kin-graph-service \+ treeGraph resolver | Network policy block on Neo4j port 7687 | treeGraph resolver returns partial\_failure result per Appendix K. Feed continues via Redis cache. No data loss. | Graph Engineering |
| Redis ElastiCache node failure (1 of 2 shards) | feed-service cache, session cache, rate limit | ElastiCache shard failover simulation (AWS FIS) | Primary shard failover \<30s. Feed falls back to chronological. Session continuity maintained via remaining shard. | Infrastructure |
| Kafka MSK broker failure (1 of 3\) | All Kafka producers and consumers | AWS FIS: terminate 1 MSK broker | Producer retry succeeds within 10s. Consumer rebalance within 30s. No event loss (ISR \= 2). | Infrastructure |
| ElevenLabs API 429 / 503 sustained | voiceprint-service \+ photoplay-service | Inject 503 responses via service mesh fault injection | All voiceprint jobs route to OpenVoice-V2 within 2 minutes. User notifications fired. No job loss. | AI Media Engineering |
| KMS endpoint timeout | memorybox-service DEK wrap/unwrap | Network latency injection: 6s on KMS endpoint (above 5s timeout) | Memory Box sealing fails gracefully. Draft preserved client-side. Error code ERR\_VAULT\_SEAL returned with retry CTA. | Security Engineering |
| dna-ingest-service crash loop | KC computation pipeline | kubectl rollout restart deployment/dna-ingest-service repeatedly | Existing KC scores served from Redis cache. In-flight VCF jobs requeued after service recovery. No user data loss. | DNA Engineering |
| Full network partition (us-east-1 to eu-west-1) | Cross-region data residency enforcement | VPC route table blackhole between regions | EU users served exclusively from eu-west-1. No data crosses regions. GDPR residency enforced. Alerting fires within 60s. | Infrastructure / DPO |

| ⚠  CRITICAL: All chaos experiments run in the staging environment only. Production chaos requires DPO \+ Engineering Lead dual approval and a 72-hour advance notice window. Results are logged to the engineering incident tracker and runbooks updated within 24 hours of each experiment. |
| :---- |

