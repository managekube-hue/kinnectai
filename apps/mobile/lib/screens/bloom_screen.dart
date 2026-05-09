import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 02.2 -- Bloom Studio.
/// Five-step flow: Photo Selection -> Voice Selection -> Quality ->
/// Rendering -> Output.
class BloomScreen extends StatefulWidget {
  const BloomScreen({super.key});

  @override
  State<BloomScreen> createState() => _BloomScreenState();
}

class _BloomScreenState extends State<BloomScreen> {
  int _step = 0;
  String? _photoPath;
  String _voiceOption = 'record'; // record | voiceprint | text
  String _quality = 'standard'; // standard | premium
  bool _isRendering = false;
  double _renderProgress = 0;
  int _bloomCredits = 5; // TODO: fetch from CommerceCubit

  static const _stepLabels = ['Photo', 'Voice', 'Quality', 'Render', 'Preview'];

  void _nextStep() {
    if (_step < 4) setState(() => _step++);
  }

  void _prevStep() {
    if (_step > 0) setState(() => _step--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: _step > 0 ? _prevStep : () => Navigator.pop(context),
        ),
        title: Text('Bloom Studio', style: KinnectTextStyles.headlineSmall),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_step + 1}/5',
                style: KinnectTextStyles.bodyLarge.copyWith(color: KinnectColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Step indicator
          _StepBar(currentStep: _step, labels: _stepLabels),

          // Step content
          Expanded(child: _buildStep()),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _PhotoSelectionStep(
          photoPath: _photoPath,
          onPhotoSelected: (path) {
            setState(() => _photoPath = path);
            _nextStep();
          },
        );
      case 1:
        return _VoiceSelectionStep(
          selected: _voiceOption,
          onChanged: (v) => setState(() => _voiceOption = v),
          onNext: _nextStep,
        );
      case 2:
        return _QualityStep(
          selected: _quality,
          credits: _bloomCredits,
          onChanged: (q) => setState(() => _quality = q),
          onNext: () {
            _nextStep();
            _startRender();
          },
        );
      case 3:
        return _RenderingStep(progress: _renderProgress);
      case 4:
        return _OutputStep(
          onShare: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Bloom published to The Line'), backgroundColor: KinnectColors.success),
            );
            Navigator.pop(context);
          },
          onSaveToCameraRoll: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Saved to camera roll'), backgroundColor: KinnectColors.success),
            );
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _startRender() async {
    setState(() => _isRendering = true);
    // Simulate rendering progress
    for (int i = 0; i <= 100; i += 5) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      setState(() => _renderProgress = i / 100);
    }
    setState(() => _isRendering = false);
    _nextStep();
  }
}

// ---------------------------------------------------------------------------
// Step 1: Photo Selection
// ---------------------------------------------------------------------------
class _PhotoSelectionStep extends StatelessWidget {
  const _PhotoSelectionStep({this.photoPath, required this.onPhotoSelected});

  final String? photoPath;
  final ValueChanged<String> onPhotoSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text('Select a Photo', style: KinnectTextStyles.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Upload from camera roll, take a new photo, or select from your Tree.',
            textAlign: TextAlign.center,
            style: KinnectTextStyles.bodyLarge.copyWith(color: KinnectColors.textSecondary),
          ),
          const SizedBox(height: 32),
          // Photo preview area
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: KinnectColors.surfaceElevated,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: KinnectColors.dividerSubtle, width: 2),
            ),
            child: photoPath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(File(photoPath!), fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(PhosphorIcons.image(), size: 48, color: KinnectColors.textMuted),
                      const SizedBox(height: 8),
                      Text('No photo selected', style: TextStyle(color: KinnectColors.textMuted, fontSize: 13)),
                    ],
                  ),
          ),
          const SizedBox(height: 32),
          _ActionButton(
            icon: PhosphorIcons.uploadSimple(),
            label: 'Upload from Camera Roll',
            onTap: () => onPhotoSelected('/placeholder/photo.jpg'),
          ),
          const SizedBox(height: 12),
          _ActionButton(
            icon: PhosphorIcons.camera(),
            label: 'Take New Photo',
            onTap: () => onPhotoSelected('/placeholder/camera.jpg'),
          ),
          const SizedBox(height: 12),
          _ActionButton(
            icon: PhosphorIcons.treeStructure(),
            label: 'Select from Tree',
            onTap: () => onPhotoSelected('/placeholder/tree.jpg'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Step 2: Voice Selection
// ---------------------------------------------------------------------------
class _VoiceSelectionStep extends StatelessWidget {
  const _VoiceSelectionStep({required this.selected, required this.onChanged, required this.onNext});

  final String selected;
  final ValueChanged<String> onChanged;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text('Add Voice', style: KinnectTextStyles.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Choose how to bring this photo to life.',
            textAlign: TextAlign.center,
            style: KinnectTextStyles.bodyLarge.copyWith(color: KinnectColors.textSecondary),
          ),
          const SizedBox(height: 32),
          _VoiceOptionTile(
            icon: PhosphorIcons.microphone(),
            title: 'Record Live Voice',
            subtitle: 'Up to 2 minutes',
            selected: selected == 'record',
            onTap: () => onChanged('record'),
          ),
          const SizedBox(height: 12),
          _VoiceOptionTile(
            icon: PhosphorIcons.waveform(),
            title: 'Use Saved Voiceprint',
            subtitle: 'Select from your voiceprints',
            selected: selected == 'voiceprint',
            onTap: () => onChanged('voiceprint'),
          ),
          const SizedBox(height: 12),
          _VoiceOptionTile(
            icon: PhosphorIcons.textT(),
            title: 'Type Text',
            subtitle: 'AI synthesises speech via ElevenLabs',
            selected: selected == 'text',
            onTap: () => onChanged('text'),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: KinnectColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }
}

class _VoiceOptionTile extends StatelessWidget {
  const _VoiceOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? KinnectColors.accent.withOpacity(0.1) : KinnectColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? KinnectColors.accent : KinnectColors.dividerSubtle),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? KinnectColors.accent : KinnectColors.textSecondary, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: KinnectTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                  Text(subtitle, style: TextStyle(color: KinnectColors.textSecondary, fontSize: 13)),
                ],
              ),
            ),
            if (selected)
              Icon(PhosphorIcons.checkCircle(), color: KinnectColors.accent),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Step 3: Quality
