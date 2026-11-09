import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/services/session_service.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/controllers/platform_dashboard_controller.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/controllers/platform_overview_document_controller.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/widgets/overview/platform_overview_document_preview_dialog.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_dashboard_overview_entity.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/navigation/platform_navigation_registry.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/widgets/overview/platform_overview_chart_grid.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/widgets/overview/platform_recent_activity_section.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/widgets/overview/platform_welcome_panel.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_section_header.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_status_banner.dart';
import 'package:netsales_dashboard/widgets/dashboard_metrics/dashboard_metrics.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_error_state.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_skeleton_grid.dart';
import 'package:netsales_dashboard/widgets/indicators/custom_segmented_bar.dart';

class PlatformOverviewScreen extends GetView<PlatformDashboardController> {
  const PlatformOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final userName = SessionService.to.currentUser?.userFullName.trim() ?? '';
    final quick = PlatformNavigationRegistry.destinations
        .where(PlatformNavigationRegistry.canOpen)
        .take(4)
        .toList(growable: false);
    return Obx(() {
      final data = controller.overview.value;
      final loading = controller.isLoadingOverview.value;
      final failed = controller.hasOverviewError.value;
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PlatformWelcomePanel(
              userName: userName,
              onRefresh: controller.refreshHeaderData,
            ),
            AppSpacing.vMd,
            _PeriodSelector(controller: controller),
            if (data != null) ...[
              AppSpacing.vSm,
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: CustomButton.outline(
                  text: l10n.text('export_pdf'),
                  prefix: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                  size: AppButtonSize.small,
                  loading: Get.find<PlatformOverviewDocumentController>()
                      .isGenerating.value,
                  onPressed: Get.find<PlatformOverviewDocumentController>()
                          .isGenerating.value
                      ? null
                      : () async {
                          final documentController =
                              Get.find<PlatformOverviewDocumentController>();
                          final artifact =
                              await documentController.generate(data);
                          if (artifact == null) return;
                          await Get.dialog<void>(
                            PlatformOverviewDocumentPreviewDialog(
                              artifact: artifact,
                            ),
                            barrierDismissible: false,
                          );
                        },
                ),
              ),
            ],
            if (controller.isOverviewStale && data != null) ...[
              AppSpacing.vSm,
              CustomStatusBanner(
                title: l10n.text('overview_stale'),
                message: l10n.text('overview_stale_message'),
                tone: CustomStatusBannerTone.warning,
                compact: true,
              ),
            ],
            if (quick.isNotEmpty) ...[
              AppSpacing.vXl,
              CustomSectionHeader(title: l10n.text('quick_actions')),
              AppSpacing.vMd,
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final destination in quick)
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
              description: data == null
                  ? l10n.text('overview_api_unavailable')
                  : l10n.text('overview_period_${data.period.key}'),
              leading: Icon(Icons.insights_rounded, color: colors.primary),
            ),
            AppSpacing.vMd,
            if (loading && data == null)
              const CustomSkeletonGrid(
                count: 5,
                crossAxisCount: 3,
                itemHeight: 132,
              )
            else if (failed && data == null)
              CustomErrorState.boxed(
                title: l10n.text('overview_load_failed'),
                subtitle: l10n.text('overview_api_unavailable'),
                retryLabel: l10n.text('refresh'),
                onRetry: controller.refreshHeaderData,
                type: ErrorStateType.server,
              )
            else if (data != null)
              DashboardMetricGrid(
                minimumCardWidth: 210,
                maximumColumns: 5,
                metrics: _metrics(l10n, data),
              )
            else
              CustomStatusBanner(
                title: l10n.text('no_overview_data'),
                message: l10n.text('overview_api_unavailable'),
                tone: CustomStatusBannerTone.info,
              ),
            if (data != null) ...[
              AppSpacing.vXl,
              CustomSectionHeader(
                title: l10n.text('platform_activity'),
                description: l10n.text('operational_activity'),
              ),
              AppSpacing.vMd,
              PlatformOverviewChartGrid(overview: data),
              AppSpacing.vXl,
              _AttentionSection(controller: controller),
              if (data.recentActivity.isNotEmpty ||
                  controller.canViewAudit) ...[
                AppSpacing.vXl,
                const PlatformRecentActivitySection(),
              ],
            ],
          ],
        ),
      );
    });
  }

  List<DashboardMetricData> _metrics(
    AppLocalizations l10n,
    PlatformDashboardOverviewEntity data,
  ) {
    final metrics = data.metrics;
    return [
      if (metrics.networks case final network?)
        DashboardMetricData(
          id: 'active_networks',
          title: l10n.text('active_network_providers'),
          value: network.active.toString(),
          variant: DashboardMetricVariant.status,
          icon: Icons.router_outlined,
          description: '${l10n.text('total')}: ${network.total}',
          tone: DashboardMetricTone.success,
          statusLabel: '${network.pending} ${l10n.text('pending')}',
        ),
      if (metrics.pos case final pos?)
        DashboardMetricData(
          id: 'active_pos',
          title: l10n.text('active_pos'),
          value: pos.active.toString(),
          variant: DashboardMetricVariant.standard,
          icon: Icons.storefront_outlined,
          description: '${l10n.text('total')}: ${pos.total}',
          tone: DashboardMetricTone.success,
        ),
      if (metrics.subscriptions case final subscriptions?) ...[
        DashboardMetricData(
          id: 'active_subscriptions',
          title: l10n.text('active_subscriptions'),
          value: subscriptions.active.toString(),
          variant: DashboardMetricVariant.trend,
          icon: Icons.card_membership_outlined,
          description: '${l10n.text('total')}: ${subscriptions.total}',
          tone: DashboardMetricTone.success,
        ),
        DashboardMetricData(
          id: 'expiring_subscriptions',
          title: l10n.text('expiring_subscriptions'),
          value: subscriptions.expiringWithin7Days.toString(),
          variant: DashboardMetricVariant.status,
          icon: Icons.hourglass_bottom_rounded,
          tone: DashboardMetricTone.warning,
          statusLabel: l10n.text('within_seven_days'),
          description: l10n.text('within_seven_days'),
        ),
      ],
      if (metrics.support case final support?)
        DashboardMetricData(
          id: 'support_tickets',
          title: l10n.text('support_tickets'),
          value: support.totalTickets.toString(),
          variant: DashboardMetricVariant.status,
          icon: Icons.support_agent_outlined,
          tone: DashboardMetricTone.info,
          description:
              '${l10n.text('unread_messages')}: ${support.unreadMessages}',
          statusLabel: l10n.text('server_aggregated_data'),
        ),
      if (metrics.sales case final sales?)
        DashboardMetricData(
          id: 'sales_invoices',
          title: l10n.text('sales_invoices'),
          value: sales.invoiceCount.toString(),
          variant: DashboardMetricVariant.standard,
          icon: Icons.receipt_long_outlined,
          description: '${l10n.text('sales_total')}: ${sales.totalAmount}',
        ),
      if (metrics.expenses case final expenses?)
        DashboardMetricData(
          id: 'expenses',
          title: l10n.text('expenses'),
          value: expenses.count.toString(),
          variant: DashboardMetricVariant.standard,
          icon: Icons.payments_outlined,
          description:
              '${l10n.text('expenses_total')}: ${expenses.totalAmount}',
        ),
    ];
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({required this.controller});
  final PlatformDashboardController controller;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Obx(
      () => CustomSegmentedBar(
        selectedIndex: const [
          '7d',
          '30d',
          '90d',
          '12m',
        ].indexOf(controller.selectedPeriod.value).clamp(0, 3),
        onSegmentChanged: (i) =>
            controller.changePeriod(const ['7d', '30d', '90d', '12m'][i]),
        items: [
          CustomSegmentItem(label: l.text('period_7d')),
          CustomSegmentItem(label: l.text('period_30d')),
          CustomSegmentItem(label: l.text('period_90d')),
          CustomSegmentItem(label: l.text('period_12m')),
        ],
      ),
    );
  }
}

