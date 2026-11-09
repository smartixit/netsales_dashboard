import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/controllers/platform_dashboard_controller.dart';
import 'package:netsales_dashboard/features/platform_pos/presentation/controllers/platform_pos_controller.dart';
import 'package:netsales_dashboard/features/platform_pos/presentation/widgets/platform_pos_filter_bar.dart';
import 'package:netsales_dashboard/features/platform_pos/presentation/widgets/platform_pos_list.dart';
import 'package:netsales_dashboard/features/platform_pos/presentation/widgets/platform_pos_metrics_section.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/dashboard_layout/src/widgets/dashboard_page_header.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_state.dart';
import 'package:netsales_dashboard/widgets/platform_workspace/platform_workspace.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_empty_state.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_error_state.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_skeleton_grid.dart';

class PlatformPosScreen extends GetView<PlatformPosController> {
  const PlatformPosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dashboard = Get.find<PlatformDashboardController>();
    return PlatformWorkspaceFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DashboardPageHeader(
            data: DashboardPageHeaderData(
              title: l10n.text('pos'),
              description: l10n.text('platform_pos_description'),
              icon: Icons.storefront_rounded,
              actions: [
                Obx(
                  () => CustomButton.secondary(
                    text: l10n.text('refresh'),
                    prefix: const Icon(Icons.refresh_rounded, size: 18),
                    loading: controller.isRefreshing.value,
                    onPressed: controller.isRefreshing.value
                        ? null
                        : controller.load,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Obx(() {
            final metrics = dashboard.overview.value?.metrics.pos;
            if (metrics == null) return const SizedBox.shrink();
            return PlatformWorkspaceSection(
              title: l10n.text('workspace_summary'),
              description: l10n.text('server_aggregated_data'),
              child: PlatformPosMetricsSection(metrics: metrics, l10n: l10n),
            );
          }),
          SizedBox(height: AppSpacing.lg),
          PlatformWorkspaceSurface(
            child: PlatformPosFilterBar(controller: controller, l10n: l10n),
          ),
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
                    title: l10n.text('pos_load_error'),
                    subtitle: controller.errorMessage.value,
                    icon: Icons.cloud_off_rounded,
                    onRetry: controller.load,
                    retryLabel: l10n.text('refresh'),
                  );
                case AppDataGridViewState.empty:
                  return CustomEmptyState.boxed(
                    title: l10n.text('pos_empty'),
                    subtitle: l10n.text('pos_empty_description'),
                    icon: Icons.storefront_outlined,
                    badgeText: l10n.text('pos'),
                  );
                case AppDataGridViewState.noResults:
                  return CustomEmptyState.search(
                    query: controller.searchQuery.value,
                    onClearSearch: controller.clearFilters,
                  );
                case AppDataGridViewState.success:
                  return PlatformPosList(controller: controller, l10n: l10n);
              }
            }),
          ),
        ],
      ),
    );
  }
}
