import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
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
    return CustomStatusBanner(
      title: l10n.text('module_not_delivered'),
      message: title,
      icon: Icons.construction_outlined,
      tone: CustomStatusBannerTone.info,
    );
  }
}
