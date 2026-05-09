import 'package:flutter/material.dart';

class FamilyPairingSetupScreen extends StatefulWidget {
  const FamilyPairingSetupScreen({super.key});

  @override
  State<FamilyPairingSetupScreen> createState() => _FamilyPairingSetupScreenState();
}

class _FamilyPairingSetupScreenState extends State<FamilyPairingSetupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _emailController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  Future<void> _sendInvite() async {
    if (_emailController.text.trim().isEmpty ||
        _relationshipController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and relationship are required.')),
      );
      return;
    }

    setState(() => _sending = true);
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() => _sending = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pairing invite sent.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Family Pairing Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Family member email',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _relationshipController,
              decoration: const InputDecoration(
                labelText: 'Relationship',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _sending ? null : _sendInvite,
                child: _sending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Send Invite'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
