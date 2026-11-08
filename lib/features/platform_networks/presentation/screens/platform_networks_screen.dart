import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/controllers/platform_dashboard_controller.dart';
import 'package:netsales_dashboard/features/platform_networks/presentation/controllers/platform_networks_controller.dart';
import 'package:netsales_dashboard/features/platform_networks/presentation/widgets/platform_network_filter_bar.dart';
import 'package:netsales_dashboard/features/platform_networks/presentation/widgets/platform_network_metrics_section.dart';
import 'package:netsales_dashboard/features/platform_networks/presentation/widgets/platform_networks_list.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/dashboard_layout/src/widgets/dashboard_page_header.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_empty_state.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_error_state.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_skeleton_grid.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_state.dart';

class PlatformNetworksScreen extends GetView<PlatformNetworksController> {
  const PlatformNetworksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dashboardController = Get.find<PlatformDashboardController>();
    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DashboardPageHeader(
            data: DashboardPageHeaderData(
              title: l10n.text('networks'),
              description: l10n.text('platform_networks_description'),
              icon: Icons.router_rounded,
              actions: [
                Obx(
                  () => CustomButton.secondary(
                    text: l10n.text('refresh'),
                    prefix: const Icon(Icons.refresh_rounded, size: 18),
                    loading: controller.isRefreshing.value,
                    onPressed: controller.isRefreshing.value ? null : controller.loadNetworks,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Obx(
            () => PlatformNetworkMetricsSection(
              metrics: dashboardController.overview.value?.metrics.networks,
              l10n: l10n,
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          PlatformNetworkFilterBar(controller: controller, l10n: l10n),
          SizedBox(height: AppSpacing.md),
          Expanded(
            child: Obx(() {
              switch (controller.viewState.value) {
                case AppDataGridViewState.loading:
                  return const CustomSkeletonGrid(
                    count: 6,
                    crossAxisCount: 1,
                    itemHeight: 84,
                  );
                case AppDataGridViewState.error:
                  return CustomErrorState.boxed(
                    title: l10n.text('networks_load_error'),
                    subtitle: controller.errorMessage.value,
                    icon: Icons.cloud_off_rounded,
                    onRetry: controller.loadNetworks,
                    retryLabel: l10n.text('refresh'),
                  );
                case AppDataGridViewState.empty:
                  return CustomEmptyState.boxed(
                    title: l10n.text('networks_empty'),
                    subtitle: l10n.text('networks_empty_description'),
                    icon: Icons.router_outlined,
                    badgeText: l10n.text('networks'),
                  );
                case AppDataGridViewState.noResults:
                  return CustomEmptyState.search(
                    query: controller.searchQuery.value,
                    onClearSearch: () {
                      controller.clearFilters();
                    },
                  );
                case AppDataGridViewState.success:
                  return PlatformNetworksList(controller: controller, l10n: l10n);
              }
            }),
          ),
        ],
      ),
    );
  }
}
