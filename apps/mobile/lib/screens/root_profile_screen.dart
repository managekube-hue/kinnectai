import 'package:flutter/material.dart';
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
            icon: const Icon(Icons.settings),
            onPressed: () => AppNav.push(context, '/settings'),
          ),
        ] : null,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 64,
              backgroundColor: KinnectColors.surface,
              child: Icon(Icons.person, size: 64, color: KinnectColors.textMuted),
            ),
            SizedBox(height: 24),
            Text(
              'Complete your profile',
              style: TextStyle(color: KinnectColors.textPrimary, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Add DOB and surname',
              style: TextStyle(color: KinnectColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}




