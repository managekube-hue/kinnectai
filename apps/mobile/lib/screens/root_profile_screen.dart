import 'package:flutter/material.dart';
import '../theme/colors.dart';

class RootProfileScreen extends StatelessWidget {
  final String? userId;
  
  const RootProfileScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    final bool isOwnProfile = userId == null;
    
    return Scaffold(
      backgroundColor: KinnectColors.darkBg,
      appBar: AppBar(
        backgroundColor: KinnectColors.darkSurface,
        title: const Text('Profile'),
        actions: isOwnProfile ? [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ] : null,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 64,
              backgroundColor: KinnectColors.darkSurface,
              child: Icon(Icons.person, size: 64, color: KinnectColors.grey40),
            ),
            SizedBox(height: 24),
            Text(
              'Complete your profile',
              style: TextStyle(color: KinnectColors.white, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Add DOB and surname',
              style: TextStyle(color: KinnectColors.grey60),
            ),
          ],
        ),
      ),
    );
  }
}