class _AttentionSection extends StatelessWidget {
  const _AttentionSection({required this.controller});
  final PlatformDashboardController controller;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final colors = context.colors;
    final data = controller.overview.value!;
    final groups = data.attentionGroups
        .where((g) => g.count > 0)
        .toList(growable: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomSectionHeader(
          title: l.text('needs_attention'),
          description: l.text('attention_queue_description'),
        ),
        AppSpacing.vMd,
        if (groups.isEmpty)
          CustomStatusBanner(
            title: l.text('nothing_needs_attention'),
            message: l.text('attention_queue_empty'),
            tone: CustomStatusBannerTone.success,
            icon: Icons.task_alt_rounded,
            compact: true,
          )
        else
          for (final group in groups) ...[
            Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l.text('attention_${group.key}'),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Text(
                    group.count.toString(),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
            ),
            for (final item in group.items)
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Material(
                  color: colors.surfaceContainerLow,
                  borderRadius: AppRadius.mdRadius,
                  child: InkWell(
                    borderRadius: AppRadius.mdRadius,
                    onTap: () => _openRoute(item.routeKey),
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Row(children: [
                        Icon(Icons.flag_outlined, color: colors.warning, size: 19),
                        AppSpacing.hSm,
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(item.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
                          ],
                        )),
                        Icon(Icons.arrow_forward_ios_rounded, size: 13, color: colors.onSurfaceVariant),
                      ]),
                    ),
                  ),
                ),
              ),
            AppSpacing.vSm,
          ],
      ],
    );
  }

  void _openRoute(String key) {
    final route = PlatformNavigationRegistry.routeForId(key);
    if (route == null) return;
    controller.setActiveRoute(route);
    Get.toNamed<void>(route);
  }
}
