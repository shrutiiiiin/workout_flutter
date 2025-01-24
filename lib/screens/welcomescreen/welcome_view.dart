import 'dart:ui';

import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: false);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      'assets/onboarding/motivated.png',
      'assets/onboarding/yoga.png',
      'assets/onboarding/mentalhealth.png',
      'assets/onboarding/comforting.png',
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Moving Grid of Images
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final offsetValue =
                  _animation.value * MediaQuery.of(context).size.height;

              return Transform.translate(
                offset: Offset(0, -offsetValue), // Adjust for vertical motion
                child: Column(
                  children: List.generate(
                    3, // Number of grid rows
                    (rowIndex) => Row(
                      children: List.generate(
                        3, // Number of grid columns
                        (colIndex) {
                          final imageIndex =
                              (rowIndex * 3 + colIndex) % images.length;
                          return Image.asset(
                            images[imageIndex],
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.height / 3,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Blur Effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          // Welcome Text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Explore the dynamic grid animations",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
