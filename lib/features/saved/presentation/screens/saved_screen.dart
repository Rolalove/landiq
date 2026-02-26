import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:landiq/core/theme/app_colors.dart';
import 'package:landiq/core/theme/app_typography.dart';
import 'package:landiq/core/widgets/app_loading_screen.dart';
import 'package:landiq/features/assessment/data/assessment_model.dart';
import 'package:landiq/features/assessment/data/nigerian_states.dart';
import 'package:landiq/features/assessment/presentation/providers/assessment_provider.dart';

class SavedScreen extends ConsumerStatefulWidget {
  const SavedScreen({super.key});

  @override
  ConsumerState<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends ConsumerState<SavedScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'High Score', 'Medium', 'Low'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Assessment> _applyFilter(List<Assessment> assessments) {
    final query = _searchController.text.toLowerCase();
    var filtered = assessments;

    // Search filter
    if (query.isNotEmpty) {
      filtered = filtered.where((a) {
        final loc = '${a.location.latitude} ${a.location.longitude}'.toLowerCase();
        final badge = (a.soilHealth.badge ?? '').toLowerCase();
        final state = NigerianStates.reverseGeocode(a.location.latitude, a.location.longitude).toLowerCase();
        return loc.contains(query) || badge.contains(query) || state.contains(query);
      }).toList();
    }

    // Category filter
    switch (_selectedFilter) {
      case 'High Score':
        filtered = filtered.where((a) => (a.soilHealth.totalScore ?? 0) >= 75).toList();
        break;
      case 'Medium':
        filtered = filtered.where((a) {
          final s = a.soilHealth.totalScore ?? 0;
          return s >= 50 && s < 75;
        }).toList();
        break;
      case 'Low':
        filtered = filtered.where((a) => (a.soilHealth.totalScore ?? 0) < 50).toList();
        break;
    }

    return filtered;
  }

  Future<void> _deleteAssessment(String id) async {
    final ok = await ref.read(createAssessmentProvider.notifier).delete(id);
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            ok ? 'Assessment deleted successfully' : 'Failed to delete assessment',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: ok ? AppColors.success : AppColors.error,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 120,
            left: 16,
            right: 16,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );

    if (ok) {
      ref.invalidate(assessmentsListProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final assessmentsAsync = ref.watch(assessmentsListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Saved Assessments', style: AppTypography.h4),
                      const SizedBox(height: 4),
                      assessmentsAsync.maybeWhen(
                        data: (list) => Text(
                          '${list.length} lands saved',
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        loading: assessmentsAsync.hasValue ? null : () => Text(
                          'Loading...',
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        orElse: () => Text(
                          '0 lands saved',
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.background2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.filter_list,
                      size: 20,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search saved lands...',
                  hintStyle: AppTypography.bodyMd.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  prefixIcon: const Icon(Icons.search, size: 20),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Filter Chips
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = filter == _selectedFilter;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = filter),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                      child: Text(
                        filter,
                        style: AppTypography.captionLg.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppColors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Assessment Cards
            Expanded(
              child: assessmentsAsync.maybeWhen(
                data: (assessments) {
                  final filtered = _applyFilter(assessments);

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bookmark_border,
                              size: 56, color: AppColors.grey500),
                          const SizedBox(height: 12),
                          Text(
                            assessments.isEmpty
                                ? 'No saved assessments yet'
                                : 'No results match your filter',
                            style: AppTypography.bodyMd.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (assessments.isEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Create an assessment and save it',
                              style: AppTypography.captionLg.copyWith(
                                color: AppColors.grey500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(assessmentsListProvider);
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        return _buildAssessmentCard(filtered[index]);
                      },
                    ),
                  );
                },
                loading: assessmentsAsync.hasValue ? null : () => const AppLoadingScreen(message: 'Loading saved assessments...'),
                orElse: () => Center(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Icon(Icons.bookmark_border,
                              size: 40, color: AppColors.primary),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No saved assessments',
                          style: AppTypography.h6.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your saved assessments will appear here for easy access later.',
                          textAlign: TextAlign.center,
                          style: AppTypography.captionLg.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => ref.invalidate(assessmentsListProvider),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              'Refresh',
                              style: AppTypography.captionLg.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentCard(Assessment assessment) {
    final score = assessment.soilHealth.totalScore ?? 0;
    final badge = assessment.soilHealth.badge ?? 'N/A';
    final loc = assessment.location;

    final Color ratingColor = score >= 75
        ? const Color(0xFF2E7D32)
        : score >= 60
            ? const Color(0xFFE65100)
            : const Color(0xFFD32F2F);

    final Color ratingBg = score >= 75
        ? const Color(0xFFE8F5E9)
        : score >= 60
            ? const Color(0xFFFFF3E0)
            : const Color(0xFFFFEBEE);

    String ratingLabel = score >= 75
        ? 'Excellent'
        : score >= 60
            ? 'Good'
            : 'Needs Attention';

    final stateName = NigerianStates.reverseGeocode(loc.latitude, loc.longitude);

    return GestureDetector(
      onTap: () async {
        try {
          final repo = ref.read(assessmentRepositoryProvider);
          final full = await repo.getAssessment(assessment.assessmentId);
          ref.read(currentAssessmentProvider.notifier).state = full;
        } catch (_) {
          ref.read(currentAssessmentProvider.notifier).state = assessment;
        }
        if (mounted) context.goNamed('assessmentReport');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            // Header Row: Location + Delete
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppColors.background2,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stateName,
                        style: AppTypography.bodyMd.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${loc.areaHectares.toStringAsFixed(1)} hectares | $badge',
                        style: AppTypography.captionLg.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _showDeleteDialog(assessment.assessmentId),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete_outline,
                        size: 18, color: AppColors.error),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Score Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: ratingBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ratingColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Text(
                    '$score',
                    style: AppTypography.h4.copyWith(color: ratingColor),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ratingLabel,
                        style: AppTypography.bodyMd.copyWith(
                          color: ratingColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Overall Quality',
                        style: AppTypography.captionLg.copyWith(
                          color: ratingColor.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Icon(Icons.bar_chart, color: ratingColor, size: 24),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }


  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Assessment'),
        content: const Text('Are you sure you want to delete this assessment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteAssessment(id);
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
