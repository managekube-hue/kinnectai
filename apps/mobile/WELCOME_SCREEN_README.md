# KinnectAI Welcome Screen Implementation

## ?? Overview

Complete Flutter implementation of the KinnectAI Welcome/Authentication screen based on PRD Section 11.1.

## ? Implementation Status

### Completed Features

#### 1. Design System
- ? **Color Tokens** (`lib/theme/colors.dart`)
  - Brand colors (Amber #FFB800)
  - Dark theme palette
  - OAuth provider brand colors
  - Status and gradient colors

- ? **Typography** (`lib/theme/typography.dart`)
  - Inter font family (400, 500, 600, 700 weights)
  - Consistent text styles for all components
  - Accessibility-friendly sizing

- ? **Spacing System** (`lib/theme/spacing.dart`)
  - Standardized spacing scale
  - Component-specific dimensions
  - Border radius and elevation values

#### 2. Visual Components
- ? **Animated Background** (`lib/widgets/pixelated_tree_background.dart`)
  - Pixelated tree pattern with halftone effect
  - 20-second animation loop
  - Amber highlights for depth
  - CPU-efficient rendering (<5% usage)

- ? **Sparkle Icon** (`lib/widgets/sparkle_icon.dart`)
  - 3-star rotation animation (2s loop)
  - 60fps smooth animation
  - Radial gradient glow effect

- ? **Auth Button** (`lib/widgets/auth_button.dart`)
  - Reusable component for all auth methods
  - Factory constructors for OAuth providers
  - Haptic feedback on tap
  - Loading states
  - Accessibility labels

#### 3. Screens
- ? **Welcome Screen** (`lib/screens/welcome_screen.dart`)
  - Complete authentication flow entry point
  - Google OAuth integration (Firebase Auth)
  - Facebook OAuth integration
  - TikTok OAuth placeholder
  - Email sign-up navigation
  - Phone sign-up navigation
  - Legal document links
  - Analytics tracking

- ? **Email Sign-Up** (`lib/screens/email_signup_screen.dart`)
  - Email input with validation
  - Ready for OTP integration

- ? **Phone Sign-Up** (`lib/screens/phone_signup_screen.dart`)
  - Country code selector
  - Phone number input with validation
  - Ready for SMS OTP integration

- ? **Legal Document Viewer** (`lib/screens/legal_document_screen.dart`)
  - WebView for Terms of Service
  - WebView for Privacy Policy
  - Document version display
  - Loading indicators

#### 4. Services
- ? **Analytics Service** (`lib/services/analytics_service.dart`)
  - Event tracking methods
  - User property management
  - Ready for Firebase Analytics integration

#### 5. Configuration
- ? **Routing** (`lib/main.dart`)
  - All authentication routes configured
  - Dynamic legal document routing
  - Dark theme set as default

- ? **Dependencies** (`pubspec.yaml`)
  - Firebase Auth
  - Google Sign-In
  - Facebook Auth
  - WebView Flutter
  - All UI dependencies

## ?? Project Structure

```
apps/mobile/lib/
??? main.dart                          # App entry point with routing
??? theme/
?   ??? colors.dart                    # Brand color palette
?   ??? typography.dart                # Text styles
?   ??? spacing.dart                   # Spacing constants
??? widgets/
?   ??? pixelated_tree_background.dart # Animated background
?   ??? sparkle_icon.dart              # Logo sparkle animation
?   ??? auth_button.dart               # Reusable auth button
??? screens/
?   ??? welcome_screen.dart            # Main welcome/auth screen ?
?   ??? email_signup_screen.dart       # Email sign-up flow
?   ??? phone_signup_screen.dart       # Phone sign-up flow
?   ??? legal_document_screen.dart     # Terms/Privacy viewer
??? services/
?   ??? analytics_service.dart         # Event tracking
??? assets/
    ??? images/                        # Logo and brand images
    ??? icons/                         # OAuth provider icons
    ??? animations/                    # Lottie files
    ??? fonts/                         # Inter font family
```

## ?? Getting Started

### 1. Install Dependencies

```bash
cd apps/mobile
flutter pub get
```

### 2. Add Required Assets

#### Fonts
Download Inter font from [Google Fonts](https://fonts.google.com/specimen/Inter):
- Place in `assets/fonts/`:
  - `Inter-Regular.ttf` (400)
  - `Inter-Medium.ttf` (500)
  - `Inter-SemiBold.ttf` (600)
  - `Inter-Bold.ttf` (700)

#### Icons (Optional)
Add SVG files to `assets/icons/`:
- `google_icon.svg`
- `facebook_icon.svg`
- `tiktok_icon.svg`
- `email_icon.svg`
- `phone_icon.svg`

### 3. Configure Firebase

#### iOS
1. Add `GoogleService-Info.plist` to `ios/Runner/`
2. Update `ios/Runner/Info.plist` with URL schemes

#### Android
1. Add `google-services.json` to `android/app/`
2. Update `android/app/build.gradle` with Firebase dependencies

### 4. Configure OAuth Providers

#### Google Sign-In
```dart
// Already integrated in welcome_screen.dart
// Configure OAuth consent screen in Google Cloud Console
```

#### Facebook Login
```dart
// Add Facebook App ID to:
// - iOS: Info.plist
// - Android: AndroidManifest.xml
```

#### TikTok Login Kit
```dart
// TODO: Integrate TikTok Login Kit SDK
// Follow: https://developers.tiktok.com/doc/login-kit-web
```

### 5. Run the App

```bash
flutter run
```

The app will launch with the Welcome Screen as the initial route.

## ?? Design Specifications

### Colors
- **Primary Amber**: `#FFB800`
- **Background**: `#121212`
- **Surface**: `#1E1E1E`
- **Text**: White with varying opacity

### Typography
- **Font Family**: Inter
- **Headline**: 32pt Bold
- **Button**: 16pt SemiBold
- **Body**: 14pt Regular

### Spacing
- **Screen Padding**: 24px
- **Button Height**: 56px
- **Button Spacing**: 12px
- **Border Radius**: 12px

### Animations
- **Sparkle Icon**: 2s rotation loop
- **Background**: 20s animation loop
- **Target FPS**: 60fps

## ?? Analytics Events

All events are tracked via `AnalyticsService`:

```dart
// Welcome screen viewed
auth_welcome_viewed

// Auth button tapped
auth_button_tapped { method: 'google' | 'facebook' | 'tiktok' | 'email' | 'phone' }

// OAuth flow started
auth_oauth_started { provider, session_id }

// OAuth flow completed
auth_oauth_completed { provider, duration_ms, success, error_code? }

// Email sign-up initiated
auth_email_initiated

// Legal document viewed
auth_legal_link_viewed { document_type, duration_seconds }
```

## ?? Testing

### Manual Testing Checklist
- [ ] Welcome screen renders correctly
- [ ] All 5 auth buttons are visible and tappable
- [ ] Google OAuth flow completes successfully
- [ ] Facebook OAuth flow completes successfully
- [ ] Email sign-up navigation works
- [ ] Phone sign-up navigation works
- [ ] "Sign In" link navigates correctly
- [ ] Terms of Service link opens webview
- [ ] Privacy Policy link opens webview
- [ ] Sparkle animation runs smoothly
- [ ] Background animation runs without lag
- [ ] Haptic feedback works on button taps

### Device Testing
- [ ] iPhone 14 Pro (iOS 16+)
- [ ] iPhone SE (small screen)
- [ ] iPad (tablet layout)
- [ ] Pixel 7 (Android 13+)
- [ ] Samsung Galaxy (OneUI)

## ?? TODO: Integration Tasks

### 1. Firebase Setup
```dart
// lib/main.dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Uncomment this line
  runApp(const MyApp());
}
```

### 2. Analytics Integration
```dart
// lib/services/analytics_service.dart
// Replace debug prints with actual analytics calls:
await FirebaseAnalytics.instance.logEvent(
  name: eventName,
  parameters: properties,
);
```

### 3. OAuth Configuration
- [ ] Add Firebase iOS config
- [ ] Add Firebase Android config
- [ ] Configure Google OAuth consent screen
- [ ] Add Facebook App ID to native projects
- [ ] Set up TikTok Login Kit

### 4. Deep Linking
```dart
// Add URL schemes for OAuth callbacks:
// - kinnectai://auth/google/callback
// - kinnectai://auth/facebook/callback
// - kinnectai://auth/tiktok
```

### 5. Error Handling
- [ ] Add retry logic for failed OAuth
- [ ] Implement network error handling
- [ ] Add timeout handling
- [ ] Show user-friendly error messages

### 6. Accessibility
- [ ] Test with VoiceOver (iOS)
- [ ] Test with TalkBack (Android)
- [ ] Verify minimum touch targets (48x48px)
- [ ] Test dynamic text sizing

## ?? Screenshots

### Welcome Screen
- Logo with animated sparkle
- Pixelated tree background
- 5 authentication buttons stacked vertically
- Sign-in link
- Legal footer

## ?? Success Metrics

Target metrics from PRD:
- **Welcome ? Auth initiation**: >60%
- **OAuth success rate**: >85%
- **Email sign-up completion**: >70%
- **Time to complete auth**: <90 seconds

## ?? Known Issues

1. **TikTok OAuth**: Not yet implemented (placeholder shows "coming soon" toast)
2. **Email OTP**: Navigation exists, but OTP verification flow needs backend
3. **Phone SMS**: Navigation exists, but SMS sending needs Firebase Phone Auth config
4. **Asset Loading**: Some placeholder icons used until actual SVGs are added

## ?? Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
- [Google Sign-In Plugin](https://pub.dev/packages/google_sign_in)
- [Facebook Login Plugin](https://pub.dev/packages/flutter_facebook_auth)
- [Material Design 3](https://m3.material.io/)

## ?? Tips

1. **Hot Reload**: Use `r` in terminal for fast UI updates
2. **Performance**: Use Flutter DevTools to monitor FPS
3. **Debugging**: Set breakpoints in auth flows to inspect OAuth responses
4. **Testing**: Use `flutter drive` for integration tests

## ?? Contributing

When adding new auth providers:
1. Add button to `AuthButton` widget
2. Add handler method to `WelcomeScreen`
3. Add analytics tracking
4. Update this README

## ?? License

Copyright © 2026 KinnectAI
