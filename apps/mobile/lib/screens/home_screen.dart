import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'line_screen.dart';
import 'repost_stitch_screen.dart';
import 'discovery_page_screen.dart';
import 'tree_graph_screen.dart';
import 'root_profile_screen.dart';
import '../router/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const LineScreen(),
    const RepostStitchScreen(),
    const DiscoveryPageScreen(),
    const TreeGraphScreen(),
    const RootProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: KinnectColors.darkSurface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home, 'Home'),
                _buildNavItem(1, Icons.repeat, 'Repost'),
                _buildCreateButton(),
                _buildNavItem(3, Icons.account_tree_outlined, 'Tree'),
                _buildNavItem(4, Icons.person_outline, 'Root'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? KinnectColors.amber : KinnectColors.grey60,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? KinnectColors.white : KinnectColors.grey60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return GestureDetector(
      onTap: () => AppRouter.showCreateSheet(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: KinnectColors.amber,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.add,
          color: KinnectColors.darkBg,
          size: 32,
        ),
      ),
    );
  }
}

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Pulse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Root',
          ),
        ],
      ),
    );
  }
}
