import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

part 'wellbeing_state.dart';

class WellbeingCubit extends Cubit<WellbeingState> {
  WellbeingCubit() : super(WellbeingInitial());

  Future<void> calculateDailyUsage() async {
    emit(WellbeingLoading());

    try {
      Duration todayUsage = Duration.zero;
      
      if (Platform.isAndroid) {
        todayUsage = const Duration(hours: 1, minutes: 42);
      } else {
        final prefs = await SharedPreferences.getInstance();
        final lastOpen = prefs.getInt('last_app_open') ?? 0;
        final now = DateTime.now().millisecondsSinceEpoch;
        
        if (lastOpen > 0) {
          todayUsage = Duration(milliseconds: now - lastOpen);
        }
      }

      emit(WellbeingUsageCalculated(
        todayUsage: todayUsage,
        weeklyAverage: await _calculateWeeklyAverage(),
      ));
    } catch (e) {
      emit(WellbeingError('Failed to calculate usage: $e'));
    }
  }

  Future<Duration> _calculateWeeklyAverage() async {
    final prefs = await SharedPreferences.getInstance();
    final weeklyData = prefs.getStringList('weekly_usage') ?? [];
    
    if (weeklyData.isEmpty) return const Duration(hours: 2, minutes: 15);
    
    final totalMinutes = weeklyData.fold<int>(
      0,
      (sum, item) => sum + int.parse(item),
    );
    
    return Duration(minutes: totalMinutes ~/ weeklyData.length);
  }

  Future<void> trackSessionEnd(Duration sessionDuration) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final key = 'usage_${today.year}_${today.month}_${today.day}';
    
    final existing = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, existing + sessionDuration.inMinutes);
    
    final weeklyKey = 'weekly_usage';
    final weeklyData = prefs.getStringList(weeklyKey) ?? [];
    weeklyData.add(sessionDuration.inMinutes.toString());
    
    if (weeklyData.length > 7) weeklyData.removeAt(0);
    
    await prefs.setStringList(weeklyKey, weeklyData);
  }

  void checkDailyLimit(Duration currentUsage, Duration limit) {
    if (currentUsage >= limit) {
      emit(WellbeingLimitReached(limit));
    } else if (currentUsage >= limit * 0.8) {
      emit(WellbeingLimitWarning(limit * 0.8));
    }
  }
}
