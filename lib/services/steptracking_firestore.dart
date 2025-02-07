import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workout_flutter_app/model/stepTracking.dart';

class StepTrackingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<StepTracking?> getTodaySteps(String userId) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    try {
      final docSnapshot = await _firestore
          .collection('steps')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThan: endOfDay)
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (docSnapshot.docs.isNotEmpty) {
        final data = docSnapshot.docs.first.data();
        return StepTracking.fromMap(data);
      }
      return null;
    } catch (e) {
      print('Error getting today\'s steps: $e');
      return null;
    }
  }

  Future<void> updateSteps(StepTracking stepTracking) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    try {
      final querySnapshot = await _firestore
          .collection('steps')
          .where('userId', isEqualTo: stepTracking.userId)
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThan: endOfDay)
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
    } catch (e) {
      print('Error updating steps: $e');
    }
  }

  Future<List<StepTracking>> getStepsHistory(
      String userId, DateTime startDate, DateTime endDate) async {
    try {
      final querySnapshot = await _firestore
          .collection('steps')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => StepTracking.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting steps history: $e');
      return [];
    }
  }
}
