import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 02.2 -- Photplay Studio.
/// Five-step flow: Photo Selection -> Voice Selection -> Quality ->
/// Rendering -> Output.
class PhotplayScreen extends StatefulWidget {
	const PhotplayScreen({super.key});

	@override
	State<PhotplayScreen> createState() => _PhotplayScreenState();
}

class _PhotplayScreenState extends State<PhotplayScreen> {
	int _step = 0;
	String? _photoPath;
	String _voiceOption = 'record'; // record | voiceprint | text
	String _quality = 'standard'; // standard | premium
	bool _isRendering = false;
	double _renderProgress = 0;

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
				title: Text('Photplay Studio', style: KinnectTextStyles.headlineSmall),
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
			// ...existing code for the rest of the widget tree...
		);
	}
}
