import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 05.3 -- GEDCOM Import.
/// Upload GEDCOM file from Ancestry / FamilySearch. Parsed and merged into
/// Neo4j graph. Conflict resolution UI for duplicate nodes.
class GedcomImportScreen extends StatefulWidget {
  const GedcomImportScreen({super.key});

  @override
  State<GedcomImportScreen> createState() => _GedcomImportScreenState();
}

class _GedcomImportScreenState extends State<GedcomImportScreen> {
  _ImportState _state = _ImportState.ready;
  double _progress = 0;
  int _nodesFound = 0;
  int _conflicts = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Import GEDCOM', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    switch (_state) {
      case _ImportState.ready:
        return _buildReady();
      case _ImportState.uploading:
        return _buildUploading();
      case _ImportState.parsing:
        return _buildParsing();
      case _ImportState.conflicts:
        return _buildConflicts();
      case _ImportState.complete:
        return _buildComplete();
    }
  }

  Widget _buildReady() {
    return Column(
      children: [
        const Spacer(),
        Icon(PhosphorIcons.fileArrowUp(), size: 80, color: KinnectColors.primary),
        const SizedBox(height: 24),
        const Text('Upload GEDCOM File', style: KinnectTextStyles.headlineMedium),
        const SizedBox(height: 12),
        Text(
          'Import your family tree from Ancestry, FamilySearch, or any GEDCOM-compatible platform.',
          textAlign: TextAlign.center,
          style: KinnectTextStyles.bodyLarge.copyWith(color: KinnectColors.textSecondary),
        ),
        const SizedBox(height: 32),
        _SourceButton(
          icon: PhosphorIcons.treeStructure(),
          label: 'Upload .ged File',
          subtitle: 'From device storage',
          onTap: _startImport,
        ),
        const SizedBox(height: 12),
        _SourceButton(
          icon: PhosphorIcons.globe(),
          label: 'Connect FamilySearch',
          subtitle: 'OAuth import',
          onTap: _startImport,
        ),
        const SizedBox(height: 12),
        _SourceButton(
          icon: PhosphorIcons.dna(),
          label: 'Connect Ancestry',
          subtitle: 'OAuth import',
          onTap: _startImport,
        ),
        const Spacer(),
        const Text(
          'Supported formats: GEDCOM 5.5, 5.5.1, 7.0',
          style: TextStyle(color: KinnectColors.textMuted, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildUploading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              value: _progress,
              strokeWidth: 6,
              valueColor: const AlwaysStoppedAnimation(KinnectColors.primary),
              backgroundColor: KinnectColors.surfaceElevated,
            ),
          ),
          const SizedBox(height: 24),
          const Text('Uploading file...', style: KinnectTextStyles.headlineSmall),
          const SizedBox(height: 8),
          Text('${(_progress * 100).round()}%', style: const TextStyle(color: KinnectColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildParsing() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(KinnectColors.accent)),
          const SizedBox(height: 24),
          const Text('Parsing tree data...', style: KinnectTextStyles.headlineSmall),
          const SizedBox(height: 8),
          Text('$_nodesFound nodes found so far', style: const TextStyle(color: KinnectColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildConflicts() {
    return Column(
      children: [
        Icon(PhosphorIcons.warningCircle(), size: 64, color: KinnectColors.warning),
        const SizedBox(height: 16),
        Text('$_conflicts Potential Duplicates', style: KinnectTextStyles.headlineMedium),
        const SizedBox(height: 8),
        Text(
          'We found nodes that may already exist in your Tree. Review each to merge or keep separate.',
          textAlign: TextAlign.center,
          style: KinnectTextStyles.bodyLarge.copyWith(color: KinnectColors.textSecondary),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            itemCount: _conflicts,
            itemBuilder: (context, i) => _ConflictTile(index: i),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(() => _state = _ImportState.complete),
            style: ElevatedButton.styleFrom(
              backgroundColor: KinnectColors.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Resolve All & Import'),
          ),
        ),
      ],
    );
  }

  Widget _buildComplete() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(PhosphorIcons.checkCircle(), size: 80, color: KinnectColors.success),
          const SizedBox(height: 24),
          const Text('Import Complete', style: KinnectTextStyles.headlineMedium),
          const SizedBox(height: 8),
          Text(
            '$_nodesFound nodes added to your Tree.',
            style: KinnectTextStyles.bodyLarge.copyWith(color: KinnectColors.textSecondary),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: KinnectColors.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('View Tree'),
          ),
        ],
      ),
    );
  }

  Future<void> _startImport() async {
    setState(() => _state = _ImportState.uploading);
    for (int i = 0; i <= 100; i += 10) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      setState(() => _progress = i / 100);
    }

    setState(() {
      _state = _ImportState.parsing;
      _nodesFound = 0;
    });
    for (int i = 0; i < 156; i += 12) {
      await Future<void>.delayed(const Duration(milliseconds: 80));
      if (!mounted) return;
      setState(() => _nodesFound = i);
    }
    setState(() {
      _nodesFound = 156;
      _conflicts = 3;
      _state = _ImportState.conflicts;
    });
  }
}

enum _ImportState { ready, uploading, parsing, conflicts, complete }

class _SourceButton extends StatelessWidget {
  const _SourceButton({required this.icon, required this.label, required this.subtitle, required this.onTap});
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: KinnectColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: KinnectColors.dividerSubtle),
        ),
        child: Row(
          children: [
            Icon(icon, color: KinnectColors.primary, size: 28),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: KinnectTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                Text(subtitle, style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 13)),
              ],
            ),
            const Spacer(),
            Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}

class _ConflictTile extends StatelessWidget {
  const _ConflictTile({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final names = ['Margaret Smith (b. 1945)', 'John O\'Brien (b. 1923)', 'Elizabeth Harrington (b. 1968)'];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: KinnectColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KinnectColors.warning.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(PhosphorIcons.warningCircle(), color: KinnectColors.warning, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(names[index], style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                const Text('85% match with existing node', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          TextButton(child: const Text('Merge'), onPressed: () {}),
          TextButton(child: const Text('Keep'), onPressed: () {}),
        ],
      ),
    );
  }
}
