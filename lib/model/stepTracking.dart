import 'package:cloud_firestore/cloud_firestore.dart';

class StepTracking {
  final String userId;
  final int steps;
  final double calories;
  final int minutesActive;
  final DateTime date;

  StepTracking({
    required this.userId,
    required this.steps,
    required this.calories,
    required this.minutesActive,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'steps': steps,
      'calories': calories,
      'minutesActive': minutesActive,
      'date': date,
    };
  }

  static StepTracking fromMap(Map<String, dynamic> map) {
    return StepTracking(
      userId: map['userId'],
      steps: map['steps'],
      calories: map['calories'],
      minutesActive: map['minutesActive'],
      date: (map['date'] as Timestamp).toDate(),
    );
  }
}
