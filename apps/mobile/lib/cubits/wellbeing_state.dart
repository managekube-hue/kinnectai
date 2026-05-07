part of 'wellbeing_cubit.dart';

abstract class WellbeingState extends Equatable {
  const WellbeingState();

  @override
  List<Object?> get props => [];
}

class WellbeingInitial extends WellbeingState {}

class WellbeingLoading extends WellbeingState {}

class WellbeingUsageCalculated extends WellbeingState {
  final Duration todayUsage;
  final Duration weeklyAverage;

  const WellbeingUsageCalculated({
    required this.todayUsage,
    required this.weeklyAverage,
  });

  @override
  List<Object?> get props => [todayUsage, weeklyAverage];
}

class WellbeingLimitWarning extends WellbeingState {
  final Duration threshold;

  const WellbeingLimitWarning(this.threshold);

  @override
  List<Object?> get props => [threshold];
}

class WellbeingLimitReached extends WellbeingState {
  final Duration limit;

  const WellbeingLimitReached(this.limit);

  @override
  List<Object?> get props => [limit];
}

class WellbeingError extends WellbeingState {
  final String message;

  const WellbeingError(this.message);

  @override
  List<Object?> get props => [message];
}
