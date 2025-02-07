import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class SteptrackingFirestore {
  Future<void> _loadTodaySteps() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    final docSnapshot = await _firestore
        .collection('steps')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    if (docSnapshot.docs.isNotEmpty) {
      final data = docSnapshot.docs.first.data();
      setState(() {
        _steps = data['steps'] ?? 0;
        _calories = data['calories'] ?? 0.0;
        _minutesActive = data['minutesActive'] ?? 0;
        _lastSavedSteps = _steps;
      });
    }
  }

  Future<void> _updateFirestore() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    final stepTracking = StepTracking(
      userId: userId,
      steps: _steps,
      calories: _calories,
      minutesActive: _minutesActive,
      date: startOfDay,
    );

    // Get today's document if it exists
    final querySnapshot = await _firestore
        .collection('steps')
        .where('userId', isEqualTo: userId)
        .where('date', isEqualTo: startOfDay)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Update existing document
      await _firestore
          .collection('steps')
          .doc(querySnapshot.docs.first.id)
          .update(stepTracking.toMap());
    } else {
      // Create new document
      await _firestore.collection('steps').add(stepTracking.toMap());
    }
  }
}
