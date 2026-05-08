import 'package:flutter/material.dart';
import '../theme/colors.dart';

class BranchMembersScreen extends StatefulWidget {
  final String branchId;

  const BranchMembersScreen({super.key, required this.branchId});

  @override
  State<BranchMembersScreen> createState() => _BranchMembersScreenState();
}

class _BranchMembersScreenState extends State<BranchMembersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Branch Members (${widget.branchId})'),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: 12,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: KinnectColors.surfaceElevated,
              ),
              child: const Icon(Icons.person_outline, size: 20),
            ),
            title: Text('Member ${index + 1}'),
            subtitle: const Text('Family relation • Last active 2d'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          );
        },
      ),
    );
  }
}
