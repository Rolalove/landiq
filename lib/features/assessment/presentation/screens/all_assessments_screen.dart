import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:landiq/core/theme/app_colors.dart';
import 'package:landiq/core/theme/app_typography.dart';
import 'package:landiq/core/widgets/app_loading_screen.dart';
import 'package:landiq/features/assessment/data/assessment_model.dart';
import 'package:landiq/features/assessment/data/nigerian_states.dart';
import 'package:landiq/features/assessment/presentation/providers/assessment_provider.dart';

class AllAssessmentsScreen extends ConsumerStatefulWidget {
  const AllAssessmentsScreen({super.key});

  @override
  ConsumerState<AllAssessmentsScreen> createState() => _AllAssessmentsScreenState();
}

class _AllAssessmentsScreenState extends ConsumerState<AllAssessmentsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assessmentsAsync = ref.watch(assessmentsListProvider);
    final query = _searchQuery.toLowerCase().trim();

    return Scaffold(
      backgroundColor: AppColors.background2,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.secondary, size: 28),
          onPressed: () => context.goNamed('home'),
        ),
        title: const Text(
          'All Assessments',
          style: TextStyle(
            color: AppColors.secondary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search by state or badge...',
                hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.background2,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ),
      ),
      body: assessmentsAsync.maybeWhen(
        data: (assessments) {
          var filtered = assessments;
          if (query.isNotEmpty) {
            filtered = assessments.where((a) {
              final state = NigerianStates.reverseGeocode(
                a.location.latitude, a.location.longitude).toLowerCase();
              final badge = (a.soilHealth.badge ?? '').toLowerCase();
              return state.contains(query) || badge.contains(query);
            }).toList();
          }

          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.landscape_outlined, size: 56, color: AppColors.grey500),
                  const SizedBox(height: 16),
                  Text(
                    query.isNotEmpty
                        ? 'No results for "$query"'
                        : 'No assessments yet',
                    style: AppTypography.bodyMd.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async => ref.invalidate(assessmentsListProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _AssessmentListCard(assessment: filtered[index]);
              },
            ),
          );
        },
        loading: assessmentsAsync.hasValue ? null : () => const AppLoadingScreen(message: 'Fetching assessments...'),
        orElse: () => const Center(
          child: Text('Failed to load assessments'),
        ),
      ),
    );
  }
}

class _AssessmentListCard extends ConsumerWidget {
  final Assessment assessment;
  const _AssessmentListCard({required this.assessment});

  Color _badgeColor(String? badge) {
    switch (badge?.toUpperCase()) {
      case 'GOLD': return const Color(0xFFD4A017);
      case 'SILVER': return const Color(0xFF607D8B);
      case 'BRONZE': return const Color(0xFFCD7F32);
      case 'PLATINUM': return const Color(0xFF4A90D9);
      default: return AppColors.primary;
    }
  }

  Color _badgeBg(String? badge) {
    switch (badge?.toUpperCase()) {
      case 'GOLD': return const Color(0xFFFFF8E1);
      case 'SILVER': return const Color(0xFFECEFF1);
      case 'BRONZE': return const Color(0xFFFFF3E0);
      case 'PLATINUM': return const Color(0xFFE3F2FD);
      default: return AppColors.background2;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = assessment.soilHealth.totalScore ?? 0;
    final badge = assessment.soilHealth.badge ?? 'N/A';
    final loc = assessment.location;
    final stateName = NigerianStates.reverseGeocode(loc.latitude, loc.longitude);

    final Color scoreColor = score >= 75
        ? const Color(0xFF2E7D32)
        : score >= 60
            ? const Color(0xFFE65100)
            : const Color(0xFFD32F2F);

    return GestureDetector(
      onTap: () async {
        try {
          final repo = ref.read(assessmentRepositoryProvider);
          final full = await repo.getAssessment(assessment.assessmentId);
          ref.read(currentAssessmentProvider.notifier).state = full;
        } catch (_) {
          ref.read(currentAssessmentProvider.notifier).state = assessment;
        }
        if (context.mounted) context.goNamed('assessmentReport');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Score circle
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: scoreColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$score',
                  style: TextStyle(
                    color: scoreColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stateName,
                    style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${loc.areaHectares.toStringAsFixed(1)} hectares',
                    style: AppTypography.captionLg.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _badgeBg(badge),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _badgeColor(badge).withValues(alpha: 0.3)),
              ),
              child: Text(
                badge,
                style: AppTypography.captionLg.copyWith(
                  color: _badgeColor(badge),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
