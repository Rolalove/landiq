import 'package:flutter/material.dart';
import 'package:landiq/core/theme/app_colors.dart';

class SkeletonContainer extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonContainer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  State<SkeletonContainer> createState() => _SkeletonContainerState();
}

class _SkeletonContainerState extends State<SkeletonContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _opacityAnim = Tween<double>(begin: 0.3, end: 0.7).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnim,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.grey300,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
    );
  }
}

class StatCardSkeleton extends StatelessWidget {
  const StatCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SkeletonContainer(width: 24, height: 24, borderRadius: 6),
          SizedBox(height: 8),
          SkeletonContainer(width: 32, height: 20, borderRadius: 4),
          SizedBox(height: 4),
          SkeletonContainer(width: 48, height: 12, borderRadius: 2),
        ],
      ),
    );
  }
}

class RecentAssessmentSkeleton extends StatelessWidget {
  const RecentAssessmentSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonContainer(width: 100, height: 16),
                  SizedBox(height: 6),
                  SkeletonContainer(width: 60, height: 12),
                ],
              ),
              SkeletonContainer(width: 70, height: 24, borderRadius: 8),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              SkeletonContainer(width: 30, height: 24),
              SizedBox(width: 8),
              SkeletonContainer(width: 40, height: 12),
              Spacer(),
              SkeletonContainer(width: 14, height: 14),
              SizedBox(width: 4),
              SkeletonContainer(width: 50, height: 12),
            ],
          ),
        ],
      ),
    );
  }
}
