import 'package:flutter/material.dart';

class LineFeedScreen extends StatefulWidget {
  const LineFeedScreen({super.key});

  @override
  _LineFeedScreenState createState() => _LineFeedScreenState();
}

class _LineFeedScreenState extends State<LineFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The Line'),
      ),
      body: Center(
        child: Text('KinnectAI Line Feed - Coming Soon'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Line'),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'Bloom'),
          BottomNavigationBarItem(icon: Icon(Icons.account_tree), label: 'Tree'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Pulse'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Root'),
        ],
      ),
    );
  }
}