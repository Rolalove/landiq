import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:landiq/core/theme/app_colors.dart';
import 'package:landiq/core/theme/app_typography.dart';
import 'package:landiq/core/widgets/app_loading_screen.dart';
import 'package:landiq/features/auth/presentation/providers/auth_provider.dart';
import 'package:landiq/features/assessment/data/assessment_model.dart';
import 'package:landiq/features/assessment/data/nigerian_states.dart';
import 'package:landiq/features/assessment/presentation/providers/assessment_provider.dart';
import 'package:landiq/features/profile/presentation/screens/profile_screen.dart';
import 'package:landiq/features/saved/presentation/screens/saved_screen.dart';
import 'package:landiq/features/home/presentation/widgets/stat_card.dart';
import 'package:landiq/core/widgets/skeletons.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final int initialTabIndex;
  const HomeScreen({super.key, this.initialTabIndex = 0});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authStateProvider);

    // While tryAutoLogin() is still running, show skeletons in a scaffold shell
    // Only show full page skeletons if we have no user data at all
    if (authAsync.isLoading && !authAsync.hasValue) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSkeleton(),
                const SizedBox(height: 24),
                const SkeletonContainer(width: double.infinity, height: 48, borderRadius: 14),
                const SizedBox(height: 24),
                _HomeScreenState.buildStatsSkeleton(),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SkeletonContainer(width: 150, height: 24),
                    const SkeletonContainer(width: 60, height: 16),
                  ],
                ),
                const SizedBox(height: 14),
                const RecentAssessmentSkeleton(),
                const SizedBox(height: 12),
                const RecentAssessmentSkeleton(),
              ],
            ),
          ),
        ),
      );
    }

    // If no user after resolution, redirect to login
    final user = authAsync.valueOrNull;
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.goNamed('login');
      });
      return const AppLoadingScreen(message: 'Redirecting...');
    }

    // Authenticated -- render normally
    final screens = [
      const _HomeTab(),
      const SavedScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),

      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () => context.goNamed('newAssessment'),
              backgroundColor: AppColors.primary,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHeaderSkeleton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SkeletonContainer(width: 120, height: 20),
            SizedBox(height: 10),
            SkeletonContainer(width: 80, height: 16),
          ],
        ),
        Row(
          children: [
            const SkeletonContainer(width: 36, height: 36, borderRadius: 12),
            const SizedBox(width: 10),
            const SkeletonContainer(width: 40, height: 40, borderRadius: 12),
          ],
        ),
      ],
    );
  }

  static Widget buildStatsSkeleton() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.85,
      children: const [
        StatCardSkeleton(),
        StatCardSkeleton(),
        StatCardSkeleton(),
      ],
    );
  }
}

//  Home Tab
class _HomeTab extends ConsumerStatefulWidget {
  const _HomeTab();

