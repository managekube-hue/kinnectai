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
      backgroundColor: KinnectColors.darkBg,
      appBar: AppBar(
        backgroundColor: KinnectColors.darkSurface,
        title: const Text('Night Mode Schedule'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable Night Mode', style: TextStyle(color: KinnectColors.white)),
            subtitle: const Text('Grayscale + mute notifications', style: TextStyle(color: KinnectColors.grey60, fontSize: 12)),
            value: _enabled,
            activeColor: KinnectColors.amber,
            onChanged: (value) => setState(() => _enabled = value),
          ),
          ListTile(
            title: const Text('Start time', style: TextStyle(color: KinnectColors.white)),
            subtitle: Text(_startTime.format(context), style: const TextStyle(color: KinnectColors.amber)),
            enabled: _enabled,
            onTap: () async {
              final time = await showTimePicker(context: context, initialTime: _startTime);
              if (time != null) setState(() => _startTime = time);
            },
          ),
          ListTile(
            title: const Text('End time', style: TextStyle(color: KinnectColors.white)),
            subtitle: Text(_endTime.format(context), style: const TextStyle(color: KinnectColors.amber)),
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
