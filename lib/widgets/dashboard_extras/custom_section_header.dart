import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_breakpoints.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';

class CustomSectionHeader extends StatelessWidget {
  const CustomSectionHeader({super.key, required this.title, this.description, this.action, this.leading});
  final String title;
  final String? description;
  final Widget? action;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xs,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 180, maxWidth: AppBreakpoints.maxContentWidth),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leading != null) ...[leading!, AppSpacing.hSm],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.titleMedium.copyWith(color: colors.onSurface)),
                    if (description != null) ...[
                      AppSpacing.vXxs,
                      Text(description!, style: AppTypography.bodySmall.copyWith(color: colors.onSurfaceVariant)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}
