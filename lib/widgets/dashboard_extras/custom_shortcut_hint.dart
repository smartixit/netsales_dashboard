import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';

class CustomShortcutHint extends StatelessWidget {
  const CustomShortcutHint({super.key, required this.keys, this.label});
  final List<String> keys;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.xxs,
      children: [
        if (label != null)
          Text(
            label!,
            style: AppTypography.caption.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        for (final key in keys)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              borderRadius: AppRadius.smRadius,
              border: Border.all(color: colors.outlineVariant),
            ),
            child: Text(
              key,
              style: AppTypography.labelSmall.copyWith(color: colors.onSurface),
            ),
          ),
      ],
    );
  }
}
