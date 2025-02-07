import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workout_flutter_app/model/stepTracking.dart';
import 'package:workout_flutter_app/screens/profile/profile.dart';
import 'package:workout_flutter_app/services/steptracking_firestore.dart';

class Homepageview extends StatefulWidget {
  const Homepageview({super.key});

  @override
  State<Homepageview> createState() => _HomepageviewState();
}

class _HomepageviewState extends State<Homepageview> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = 'Idle';
  double _calories = 0;
  int _minutesActive = 0;
  int _steps = 0;
  int _lastSavedSteps = 0;
  DateTime? _lastStepTime;
  Timer? _activityTimer;
  bool _isInitialized = false;
  final StepTrackingService _stepTrackingService = StepTrackingService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _loadTodaySteps();
    await initPlatformState();
    _startActivityTimer();
  }

  void _startActivityTimer() {
    _activityTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (_status == 'walking' || _status == 'running') {
        setState(() {
          _minutesActive++;
          _updateSteps();
        });
      }
    });
  }

  Future<void> _loadTodaySteps() async {
    try {
      final stepTracking = await _stepTrackingService.getTodaySteps(userId);
      if (stepTracking != null) {
        setState(() {
          _steps = stepTracking.steps;
          _calories = stepTracking.calories;
          _minutesActive = stepTracking.minutesActive;
        });
      }
    } catch (e) {
      print('Error loading today\'s steps: $e');
    }
  }

  void onStepCount(StepCount event) {
    if (!_isInitialized) {
      _lastSavedSteps = event.steps;
      _isInitialized = true;
      return;
    }

    final stepsDifference = event.steps - _lastSavedSteps;

    if (stepsDifference > 0) {
      setState(() {
        _steps += stepsDifference;
        _calories = _steps * 0.04;
        _lastSavedSteps = event.steps;
        _lastStepTime = DateTime.now();
        _updateSteps();
      });
    }
  }

  Future<void> _updateSteps() async {
    final stepTracking = StepTracking(
      userId: userId,
      steps: _steps,
      calories: _calories,
      minutesActive: _minutesActive,
      date: DateTime.now(),
    );

    await _stepTrackingService.updateSteps(stepTracking);
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('Pedestrian status error: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
  }

  void onStepCountError(error) {
    print('Step count error: $error');
    setState(() {
      _steps = 0;
    });
  }

  Future<void> initPlatformState() async {
    try {
      if (await Permission.activityRecognition.request().isGranted) {
        _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
        _stepCountStream = Pedometer.stepCountStream;

        _pedestrianStatusStream
            .listen(onPedestrianStatusChanged)
            .onError(onPedestrianStatusError);
        _stepCountStream.listen(onStepCount).onError(onStepCountError);
      } else {
        setState(() {
          _status = 'Permission denied';
          _steps = 0;
        });
      }
    } catch (e) {
      print('Error initializing platform state: $e');
    }
  }

  @override
  void dispose() {
    _activityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.fitness_center, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Pump&Pulse',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back, User!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

              // Quick Stats Card with real-time data
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn('Steps', _steps.toString(), 'Today'),
                    _buildStatColumn(
                        'Calories', _calories.toStringAsFixed(1), 'Burned'),
                    _buildStatColumn(
                        'Minutes', _minutesActive.toString(), 'Active'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Activity Status Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      _status == 'walking'
                          ? Icons.directions_walk
                          : _status == 'running'
                              ? Icons.directions_run
                              : Icons.accessibility_new,
                      color: Colors.blue,
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Current Activity: $_status',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Rest of your existing UI components...
              const Text(
                'Today\'s Workout',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildWorkoutCard(
                'Full Body Workout',
                '45 mins',
                'Intermediate',
                Icons.whatshot,
                Colors.orange,
              ),
              const SizedBox(height: 24),

              // Workout Categories
              const Text(
                'Workout Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildCategoryCard(
                      'Strength', Icons.fitness_center, Colors.red),
                  _buildCategoryCard(
                      'Cardio', Icons.directions_run, Colors.green),
                  _buildCategoryCard(
                      'Yoga', Icons.self_improvement, Colors.purple),
                  _buildCategoryCard(
                      'Stretching', Icons.accessibility_new, Colors.blue),
                ],
              ),
              const SizedBox(height: 24),

              // Recent Workouts section
              const Text(
                'Recent Workouts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildRecentWorkoutItem(
                'Upper Body',
                'Completed Yesterday',
                '35 mins',
                Icons.arrow_upward,
              ),
              _buildRecentWorkoutItem(
                'Core Strength',
                'Completed 2 days ago',
                '25 mins',
                Icons.circle_outlined,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF2A2A2A),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Discover'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Start new workout
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }

  // Your existing widget building methods remain the same...
  Widget _buildStatColumn(String title, String value, String subtitle) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutCard(
    String title,
    String duration,
    String level,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$duration • $level',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_fill,
                color: Colors.blue, size: 40),
            onPressed: () {
              // TODO: Start workout
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to category
        },
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentWorkoutItem(
    String title,
    String subtitle,
    String duration,
    IconData icon,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: Text(
        duration,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
