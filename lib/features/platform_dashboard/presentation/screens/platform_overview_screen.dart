import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/services/permission_service.dart';
import 'package:netsales_dashboard/core/services/session_service.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/controllers/platform_dashboard_controller.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/navigation/platform_navigation_registry.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/widgets/overview/platform_overview_chart_grid.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/widgets/overview/platform_recent_activity_section.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/widgets/overview/platform_welcome_panel.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_section_header.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_status_banner.dart';
import 'package:netsales_dashboard/widgets/dashboard_metrics/dashboard_metrics.dart';

class PlatformOverviewScreen extends GetView<PlatformDashboardController> {
  const PlatformOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final userName = SessionService.to.currentUser?.userFullName.trim() ?? '';
    final quickDestinations = PlatformNavigationRegistry.destinations
        .where(PlatformNavigationRegistry.canOpen)
        .take(4)
        .toList(growable: false);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PlatformWelcomePanel(userName: userName, onRefresh: controller.refreshHeaderData),
          if (quickDestinations.isNotEmpty) ...[
            AppSpacing.vXl,
            CustomSectionHeader(title: l10n.text('quick_actions')),
            AppSpacing.vMd,
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final destination in quickDestinations)
                  CustomButton.outline(
                    text: l10n.text(destination.labelKey),
                    prefix: Icon(destination.icon, size: 18),
                    size: AppButtonSize.small,
                    onPressed: () {
                      controller.setActiveRoute(destination.route);
                      Get.toNamed<void>(destination.route);
                    },
                  ),
              ],
            ),
          ],
          AppSpacing.vXl,
          CustomSectionHeader(
            title: l10n.text('performance_overview'),
            description: l10n.text('overview_api_note'),
            leading: Icon(Icons.insights_rounded, color: colors.primary),
          ),
          AppSpacing.vMd,
          DashboardMetricGrid(
            minimumCardWidth: 210,
            maximumColumns: 5,
            metrics: _metrics(l10n),
          ),
          AppSpacing.vMd,
          CustomStatusBanner(
            title: l10n.text('no_overview_data'),
            message: l10n.text('overview_api_unavailable'),
            tone: CustomStatusBannerTone.warning,
            icon: Icons.query_stats_rounded,
          ),
          AppSpacing.vXl,
          CustomSectionHeader(
            title: l10n.text('platform_activity'),
            description: l10n.text('operational_activity'),
          ),
          AppSpacing.vMd,
          const PlatformOverviewChartGrid(),
          if (controller.canViewAudit) ...[
            AppSpacing.vXl,
            PlatformRecentActivitySection(controller: controller),
          ],
          AppSpacing.vXl,
          CustomSectionHeader(title: l10n.text('needs_attention')),
          AppSpacing.vMd,
          CustomStatusBanner(
            title: l10n.text('no_overview_data'),
            message: l10n.text('overview_api_unavailable'),
            tone: CustomStatusBannerTone.info,
            icon: Icons.fact_check_outlined,
          ),
        ],
      ),
    );
  }

  List<DashboardMetricData> _metrics(AppLocalizations l10n) {
    final permissions = PermissionService.to;
    return [
      if (permissions.can('networks.view'))
        DashboardMetricData(
          id: 'active_networks',
          title: l10n.text('active_network_providers'),
          value: '—',
          variant: DashboardMetricVariant.standard,
          icon: Icons.router_outlined,
          description: l10n.text('no_overview_data'),
        ),
      if (permissions.can('pos.view'))
        DashboardMetricData(
          id: 'active_pos',
          title: l10n.text('active_pos'),
          value: '—',
          variant: DashboardMetricVariant.standard,
          icon: Icons.storefront_outlined,
          description: l10n.text('no_overview_data'),
        ),
      if (permissions.can('subscriptions.view')) ...[
        DashboardMetricData(
          id: 'active_subscriptions',
          title: l10n.text('active_subscriptions'),
          value: '—',
          variant: DashboardMetricVariant.standard,
          icon: Icons.card_membership_outlined,
          description: l10n.text('no_overview_data'),
        ),
        DashboardMetricData(
          id: 'expiring_subscriptions',
          title: l10n.text('expiring_subscriptions'),
          value: '—',
          variant: DashboardMetricVariant.standard,
          icon: Icons.hourglass_bottom_rounded,
          tone: DashboardMetricTone.warning,
          description: l10n.text('no_overview_data'),
        ),
      ],
      if (permissions.can('support.view'))
        DashboardMetricData(
          id: 'open_support_tickets',
          title: l10n.text('open_support_tickets'),
          value: '—',
          variant: DashboardMetricVariant.standard,
          icon: Icons.support_agent_outlined,
          tone: DashboardMetricTone.info,
          description: l10n.text('no_overview_data'),
        ),
    ];
  }
}
