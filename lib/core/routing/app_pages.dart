import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/widgets/dashboard_metrics/showcase/dashboard_metrics_showcase_binding.dart';
import 'package:netsales_dashboard/widgets/dashboard_metrics/showcase/dashboard_metrics_showcase_screen.dart';
import 'package:netsales_dashboard/widgets/data_grid/showcase/data_grid_showcase_binding.dart';
import 'package:netsales_dashboard/widgets/data_grid/showcase/data_grid_showcase_screen.dart';

/// ============================================================================
/// سجل صفحات ومسارات التطبيق (Application Pages Register)
/// ============================================================================
abstract final class AppPages {
  AppPages._();

  static const String initial = AppRoutes.initial;

  static final List<GetPage<dynamic>> routes = [
    // Developer-only visual verification; omitted from release builds.
    if (kDebugMode)
      GetPage<dynamic>(
        name: AppRoutes.dashboardMetricsShowcase,
        page: () => const DashboardMetricsShowcaseScreen(),
        binding: DashboardMetricsShowcaseBinding(),
      ),
    // Developer-only DataGrid showcase; omitted from release builds.
    if (kDebugMode)
      GetPage<dynamic>(
        name: AppRoutes.dataGridShowcase,
        page: () => const DataGridShowcaseScreen(),
        binding: DataGridShowcaseBinding(),
      ),
  ];
}
