import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';

class PlatformNavigationFooter extends StatelessWidget {
  const PlatformNavigationFooter({super.key, required this.collapsed});
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    if (collapsed) {
      return Tooltip(
        message: l10n.text('application'),
        child: Icon(
          Icons.verified_user_outlined,
          color: colors.onSurfaceVariant,
        ),
      );
    }
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_user_outlined, color: colors.primary, size: 20),
          AppSpacing.hSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NetSales Platform',
                  style: AppTypography.labelMedium.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                Text(
                  l10n.text('secure_administration'),
                  style: AppTypography.caption.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
