import 'package:flutter/material.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:workout_flutter_app/screens/loginscreen/loginscreen_view.dart';
import 'package:workout_flutter_app/screens/onboarding/onboarding_model.dart';

class OnboardingView extends StatelessWidget {
  final List<OnboardingData> pages = [
    OnboardingData(
      image: 'assets/onboarding/mentalhealth_Support.png',
      title: "Mental Health Support",
      description:
          "Track your well-being and access resources for mental health support.",
      bgGradient: const LinearGradient(
        colors: [Color(0XFFAADCDC), Color(0XFFD9E3E4)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    OnboardingData(
      image: 'assets/onboarding/motivated.png',
      title: "Earn Badges",
      description:
          "Stay motivated with badges for your milestones and achievements.",
      bgGradient: const LinearGradient(
        colors: [Color(0XFFFFC3D2), Color(0XFFFFEFF3)],
        begin: Alignment.topCenter,
        end: Alignment.bottomLeft,
      ),
    ),
    OnboardingData(
      image: 'assets/onboarding/yoga.png',
      title: "Achievements & Awards",
      description:
          "Celebrate your progress and earn awards for your dedication.",
      bgGradient: const LinearGradient(
        colors: [Color(0XFFFFD700), Color(0XFFFFF5E3)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
    ),
    OnboardingData(
      image: 'assets/onboarding/mentalhealth_Support.png',
      title: "Menstrual Cycle Tracking",
      description: "Keep track of your cycle and access personalized insights.",
      bgGradient: const LinearGradient(
        colors: [Color(0XFFFAF4FF), Color(0XFFEBD6FF)],
        begin: Alignment.centerLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

  OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ConcentricPageView(
            itemBuilder: (int index) {
              final data = pages[index];
              return OnboardingCard(data: data);
            },
            colors: pages.map((data) => data.bgGradient.colors.first).toList(),
            itemCount: pages.length,
            onFinish: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginscreenView()));
            }));
  }
}
