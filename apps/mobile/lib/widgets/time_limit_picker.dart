import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/design_system.dart';

class TimeLimitPicker extends StatefulWidget {
  final Duration initialLimit;
  final Duration maxLimit;

  const TimeLimitPicker({
    super.key,
    required this.initialLimit,
    required this.maxLimit,
  });

  @override
  State<TimeLimitPicker> createState() => _TimeLimitPickerState();
}

class _TimeLimitPickerState extends State<TimeLimitPicker> {
  late int _hours;
  late int _minutes;

  @override
  void initState() {
    super.initState();
    _hours = widget.initialLimit.inHours;
    _minutes = widget.initialLimit.inMinutes.remainder(60);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: KinnectColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Set Daily Limit', style: DesignTextStyles.headlineMedium),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPicker(
                value: _hours,
                max: widget.maxLimit.inHours,
                label: 'hours',
                onChanged: (val) => setState(() => _hours = val),
              ),
              const SizedBox(width: 20),
              Text(':', style: DesignTextStyles.headlineLarge),
              const SizedBox(width: 20),
              _buildPicker(
                value: _minutes,
                max: 59,
                label: 'minutes',
                step: 15,
                onChanged: (val) => setState(() => _minutes = val),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Maximum: ${widget.maxLimit.inHours}h 0m',
            style: DesignTextStyles.bodySmall.copyWith(color: DesignColors.darkHint),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final duration = Duration(hours: _hours, minutes: _minutes);
            Navigator.pop(context, duration);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: KinnectColors.accent,
            foregroundColor: KinnectColors.background,
          ),
          child: const Text('Set Limit'),
        ),
      ],
    );
  }

  Widget _buildPicker({
    required int value,
    required int max,
    required String label,
    int step = 1,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_up, color: KinnectColors.accent),
          onPressed: () {
            if (value + step <= max) onChanged(value + step);
          },
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: KinnectColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: DesignTextStyles.headlineLarge,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: KinnectColors.accent),
          onPressed: () {
            if (value - step >= 0) onChanged(value - step);
          },
        ),
        Text(label, style: DesignTextStyles.bodySmall),
      ],
    );
  }
}
