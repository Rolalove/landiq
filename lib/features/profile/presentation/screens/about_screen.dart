import 'package:flutter/material.dart';
import 'package:landiq/core/theme/app_colors.dart';
import 'package:landiq/core/theme/app_typography.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Gradient Header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF005461),
                  Color(0xFF0A2E36),
                ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Back button
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, top: 8),
                      child: IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back,
                              size: 20, color: Colors.white),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),

                  // Logo / Icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.eco,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'LandIQ',
                    style: AppTypography.h4.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Smart Land Assessment',
                    style: AppTypography.bodyMd.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0',
                    style: AppTypography.captionLg.copyWith(
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mission Card (overlapping header)
                  Transform.translate(
                    offset: const Offset(0, -16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.favorite_outline,
                                    size: 18, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text(
                                  'Our Mission',
                                  style: AppTypography.bodyMd.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'To empower Nigerian farmers and agricultural SMEs with instant, accurate land assessment data, helping them make informed investment decisions and maximize agricultural productivity across the nation.',
                              style: AppTypography.bodyMd.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Stats Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        _buildStat('10K+', 'Active Users'),
                        const SizedBox(width: 12),
                        _buildStat('50K+', 'Assessments'),
                        const SizedBox(width: 12),
                        _buildStat('36', 'States'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // KEY FEATURES
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'KEY FEATURES',
                      style: AppTypography.captionLg.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _featureItem(
                    Icons.speed,
                    const Color(0xFF1565C0),
                    const Color(0xFFE3F2FD),
                    'Instant Assessment',
                    'Get comprehensive soil health reports in seconds using satellite imagery',
                  ),
                  _featureItem(
                    Icons.analytics_outlined,
                    const Color(0xFF2E7D32),
                    const Color(0xFFE8F5E9),
                    'Data Accuracy',
                    '85-92% accurate assessments using multiple data sources and AI analysis',
                  ),
                  _featureItem(
                    Icons.public,
                    const Color(0xFFE65100),
                    const Color(0xFFFFF3E0),
                    'Nationwide Coverage',
                    'All Nigerian states and LGAs covered with regular data updates',
                  ),
                  _featureItem(
                    Icons.people_outline,
                    const Color(0xFF6A1B9A),
                    const Color(0xFFF3E5F5),
                    'Trusted by Farmers',
                    'Used by 10,000+ farmers and agricultural SMEs across Nigeria',
                  ),

                  const SizedBox(height: 28),

                  // OUR TEAM
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'OUR TEAM',
                      style: AppTypography.captionLg.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background2,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          _teamRow(Icons.groups, '35+', 'Experts',
                              'Dedicated to African agriculture'),
                          const Divider(height: 24),
                          _teamRow(Icons.science, '15+',
                              'Agricultural Science', ''),
                          const Divider(height: 24),
                          _teamRow(
                              Icons.memory, '8+', 'Data Scientists', ''),
                          const Divider(height: 24),
                          _teamRow(Icons.engineering, '12+', 'Engineers', ''),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Technology Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF005461),
                            Color(0xFF0A2E36),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Powered by Advanced Technology',
                            style: AppTypography.bodyMd.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _techItem('Sentinel-2 Satellite Imagery'),
                          _techItem('AI & Machine Learning Analysis'),
                          _techItem('Real-time Climate Data'),
                          _techItem('Nigerian Soil Databases'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Contact Information
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background2,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact Information',
                            style: AppTypography.bodyMd.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _contactRow('EMAIL', 'info@landiq.org'),
                          const SizedBox(height: 10),
                          _contactRow('PHONE', '+234 803 123 4567'),
                          const SizedBox(height: 10),
                          _contactRow('ADDRESS', 'Lagos, Nigeria'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Footer
                  Center(
                    child: Text(
                      '© 2026 LandIQ. All rights reserved.\nMade with LandIQ for Nigerian Farmers',
                      textAlign: TextAlign.center,
                      style: AppTypography.captionLg.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String number, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.background2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(
              number,
              style: AppTypography.h5.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.captionLg.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _featureItem(
    IconData icon,
    Color color,
    Color bg,
    String title,
    String desc,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTypography.bodyMd
                          .copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: AppTypography.captionLg.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _teamRow(
      IconData icon, String count, String role, String subtitle) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Text(count,
            style:
                AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(role, style: AppTypography.bodyMd),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: AppTypography.captionLg.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _techItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF4DD0E1),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: AppTypography.bodyMd.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  static Widget _contactRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: AppTypography.captionLg.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
