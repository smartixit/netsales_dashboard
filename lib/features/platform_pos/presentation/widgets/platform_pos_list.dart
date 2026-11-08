import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/entities/platform_pos_entity.dart';
import 'package:netsales_dashboard/features/platform_pos/presentation/controllers/platform_pos_controller.dart';
import 'package:netsales_dashboard/features/platform_pos/presentation/widgets/platform_pos_status_badge.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/data_grid/app_data_grid.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_features.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_pagination.dart';
import 'package:netsales_dashboard/widgets/images/custom_cached_image.dart';

class PlatformPosList extends StatelessWidget {
  const PlatformPosList({required this.controller, required this.l10n, super.key});
  final PlatformPosController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Obx(() => LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth >= 760) {
        return AppDataGrid<PlatformPosEntity>(
          source: controller.gridSource,
          features: const AppDataGridFeatures(
            dataMode: AppDataGridDataMode.remote,
            allowSorting: false,
            allowFiltering: false,
            allowSelection: false,
            allowMultiSelection: false,
            allowColumnDragging: true,
            allowColumnResizing: true,
            rowHeight: 66,
            headerRowHeight: 54,
            columnWidthMode: ColumnWidthMode.none,
          ),
          viewState: controller.viewState.value,
          pagination: AppDataGridPagination.cursorBased(
            hasPrevious: false,
            hasNext: controller.hasMore,
            onPrevious: () async {},
            onNext: () => controller.load(append: true),
            pageLabel: l10n.text('pos_page_label'),
            isLoading: controller.isLoadingMore.value,
          ),
          exportController: controller.exportController,
          exportFileName: 'NetSales_POS',
          onRetry: controller.load,
          errorTitle: l10n.text('pos_load_error'),
          errorMessage: controller.errorMessage.value,
          emptyTitle: l10n.text('pos_empty'),
          emptyMessage: l10n.text('pos_empty_description'),
          mobileItemBuilder: (context, item) => _PosCard(item: item, l10n: l10n),
        );
      }
      return ListView.separated(
        itemCount: controller.items.length + (controller.hasMore ? 1 : 0),
        separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          if (index == controller.items.length) {
            return Center(
              child: CustomButton.secondary(
                text: l10n.text('load_more'),
                loading: controller.isLoadingMore.value,
                onPressed: controller.isLoadingMore.value ? null : () => controller.load(append: true),
              ),
            );
          }
          return _PosCard(item: controller.items[index], l10n: l10n);
        },
      );
    },
  ));
}

class _PosCard extends StatelessWidget {
  const _PosCard({required this.item, required this.l10n});
  final PlatformPosEntity item;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Material(
    color: context.colors.surfaceContainerLowest,
    borderRadius: BorderRadius.circular(AppRadius.lg),
    child: InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: () => Get.toNamed<void>(AppRoutes.posDetail(item.id)),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              CustomCachedImage.avatar(url: item.logo, radius: 23, fallbackText: item.name.isEmpty ? '?' : item.name.characters.first),
              SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(item.name, style: AppTypography.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis)),
              PlatformPosStatusBadge(status: item.status, statusLabel: item.statusLabel),
            ]),
            SizedBox(height: AppSpacing.sm),
            Text(item.ownerName ?? '—', style: AppTypography.bodyMedium),
            Text(item.phoneNumber ?? '—', style: AppTypography.bodySmall.copyWith(color: context.colors.onSurfaceVariant)),
            SizedBox(height: AppSpacing.sm),
            CustomButton.text(text: l10n.text('view_details'), onPressed: () => Get.toNamed<void>(AppRoutes.posDetail(item.id))),
          ],
        ),
      ),
    ),
  );
}
