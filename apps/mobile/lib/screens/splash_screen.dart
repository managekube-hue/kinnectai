import 'package:flutter/material.dart';
import '../router/app_nav.dart';
import '../theme/design_system.dart';

/// Splash screen with animated shader gradient background
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // Navigate to welcome after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        AppNav.go(context, '/welcome');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Shader gradient background (neonDusk preset at 145° angle)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    transform: const GradientRotation(145 * 3.14159 / 180),
                    colors: [
                      const Color(0xFF1A1C18), // color0
                      const Color(0xFF2A2D26), // color1
                      DesignColors.darkSecondaryText, // color2
                      const Color(0xFF1A1C18), // color3
                      const Color(0xFF1A1C18), // color4
                      const Color(0xFF2A2D26), // color5
                      const Color(0xFF1A1C18), // color6
                    ],
                    stops: [
                      0.0,
                      _controller.value * 0.2,
                      0.4 + (_controller.value * 0.1),
                      0.6,
                      0.7,
                      0.85 + (_controller.value * 0.1),
                      1.0,
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Overlay container with 30% opacity
          Container(
            width: double.infinity,
            height: double.infinity,
            color: DesignColors.darkPrimaryText.withOpacity(0.05),
            child: Center(
              child: Opacity(
                opacity: 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // KinnectAI logo mark
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: DesignColors.darkPrimary.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(DesignRadii.lg),
                      ),
                      child: const Icon(
                        Icons.account_tree_outlined,
                        size: 64,
                        color: DesignColors.darkPrimary,
                      ),
                    ),
                    const SizedBox(height: DesignSpacing.lg),
                    
                    // App name
                    Text(
                      'KinnectAI',
                      style: DesignTextStyles.headlineLarge.copyWith(
                        color: DesignColors.darkPrimaryText,
                      ),
                    ),
                    const SizedBox(height: DesignSpacing.sm),
                    
                    // Tagline
                    Text(
                      'Your Digital Legacy',
                      style: DesignTextStyles.bodyMedium.copyWith(
                        color: DesignColors.darkSecondaryText,
                      ),
                    ),
                    
                    const SizedBox(height: DesignSpacing.xl),
                    
                    // Loading indicator
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          DesignColors.darkPrimary,
                        ),
                        strokeWidth: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



