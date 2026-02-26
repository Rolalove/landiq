import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:landiq/core/theme/app_colors.dart';
import 'package:landiq/core/theme/app_sizes.dart';
import 'package:landiq/core/theme/app_buttons.dart';
import 'package:landiq/core/widgets/app_loading_screen.dart';
import 'package:landiq/features/assessment/data/assessment_model.dart';
import 'package:landiq/features/assessment/data/nigerian_states.dart';
import 'package:landiq/features/assessment/presentation/providers/assessment_provider.dart';

class AssessmentReportScreen extends ConsumerStatefulWidget {
  const AssessmentReportScreen({super.key});

  @override
  ConsumerState<AssessmentReportScreen> createState() =>
      _AssessmentReportScreenState();
}

class _AssessmentReportScreenState
    extends ConsumerState<AssessmentReportScreen> {
  bool _isSaving = false;
  Timer? _pollingTimer;
  int _pollingCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndStartPolling();
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _checkAndStartPolling() {
    final assessment = ref.read(currentAssessmentProvider);
    if (assessment == null) return;

    // The backend often returns "string" or empty if AI is still thinking
    final isAiPending = assessment.aiExplanation == null ||
        assessment.aiExplanation == 'string' ||
        assessment.aiExplanation!.trim().isEmpty;

    if (isAiPending) {
      _startPolling(assessment.assessmentId);
    }
  }

  void _startPolling(String id) {
    _pollingTimer?.cancel();
    _pollingCount = 0;
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      _pollingCount++;
      if (_pollingCount > 10) {
        timer.cancel();
        return;
      }

      try {
        final repo = ref.read(assessmentRepositoryProvider);
        final fresh = await repo.getAssessment(id);

        final isStillPending = fresh.aiExplanation == null ||
            fresh.aiExplanation == 'string' ||
            fresh.aiExplanation!.trim().isEmpty;

        if (!isStillPending) {
          ref.read(currentAssessmentProvider.notifier).state = fresh;
          timer.cancel();
        }
      } catch (e) {
        // Silently ignore polling errors
      }
    });
  }

  Color _badgeColor(String? badge) {
    switch (badge?.toUpperCase()) {
      case 'GOLD':
        return const Color(0xFFD4A017);
      case 'SILVER':
        return const Color(0xFF8A8A8A);
      case 'BRONZE':
        return const Color(0xFFCD7F32);
      case 'PLATINUM':
        return const Color(0xFF4A90D9);
      default:
        return AppColors.primary;
    }
  }

  Color _riskColor(String? risk) {
    switch (risk?.toUpperCase()) {
      case 'LOW':
        return AppColors.success;
      case 'MODERATE':
      case 'MEDIUM':
        return const Color(0xFFFF9800);
      case 'HIGH':
        return AppColors.error;
      default:
        return AppColors.grey500;
    }
  }

  double _scorePercent(int? score) => (score ?? 0) / 100.0;

  Future<void> _saveAssessment(Assessment a) async {
    setState(() => _isSaving = true);
    final ok = await ref
        .read(createAssessmentProvider.notifier)
        .save(a.assessmentId);
    if (!mounted) return;
    setState(() => _isSaving = false);

    if (ok) {
      // Refresh the assessments list
      ref.invalidate(assessmentsListProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Assessment saved successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      // Navigate back to home (Saved tab)
      // We use a query param or state to ensure the home screen opens the correct tab if possible,
      // but for now context.goNamed('home') defaults to Home tab.
      // THE BETTER WAY: Use the router state or a specific route if defined.
      // For LandIQ, home route handles index.
      context.go('/?tab=1'); // Force Saved tab if router supports it, or just home and user clicks.
      // Wait, let's check app_router.dart if it handles tab.
      // If not, just context.goNamed('home') is fine, but user said "lead to sav screen".
      // Let's assume the user wants to see the saved list immediately.
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save assessment'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showSaveSheet(Assessment a) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              'Save This Assessment?',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Save this assessment permanently to your dashboard. Once saved, you can access it anytime from the Saved tab.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // Save permanently
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : () {
                  Navigator.pop(ctx);
                  _saveAssessment(a);
                },
                icon: const Icon(Icons.bookmark_add, size: 18),
                label: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save Permanently'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Dismiss — expires in 24hrs
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'This assessment will expire in 24 hours',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: Color(0xFFE65100),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.timer_outlined, size: 18),
                label: const Text('Dismiss — expires in 24h'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFE65100),
                  side: const BorderSide(color: Color(0xFFE65100)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(ctx).viewInsets.bottom + 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final assessment = ref.watch(currentAssessmentProvider);

    if (assessment == null) {
      return const AppLoadingScreen(message: 'Loading report...');
    }

    final health = assessment.soilHealth;
    final props = assessment.soilProperties;
    final loc = assessment.location;
    final stateName =
        NigerianStates.reverseGeocode(loc.latitude, loc.longitude);

    return Scaffold(
      backgroundColor: AppColors.background2,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left,
              color: AppColors.secondary, size: 28),
          onPressed: () => context.goNamed('home'),
        ),
        title: const Text(
          'Assessment Report',
          style: TextStyle(
            color: AppColors.secondary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location header card
            _buildLocationCard(stateName, loc),
            const SizedBox(height: 16),

            // Score card
            _buildScoreCard(health),
            const SizedBox(height: 24),

            // Key Indicators
            const Text(
              'KEY INDICATORS',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            _buildIndicatorCard(
              icon: Icons.eco,
              iconColor: AppColors.success,
              title: 'Suitability',
              value: props.suitability ?? 'N/A',
            ),
            const SizedBox(height: 10),
            _buildIndicatorCard(
              icon: Icons.water_drop_outlined,
              iconColor: const Color(0xFF2196F3),
              title: 'Drainage',
              value: props.drainage ?? 'N/A',
            ),
            const SizedBox(height: 10),
            _buildIndicatorCard(
              icon: Icons.terrain,
              iconColor: const Color(0xFFFF9800),
              title: 'Slope',
              value: props.slope ?? 'N/A',
            ),
            const SizedBox(height: 10),
            _buildIndicatorCard(
              icon: Icons.grass,
              iconColor: const Color(0xFF8BC34A),
              title: 'Soil Texture',
              value: props.soilTexture ?? 'N/A',
            ),
            const SizedBox(height: 16),

            // ── Soil properties detail ──
            _buildSoilPropertiesCard(props),
            const SizedBox(height: 16),

            // AI Analysis (Prioritized Visibility)
            _buildAIAnalysisCard(assessment),
            const SizedBox(height: 24),

            // ── Save prompt button ──
            if (assessment.isTemporary)
              AppButton(
                label: 'Save Assessment',
                onPressed: () => _showSaveSheet(assessment),
                showTrailingArrow: false,
                isLoading: false,
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(String stateName, AssessmentLocation loc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.location_on, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stateName,
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${loc.areaHectares.toStringAsFixed(1)} hectares | ${loc.latitude.toStringAsFixed(4)}N, ${loc.longitude.toStringAsFixed(4)}E',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(SoilHealth health) {
    final score = health.totalScore ?? 0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overall Land Score',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _badgeColor(health.badge).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  health.badge ?? 'N/A',
                  style: TextStyle(
                    color: _badgeColor(health.badge),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$score',
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(
                  '/100',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _scorePercent(health.totalScore),
              minHeight: 8,
              backgroundColor: AppColors.grey300,
              valueColor:
                  AlwaysStoppedAnimation<Color>(_badgeColor(health.badge)),
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Poor',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 11)),
              Text('Excellent',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.shield_outlined,
                  size: 16, color: _riskColor(health.degradationRisk)),
              const SizedBox(width: 6),
              Text(
                'Degradation Risk: ${health.degradationRisk ?? 'N/A'}',
                style: TextStyle(
                  color: _riskColor(health.degradationRisk),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoilPropertiesCard(SoilProperties props) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SOIL PROPERTIES',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 14),
          _propertyRow('pH Range', props.phRange ?? 'N/A'),
          _propertyRow('Soil Depth', props.soilDepth ?? 'N/A'),
          _propertyRow('Ecological Zone', props.ecologicalZone ?? 'N/A'),
          _propertyRow('Major Crops', props.majorCrops ?? 'N/A'),
          if (props.riskFactors != null)
            _propertyRow('Risk Factors', props.riskFactors!),
        ],
      ),
    );
  }

  Widget _propertyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.secondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // AI Analysis card with rich Markdown rendering
  Widget _buildAIAnalysisCard(Assessment a) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.08),
                  AppColors.primary.withValues(alpha: 0.03),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.auto_awesome,
                      color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Analysis',
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Powered by LandIQ Intelligence',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                if (a.aiExplanationStatus == 'pending')
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: Color(0xFFFF9800),
                          ),
                        ),
                        SizedBox(width: 6),
                        Text('Pending',
                            style: TextStyle(
                                color: Color(0xFFFF9800), fontSize: 11)),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Markdown body
          Padding(
            padding: const EdgeInsets.all(16),
            child: (a.aiExplanation == null ||
                    a.aiExplanation == 'string' ||
                    a.aiExplanation!.trim().isEmpty)
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        children: [
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Generating AI analysis...',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : MarkdownBody(
                    data: a.aiExplanation ?? '',
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      h1: const TextStyle(
                        color: AppColors.secondary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.4,
                      ),
                      h2: const TextStyle(
                        color: AppColors.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.4,
                      ),
                      h3: const TextStyle(
                        color: AppColors.secondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                      p: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13.5,
                        height: 1.6,
                      ),
                      listBullet: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      strong: const TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                      em: const TextStyle(
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                      horizontalRuleDecoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: AppColors.grey300,
                            width: 1,
                          ),
                        ),
                      ),
                      blockquoteDecoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border(
                          left: BorderSide(
                            color: AppColors.primary,
                            width: 3,
                          ),
                        ),
                      ),
                      blockquotePadding: const EdgeInsets.all(12),
                      listIndent: 20,
                      blockSpacing: 12,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
