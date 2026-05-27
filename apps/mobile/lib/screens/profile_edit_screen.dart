import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 10.1 -- Edit Root Profile.
class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late final TextEditingController _locationController;
  late final TextEditingController _surnameController;
  bool _isSaving = false;
  final bool _dnaVerified = true;
  final String _haplogroup = 'H1c3';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Elara Vance');
    _bioController = TextEditingController(text: 'Exploring my roots, one Kin at a time.');
    _locationController = TextEditingController(text: 'Portland, OR');
    _surnameController = TextEditingController(text: 'Vance');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated'), backgroundColor: KinnectColors.success),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Edit Root', style: KinnectTextStyles.headlineSmall),
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
        padding: const EdgeInsets.all(20),
        children: [
          // Profile photo
          Center(
            child: Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: KinnectColors.surfaceElevated,
                    border: Border.all(color: KinnectColors.dividerSubtle, width: 2),
                  ),
                  child: Icon(PhosphorIcons.user(), size: 48, color: KinnectColors.textMuted),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: KinnectColors.accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: KinnectColors.background, width: 2),
                    ),
                    child: Icon(PhosphorIcons.camera(), size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('Change Photo', style: TextStyle(color: KinnectColors.primary)),
            ),
          ),
          const SizedBox(height: 20),

          // Display name
          const _FieldLabel('Display Name'),
          const SizedBox(height: 6),
          _StyledTextField(controller: _nameController, hint: 'Your display name'),
          const SizedBox(height: 20),

          // Surname
          const _FieldLabel('Surname'),
          const SizedBox(height: 6),
          _StyledTextField(controller: _surnameController, hint: 'Family surname'),
          if (_dnaVerified)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Icon(PhosphorIcons.dna(), size: 14, color: KinnectColors.accent),
                  const SizedBox(width: 4),
                  const Text(
                    'DNA verified -- displayed in accent colour',
                    style: TextStyle(color: KinnectColors.accent, fontSize: 12),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),

          // Bio
          const _FieldLabel('Bio'),
          const SizedBox(height: 6),
          _StyledTextField(controller: _bioController, hint: 'Tell your Kin about yourself', maxLines: 3),
          const SizedBox(height: 20),

          // Location
          const _FieldLabel('Location'),
          const SizedBox(height: 6),
          _StyledTextField(controller: _locationController, hint: 'City, State/Country'),
          const SizedBox(height: 20),

          // Haplogroup (read-only)
          const _FieldLabel('Haplogroup'),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: KinnectColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(PhosphorIcons.dna(), size: 20, color: KinnectColors.primary),
                const SizedBox(width: 10),
                Text(_haplogroup, style: const TextStyle(color: KinnectColors.textPrimary, fontSize: 15)),
                const Spacer(),
                const Text('DNA Connected', style: TextStyle(color: KinnectColors.success, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Voiceprint status
          const _FieldLabel('Voiceprint'),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: KinnectColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(PhosphorIcons.microphone(), size: 20, color: KinnectColors.success),
                const SizedBox(width: 10),
                const Text('Voiceprint captured', style: TextStyle(color: KinnectColors.textPrimary, fontSize: 15)),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text('Manage', style: TextStyle(color: KinnectColors.primary, fontSize: 13)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: KinnectTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600, fontSize: 14));
  }
}

class _StyledTextField extends StatelessWidget {
  const _StyledTextField({required this.controller, required this.hint, this.maxLines = 1});
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: KinnectColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: KinnectColors.textMuted),
        filled: true,
        fillColor: KinnectColors.surfaceElevated,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.all(14),
      ),
    );
  }
}
