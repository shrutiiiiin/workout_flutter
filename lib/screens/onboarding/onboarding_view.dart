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
        colors: [Color(0XFFFFC3D2), Color(0XFFFFEFF3)],
        begin: Alignment.bottomLeft,
        end: Alignment.topLeft,
      ),
      descriptionTextColor: Colors.black45,
    ),
    OnboardingData(
      image: 'assets/onboarding/mentalhealth.png',
      title: "Mental Health Support",
      description:
          "Track your well-being and access resources for mental health support.",
      bgGradient: const LinearGradient(
        colors: [Color(0XFFAADCDC), Color(0XFFD9E3E4)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      descriptionTextColor: Colors.black45,
    ),
    OnboardingData(
      image: 'assets/onboarding/yoga.png',
      title: "Achievements & Awards",
      description:
          "Celebrate your progress and earn awards for your dedication.",
      bgGradient: const LinearGradient(
        colors: [Color(0XFFFFD700), Color(0XFFFFF5E3)],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ),
      descriptionTextColor: Colors.black45,
    ),
    OnboardingData(
      image: 'assets/onboarding/comforting.png',
      title: "Menstrual Cycle Tracking",
      description: "Keep track of your cycle and access personalized insights.",
      bgGradient: const LinearGradient(
        colors: [Color(0XFFE0BFFF), Color(0XFFFAF4FF)],
        begin: Alignment.bottomLeft,
        end: Alignment.topLeft,
      ),
      descriptionTextColor: Colors.black45,
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
    _pageController.dispose(); // Dispose of the controller
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
        MaterialPageRoute(builder: (context) => LoginscreenView()),
      );
    }
  }

  void _skipOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginscreenView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            top: 50, // Positioning it like an app bar
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Progress Bar
                Expanded(
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: (_currentPage + 1) / pages.length,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(
                              0XFF4F5F94), // Custom color for the filled part
                        ),
                      ),
                    ),
                  ),
                ),

                // Skip Button
                TextButton(
                  onPressed: _skipOnboarding,
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // "Let's Get Started" Button on Last Page
          if (_currentPage == pages.length - 1)
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: _nextPage,
                child: const Text(
                  'Let\'s get Started',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF4F5F94),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
