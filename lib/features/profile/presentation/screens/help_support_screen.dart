import 'package:flutter/material.dart';
import 'package:landiq/core/theme/app_colors.dart';
import 'package:landiq/core/theme/app_typography.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _searchController = TextEditingController();
  int? _expandedFaqIndex;

  final List<_FaqItem> _faqs = const [
    _FaqItem(
      question: 'How do I assess my first piece of land?',
      answer:
          'Search for a village or drop a pin on the map. LandIQ will instantly generate a soil health score and show what the land is suitable for, including crops, poultry, or fishery.',
    ),
    _FaqItem(
      question: 'What areas does LandIQ cover?',
      answer:
          'LandIQ currently supports selected agricultural regions in Nigeria. We are expanding coverage regularly. If your area is not available yet, check back soon for updates.',
    ),
    _FaqItem(
      question: 'How accurate are the soil health scores?',
      answer:
          'Scores are generated using satellite imagery, soil maps, climate data, and environmental risk models. LandIQ provides reliable guidance, but for major investments, we recommend combining results with on-site inspection or lab testing.',
    ),
    _FaqItem(
      question: 'What data sources does LandIQ use?',
      answer:
          'We use satellite data, regional soil maps, rainfall records, temperature trends, and erosion models to evaluate land productivity and environmental risk.',
    ),
    _FaqItem(
      question: 'How often is the data updated?',
      answer:
          'Environmental and satellite data are updated periodically to reflect seasonal and regional changes. Updates ensure your assessment reflects current conditions as accurately as possible.',
    ),
    _FaqItem(
      question: 'Is my data secure and private?',
      answer:
          'Yes. Your account information, saved plots, and reports are securely stored and encrypted. LandIQ does not sell or share your personal data without your consent.',
    ),
    _FaqItem(
      question: 'Can I export my assessment reports?',
      answer:
          'Yes. You can generate a downloadable PDF report and share it via email or messaging apps directly from LandIQ.',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
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
                  Text('Help & Support', style: AppTypography.h5),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CONTACT US
                    Text(
                      'CONTACT US',
                      style: AppTypography.captionLg.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildContactCard(
                      icon: Icons.chat_bubble_outline,
                      iconColor: const Color(0xFF25D366),
                      iconBg: const Color(0xFFE8F8EE),
                      title: 'WhatsApp Support',
                      subtitle: 'Chat with us | Usually replies in 5 min',
                    ),
                    const SizedBox(height: 10),
                    _buildContactCard(
                      icon: Icons.mail_outline,
                      iconColor: const Color(0xFF2196F3),
                      iconBg: const Color(0xFFE3F2FD),
                      title: 'Email Support',
                      subtitle: 'support@landiq.ng | 24-48 hour response',
                    ),
                    const SizedBox(height: 10),
                    _buildContactCard(
                      icon: Icons.phone_outlined,
                      iconColor: const Color(0xFF4CAF50),
                      iconBg: const Color(0xFFE8F5E9),
                      title: 'Phone Support',
                      subtitle: '+234 803 123 4567 | Mon-Fri, 8AM-6PM',
                    ),

                    const SizedBox(height: 28),

                    // FREQUENTLY ASKED QUESTIONS
                    Text(
                      'FREQUENTLY ASKED QUESTIONS',
                      style: AppTypography.captionLg.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ...List.generate(_faqs.length, (index) {
                      final faq = _faqs[index];
                      final isExpanded = _expandedFaqIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildFaqCard(
                          faq: faq,
                          isExpanded: isExpanded,
                          onTap: () {
                            setState(() {
                              _expandedFaqIndex =
                                  isExpanded ? null : index;
                            });
                          },
                        ),
                      );
                    }),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTypography.bodyMd
                        .copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
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
      ),
    );
  }

  Widget _buildFaqCard({
    required _FaqItem faq,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    faq.question,
                    style: AppTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey900,
                    ),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.primary,
                  size: 22,
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 12),
              Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 12),
              Text(
                faq.answer,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.grey600,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FaqItem {
  final String question;
  final String answer;

  const _FaqItem({
    required this.question,
    required this.answer,
  });
}
