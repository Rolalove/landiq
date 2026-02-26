import 'package:flutter/material.dart';
import 'package:landiq/core/theme/app_colors.dart';
import 'package:landiq/core/theme/app_typography.dart';

class LegalScreen extends StatefulWidget {
  const LegalScreen({super.key});

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.background2,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back,
                          size: 20, color: AppColors.secondary),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  Text('Legal', style: AppTypography.h5),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Tab Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background2,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.secondary,
                  labelStyle: AppTypography.captionLg.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: AppTypography.captionLg,
                  tabs: const [
                    Tab(text: 'Terms of Service'),
                    Tab(text: 'Privacy Policy'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Last Updated
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.background2,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.verified_outlined,
                        size: 18, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last Updated',
                          style: AppTypography.captionLg.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text('January 15, 2026',
                            style: AppTypography.bodyMd
                                .copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _TermsOfServiceTab(),
                  _PrivacyPolicyTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// TERMS OF SERVICE TAB
class _TermsOfServiceTab extends StatelessWidget {
  const _TermsOfServiceTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('1. Acceptance of Terms'),
          _body(
            'By accessing and using LandIQ ("the Service"), you accept and agree to be bound by the terms and provision of this agreement.\n\n'
            'LandIQ provides soil health assessment services for agricultural land in Nigeria. Our service is designed to help farmers and agricultural SMEs make informed decisions about land investments.',
          ),
          const SizedBox(height: 24),

          _sectionTitle('2. Use of Service'),
          _bulletList([
            'You must be at least 18 years old to use this service',
            'You are responsible for maintaining the confidentiality of your account',
            'You agree not to misuse the service or help anyone else do so',
            'You may not use the service for any illegal or unauthorized purpose',
          ]),
          const SizedBox(height: 24),

          _sectionTitle('3. Assessment Accuracy'),
          _body(
            'LandIQ uses satellite imagery, soil databases, and climate data to provide assessments with 85-92% accuracy. However, these assessments are estimates and should not be considered as professional agricultural advice.',
          ),
          const SizedBox(height: 12),
          // Disclaimer card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: const Color(0xFFFFE082)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning_amber,
                        size: 16, color: Color(0xFFE65100)),
                    const SizedBox(width: 6),
                    Text(
                      'Important Disclaimer',
                      style: AppTypography.captionLg.copyWith(
                        color: const Color(0xFFE65100),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Always conduct in-person verification and consult with agricultural experts before making significant land investments. LandIQ is not liable for any financial decisions made based solely on our assessments.',
                  style: AppTypography.captionLg.copyWith(
                    color: AppColors.secondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _sectionTitle('4. Intellectual Property'),
          _body(
            'All content, features, and functionality of LandIQ are owned by LandIQ and are protected by international copyright, trademark, and other intellectual property laws.',
          ),
          const SizedBox(height: 24),

          _sectionTitle('5. Limitation of Liability'),
          _body(
            'LandIQ shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of or inability to use the service.',
          ),
          const SizedBox(height: 24),

          _sectionTitle('6. Changes to Terms'),
          _body(
            'We reserve the right to modify these terms at any time. We will notify users of any material changes via email or app notification.',
          ),
          const SizedBox(height: 24),

          _sectionTitle('7. Contact Information'),
          _body('For questions about these Terms of Service, please contact us:'),
          const SizedBox(height: 8),
          Text(
            'legal@landiq.ng',
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '+234 803 123 4567',
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// PRIVACY POLICY TAB
class _PrivacyPolicyTab extends StatelessWidget {
  const _PrivacyPolicyTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('1. Information We Collect'),
          _body(
              'We collect information to provide better services to all our users. Here\'s what we collect:'),
          const SizedBox(height: 12),
          _infoCard('Personal Information',
              'Name, phone number, email address, and location data you provide when creating an account.'),
          const SizedBox(height: 8),
          _infoCard('Assessment Data',
              'Land locations you search, saved assessments, and comparison history.'),
          const SizedBox(height: 8),
          _infoCard('Usage Information',
              'App interactions, feature usage, and crash reports to improve our service.'),
          const SizedBox(height: 24),

          _sectionTitle('2. How We Use Your Information'),
          _checkList([
            'Provide and improve our land assessment services',
            'Send you assessment results and notifications',
            'Analyze usage patterns to enhance user experience',
            'Communicate updates and new features',
          ]),
          const SizedBox(height: 24),

          _sectionTitle('3. Data Security'),
          _body(
              'We implement industry-standard security measures to protect your data:'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _securityItem('End-to-end encryption'),
                _securityItem('Secure cloud storage'),
                _securityItem('Regular security audits'),
                _securityItem('Two-factor authentication'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _sectionTitle('4. Data Sharing'),
          _body(
              'We do NOT sell your personal information to third parties. We may share data only in these cases:'),
          _bulletList([
            'With your explicit consent',
            'For legal compliance or safety reasons',
            'With service providers who help us operate (under strict agreements)',
          ]),
          const SizedBox(height: 24),

          _sectionTitle('5. Your Rights'),
          _body('You have the right to:'),
          _arrowList([
            'Access your personal data at any time',
            'Request data correction or deletion',
            'Export your assessment history',
            'Opt-out of marketing communications',
          ]),
          const SizedBox(height: 24),

          _sectionTitle('6. Contact Us'),
          _body(
              'For privacy-related questions, contact our Data Protection Officer:'),
          const SizedBox(height: 8),
          Text(
            'privacy@landiq.ng',
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '+234 803 123 4567',
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  static Widget _infoCard(String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(
            desc,
            style: AppTypography.captionLg.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _checkList(List<String> items) {
    return Column(
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle,
                        size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: AppTypography.bodyMd.copyWith(height: 1.4),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  static Widget _securityItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.shield, size: 16, color: Color(0xFF2E7D32)),
          const SizedBox(width: 8),
          Text(text, style: AppTypography.bodyMd),
        ],
      ),
    );
  }

  static Widget _arrowList(List<String> items) {
    return Column(
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.arrow_forward,
                        size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: AppTypography.bodyMd.copyWith(height: 1.4),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

// SHARED HELPERS
Widget _sectionTitle(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text,
          style: AppTypography.bodyMd
              .copyWith(fontWeight: FontWeight.w700, fontSize: 16)),
    );

Widget _body(String text) => Text(
      text,
      style: AppTypography.bodyMd.copyWith(
        color: AppColors.textSecondary,
        height: 1.6,
      ),
    );

Widget _bulletList(List<String> items) => Column(
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item,
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
