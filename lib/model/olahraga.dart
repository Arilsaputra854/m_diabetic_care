class ExerciseReminder {
  final int id;
  final String exerciseType;
  final String scheduledTime;
  final int durationMinutes;

  ExerciseReminder({
    required this.id,
    required this.exerciseType,
    required this.scheduledTime,
    required this.durationMinutes,
  });

  factory ExerciseReminder.fromJson(Map<String, dynamic> json) {
    return ExerciseReminder(
      id: json['id'],
      exerciseType: json['exercise_type'],
      scheduledTime: json['scheduled_time'],
      durationMinutes: json['duration_minutes'],
    );
  }
}
