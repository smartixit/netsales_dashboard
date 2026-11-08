import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';

class PlatformSidebarBrand extends StatelessWidget {
  const PlatformSidebarBrand({super.key, required this.collapsed});
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisAlignment: collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Container(
          width: AppSpacing.huge,
          height: AppSpacing.huge,
          decoration: BoxDecoration(color: colors.primaryContainer, borderRadius: AppRadius.mdRadius),
          alignment: Alignment.center,
          child: Icon(Icons.hub_rounded, color: colors.onPrimaryContainer, size: 24),
        ),
        if (!collapsed) ...[
          AppSpacing.hSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NetSales', style: AppTypography.titleMedium.copyWith(color: colors.onSurface, fontWeight: FontWeight.w800)),
                Text(AppLocalizations.of(context).text('platform_edition'), style: AppTypography.caption.copyWith(color: colors.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
