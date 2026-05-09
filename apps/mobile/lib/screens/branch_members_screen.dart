import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 06.1 -- Branch Members list.
/// Shows all confirmed members of a Branch sorted by Kin Score to the viewer.
class BranchMembersScreen extends StatefulWidget {
  const BranchMembersScreen({super.key, required this.branchId});

  final String branchId;

  @override
  State<BranchMembersScreen> createState() => _BranchMembersScreenState();
}

class _BranchMembersScreenState extends State<BranchMembersScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  // TODO: fetch from repository
  static final _members = List.generate(20, (i) => _MemberData(
    id: 'user_$i',
    name: [
      'James Harrington', 'Emily Harrington', 'Michael O\'Brien', 'Sarah Vance',
      'Daniel Murphy', 'Katie Walsh', 'Thomas Harrington', 'Grace O\'Sullivan',
      'Patrick Byrne', 'Aoife Kelly', 'Liam Harrington', 'Ciara Doyle',
      'Sean Murphy', 'Niamh Harrington', 'Conor Ryan', 'Siobhan Walsh',
      'Declan Harrington', 'Roisin Burke', 'Eoin Gallagher', 'Maeve Harrington',
    ][i],
    relationship: ['Parent', '1st Cousin', '2nd Cousin', '3rd Cousin', 'Half-Sibling'][i % 5],
    kinScore: [0.50, 0.25, 0.125, 0.0625, 0.25][i % 5],
    lastActive: ['2h', '1d', '3d', '1w', '2w'][i % 5],
    isOnline: i % 3 == 0,
  ));

  List<_MemberData> get _filtered => _query.isEmpty
      ? _members
      : _members.where((m) => m.name.toLowerCase().contains(_query.toLowerCase())).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Branch Members', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(12),
            color: KinnectColors.surface,
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              style: const TextStyle(color: KinnectColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search members...',
                hintStyle: TextStyle(color: KinnectColors.textMuted),
                prefixIcon: Icon(PhosphorIcons.magnifyingGlass(), color: KinnectColors.textMuted),
                filled: true,
                fillColor: KinnectColors.surfaceElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),

          // Member count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${_filtered.length} members',
                  style: TextStyle(color: KinnectColors.textSecondary, fontSize: 13),
                ),
                const Spacer(),
                Text('Sorted by Kin Score', style: TextStyle(color: KinnectColors.textMuted, fontSize: 12)),
              ],
            ),
          ),

          // Member list
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (context, i) => _MemberTile(member: _filtered[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberData {
  const _MemberData({
    required this.id,
    required this.name,
    required this.relationship,
    required this.kinScore,
    required this.lastActive,
    required this.isOnline,
  });

  final String id;
  final String name;
  final String relationship;
  final double kinScore;
  final String lastActive;
  final bool isOnline;
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({required this.member});

  final _MemberData member;

  @override
  Widget build(BuildContext context) {
    final scoreColor = member.kinScore >= 0.25
        ? KinnectColors.accent
        : member.kinScore >= 0.125
            ? KinnectColors.primary
            : KinnectColors.textSecondary;

    return ListTile(
      onTap: () => AppNav.push(context, '/root/${member.id}'),
      leading: Stack(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: KinnectColors.surfaceElevated,
            ),
            child: Icon(PhosphorIcons.user(), size: 22, color: KinnectColors.textMuted),
          ),
          if (member.isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: KinnectColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: KinnectColors.background, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(member.name, style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
      subtitle: Text(
        '${member.relationship} -- Last active ${member.lastActive}',
        style: TextStyle(color: KinnectColors.textSecondary, fontSize: 13),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: scoreColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '${(member.kinScore * 100).round()}%',
          style: TextStyle(color: scoreColor, fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
