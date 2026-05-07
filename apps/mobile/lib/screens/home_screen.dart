import 'package:flutter/material.dart';
import 'line_feed_screen.dart';
import 'bloom_screen.dart';
import 'tree_screen.dart';
import 'pulse_screen.dart';
import 'root_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const LineFeedScreen(),
    const BloomScreen(),
    const TreeScreen(),
    const PulseScreen(),
    const RootScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Line',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Bloom',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_tree),
            label: 'Tree',
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
