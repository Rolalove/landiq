import 'package:flutter/material.dart';
import 'package:landiq/core/theme/app_colors.dart';
import 'package:landiq/core/theme/app_typography.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String number;
  final String label;

  const StatCard({
    super.key,
    required this.icon,
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
  decoration: BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppColors.border,
      width: 1.0,
    ),
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        icon,
        size: 22,
        color: AppColors.primary,
      ),
      const SizedBox(height: 8),

      Text(
        number,
        style: AppTypography.h4,
      ),

      const SizedBox(height: 4),

      Flexible( // prevents overflow
        child: Text(
          label,
          style: AppTypography.captionLg,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  ),
);
  }
}