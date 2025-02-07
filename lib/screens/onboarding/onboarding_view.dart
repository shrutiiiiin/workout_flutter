import 'package:flutter/material.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:workout_flutter_app/screens/loginscreen/loginscreen_view.dart';
import 'package:workout_flutter_app/screens/onboarding/onboarding_model.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  _OnboardingViewState createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final List<OnboardingData> pages = [
    OnboardingData(
      image: 'assets/onboarding/motivated.png',
      title: "Earn Badges",
      description:
          "Stay motivated with badges for your milestones and achievements.",
      bgGradient: const LinearGradient(
        colors: [Color(0xFF1E1E2C), Color(0xFF3E3E58)],
        begin: Alignment.bottomLeft,
        end: Alignment.topLeft,
      ),
      descriptionTextColor: Colors.white70,
    ),
    OnboardingData(
      image: 'assets/onboarding/mentalhealth.png',
      title: "Mental Health Support",
      description:
          "Track your well-being and access resources for mental health support.",
      bgGradient: const LinearGradient(
        colors: [Color(0xFF232D3F), Color(0xFF3A506B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      descriptionTextColor: Colors.white70,
    ),
    OnboardingData(
      image: 'assets/onboarding/yoga.png',
      title: "Achievements & Awards",
      description:
          "Celebrate your progress and earn awards for your dedication.",
      bgGradient: const LinearGradient(
        colors: [Color(0xFF3E3E58), Color(0xFF5E5E77)],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ),
      descriptionTextColor: Colors.white70,
    ),
    OnboardingData(
      image: 'assets/onboarding/comforting.png',
      title: "Menstrual Cycle Tracking",
      description: "Keep track of your cycle and access personalized insights.",
      bgGradient: const LinearGradient(
        colors: [Color(0xFF4B3F72), Color(0xFF6A5D8A)],
        begin: Alignment.bottomLeft,
        end: Alignment.topLeft,
      ),
      descriptionTextColor: Colors.white70,
    ),
  ];

  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      if (mounted) {
        setState(() {
          _currentPage = _pageController.page!.toInt();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginscreenView()),
      );
    }
  }

  void _skipOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginscreenView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          ConcentricPageView(
            pageController: _pageController,
            itemBuilder: (int index) {
              final data = pages[index];
              return OnboardingCard(data: data);
            },
            colors: pages.map((data) => data.bgGradient.colors.first).toList(),
            itemCount: pages.length,
          ),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white30,
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: (_currentPage + 1) / pages.length,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.tealAccent,
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _skipOnboarding,
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_currentPage == pages.length - 1)
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Let\'s get Started',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
