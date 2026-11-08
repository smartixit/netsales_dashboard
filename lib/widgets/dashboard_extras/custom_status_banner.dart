import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';

enum CustomStatusBannerTone { info, success, warning, danger }

class CustomStatusBanner extends StatelessWidget {
  const CustomStatusBanner({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.tone = CustomStatusBannerTone.info,
    this.action,
    this.compact = false,
  });
  final String title;
  final String? message;
  final IconData? icon;
  final CustomStatusBannerTone tone;
  final Widget? action;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final semantic = switch (tone) {
      CustomStatusBannerTone.info => colors.info,
      CustomStatusBannerTone.success => colors.success,
      CustomStatusBannerTone.warning => colors.warning,
      CustomStatusBannerTone.danger => colors.error,
    };
    final background = switch (tone) {
      CustomStatusBannerTone.info => colors.infoContainer.withValues(alpha: 0.18),
      CustomStatusBannerTone.success => colors.successContainer.withValues(alpha: 0.18),
      CustomStatusBannerTone.warning => colors.warningContainer.withValues(alpha: 0.2),
      CustomStatusBannerTone.danger => colors.errorContainer.withValues(alpha: 0.18),
    };
    return Container(
      padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.lg),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: semantic.withValues(alpha: 0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? Icons.info_outline_rounded, color: semantic),
          AppSpacing.hSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleSmall.copyWith(color: colors.onSurface)),
                if (message != null) ...[
                  AppSpacing.vXxs,
                  Text(message!, style: AppTypography.bodySmall.copyWith(color: colors.onSurfaceVariant)),
                ],
              ],
            ),
          ),
          if (action != null) ...[AppSpacing.hSm, action!],
        ],
      ),
    );
  }
}
