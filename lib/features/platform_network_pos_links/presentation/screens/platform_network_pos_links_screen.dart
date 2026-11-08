import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/core/services/permission_service.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/entities/platform_network_pos_link_entity.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/presentation/controllers/platform_network_pos_links_controller.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/presentation/widgets/platform_network_pos_link_create_dialog.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/presentation/widgets/platform_network_pos_links_filter_bar.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/presentation/widgets/platform_network_pos_link_grid_columns.dart';
import 'package:netsales_dashboard/core/presentation/enums/enum_presentation_registry.dart';
import 'package:netsales_dashboard/widgets/badges/custom_status_badge.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/data_grid/app_data_grid.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_features.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_pagination.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_state.dart';
import 'package:netsales_dashboard/widgets/dashboard_layout/src/widgets/dashboard_page_header.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_empty_state.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_error_state.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_skeleton_grid.dart';
import 'package:netsales_dashboard/widgets/images/custom_cached_image.dart';

class PlatformNetworkPosLinksScreen
    extends GetView<PlatformNetworkPosLinksController> {
  const PlatformNetworkPosLinksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final canCreate = PermissionService.to.can('networks.edit');
    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DashboardPageHeader(
            data: DashboardPageHeaderData(
              title: l10n.text('network_pos_links'),
              description: l10n.text('network_pos_links_description'),
              icon: Icons.hub_outlined,
              actions: [
                if (canCreate)
                  Obx(
                    () => CustomButton.primary(
                      text: l10n.text('create_network_pos_link'),
                      prefix: const Icon(Icons.add_link_rounded, size: 18),
                      loading: controller.isMutating.value,
                      onPressed: controller.isMutating.value
                          ? null
                          : () => _create(context, l10n),
                    ),
                  ),
                Obx(
                  () => CustomButton.secondary(
                    text: l10n.text('refresh'),
                    prefix: const Icon(Icons.refresh_rounded, size: 18),
                    loading: controller.isLoading.value,
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.loadSelectionOptions().then((_) => controller.load()),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          PlatformNetworkPosLinksFilterBar(controller: controller, l10n: l10n),
          SizedBox(height: AppSpacing.md),
          Expanded(
            child: Obx(() {
              final state = controller.isLoading.value && controller.links.isEmpty
                  ? AppDataGridViewState.loading
                  : controller.errorMessage.value.isNotEmpty && controller.links.isEmpty
                  ? AppDataGridViewState.error
                  : controller.links.isEmpty
                  ? AppDataGridViewState.empty
                  : AppDataGridViewState.success;
              if (state == AppDataGridViewState.loading) {
                return const CustomSkeletonGrid(count: 6, crossAxisCount: 1, itemHeight: 76);
              }
              if (state == AppDataGridViewState.error) {
                return CustomErrorState.boxed(
                  title: l10n.text('network_pos_links_load_error'),
                  subtitle: controller.errorMessage.value,
                  icon: Icons.cloud_off_rounded,
                  retryLabel: l10n.text('refresh'),
                  onRetry: controller.load,
                );
              }
              if (state == AppDataGridViewState.empty) {
                return CustomEmptyState.boxed(
                  title: l10n.text('network_pos_links_empty'),
                  subtitle: l10n.text('network_pos_links_empty_description'),
                  icon: Icons.link_off_rounded,
                  badgeText: l10n.text('network_pos_links'),
                  actionLabel: canCreate ? l10n.text('create_network_pos_link') : null,
                  onAction: canCreate ? () => _create(context, l10n) : null,
                );
              }
              return AppDataGrid<PlatformNetworkPosLinkEntity>(
                source: controller.dataSource,
                features: const AppDataGridFeatures(
                  dataMode: AppDataGridDataMode.remote,
                  allowSorting: false,
                  allowFiltering: false,
                  allowSelection: false,
                  allowMultiSelection: false,
                  allowColumnDragging: true,
                  allowColumnResizing: true,
                  rowHeight: 68,
                  headerRowHeight: 54,
                ),
                viewState: state,
                searchController: controller.searchController,
                searchHint: l10n.text('search_network_pos_links_hint'),
                onSearchChanged: controller.onSearchChanged,
                onClearSearch: controller.clearSearch,
                pagination: AppDataGridPagination.cursorBased(
                  hasPrevious: false,
                  hasNext: controller.hasMore.value,
                  onPrevious: () async {},
                  onNext: controller.loadMore,
                  pageLabel: l10n.text('load_more'),
                  isLoading: controller.isLoadingMore.value,
                ),
                exportFileName: 'NetSales_Network_POS_Links',
                onRetry: controller.load,
                errorTitle: l10n.text('network_pos_links_load_error'),
                errorMessage: controller.errorMessage.value,
                emptyTitle: l10n.text('network_pos_links_empty'),
                emptyMessage: l10n.text('network_pos_links_empty_description'),
                mobileItemBuilder: (context, item) => _LinkCard(item: item, l10n: l10n),
              );
            }),
          ),
        ],
      ),
    );
  }

  Future<void> _create(BuildContext context, AppLocalizations l10n) async {
    await controller.loadSelectionOptions();
    if (controller.networks.isEmpty || controller.pointsOfSale.isEmpty) {
      CustomSnackbar.show(
        title: l10n.text('error'),
        message: l10n.text('network_pos_link_options_unavailable'),
        type: SnackType.error,
      );
      return;
    }
    final result = await PlatformNetworkPosLinkCreateDialog.show(
      controller: controller,
      l10n: l10n,
    );
    if (result != true) return;
    try {
      await CustomAnimationOverlay.showLoading(message: l10n.text('creating_link'));
      await controller.create();
      if (CustomAnimationOverlay.isShowing) await CustomAnimationOverlay.hide();
      await CustomAnimationOverlay.showSuccess(message: l10n.text('network_pos_link_created'));
    } catch (error) {
      if (CustomAnimationOverlay.isShowing) await CustomAnimationOverlay.hide();
      CustomSnackbar.show(title: l10n.text('error'), message: error.toString(), type: SnackType.error);
    }
  }
}

class _LinkCard extends StatelessWidget {
  const _LinkCard({required this.item, required this.l10n});

  final PlatformNetworkPosLinkEntity item;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            CustomCachedImage.logo(url: item.networkLogo, size: 42, fallback: const Icon(Icons.router_outlined)),
            SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(item.networkName ?? '—', style: Theme.of(context).textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis)),
            CustomStatusBadge.fromPresentation(EnumPresentationRegistry.resolveLinkStatus(item.isActive), isCompact: true),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              const Icon(Icons.link_rounded, size: 18),
              SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(item.posName ?? '—', style: Theme.of(context).textTheme.bodyMedium)),
            ],
          ),
        ),
        CustomButton.text(
          text: l10n.text('view_details'),
          onPressed: () => Get.toNamed<void>(AppRoutes.networkPosLinkDetail(item.id)),
        ),
      ],
    ),
  );
}
