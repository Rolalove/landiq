import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:landiq/core/network/token_storage.dart';
import 'package:landiq/features/onboarding/presentation/widgets/page_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/images/onboarding/Onboarding.png',
      'text':
          'LandIQ gives you AI-powered soil intelligence so you never commit capital to degraded farmland again.',
    },
    {
      'image': 'assets/images/onboarding/Onboarding2.png',
      'text':
          'LandIQ gives you intelligence so you never commit capital to degraded farmland again.',
    },
    {
      'image': 'assets/images/onboarding/Onboarding3.jpg',
      'text':
          'LandIQ gives you AI-powered soil intelligence so you never commit capital to degraded farmland again.',
    },
  ];

  void _nextPage() {
    if (_currentPage < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() async {
    await TokenStorage().setOnboardingComplete();
    if (mounted) context.goNamed('getStarted');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView for images
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return PageWidget(image: pages[index]['image']!, text: '');
            },
          ),
          // Skip button top-right
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: _finishOnboarding,
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          ),
          // Bottom controls: Text + Dots + Next
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page text
                Text(
                  pages[_currentPage]['text']!,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 16),
                // Dots + Next button row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Dots
                    Row(
                      children: List.generate(
                        pages.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 12 : 8,
                          height: _currentPage == index ? 12 : 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.white54,
                          ),
                        ),
                      ),
                    ),
                    // Next button with background color
                    ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                        backgroundColor: const Color(0xFFD1E6EB),
                      ),
                      child: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
