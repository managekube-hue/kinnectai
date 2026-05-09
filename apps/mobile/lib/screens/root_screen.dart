import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../router/app_nav.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Root'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings coming soon!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.deepPurple.shade100,
                child: const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                authService.currentUser ?? 'Guest',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Kin Score: --',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Card(
              child: ListTile(
                leading: const Icon(Icons.family_restroom, color: Colors.deepPurple),
                title: const Text('Kinnections'),
                subtitle: const Text('Manage your family connections'),
                trailing: Icon(PhosphorIcons.caretRight()),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kinnections management coming soon!')),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.science, color: Colors.deepPurple),
                title: const Text('DNA Kit'),
                subtitle: const Text('Submit or check DNA kit status'),
                trailing: Icon(PhosphorIcons.caretRight()),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('DNA kit management coming soon!')),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.people, color: Colors.deepPurple),
                title: const Text('Surname Search'),
                subtitle: const Text('Find relatives by surname'),
                trailing: Icon(PhosphorIcons.caretRight()),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Surname search coming soon!')),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  authService.logout();
                  AppNav.go(context, '/login');
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



