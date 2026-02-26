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
      category: 'GETTING STARTED',
      question: 'How do I assess my first piece of land?',
      answer:
          'To assess land, tap the + button on the home screen, enter the coordinates or search for the location, specify the area in hectares, and submit. LandIQ will analyze the soil data and provide a detailed report.',
    ),
    _FaqItem(
      category: 'GETTING STARTED',
      question: 'What areas does LandIQ cover?',
      answer:
          'LandIQ currently covers all of Nigeria with detailed soil mapping data. For locations outside Nigeria, general agricultural guidance is provided.',
    ),
    _FaqItem(
      category: 'ASSESSMENTS',
      question: 'How accurate are the soil health scores?',
      answer:
          'Our soil health scores are based on verified geospatial data and AI analysis. Scores reflect real soil properties including drainage, pH, texture, and ecological zone data.',
    ),
    _FaqItem(
      category: 'TECHNICAL',
      question: 'What data sources does LandIQ use?',
      answer:
          'LandIQ uses satellite imagery, soil survey databases, ecological zone maps, and AI models to generate comprehensive land assessments.',
    ),
    _FaqItem(
      category: 'TECHNICAL',
      question: 'How often is the data updated?',
      answer:
          'Soil data is updated quarterly. AI explanations are generated in real-time for each new assessment.',
    ),
    _FaqItem(
      category: 'ACCOUNT',
      question: 'Is my data secure and private?',
      answer:
          'Yes. All data is encrypted in transit and at rest. We use JWT authentication and follow industry best practices for data security.',
    ),
    _FaqItem(
      category: 'ACCOUNT',
      question: 'Can I export my assessment reports?',
      answer:
          'Report export functionality is coming soon. You can currently save assessments for later reference.',
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
                    // Search
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search help articles...',
                        hintStyle: AppTypography.bodyMd.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        prefixIcon: const Icon(Icons.search, size: 20),
                        filled: true,
                        fillColor: AppColors.background2,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),

                    const SizedBox(height: 28),

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
    // Category color mapping
    Color categoryColor;
    switch (faq.category) {
      case 'GETTING STARTED':
        categoryColor = const Color(0xFF2E7D32);
        break;
      case 'ASSESSMENTS':
        categoryColor = const Color(0xFF1565C0);
        break;
      case 'TECHNICAL':
        categoryColor = const Color(0xFFE65100);
        break;
      case 'ACCOUNT':
        categoryColor = const Color(0xFF6A1B9A);
        break;
      default:
        categoryColor = AppColors.primary;
    }

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        faq.category,
                        style: AppTypography.captionLg.copyWith(
                          color: categoryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        faq.question,
                        style: AppTypography.bodyMd
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
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
                  color: AppColors.textSecondary,
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
  final String category;
  final String question;
  final String answer;

  const _FaqItem({
    required this.category,
    required this.question,
    required this.answer,
  });
}
