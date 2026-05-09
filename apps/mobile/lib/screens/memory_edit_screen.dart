import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/colors.dart';
import '../theme/typography.dart';

/// Memory edit screen -- caption, visibility, Stitch permission, Strand assignment.
class MemoryEditScreen extends StatefulWidget {
  const MemoryEditScreen({super.key, required this.memoryId});

  final String memoryId;

  @override
  State<MemoryEditScreen> createState() => _MemoryEditScreenState();
}

class _MemoryEditScreenState extends State<MemoryEditScreen> {
  late final TextEditingController _captionController;
  String _visibility = 'all_kin'; // all_kin | kinnections_only | branch_only
  bool _allowStitch = true;
  bool _allowRewind = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController(text: 'Sharing a moment with Kin.');
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    // TODO: call API
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Memory updated'), backgroundColor: KinnectColors.success),
    );
    Navigator.pop(context);
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: KinnectColors.surface,
        title: const Text('Delete Memory?', style: TextStyle(color: KinnectColors.textPrimary)),
        content: const Text(
          'This Memory will be moved to "Recently Deleted" and permanently removed after 30 days.',
          style: TextStyle(color: KinnectColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Memory deleted'), backgroundColor: KinnectColors.error),
              );
            },
            child: const Text('Delete', style: TextStyle(color: KinnectColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Edit Memory', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.close, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: KinnectColors.accent))
                  : const Text('Save', style: TextStyle(color: KinnectColors.accent, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Thumbnail preview
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: KinnectColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Icon(PhosphorIcons.play(), size: 48, color: KinnectColors.textMuted)),
          ),
          const SizedBox(height: 20),

          // Caption
          _SectionLabel('Caption'),
          const SizedBox(height: 8),
          TextField(
            controller: _captionController,
            maxLines: 4,
            style: const TextStyle(color: KinnectColors.textPrimary),
            decoration: _inputDecoration('Write a caption...'),
          ),
          const SizedBox(height: 24),

          // Visibility
          _SectionLabel('Visibility'),
          const SizedBox(height: 8),
          _RadioOption(
            label: 'All Kin',
            subtitle: 'Visible to all users in your Kin Score range',
            value: 'all_kin',
            groupValue: _visibility,
            onChanged: (v) => setState(() => _visibility = v!),
          ),
          _RadioOption(
            label: 'Confirmed Kinnections Only',
            subtitle: 'Only confirmed biological connections',
            value: 'kinnections_only',
            groupValue: _visibility,
            onChanged: (v) => setState(() => _visibility = v!),
          ),
          _RadioOption(
            label: 'Branch Only',
            subtitle: 'Only members of the same Branch',
            value: 'branch_only',
            groupValue: _visibility,
            onChanged: (v) => setState(() => _visibility = v!),
          ),
          const SizedBox(height: 24),

          // Reuse permissions (PRD 12.1)
          _SectionLabel('Reuse Permissions'),
          const SizedBox(height: 8),
          _ToggleTile(
            icon: PhosphorIcons.scissors(),
            label: 'Allow Stitch',
            subtitle: 'Other Kin can include this Memory in Stitches',
            value: _allowStitch,
            onChanged: (v) => setState(() => _allowStitch = v),
          ),
          _ToggleTile(
            icon: PhosphorIcons.arrowUDownLeft(),
            label: 'Allow Rewind',
            subtitle: 'Other Kin can create Rewind reactions',
            value: _allowRewind,
            onChanged: (v) => setState(() => _allowRewind = v),
          ),
          const SizedBox(height: 32),

          // Delete
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _confirmDelete,
              icon: Icon(PhosphorIcons.trash(), size: 18),
              label: const Text('Delete Memory'),
              style: OutlinedButton.styleFrom(
                foregroundColor: KinnectColors.error,
                side: const BorderSide(color: KinnectColors.error),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: KinnectColors.textMuted),
      filled: true,
      fillColor: KinnectColors.surfaceElevated,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.all(14),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: KinnectTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600));
  }
}

class _RadioOption extends StatelessWidget {
  const _RadioOption({required this.label, required this.subtitle, required this.value, required this.groupValue, required this.onChanged});

  final String label;
  final String subtitle;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: KinnectColors.accent,
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(color: KinnectColors.textPrimary, fontSize: 14)),
      subtitle: Text(subtitle, style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({required this.icon, required this.label, required this.subtitle, required this.value, required this.onChanged});

  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeColor: KinnectColors.accent,
      contentPadding: EdgeInsets.zero,
      secondary: Icon(icon, color: KinnectColors.textSecondary),
      title: Text(label, style: const TextStyle(color: KinnectColors.textPrimary, fontSize: 14)),
      subtitle: Text(subtitle, style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
    );
  }
}
