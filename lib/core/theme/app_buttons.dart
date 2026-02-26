import 'package:flutter/material.dart';
import 'package:landiq/core/theme/app_sizes.dart';
import 'app_colors.dart';
import 'app_typography.dart';

enum AppButtonVariant { primary, secondary, tertiary }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? leadingIcon;
  final bool fullWidth;
  final bool showTrailingArrow;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.leadingIcon,
    this.fullWidth = true,
    this.showTrailingArrow = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.buttonHeightMd,
      width: fullWidth ? double.infinity : null,
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    switch (variant) {
      case AppButtonVariant.primary:
        return _PrimaryButton(
          label: label,
          onPressed: isLoading ? null : onPressed,
          leadingIcon: leadingIcon,
          showTrailingArrow: showTrailingArrow,
          isLoading: isLoading,
        );
      case AppButtonVariant.secondary:
        return _SecondaryButton(
          label: label,
          onPressed: isLoading ? null : onPressed,
          leadingIcon: leadingIcon,
          showTrailingArrow: showTrailingArrow,
          isLoading: isLoading,
        );
      case AppButtonVariant.tertiary:
        return _TertiaryButton(
          label: label,
          onPressed: isLoading ? null : onPressed,
          leadingIcon: leadingIcon,
          showTrailingArrow: showTrailingArrow,
          isLoading: isLoading,
        );
    }
  }
}

// PRIMARY
class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final bool showTrailingArrow;
  final bool isLoading;

  const _PrimaryButton({required this.label, this.onPressed, this.leadingIcon, this.showTrailingArrow = true, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style:
          ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.primary,
            disabledForegroundColor: AppColors.white,
            elevation: AppSizes.elevationSm,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return AppColors.white.withOpacity(0.1);
              }
              if (states.contains(WidgetState.hovered)) {
                return AppColors.white.withOpacity(0.05);
              }
              return null;
            }),
          ),
      child: _ButtonContent(
        label: label,
        leadingIcon: leadingIcon,
        color: AppColors.white,
        showTrailingArrow: showTrailingArrow,
        isLoading: isLoading,
      ),
    );
  }
}

// SECONDARY
class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final bool showTrailingArrow;
  final bool isLoading;

  const _SecondaryButton({
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.showTrailingArrow = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style:
          OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            disabledForegroundColor: AppColors.primary.withOpacity(0.4),
            side: BorderSide(
              color: onPressed == null
                  ? AppColors.primary.withOpacity(0.4)
                  : AppColors.primary,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return AppColors.primary.withOpacity(0.1);
              }
              if (states.contains(WidgetState.hovered)) {
                return AppColors.primary.withOpacity(0.05);
              }
              return null;
            }),
          ),
      child: _ButtonContent(
        label: label,
        leadingIcon: leadingIcon,
        color: onPressed == null
            ? AppColors.primary.withOpacity(0.4)
            : AppColors.primary,
        showTrailingArrow: showTrailingArrow,
        isLoading: isLoading,
      ),
    );
  }
}

// TERTIARY
class _TertiaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final bool showTrailingArrow;
  final bool isLoading;

  const _TertiaryButton({
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.showTrailingArrow = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style:
          TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            disabledForegroundColor: AppColors.primary.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return AppColors.primary.withOpacity(0.1);
              }
              if (states.contains(WidgetState.hovered)) {
                return AppColors.primary.withOpacity(0.05);
              }
              return null;
            }),
          ),
      child: _ButtonContent(
        label: label,
        leadingIcon: leadingIcon,
        color: onPressed == null
            ? AppColors.primary.withOpacity(0.4)
            : AppColors.primary,
        showTrailingArrow: showTrailingArrow,
        isLoading: isLoading,
      ),
    );
  }
}

// SHARED CONTENT (icon + text + arrow)
class _ButtonContent extends StatelessWidget {
  final String label;
  final IconData? leadingIcon;
  final Color color;
  final bool showTrailingArrow;
  final bool isLoading;

  const _ButtonContent({
    required this.label,
    required this.color,
    this.leadingIcon,
    this.showTrailingArrow = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: AppSizes.iconSm, color: color),
          const SizedBox(width: AppSizes.xs),
        ],
        Text(
          label,
          style: AppTypography.bodyMd.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
        if (showTrailingArrow) ...[
          const SizedBox(width: AppSizes.xs),
          Icon(Icons.arrow_forward, size: AppSizes.iconSm, color: color),
        ],
      ],
    );
  }
}
