import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../cubits/steward_consent_cubit.dart';
import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Addendum 1.0 Gap 6 -- Steward Consent Flow.
/// Four-step flow: Selection -> Agreement -> Confirmation -> Completion.
class StewardAgreementScreen extends StatefulWidget {
  const StewardAgreementScreen({super.key, this.memoryId});

  final String? memoryId;

  @override
  State<StewardAgreementScreen> createState() => _StewardAgreementScreenState();
}

class _StewardAgreementScreenState extends State<StewardAgreementScreen> {
  int _step = 0;
  String? _selectedStewardId;
  String _selectedStewardName = '';
  bool _consentChecked = false;

  static const _stepLabels = ['Select Steward', 'Agreement', 'Confirmation', 'Complete'];

  // TODO: fetch from confirmed Kinnections
  static final _kinnections = [
    _KinOption(id: 'user_1', name: 'Emily Harrington', relationship: 'Parent', kinScore: 0.50),
    _KinOption(id: 'user_2', name: 'James Harrington', relationship: '1st Cousin', kinScore: 0.25),
    _KinOption(id: 'user_3', name: 'Sarah Vance', relationship: 'Sibling', kinScore: 0.50),
    _KinOption(id: 'user_4', name: 'Michael O\'Brien', relationship: '2nd Cousin', kinScore: 0.125),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Steward Designation', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: _step > 0 ? () => setState(() => _step--) : () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text('${_step + 1}/4', style: TextStyle(color: KinnectColors.textSecondary)),
            ),
          ),
        ],
      ),
      body: _buildStep(),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _buildSelection();
      case 1:
        return _buildAgreement();
      case 2:
        return _buildConfirmation();
      case 3:
        return _buildCompletion();
      default:
        return const SizedBox.shrink();
    }
  }

  // Step 1: Select Steward from confirmed Kinnections
  Widget _buildSelection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(PhosphorIcons.shield(), size: 48, color: KinnectColors.accent),
              const SizedBox(height: 12),
              Text('Select a Steward', style: KinnectTextStyles.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'Choose a confirmed Kinnection to serve as Steward for your Memory Box.',
                textAlign: TextAlign.center,
                style: TextStyle(color: KinnectColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _kinnections.length,
            itemBuilder: (context, i) {
              final kin = _kinnections[i];
              final selected = _selectedStewardId == kin.id;
              return GestureDetector(
                onTap: () => setState(() {
                  _selectedStewardId = kin.id;
                  _selectedStewardName = kin.name;
                }),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: selected ? KinnectColors.accent.withOpacity(0.1) : KinnectColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: selected ? KinnectColors.accent : KinnectColors.dividerSubtle),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: KinnectColors.surfaceElevated),
                        child: Icon(PhosphorIcons.user(), size: 22, color: KinnectColors.textMuted),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(kin.name, style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
                            Text('${kin.relationship} -- ${(kin.kinScore * 100).round()}% Kin Score', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 13)),
                          ],
                        ),
                      ),
                      if (selected) Icon(PhosphorIcons.checkCircle(), color: KinnectColors.accent),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedStewardId != null ? () => setState(() => _step = 1) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: KinnectColors.accent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: KinnectColors.surfaceElevated,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Select as Steward'),
            ),
          ),
        ),
      ],
    );
  }

  // Step 2: Legal agreement
  Widget _buildAgreement() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Icon(PhosphorIcons.fileText(), size: 48, color: KinnectColors.primary),
        const SizedBox(height: 16),
        Text('Steward Agreement', style: KinnectTextStyles.headlineMedium, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text('for Posthumous Memory Delivery', style: TextStyle(color: KinnectColors.textSecondary), textAlign: TextAlign.center),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: KinnectColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: KinnectColors.dividerSubtle),
          ),
          child: Text(
            'You are designating $_selectedStewardName as the custodian of this Memory Box item.\n\n'
            'Upon verification of your death, $_selectedStewardName will have the authority to:\n\n'
            '  \u2022 Confirm death signals (SSDI match, obituary, biometric inactivity)\n'
            '  \u2022 Authorize delivery of this encrypted Memory to the designated recipient\n'
            '  \u2022 Manage trigger settings if circumstances change\n\n'
            'This designation is legally binding per the KinnectAI Steward Agreement. '
            '$_selectedStewardName must independently confirm this designation via their account '
            'before this Memory can be sealed.',
            style: const TextStyle(color: KinnectColors.textPrimary, height: 1.6, fontSize: 14),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {},
          child: Text('View full Steward Agreement (PDF)', style: TextStyle(color: KinnectColors.primary)),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          value: _consentChecked,
          onChanged: (v) => setState(() => _consentChecked = v ?? false),
          activeColor: KinnectColors.accent,
          title: const Text(
            'I understand and authorize this Steward designation.',
            style: TextStyle(color: KinnectColors.textPrimary, fontSize: 14),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _consentChecked ? () => setState(() => _step = 2) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: KinnectColors.accent,
              foregroundColor: Colors.white,
              disabledBackgroundColor: KinnectColors.surfaceElevated,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Send Steward Request'),
          ),
        ),
      ],
    );
  }

  // Step 3: Waiting for steward confirmation
  Widget _buildConfirmation() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: KinnectColors.warning.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(PhosphorIcons.clock(), size: 40, color: KinnectColors.warning),
            ),
            const SizedBox(height: 24),
            Text('Waiting for Confirmation', style: KinnectTextStyles.headlineMedium),
            const SizedBox(height: 12),
            Text(
              '$_selectedStewardName has been notified via push notification, in-app alert, and email.\n\n'
              'They must log in, review the agreement, and confirm via biometric re-authentication.\n\n'
              'Request expires in 14 days.',
              textAlign: TextAlign.center,
              style: TextStyle(color: KinnectColors.textSecondary, height: 1.6),
            ),
            const SizedBox(height: 32),
            // Simulate confirmation for demo
            ElevatedButton(
              onPressed: () => setState(() => _step = 3),
              style: ElevatedButton.styleFrom(
                backgroundColor: KinnectColors.success,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Steward Confirmed (demo)'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: KinnectColors.textSecondary,
                side: const BorderSide(color: KinnectColors.dividerSubtle),
              ),
              child: const Text('Close & Wait'),
            ),
          ],
        ),
      ),
    );
  }

  // Step 4: Complete
  Widget _buildCompletion() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(PhosphorIcons.checkCircle(), size: 80, color: KinnectColors.success),
            const SizedBox(height: 24),
            Text('Steward Designated', style: KinnectTextStyles.headlineMedium),
            const SizedBox(height: 12),
            Text(
              '$_selectedStewardName has confirmed the Steward designation. Your Memory can now be sealed.',
              textAlign: TextAlign.center,
              style: TextStyle(color: KinnectColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: KinnectColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Continue to Seal Memory'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KinOption {
  const _KinOption({required this.id, required this.name, required this.relationship, required this.kinScore});
  final String id;
  final String name;
  final String relationship;
  final double kinScore;
}
