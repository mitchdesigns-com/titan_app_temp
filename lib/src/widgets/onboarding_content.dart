import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingContent extends StatefulWidget {
  const OnboardingContent({super.key});

  @override
  OnboardingContentState createState() => OnboardingContentState();
}

class OnboardingContentState extends State<OnboardingContent> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildStep(
                  "تسوق مابين تشكيلة منتجات مميزة",
                  "تاريخ حلو المذاق",
                  "assets/images/splash/onboarding_top_1.png",
                  "assets/images/splash/onboarding_image_1.png"),
              _buildStep(
                  "توصيل سريع ويمكنك الاستلام من الفرع",
                  "تاريخ حلو المذاق",
                  "assets/images/splash/onboarding_top_2.png",
                  "assets/images/splash/onboarding_image_2.png"),
              _buildStep(
                  "ارسل هدية لاحبابك من منتجاتنا المميزة",
                  "تاريخ حلو المذاق",
                  "assets/images/splash/onboarding_top_3.png",
                  "assets/images/splash/onboarding_image_3.png"),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: buildDotsIndicator(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: _currentPage > 0 ? 1.0 : 0.0,
                child: ElevatedButton(
                  onPressed: _currentPage > 0 ? _prevPage : null,
                  child: Text(
                    "السابق",
                    style: GoogleFonts.vazirmatn(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _nextPage,
                child: Text(
                  _currentPage < 2 ? "التالي" : "ابدأ التسوق",
                  style: GoogleFonts.vazirmatn(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep(
      String title, String subtitle, String image1, String image2) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset(image1, width: 200),
        ),
        Positioned.fill(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(image2, width: 200),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: GoogleFonts.vazirmatn(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    style: GoogleFonts.vazirmatn(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          height: 4,
          width: _currentPage == index ? 40 : 20,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Theme.of(context).colorScheme.tertiary
                : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
