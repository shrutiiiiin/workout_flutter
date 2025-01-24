// onboarding_card.dart
import 'package:flutter/material.dart';

class OnboardingData {
  final String image;
  final String title;
  final String description;
  final Gradient bgGradient;
  final Color descriptionTextColor;

  OnboardingData(
      {required this.image,
      required this.title,
      required this.description,
      required this.bgGradient,
      required this.descriptionTextColor});
}

class OnboardingCard extends StatelessWidget {
  final OnboardingData data;

  const OnboardingCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: data.bgGradient,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            data.image,
            height: 400,
            width: 300,
          ),
          const SizedBox(height: 20),
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              data.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: data.descriptionTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
