import 'package:flutter/material.dart';

import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_elevation.dart';
import '../../../core/themes/app_motion.dart';
import '../../../core/themes/app_breakpoints.dart';
import '../src/theme/dashboard_metrics_theme.dart';

/// Bridges the generic KPI semantic theme to the existing NetSales Dashboard tokens.
/// Keep this adapter at the host boundary; generic KPI widgets do not import
/// NetSales Dashboard core classes.
class NetSalesDashboardMetricsThemeAdapter {
  const NetSalesDashboardMetricsThemeAdapter._();

  static DashboardMetricsTheme of(BuildContext context) {
    final colors = AppColors.of(context);
        return DashboardMetricsTheme(
      primary: colors.primary,
      success: colors.success,
      warning: colors.warning,
      danger: colors.error,
      info: colors.info,
      neutral: colors.onSurfaceVariant,
      cardBackground: colors.surfaceContainerLowest,
      cardBorder: colors.outlineVariant.withValues(alpha: 0.55),
      mutedForeground: colors.onSurfaceVariant,
      cardRadius: AppRadius.card,
      cardPadding: AppSpacing.xl,
      iconRadius: AppRadius.md,
      gridSpacing: AppBreakpoints.gridGutter(context),
      cardShadows: AppElevation.level2(context),
      motionDuration: AppMotion.duration(context, AppMotion.fast),
      motionCurve: AppMotion.standard,
    );
  }

  static Widget wrap({required BuildContext context, required Widget child}) {
    final theme = Theme.of(context);
    final extensions = theme.extensions.values
        .where((extension) => extension is! DashboardMetricsTheme)
        .toList(growable: true);
    extensions.add(of(context));

    return Theme(
      data: theme.copyWith(extensions: extensions),
      child: child,
    );
  }
}