// ---------------------------------------------------------------------------
class _QualityStep extends StatelessWidget {
  const _QualityStep({required this.selected, required this.credits, required this.onChanged, required this.onNext});

  final String selected;
  final int credits;
  final ValueChanged<String> onChanged;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text('Choose Quality', style: KinnectTextStyles.headlineMedium),
          const SizedBox(height: 24),
          _VoiceOptionTile(
            icon: PhosphorIcons.sparkle(),
            title: 'Standard (Free)',
            subtitle: 'SadTalker OSS -- 2-4 min processing',
            selected: selected == 'standard',
            onTap: () => onChanged('standard'),
          ),
          const SizedBox(height: 12),
          _VoiceOptionTile(
            icon: PhosphorIcons.diamond(),
            title: 'Premium (1 Bloom Credit)',
            subtitle: 'D-ID API -- 60-90 sec, higher quality',
            selected: selected == 'premium',
            onTap: () => onChanged('premium'),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: KinnectColors.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(PhosphorIcons.coins(), size: 18, color: KinnectColors.accent),
                const SizedBox(width: 8),
                Text(
                  'Balance: $credits Bloom Credits',
                  style: KinnectTextStyles.bodyLarge.copyWith(color: KinnectColors.textSecondary),
                ),
              ],
            ),
          ),
          if (credits == 0 && selected == 'premium') ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => AppNav.push(context, '/settings/balance'),
              child: Text('Buy Credits', style: TextStyle(color: KinnectColors.accent)),
            ),
          ],
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (selected == 'premium' && credits == 0) ? null : onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: KinnectColors.accent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: KinnectColors.surfaceElevated,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Start Rendering'),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Step 4: Rendering
// ---------------------------------------------------------------------------
class _RenderingStep extends StatelessWidget {
  const _RenderingStep({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).round();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 6,
                    valueColor: const AlwaysStoppedAnimation(KinnectColors.accent),
                    backgroundColor: KinnectColors.surfaceElevated,
                  ),
                  Text('$pct%', style: KinnectTextStyles.headlineMedium),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Creating your Bloom...', style: KinnectTextStyles.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'You can leave the app. We\'ll send a notification when it\'s ready.',
              textAlign: TextAlign.center,
              style: KinnectTextStyles.bodyLarge.copyWith(color: KinnectColors.textSecondary),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: KinnectColors.textSecondary,
                side: const BorderSide(color: KinnectColors.dividerSubtle),
              ),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Step 5: Output
// ---------------------------------------------------------------------------
class _OutputStep extends StatelessWidget {
  const _OutputStep({required this.onShare, required this.onSaveToCameraRoll});

  final VoidCallback onShare;
  final VoidCallback onSaveToCameraRoll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Preview placeholder
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: KinnectColors.surfaceElevated,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(PhosphorIcons.play(), size: 64, color: KinnectColors.accent),
                  const SizedBox(height: 12),
                  Text('Bloom Preview', style: KinnectTextStyles.headlineSmall),
                  const SizedBox(height: 4),
                  Text('Tap to play', style: TextStyle(color: KinnectColors.textSecondary)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onShare,
              icon: Icon(PhosphorIcons.shareNetwork(), size: 18),
              label: const Text('Share to The Line'),
              style: ElevatedButton.styleFrom(
                backgroundColor: KinnectColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onSaveToCameraRoll,
              icon: Icon(PhosphorIcons.downloadSimple(), size: 18),
              label: const Text('Save to Camera Roll'),
              style: OutlinedButton.styleFrom(
                foregroundColor: KinnectColors.textPrimary,
                side: const BorderSide(color: KinnectColors.dividerSubtle),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared widgets
// ---------------------------------------------------------------------------

class _StepBar extends StatelessWidget {
  const _StepBar({required this.currentStep, required this.labels});

  final int currentStep;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: KinnectColors.surface,
      child: Row(
        children: List.generate(labels.length, (i) {
          final active = i <= currentStep;
          return Expanded(
            child: Column(
              children: [
                Container(
                  height: 3,
                  margin: EdgeInsets.only(right: i < labels.length - 1 ? 4 : 0),
                  decoration: BoxDecoration(
                    color: active ? KinnectColors.accent : KinnectColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 10,
                    color: active ? KinnectColors.accent : KinnectColors.textMuted,
                    fontWeight: i == currentStep ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: KinnectColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: KinnectColors.dividerSubtle),
        ),
        child: Row(
          children: [
            Icon(icon, color: KinnectColors.accent, size: 22),
            const SizedBox(width: 12),
            Text(label, style: KinnectTextStyles.bodyLarge),
            const Spacer(),
            Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}
