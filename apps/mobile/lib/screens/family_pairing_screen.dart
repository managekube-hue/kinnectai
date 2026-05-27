import 'package:flutter/material.dart';
import '../theme/colors.dart';

class FamilyPairingScreen extends StatefulWidget {
  const FamilyPairingScreen({super.key});

  @override
  State<FamilyPairingScreen> createState() => _FamilyPairingScreenState();
}

class _FamilyPairingScreenState extends State<FamilyPairingScreen> {
  final List<TeenAccount> _pairedAccounts = [];

  @override
  void initState() {
    super.initState();
    _loadPairedAccounts();
  }

  void _loadPairedAccounts() {
    setState(() {
      _pairedAccounts.addAll([
        TeenAccount(
          name: 'Sarah Chen',
          age: 15,
          dailyLimit: 120,
          currentUsage: 87,
          accountType: 'Private',
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Family Pairing'),
      ),
      body: _pairedAccounts.isEmpty ? _buildEmptyState() : _buildPairedAccounts(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTeenDialog,
        backgroundColor: KinnectColors.accent,
        icon: const Icon(Icons.person_add, color: KinnectColors.background),
        label: const Text('Add Teen', style: TextStyle(color: KinnectColors.background)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.family_restroom, size: 80, color: KinnectColors.textMuted),
          const SizedBox(height: 24),
          const Text(
            'Family Pairing',
            style: TextStyle(color: KinnectColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'COPPA-compliant parental controls for teen accounts',
              textAlign: TextAlign.center,
              style: TextStyle(color: KinnectColors.textSecondary, fontSize: 16),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _showAddTeenDialog,
            icon: const Icon(Icons.person_add),
            label: const Text('Add Teen Account'),
            style: ElevatedButton.styleFrom(
              backgroundColor: KinnectColors.accent,
              foregroundColor: KinnectColors.background,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPairedAccounts() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pairedAccounts.length,
      itemBuilder: (context, index) {
        final account = _pairedAccounts[index];
        return Card(
          color: KinnectColors.surface,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: KinnectColors.accent.withOpacity(0.2),
                      child: Text(
                        account.name[0],
                        style: const TextStyle(color: KinnectColors.accent, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            account.name,
                            style: const TextStyle(color: KinnectColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Age ${account.age} â€¢ ${account.accountType}',
                            style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: KinnectColors.accent),
                      onPressed: () => _showAccountSettings(account),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: KinnectColors.dividerSubtle),
                const SizedBox(height: 16),
                _buildUsageBar(account),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildControlChip('Screen Time', Icons.timer, () => _showScreenTimeDialog(account)),
                    _buildControlChip('Content', Icons.tune, () {}),
                    _buildControlChip('Messages', Icons.message, () {}),
                    _buildControlChip('Privacy', Icons.privacy_tip, () {}),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUsageBar(TeenAccount account) {
    final percentage = (account.currentUsage / account.dailyLimit).clamp(0.0, 1.0);
    final remaining = account.dailyLimit - account.currentUsage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Today\'s Usage', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            Text(
              '$remaining min remaining',
              style: TextStyle(
                color: remaining < 30 ? KinnectColors.error : KinnectColors.success,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8,
            backgroundColor: KinnectColors.dividerSubtle,
            valueColor: AlwaysStoppedAnimation<Color>(
              percentage > 0.9 ? KinnectColors.error : percentage > 0.7 ? KinnectColors.warning : KinnectColors.success,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${account.currentUsage} / ${account.dailyLimit} min',
          style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildControlChip(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Chip(
        avatar: Icon(icon, color: KinnectColors.accent, size: 16),
        label: Text(label, style: const TextStyle(color: KinnectColors.textPrimary, fontSize: 12)),
        backgroundColor: KinnectColors.background,
      ),
    );
  }

  void _showAddTeenDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: KinnectColors.surface,
        title: const Text('Add Teen Account', style: TextStyle(color: KinnectColors.textPrimary)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: TextStyle(color: KinnectColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Teen\'s Name',
                labelStyle: TextStyle(color: KinnectColors.textSecondary),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: KinnectColors.textMuted)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              style: TextStyle(color: KinnectColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                labelStyle: TextStyle(color: KinnectColors.textSecondary),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: KinnectColors.textMuted)),
              ),
              keyboardType: TextInputType.datetime,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: KinnectColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Teen account request sent'),
                  backgroundColor: KinnectColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: KinnectColors.accent),
            child: const Text('Send Invite', style: TextStyle(color: KinnectColors.background)),
          ),
        ],
      ),
    );
  }

  void _showAccountSettings(TeenAccount account) {
    showModalBottomSheet(
      context: context,
      backgroundColor: KinnectColors.surface,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${account.name} Settings',
              style: const TextStyle(color: KinnectColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.timer, color: KinnectColors.accent),
              title: const Text('Daily Time Limit', style: TextStyle(color: KinnectColors.textPrimary)),
              subtitle: Text('${account.dailyLimit} minutes', style: const TextStyle(color: KinnectColors.textSecondary)),
              onTap: () => _showScreenTimeDialog(account),
            ),
            ListTile(
              leading: const Icon(Icons.visibility, color: KinnectColors.accent),
              title: const Text('Account Type', style: TextStyle(color: KinnectColors.textPrimary)),
              subtitle: Text(account.accountType, style: const TextStyle(color: KinnectColors.textSecondary)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.message, color: KinnectColors.accent),
              title: const Text('Message Restrictions', style: TextStyle(color: KinnectColors.textPrimary)),
              subtitle: const Text('Confirmed Kinnections only', style: TextStyle(color: KinnectColors.textSecondary)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: KinnectColors.error),
              title: const Text('Remove Pairing', style: TextStyle(color: KinnectColors.error)),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _showScreenTimeDialog(TeenAccount account) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: KinnectColors.surface,
        title: const Text('Daily Time Limit', style: TextStyle(color: KinnectColors.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${account.dailyLimit} minutes',
              style: const TextStyle(color: KinnectColors.accent, fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: account.dailyLimit.toDouble(),
              min: 30,
              max: 300,
              divisions: 27,
              activeColor: KinnectColors.accent,
              label: '${account.dailyLimit} min',
              onChanged: (value) {
                setState(() => account.dailyLimit = value.toInt());
              },
            ),
            const Text(
              'Teen will be warned at 80% of limit',
              style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: KinnectColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: KinnectColors.accent),
            child: const Text('Save', style: TextStyle(color: KinnectColors.background)),
          ),
        ],
      ),
    );
  }
}

class TeenAccount {
  final String name;
  final int age;
  int dailyLimit;
  final int currentUsage;
  final String accountType;

  TeenAccount({
    required this.name,
    required this.age,
    required this.dailyLimit,
    required this.currentUsage,
    required this.accountType,
  });
}

