import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../cubits/wellbeing_cubit.dart';
import '../widgets/screen_time_chart.dart';
import '../widgets/time_limit_picker.dart';

class TimeWellbeingScreen extends StatelessWidget {
  const TimeWellbeingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WellbeingCubit()..calculateDailyUsage(),
      child: const _TimeWellbeingContent(),
    );
  }
}

class _TimeWellbeingContent extends StatefulWidget {
  const _TimeWellbeingContent();

  @override
  State<_TimeWellbeingContent> createState() => _TimeWellbeingContentState();
}

class _TimeWellbeingContentState extends State<_TimeWellbeingContent> {
  bool _dailyLimitEnabled = false;
  Duration _dailyLimit = const Duration(hours: 2, minutes: 30);
  bool _breakRemindersEnabled = false;
  Duration _breakInterval = const Duration(minutes: 20);
  bool _nightModeEnabled = false;
  final TimeOfDay _nightModeStart = const TimeOfDay(hour: 22, minute: 0);
  final TimeOfDay _nightModeEnd = const TimeOfDay(hour: 7, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dailyLimitEnabled = prefs.getBool('daily_limit_enabled') ?? false;
      _dailyLimit = Duration(minutes: prefs.getInt('daily_limit_minutes') ?? 150);
      _breakRemindersEnabled = prefs.getBool('break_reminders_enabled') ?? false;
      _breakInterval = Duration(minutes: prefs.getInt('break_interval_minutes') ?? 20);
      _nightModeEnabled = prefs.getBool('night_mode_enabled') ?? false;
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) await prefs.setBool(key, value);
    if (value is int) await prefs.setInt(key, value);
    _loadSettings();
  }

  Future<void> _pickDailyLimit() async {
    final result = await showDialog<Duration>(
      context: context,
      builder: (context) => TimeLimitPicker(
        initialLimit: _dailyLimit,
        maxLimit: const Duration(hours: 8),
      ),
    );

    if (result != null && mounted) {
      await _saveSetting('daily_limit_minutes', result.inMinutes);
      setState(() => _dailyLimit = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Time & Well-being', style: KinnectTextStyles.headlineSmall),
        centerTitle: true,
      ),
      body: BlocListener<WellbeingCubit, WellbeingState>(
        listener: (context, state) {
          if (state is WellbeingLimitWarning) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('You\'ve reached 80% of your daily limit (${_formatDuration(state.threshold)})'),
                backgroundColor: KinnectColors.warning,
              ),
            );
          } else if (state is WellbeingLimitReached) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Daily limit reached (${_formatDuration(state.limit)})'),
                backgroundColor: KinnectColors.error,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: KinnectColors.accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: const Icon(Icons.self_improvement, size: 60, color: KinnectColors.accent),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Balance your digital legacy with your daily life.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: KinnectColors.textPrimary, fontSize: 16),
                ),
              ),
              const SizedBox(height: 32),
              
              _buildScreenTimeStats(),
              const SizedBox(height: 24),
              _buildDailyLimit(),
              const SizedBox(height: 16),
              _buildBreakReminders(),
              const SizedBox(height: 16),
              _buildNightMode(),
              const SizedBox(height: 32),
              
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KinnectColors.accent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Save Preferences'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScreenTimeStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: KinnectColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Daily Screen Time', style: KinnectTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            BlocBuilder<WellbeingCubit, WellbeingState>(
              builder: (context, state) {
                if (state is WellbeingUsageCalculated) {
                  return Row(
                    children: [
                      Expanded(child: _buildStatCard('Today', _formatDuration(state.todayUsage), Icons.today)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildStatCard('Weekly Avg', _formatDuration(state.weeklyAverage), Icons.trending_up)),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator(color: KinnectColors.accent));
              },
            ),
            const SizedBox(height: 20),
            const ScreenTimeChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: KinnectColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: KinnectColors.accent, size: 24),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: KinnectColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildDailyLimit() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: KinnectColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Daily Limit', style: KinnectTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      const Text('Hard daily cap. We\'ll notify you at 80%.', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                Switch(
                  value: _dailyLimitEnabled,
                  onChanged: (value) {
                    _saveSetting('daily_limit_enabled', value);
                    setState(() => _dailyLimitEnabled = value);
                  },
                  activeThumbColor: KinnectColors.accent,
                ),
              ],
            ),
            if (_dailyLimitEnabled) ...[
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickDailyLimit,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: KinnectColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(_dailyLimit), style: const TextStyle(color: KinnectColors.textPrimary, fontSize: 16)),
                      const Icon(Icons.edit, color: KinnectColors.accent, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBreakReminders() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: KinnectColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Break Reminders', style: KinnectTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      const Text('Timed nudges to step away.', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                Switch(
                  value: _breakRemindersEnabled,
                  onChanged: (value) {
                    _saveSetting('break_reminders_enabled', value);
                    setState(() => _breakRemindersEnabled = value);
                  },
                  activeThumbColor: KinnectColors.accent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNightMode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: KinnectColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Night Mode', style: KinnectTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  const Text('Auto-grayscale during sleep.', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            Switch(
              value: _nightModeEnabled,
              onChanged: (value) {
                _saveSetting('night_mode_enabled', value);
                setState(() => _nightModeEnabled = value);
              },
              activeThumbColor: KinnectColors.accent,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }
}
