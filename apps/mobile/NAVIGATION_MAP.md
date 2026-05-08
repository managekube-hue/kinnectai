# KinnectAI Navigation Architecture

## Route Map (PRD Section 00)

### Auth Flow (Section 11)
- `/splash` ? SplashScreen (2s animation ? `/welcome`)
- `/welcome` ? WelcomeScreen (OAuth buttons + Email/Phone)
- `/login` ? LoginScreen (Email/Phone + Password)
- `/register` ? RegisterScreen (OAuth redirect target)
- `/email-signup` ? EmailSignUpScreen (Email + Password + DOB)
- `/phone-signup` ? PhoneSignUpScreen (Phone + OTP)
- `/landing` ? LandingScreen (Post-auth onboarding)

### Bottom Bar (Section 00 - Always Visible)
1. **Home** (`/home` or `/line`) - The Line feed
2. **Repost** - Dual-purpose (repost/stitch)
3. **Create** (`/creation-hub`) - All creation tools
4. **Tree** - Interactive genealogical graph
5. **Profile** - Root (user profile)

### Creation Hub Tools (Section 02)
- `/creation-hub` ? CreationHubScreen
  - Bloom ? Bloom Studio
  - Memory Box ? `/memory-box`
  - Memory ? Camera/upload
  - Stitch ? Stitch editor
  - Restore ? Restore tool
  - Legacy Reel ? AI documentary
  - Family Crest ? AI crest generator
  - Voiceprint ? `/voiceprint-capture`

### Memory Box (Section 03)
- `/memory-box` ? MemoryBoxScreen
  - Sealed tab
  - Delivered tab
  - Drafts tab
  - Memory Box composer

### Secondary Features
- `/voiceprint-capture` ? VoiceprintCaptureScreen (Section 02.9)
- `/time-wellbeing` ? TimeWellbeingScreen (Section 12.3)
- `/memory/{id}/comments` ? CommentThreadScreen (Section 01.2)
- `/kin-score-detail?target={userId}` ? KinScoreDetailScreen (Section 01.1)

### Legal Documents (Section 11)
- `/legal/terms` ? Legal Document Screen (Terms of Service)
- `/legal/privacy` ? Legal Document Screen (Privacy Policy)
- `/legal/biometric` ? Legal Document Screen (Biometric Consent)

## Navigation Flow

```
Splash (2s)
  ?
Welcome
  ?? OAuth ? Register ? Landing ? Home
  ?? Email Signup ? Verify ? Landing ? Home
  ?? Phone Signup ? OTP ? Landing ? Home
  ?? Sign In ? Home

Home (Bottom Bar)
  ?? Home/Line (The Line feed)
  ?   ?? Video tap ? Pause/Play
  ?   ?? Right rail ? Pulse/Comment/Rewind/Save/Share/Branch
  ?   ?? Comment icon ? /memory/{id}/comments
  ?   ?? Kin Score badge ? /kin-score-detail?target={userId}
  ?   ?? Creator name ? /profile/{userId}
  ?? Repost (Repost/Stitch dual mode)
  ?? Create ? /creation-hub
  ?   ?? Voiceprint ? /voiceprint-capture
  ?   ?? Memory Box ? /memory-box
  ?   ?? [Other tools]
  ?? Tree (Interactive graph)
  ?? Profile (Root)
      ?? Settings ? /time-wellbeing
```

## Screen States

### The Line (Home)
- Empty state (new user) - "Invite your first Kin"
- Loading state - Skeleton with amber shimmer
- Kinnections tab - Confirmed connections only
- Echoes tab - Date-matched memories
- Discover tab - Discovery cards with Connection Score

### Memory Box
- Draft status (grey badge)
- Sealed status (amber lock)
- Triggered status (blue clock)
- Delivered status (green check)

### Discovery Cards
- Connection Score % (0-100%)
- Relationship guess
- Primary signal (DNA/Tree/Name+Location)
- Explore Connection CTA
- Kinnect button
- Dismiss (swipe left)

## Implementation Status

? Implemented:
- Splash screen with gradient animation
- Welcome screen with OAuth buttons
- The Line feed with video player
- Creation Hub with colorful tool cards
- Memory Box with 3 tabs
- Voiceprint Capture with consent flow
- Time & Well-being settings
- Comment thread screen
- Kin Score detail screen

?? To Build:
- Bottom navigation bar (5 tabs)
- Tree interactive graph
- Profile/Root screen
- Repost/Stitch dual mode
- Bloom Studio
- Stitch editor
- Restore tool
- Legacy Reel composer
- Family Crest generator
- Rooms (video calls)
- Discovery page
- Branch page
- Sidebar/Drawer
- Settings screens (full Section 12)
