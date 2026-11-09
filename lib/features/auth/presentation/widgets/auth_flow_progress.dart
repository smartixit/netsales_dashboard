import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';

/// Progress indicator for multi-step authentication journeys.
class AuthFlowProgress extends StatelessWidget {
  const AuthFlowProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.label,
  }) : assert(totalSteps > 0),
       assert(currentStep > 0),
       assert(currentStep <= totalSteps);

  final int currentStep;
  final int totalSteps;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTypography.titleSmall.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: colors.primaryContainer.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                '$currentStep / $totalSteps',
                textDirection: TextDirection.ltr,
                style: AppTypography.badgeText.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.vSm,
        Row(
          children: [
            for (var index = 0; index < totalSteps; index++)
              Expanded(
                child: Container(
                  height: 5,
                  margin: EdgeInsetsDirectional.only(
                    end: index == totalSteps - 1 ? 0 : AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: index < currentStep
                        ? colors.primary
                        : colors.outlineVariant.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
