import 'package:flutter/material.dart';

import '../widgets/onboarding_content.dart';
import '../widgets/splash_animation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState(); // Remove underscore
}

class SplashScreenState extends State<SplashScreen> { // Remove underscore
  bool _showContent = false;

  void _onAnimationEnd() {
    setState(() {
      _showContent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          SplashAnimation(onAnimationEnd: _onAnimationEnd),
          if (_showContent) OnboardingContent(),
        ],
      ),
    );
  }
}
