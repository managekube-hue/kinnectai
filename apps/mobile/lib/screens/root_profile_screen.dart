import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../router/app_nav.dart';
import '../theme/colors.dart';

class RootProfileScreen extends StatelessWidget {
  final String? userId;
  
  const RootProfileScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    final bool isOwnProfile = userId == null;
    
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Profile'),
        actions: isOwnProfile ? [
          IconButton(
            icon: Icon(PhosphorIcons.gear(), color: KinnectColors.textPrimary),
            onPressed: () => AppNav.push(context, '/settings'),
          ),
        ] : null,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 64,
              backgroundColor: KinnectColors.surface,
              child: Icon(PhosphorIcons.user(), size: 64, color: KinnectColors.textMuted),
            ),
            const SizedBox(height: 24),
            const Text(
              'Complete your profile',
              style: TextStyle(color: KinnectColors.textPrimary, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add DOB and surname',
              style: TextStyle(color: KinnectColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}




