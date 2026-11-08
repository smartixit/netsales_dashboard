import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/services/permission_service.dart';
import 'package:netsales_dashboard/core/services/session_service.dart';
import 'package:netsales_dashboard/core/themes/app_breakpoints.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_activity_entity.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/controllers/platform_dashboard_controller.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/navigation/platform_navigation_registry.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/charts/charting.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_activity_timeline.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_section_header.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_status_banner.dart';
import 'package:netsales_dashboard/widgets/dashboard_metrics/dashboard_metrics.dart';
import 'package:netsales_dashboard/widgets/data_grid/app_data_grid.dart';

class PlatformOverviewScreen extends GetView<PlatformDashboardController> {
  const PlatformOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final userName = SessionService.to.currentUser?.userFullName.trim() ?? '';
    final greeting = userName.isEmpty ? l10n.text('welcome_back') : '${l10n.text('welcome_back')}، $userName';
    final quickDestinations = PlatformNavigationRegistry.destinations.where(PlatformNavigationRegistry.canOpen).take(4).toList(growable: false);

    return SingleChildScrollView(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _WelcomePanel(greeting: greeting, subtitle: l10n.text('platform_summary'), onRefresh: controller.refreshHeaderData),
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
        DashboardMetricGrid(minimumCardWidth: 210, maximumColumns: 5, metrics: _metrics(l10n)),
        AppSpacing.vMd,
        CustomStatusBanner(
          title: l10n.text('no_overview_data'),
          message: l10n.text('overview_api_unavailable'),
          tone: CustomStatusBannerTone.warning,
          icon: Icons.query_stats_rounded,
        ),
        AppSpacing.vXl,
        CustomSectionHeader(title: l10n.text('platform_activity'), description: l10n.text('operational_activity')),
        AppSpacing.vMd,
        const _ChartGrid(),
        AppSpacing.vXl,
        if (controller.canViewAudit) ...[
          CustomSectionHeader(title: l10n.text('recent_activity'), description: l10n.text('recent_activity')),
          AppSpacing.vMd,
          Obx(() {
            if (controller.isLoadingActivity.value) return const Center(child: CircularProgressIndicator());
            if (controller.hasActivityError.value) {
              return CustomStatusBanner(
                title: l10n.text('network_error'),
                action: CustomButton.text(text: l10n.text('refresh'), onPressed: controller.loadActivity),
                tone: CustomStatusBannerTone.danger,
              );
            }
            return CustomActivityTimeline(
              items: controller.activityItems,
              emptyTitle: l10n.text('no_activity'),
              emptyMessage: l10n.text('no_activity'),
            );
          }),
          AppSpacing.vXl,
          CustomSectionHeader(title: l10n.text('audit_logs'), description: l10n.text('recent_activity')),
          AppSpacing.vMd,
          Obx(() {
            final source = controller.activityGridSource.value;
            if (source == null || source.items.isEmpty) {
              return CustomStatusBanner(title: l10n.text('no_activity'), tone: CustomStatusBannerTone.info, compact: true);
            }
            return SizedBox(
              height: 340,
              child: AppDataGrid<PlatformActivityEntity>(
                source: source,
                title: l10n.text('audit_logs'),
                subtitle: l10n.text('recent_activity'),
                emptyTitle: l10n.text('no_activity'),
                emptyMessage: l10n.text('no_activity'),
              ),
            );
          }),
          AppSpacing.vXl,
        ],
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
        DashboardMetricData(id: 'active_networks', title: l10n.text('active_network_providers'), value: '—', variant: DashboardMetricVariant.standard, icon: Icons.router_outlined, description: l10n.text('no_overview_data')),
      if (permissions.can('pos.view'))
        DashboardMetricData(id: 'active_pos', title: l10n.text('active_pos'), value: '—', variant: DashboardMetricVariant.standard, icon: Icons.storefront_outlined, description: l10n.text('no_overview_data')),
      if (permissions.can('subscriptions.view')) ...[
        DashboardMetricData(id: 'active_subscriptions', title: l10n.text('active_subscriptions'), value: '—', variant: DashboardMetricVariant.standard, icon: Icons.card_membership_outlined, description: l10n.text('no_overview_data')),
        DashboardMetricData(id: 'expiring_subscriptions', title: l10n.text('expiring_subscriptions'), value: '—', variant: DashboardMetricVariant.standard, icon: Icons.hourglass_bottom_rounded, tone: DashboardMetricTone.warning, description: l10n.text('no_overview_data')),
      ],
      if (permissions.can('support.view'))
        DashboardMetricData(id: 'open_support_tickets', title: l10n.text('open_support_tickets'), value: '—', variant: DashboardMetricVariant.standard, icon: Icons.support_agent_outlined, tone: DashboardMetricTone.info, description: l10n.text('no_overview_data')),
    ];
  }
}

class _WelcomePanel extends StatelessWidget {
  const _WelcomePanel({required this.greeting, required this.subtitle, required this.onRefresh});
  final String greeting;
  final String subtitle;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final date = DateFormat.yMMMMEEEEd(l10n.isArabic ? 'ar' : 'en').format(DateTime.now());
    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: colors.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < AppBreakpoints.desktopMax;
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(greeting, style: AppTypography.headlineSmall.copyWith(color: colors.onSurface)),
              AppSpacing.vXs,
              Text(subtitle, style: AppTypography.bodyMedium.copyWith(color: colors.onSurfaceVariant)),
              AppSpacing.vXs,
              Text(date, style: AppTypography.caption.copyWith(color: colors.onSurfaceVariant)),
            ],
          );
          final action = CustomButton.outline(
            text: l10n.text('refresh'),
            prefix: const Icon(Icons.refresh_rounded, size: 18),
            onPressed: onRefresh,
            size: AppButtonSize.small,
          );
          if (compact) {
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [copy, AppSpacing.vMd, action]);
          }
          return Row(children: [Expanded(child: copy), action]);
        },
      ),
    );
  }
}

class _ChartGrid extends StatelessWidget {
  const _ChartGrid();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final permissions = PermissionService.to;
    final definitions = <(String, ChartFamily, ChartType)>[
      if (permissions.can('subscriptions.view')) (l10n.text('subscription_trend'), ChartFamily.cartesian, ChartType.line),
      if (permissions.can('networks.view') || permissions.can('pos.view')) (l10n.text('provider_distribution'), ChartFamily.circular, ChartType.doughnut),
      if (permissions.can('support.view') || permissions.can('system_logs.view')) (l10n.text('operational_activity'), ChartFamily.comparison, ChartType.column),
    ];
    if (definitions.isEmpty) {
      return CustomStatusBanner(title: l10n.text('module_not_authorized'), tone: CustomStatusBannerTone.info, compact: true);
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1200 ? 3 : width >= 900 ? 2 : 1;
        final gap = AppSpacing.md;
        final itemWidth = (width - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final item in definitions)
              SizedBox(
                width: itemWidth,
                child: ChartCard(
                  title: item.$1,
                  description: l10n.text('overview_api_unavailable'),
                  height: 230,
                  state: ChartState.empty,
                  chart: ChartRenderer(
                    definition: ChartDefinition(family: item.$2, type: item.$3, series: const [], state: ChartState.empty),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
