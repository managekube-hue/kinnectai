import 'package:flutter/material.dart';
import '../theme/colors.dart';

class NightModeScreen extends StatefulWidget {
  const NightModeScreen({super.key});

  @override
  State<NightModeScreen> createState() => _NightModeScreenState();
}

class _NightModeScreenState extends State<NightModeScreen> {
  bool _enabled = false;
  TimeOfDay _startTime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 7, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Night Mode Schedule'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable Night Mode', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Grayscale + mute notifications', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            value: _enabled,
            activeColor: KinnectColors.accent,
            onChanged: (value) => setState(() => _enabled = value),
          ),
          ListTile(
            title: const Text('Start time', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: Text(_startTime.format(context), style: const TextStyle(color: KinnectColors.accent)),
            enabled: _enabled,
            onTap: () async {
              final time = await showTimePicker(context: context, initialTime: _startTime);
              if (time != null) setState(() => _startTime = time);
            },
          ),
          ListTile(
            title: const Text('End time', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: Text(_endTime.format(context), style: const TextStyle(color: KinnectColors.accent)),
            enabled: _enabled,
            onTap: () async {
              final time = await showTimePicker(context: context, initialTime: _endTime);
              if (time != null) setState(() => _endTime = time);
            },
          ),
        ],
      ),
    );
  }
}
