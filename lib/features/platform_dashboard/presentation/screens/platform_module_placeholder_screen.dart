import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/navigation/platform_navigation_registry.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_status_banner.dart';

class PlatformModulePlaceholderScreen extends StatelessWidget {
  const PlatformModulePlaceholderScreen({super.key, required this.destinationId});
  final String destinationId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final destination = PlatformNavigationRegistry.destinations.firstWhereOrNull((item) => item.id == destinationId);
    final title = destinationId == 'account'
        ? l10n.text('profile')
        : destination == null ? destinationId : l10n.text(destination.labelKey);
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.headlineSmall.copyWith(color: colors.onSurface)),
        AppSpacing.vMd,
        CustomStatusBanner(
          title: title,
          message: l10n.text('module_not_delivered'),
          icon: Icons.construction_outlined,
          tone: CustomStatusBannerTone.info,
        ),
      ],
    );
  }
}
