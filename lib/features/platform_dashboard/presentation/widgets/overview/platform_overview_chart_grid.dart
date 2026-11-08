import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/services/permission_service.dart';
import 'package:netsales_dashboard/widgets/charts/charting.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_status_banner.dart';

class PlatformOverviewChartGrid extends StatelessWidget {
  const PlatformOverviewChartGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final permissions = PermissionService.to;
    final definitions = <(String, ChartFamily, ChartType)>[
      if (permissions.can('subscriptions.view'))
        (l10n.text('subscription_trend'), ChartFamily.cartesian, ChartType.line),
      if (permissions.can('networks.view') || permissions.can('pos.view'))
        (l10n.text('provider_distribution'), ChartFamily.circular, ChartType.doughnut),
      if (permissions.can('support.view') || permissions.can('system_logs.view'))
        (l10n.text('operational_activity'), ChartFamily.comparison, ChartType.column),
    ];
    if (definitions.isEmpty) {
      return CustomStatusBanner(
        title: l10n.text('module_not_authorized'),
        tone: CustomStatusBannerTone.info,
        compact: true,
      );
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
                    definition: ChartDefinition(
                      family: item.$2,
                      type: item.$3,
                      series: const [],
                      state: ChartState.empty,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
