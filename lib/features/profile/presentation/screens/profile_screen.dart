import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:landiq/core/theme/app_colors.dart';
import 'package:landiq/core/theme/app_typography.dart';
import 'package:landiq/core/router/app_router.dart';
import 'package:landiq/features/auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Gradient Header + User Card
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile',
                      style: AppTypography.h4.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    // User Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 14),
                          // Name + Phone
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.fullName ?? 'User',
                                  style: AppTypography.h5,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user?.email ?? '',
                                  style: AppTypography.bodyMd.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () => context.pushNamed('editProfile'),
                                  child: Text(
                                    'Edit Profile',
                                    style: AppTypography.bodyMd.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ACCOUNT section
                  Text(
                    'ACCOUNT',
                    style: AppTypography.captionLg.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuCard(context, [
                    _MenuItem(
                      icon: Icons.person_outline,
                      label: 'Personal Information',
                      onTap: () => context.pushNamed('editProfile'),
                    ),
                    _MenuItem(
                      icon: Icons.notifications_none,
                      label: 'Notifications',
                      onTap: () => context.pushNamed('notifications'),
                    ),
                    _MenuItem(
                      icon: Icons.lock_outline,
                      label: 'Security & Privacy',
                    ),
                  ]),

                  const SizedBox(height: 28),

                  // SUPPORT section
                  Text(
                    'SUPPORT',
                    style: AppTypography.captionLg.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuCard(context, [
                    _MenuItem(
                      icon: Icons.help_outline,
                      label: 'Help & Support',
                      onTap: () => context.pushNamed('helpSupport'),
                    ),
                    _MenuItem(
                      icon: Icons.description_outlined,
                      label: 'Terms & Privacy',
                      onTap: () => context.pushNamed('legal'),
                    ),
                    _MenuItem(
                      icon: Icons.info_outline,
                      label: 'About LandIQ',
                      onTap: () => context.pushNamed('about'),
                    ),
                  ]),

                  const SizedBox(height: 28),

                  // App Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'App Version',
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text('1.0', style: AppTypography.bodyMd),
                    ],
                  ),


                  const SizedBox(height: 32),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await ref.read(authStateProvider.notifier).logout();
                        ref.invalidate(initialLocationProvider);
                        if (context.mounted) {
                          context.goNamed('login');
                        }
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: AppColors.warning,
                        size: 20,
                      ),
                      label: Text(
                        'Log Out',
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.warning,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
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

  // Builds a white rounded card containing a list of menu items
  Widget _buildMenuCard(BuildContext context, List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              ListTile(
                leading: Icon(
                  item.icon,
                  color: AppColors.secondary,
                  size: 22,
                ),
                title: Text(
                  item.label,
                  style: AppTypography.bodyMd,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onTap: item.onTap,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
              ),
              if (index < items.length - 1)
                Divider(
                  height: 1,
                  indent: 54,
                  color: AppColors.border,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// Simple data holder for menu items
class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.onTap,
  });
}
