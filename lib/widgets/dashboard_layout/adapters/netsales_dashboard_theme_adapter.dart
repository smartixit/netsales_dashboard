import 'package:flutter/material.dart';

import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/themes/app_breakpoints.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_elevation.dart';
import '../../../core/themes/app_motion.dart';

import '../src/theme/dashboard_layout_theme.dart';

/// Maps the NetSales Dashboard design language to reusable dashboard semantic roles.
class NetSalesDashboardThemeAdapter {
  const NetSalesDashboardThemeAdapter._();

  static DashboardLayoutTheme of(BuildContext context) {
    final colors = AppColors.of(context);
    final isDesktop = AppBreakpoints.isDesktop(context);

    return DashboardLayoutTheme(
      sidebarBackground: colors.surfaceContainerLow,
      sidebarForeground: colors.onSurface,
      sidebarMuted: colors.onSurfaceVariant,
      sidebarSelectedBackground: colors.primaryContainer.withValues(alpha: 0.65),
      sidebarSelectedForeground: colors.primary,
      sidebarHoverBackground: colors.surfaceContainerHigh,
      topbarBackground: colors.surfaceContainerLowest,
      contentBackground: colors.background,
      border: colors.outlineVariant.withValues(alpha: 0.52),
      badgeBackground: colors.primary,
      badgeForeground: colors.onPrimary,
      itemRadius: AppRadius.md,
      sidebarPadding: isDesktop ? AppSpacing.lg : AppSpacing.md,
      itemSpacing: AppSpacing.xs,
      sectionSpacing: isDesktop ? AppSpacing.xl : AppSpacing.lg,
      contentPadding: isDesktop ? AppSpacing.xxl : AppSpacing.lg,
      motionDuration: AppMotion.duration(context, AppMotion.normal),
      motionCurve: AppMotion.standard,
    );
  }

  /// Wrap the shell once at the host boundary; generic widgets consume only
  /// the ThemeExtension and never import NetSales Dashboard core services.
  static Widget wrap({required BuildContext context, required Widget child}) {
    final baseTheme = Theme.of(context);
    return Theme(
      data: baseTheme.copyWith(
        extensions: <ThemeExtension<dynamic>>[
          ...baseTheme.extensions.values.where(
            (extension) => extension is! DashboardLayoutTheme,
          ),
          of(context),
        ],
      ),
      child: child,
    );
  }

  /// Exposes the established shadow vocabulary to host-provided surfaces.
  static List<BoxShadow> sidebarElevation(BuildContext context) =>
      AppElevation.level1(context);
}
