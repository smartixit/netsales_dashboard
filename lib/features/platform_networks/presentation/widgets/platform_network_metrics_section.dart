import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_dashboard_overview_entity.dart';
import 'package:netsales_dashboard/widgets/dashboard_metrics/dashboard_metrics.dart';

class PlatformNetworkMetricsSection extends StatelessWidget {
  const PlatformNetworkMetricsSection({
    required this.metrics,
    required this.l10n,
    super.key,
  });

  final PlatformEntityStatusMetricEntity? metrics;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final data = metrics;
    if (data == null) return const SizedBox.shrink();

    final source = DashboardMetricSource(
      label: l10n.text('server_aggregated_data'),
      detail: l10n.text('overview_api_note'),
      freshness: DashboardMetricFreshness.unknown,
    );

    final cards = <DashboardMetricData>[
      _metric('total', l10n.text('network_metrics_total'), data.total, Icons.hub_outlined, DashboardMetricTone.primary, source),
      _metric('active', l10n.text('network_metrics_active'), data.active, Icons.verified_rounded, DashboardMetricTone.success, source),
      _metric('pending', l10n.text('network_metrics_pending'), data.pending, Icons.hourglass_top_rounded, DashboardMetricTone.warning, source),
      _metric('inactive', l10n.text('network_metrics_inactive'), data.inactive, Icons.pause_circle_outline_rounded, DashboardMetricTone.neutral, source),
      _metric('rejected', l10n.text('network_metrics_rejected'), data.rejected, Icons.block_rounded, DashboardMetricTone.danger, source),
      _metric('banned', l10n.text('network_metrics_banned'), data.banned, Icons.gpp_bad_outlined, DashboardMetricTone.danger, source),
    ];

    return DashboardMetricGrid(
      metrics: cards,
      minimumCardWidth: 190,
      maximumColumns: 6,
    );
  }

  DashboardMetricData _metric(
    String id,
    String title,
    int value,
    IconData icon,
    DashboardMetricTone tone,
    DashboardMetricSource source,
  ) => DashboardMetricData(
    id: id,
    title: title,
    value: value.toString(),
    description: l10n.text('server_aggregated_data'),
    icon: icon,
    tone: tone,
    variant: DashboardMetricVariant.status,
    statusLabel: title,
    source: source,
  );
}
