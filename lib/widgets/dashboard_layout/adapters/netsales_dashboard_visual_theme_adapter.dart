import 'package:flutter/material.dart';

import '../../charts/adapters/netsales_charts_theme_adapter.dart';
import '../../charts/src/theme/charts_theme.dart';
import '../../dashboard_metrics/adapters/netsales_dashboard_metrics_theme_adapter.dart';
import '../../dashboard_metrics/src/theme/dashboard_metrics_theme.dart';
import '../src/theme/dashboard_layout_theme.dart';
import 'netsales_dashboard_theme_adapter.dart';

/// Installs the complete NetSales visual language at one application boundary.
class NetSalesDashboardVisualThemeAdapter {
  const NetSalesDashboardVisualThemeAdapter._();

  static Widget wrap({
    required BuildContext context,
    required Widget child,
  }) {
    final baseTheme = Theme.of(context);
    final extensions = baseTheme.extensions.values.where(
      (extension) =>
          extension is! DashboardLayoutTheme &&
          extension is! DashboardMetricsTheme &&
          extension is! ChartsTheme,
    ).toList(growable: true);

    extensions
      ..add(NetSalesDashboardThemeAdapter.of(context))
      ..add(NetSalesDashboardMetricsThemeAdapter.of(context))
      ..add(NetSalesChartsThemeAdapter.of(context));

    return Theme(
      data: baseTheme.copyWith(extensions: extensions),
      child: child,
    );
  }
}