  @override
  ConsumerState<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<_HomeTab> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authStateProvider);
    final assessmentsAsync = ref.watch(assessmentsListProvider);

    final userName = userAsync.whenOrNull(
          data: (user) => user?.firstName ?? 'User',
        ) ??
        'User';

    final query = _searchQuery.toLowerCase().trim();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome back,', style: AppTypography.h5),
                    const SizedBox(height: 10),
                    Text(userName, style: AppTypography.bodyMd),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pushNamed('notifications'),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.background2,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.notifications_none,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search by state or badge...',
                hintStyle: AppTypography.bodyMd.copyWith(
                  color: AppColors.textSecondary,
                ),
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
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Stats Grid -- computed from API data
            assessmentsAsync.maybeWhen(
              data: (assessments) {
                final count = assessments.length;
                final avgScore = count > 0
                    ? (assessments.fold<int>(
                            0, (sum, a) => sum + (a.soilHealth.totalScore ?? 0)) /
                        count)
                        .round()
                    : 0;

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                  children: [
                    StatCard(
                      icon: Icons.analytics_outlined,
                      number: '$count',
                      label: 'Lands Assessed',
                    ),
                    StatCard(
                      icon: Icons.bookmark_outline,
                      number: '$count',
                      label: 'Saved',
                    ),
                    StatCard(
                      icon: Icons.workspace_premium_outlined,
                      number: '$avgScore',
                      label: 'Avg Score',
                    ),
                  ],
                );
              },
              loading: assessmentsAsync.hasValue ? null : () => _HomeScreenState.buildStatsSkeleton(),
              orElse: () => GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
                children: const [
                  StatCard(icon: Icons.analytics_outlined, number: '0', label: 'Lands Assessed'),
                  StatCard(icon: Icons.bookmark_outline, number: '0', label: 'Saved'),
                  StatCard(icon: Icons.workspace_premium_outlined, number: '0', label: 'Avg Score'),
                ],
              ),
            ),

            const SizedBox(height: 28),

            /// Recent Assessments Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Assessments', style: AppTypography.bodyLg),
                GestureDetector(
                  onTap: () => context.pushNamed('allAssessments'),
                  child: Text(
                    'View All',
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Recent Assessment Cards -- from API
            assessmentsAsync.maybeWhen(
              data: (assessments) {
                // Filter by search query
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
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        query.isNotEmpty
                            ? 'No results for "$query"'
                            : 'No assessments yet\nTap + to create your first',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }

                // Show up to 3 most recent
                final recent = filtered.take(3).toList();
                return Column(
                  children: recent.map((a) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _RecentAssessmentCard(assessment: a),
                    );
                  }).toList(),
                );
              },
              loading: assessmentsAsync.hasValue ? null : () => Column(
                children: const [
                  RecentAssessmentSkeleton(),
                  SizedBox(height: 12),
                  RecentAssessmentSkeleton(),
                ],
              ),
              orElse: () => Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(Icons.landscape_outlined,
                        size: 48, color: AppColors.grey500),
                    const SizedBox(height: 12),
                    Text(
                      'No assessments yet',
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap + to create your first assessment',
                      style: AppTypography.captionLg.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => ref.invalidate(assessmentsListProvider),
                      child: Text(
                        'Refresh',
                        style: AppTypography.captionLg.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// Recent Assessment Card
class _RecentAssessmentCard extends ConsumerStatefulWidget {
  final Assessment assessment;

  const _RecentAssessmentCard({required this.assessment});

  @override
  ConsumerState<_RecentAssessmentCard> createState() =>
      _RecentAssessmentCardState();
}

class _RecentAssessmentCardState extends ConsumerState<_RecentAssessmentCard> {
  bool _isLoading = false;

  Color _badgeColor(String? badge) {
    switch (badge?.toUpperCase()) {
      case 'GOLD':
        return const Color(0xFFD4A017);
      case 'SILVER':
        return const Color(0xFF607D8B);
      case 'BRONZE':
        return const Color(0xFFCD7F32);
      case 'PLATINUM':
        return const Color(0xFF4A90D9);
      default:
        return AppColors.primary;
    }
  }

  Color _badgeBg(String? badge) {
    switch (badge?.toUpperCase()) {
      case 'GOLD':
        return const Color(0xFFFFF8E1);
      case 'SILVER':
        return const Color(0xFFECEFF1);
      case 'BRONZE':
        return const Color(0xFFFFF3E0);
      case 'PLATINUM':
        return const Color(0xFFE3F2FD);
      default:
        return AppColors.background2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final assessment = widget.assessment;
    final score = assessment.soilHealth.totalScore ?? 0;
    final badge = assessment.soilHealth.badge ?? 'N/A';
    final loc = assessment.location;

    final Color scoreColor = score >= 75
        ? const Color(0xFF2E7D32)
        : score >= 60
            ? const Color(0xFFE65100)
            : const Color(0xFFD32F2F);

    final stateName = NigerianStates.reverseGeocode(loc.latitude, loc.longitude);

    return GestureDetector(
      onTap: _isLoading
          ? null
          : () async {
              setState(() => _isLoading = true);
              try {
                final repo = ref.read(assessmentRepositoryProvider);
                final full = await repo.getAssessment(assessment.assessmentId);
                ref.read(currentAssessmentProvider.notifier).state = full;
              } catch (_) {
                ref.read(currentAssessmentProvider.notifier).state = assessment;
              } finally {
                if (mounted) setState(() => _isLoading = false);
              }
              if (context.mounted) context.goNamed('assessmentReport');
            },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: _isLoading ? Border.all(color: AppColors.primary, width: 1) : null,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                // Header: Location + Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            '${loc.areaHectares.toStringAsFixed(1)} hectares',
                            style: AppTypography.captionLg.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _badgeBg(badge),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _badgeColor(badge).withValues(alpha: 0.3),
                        ),
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

                const SizedBox(height: 12),

                // Score + Risk
                Row(
                  children: [
                    Text(
                      '$score',
                      style: AppTypography.h4.copyWith(color: scoreColor),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Score',
                      style: AppTypography.captionLg.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.shield_outlined, size: 14, color: scoreColor),
                    const SizedBox(width: 4),
                    Text(
                      assessment.soilHealth.degradationRisk ?? 'N/A',
                      style: AppTypography.captionLg.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
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
}