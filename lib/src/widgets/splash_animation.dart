import 'package:flutter/material.dart';

class SplashAnimation extends StatefulWidget {
  final VoidCallback onAnimationEnd;

  const SplashAnimation(
      {super.key, required this.onAnimationEnd}); // Added super.key

  @override
  SplashAnimationState createState() => SplashAnimationState();
}

class SplashAnimationState extends State<SplashAnimation>
    with SingleTickerProviderStateMixin {
  double _opacity = 1.0;
  double _imagePosition = 0;
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _bounceAnimation2;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: 20).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _bounceAnimation2 = Tween<double>(begin: 0, end: 439).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _imagePosition = 0;
      });
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _opacity = 0.0;
        });
        widget.onAnimationEnd(); // Notify parent that animation has ended
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedOpacity(
          duration: Duration(seconds: 2),
          opacity: _opacity,
          child: Center(
            child: Image.asset('assets/images/splash_logo.png', width: 150),
          ),
        ),
        AnimatedBuilder(
          animation: _bounceAnimation,
          builder: (context, child) {
            return Positioned(
              top: _bounceAnimation.value,
              left: 0,
              child: AnimatedOpacity(
                duration: Duration(seconds: 2),
                opacity: _opacity,
                child: Image.asset('assets/images/splash_01.png', width: 30),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _bounceAnimation2,
          builder: (context, child) {
            return AnimatedPositioned(
              duration: Duration(seconds: 2),
              top: 0,
              left: _imagePosition,
              child: AnimatedOpacity(
                duration: Duration(seconds: 2),
                opacity: _opacity,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _bounceAnimation2,
                    builder: (context, child) {
                      return Image.asset(
                        'assets/images/splash_full.png',
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
