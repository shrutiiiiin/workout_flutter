import 'package:flutter/material.dart';
import 'package:workout_flutter_app/screens/onboarding/onboarding_view.dart';
import 'package:firebase_core/firebase_core.dart';
// Import Firebase Core

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const OnboardingView(),
    );
  }
}
