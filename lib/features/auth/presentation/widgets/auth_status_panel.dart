import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/interactions/custom_interactive_bounce.dart';

/// Distinct result surface for completed or blocked authentication journeys.
class AuthStatusPanel extends StatelessWidget {
  const AuthStatusPanel({
    super.key,
    required this.icon,
    required this.accentColor,
    required this.eyebrow,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimaryPressed,
    this.secondaryLabel,
    this.onSecondaryPressed,
  });

  final IconData icon;
  final Color accentColor;
  final String eyebrow;
  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimaryPressed;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.65),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.07),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                eyebrow,
                style: AppTypography.badgeText.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          AppSpacing.vXl,
          Center(
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withValues(alpha: 0.1),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.28),
                  width: 1.5,
                ),
              ),
              child: Icon(icon, size: 44, color: accentColor),
            ),
          ),
          AppSpacing.vXl,
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.headlineMedium.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          AppSpacing.vSm,
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: colors.onSurfaceVariant,
              height: 1.65,
            ),
          ),
          AppSpacing.vXxl,
          CustomInteractiveBounce(
            child: CustomButton.primary(
              text: primaryLabel,
              prefix: const Icon(Icons.arrow_forward_rounded),
              width: double.infinity,
              height: 50,
              onPressed: onPrimaryPressed,
            ),
          ),
          if (secondaryLabel != null && onSecondaryPressed != null) ...[
            AppSpacing.vSm,
            CustomButton.text(
              text: secondaryLabel!,
              onPressed: onSecondaryPressed,
            ),
          ],
        ],
      ),
    );
  }
}
