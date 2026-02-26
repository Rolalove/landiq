import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:landiq/core/network/token_storage.dart';
import 'package:landiq/core/theme/app_buttons.dart';
import 'package:landiq/core/theme/app_colors.dart';
import 'package:landiq/core/theme/app_typography.dart';

class WalkthroughScreen extends StatefulWidget {
  const WalkthroughScreen({super.key});

  @override
  State<WalkthroughScreen> createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeWalkthrough() async {
    await TokenStorage().setWalkthroughComplete();
    if (mounted) context.goNamed('home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Page indicators + Skip
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page indicators
                  Row(
                    children: List.generate(2, (index) {
                      final isActive = index == _currentPage;
                      return Container(
                        width: isActive ? 24 : 8,
                        height: 6,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primary
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                  // Skip -- only on page 0
                  if (_currentPage == 0)
                    GestureDetector(
                      onTap: _completeWalkthrough,
                      child: Text(
                        'skip',
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 32),
                ],
              ),
            ),

            // PageView
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: const [
                  _WelcomePage(),
                  _RatingsPage(),
                ],
              ),
            ),

            // Bottom Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Next',
                  showTrailingArrow: false,
                  onPressed: () {
                    if (_currentPage < 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _completeWalkthrough();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// PAGE 1 — Welcome to LandIQ
class _WelcomePage extends StatelessWidget {
  const _WelcomePage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),

          Text(
            'Welcome to LandIQ',
            style: AppTypography.h4,
          ),

          const SizedBox(height: 16),

          Text(
            'Your land intelligence platform for smarter agricultural investment',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.secondary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'LandIQ helps farmers and agribusiness investors evaluate soil productivity and degradation risk before committing capital',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.secondary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 32),

          // Highlighted info card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFABE1EF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.border2.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              'Make informed decisions with AI-driven and land intelligence',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.secondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// PAGE 2 — Understanding Soil Health Rating
class _RatingsPage extends StatelessWidget {
  const _RatingsPage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          Center(
            child: Text(
              'Understanding Soil\nHealth Rating',
              textAlign: TextAlign.center,
              style: AppTypography.h4,
            ),
          ),

          const SizedBox(height: 8),

          Center(
            child: Text(
              'We use a simple three-tier system',
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Gold Rating
          _buildRatingItem(
            icon: Icons.workspace_premium,
            iconBg: const Color(0xFFFFF8E1),
            iconColor: const Color(0xFFFFB300),
            borderColor: const Color(0xFFFFD54F),
            title: 'Gold Rating',
            description:
                'High soil health and strong productivity potential.\nBest choice for long term agricultural investment.',
            scoreRange: 'Score Range: 80% to 100%',
            scoreColor: const Color(0xFFFFB300),
          ),

          const SizedBox(height: 24),

          // Silver Rating
          _buildRatingItem(
            icon: Icons.workspace_premium,
            iconBg: const Color(0xFFECEFF1),
            iconColor: const Color(0xFF90A4AE),
            borderColor: const Color(0xFFB0BEC5),
            title: 'Silver Rating',
            description:
                'Moderate soil health with manageable limitations.\nSuitable for investment with proper land management.',
            scoreRange: 'Score Range: 60% to 79%',
            scoreColor: const Color(0xFF607D8B),
          ),

          const SizedBox(height: 24),

          // Bronze Rating
          _buildRatingItem(
            icon: Icons.workspace_premium,
            iconBg: const Color(0xFFFFEBEE),
            iconColor: const Color(0xFFEF5350),
            borderColor: const Color(0xFFEF9A9A),
            title: 'Bronze Rating',
            description:
                'Low soil health or higher environmental risk.\nHigher risk for investment without corrective action.',
            scoreRange: 'Score Range: Below 60%',
            scoreColor: const Color(0xFFEF5350),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildRatingItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required Color borderColor,
    required String title,
    required String description,
    required String scoreRange,
    required Color scoreColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon circle
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const SizedBox(width: 16),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.h5,
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: AppTypography.captionLg.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                scoreRange,
                style: AppTypography.h5.copyWith(
                  color: scoreColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
