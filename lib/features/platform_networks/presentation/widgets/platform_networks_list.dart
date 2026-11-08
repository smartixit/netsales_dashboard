import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/entities/platform_network_entity.dart';
import 'package:netsales_dashboard/features/platform_networks/presentation/controllers/platform_networks_controller.dart';
import 'package:netsales_dashboard/features/platform_networks/presentation/widgets/platform_network_status_badge.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/data_grid/adapters/app_data_grid_export_controller.dart';
import 'package:netsales_dashboard/widgets/data_grid/adapters/net_sales_data_grid_source.dart';
import 'package:netsales_dashboard/widgets/data_grid/app_data_grid.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_column.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_features.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_pagination.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_state.dart';
import 'package:netsales_dashboard/widgets/images/custom_cached_image.dart';

class PlatformNetworksList extends StatefulWidget {
  const PlatformNetworksList({
    required this.controller,
    required this.l10n,
    super.key,
  });

  final PlatformNetworksController controller;
  final AppLocalizations l10n;

  @override
  State<PlatformNetworksList> createState() => _PlatformNetworksListState();
}

class _PlatformNetworksListState extends State<PlatformNetworksList> {
  late final AppDataGridExportController _exportController;
  late NetSalesDataGridSource<PlatformNetworkEntity> _source;

  @override
  void initState() {
    super.initState();
    _exportController = AppDataGridExportController();
    _source = _createSource(widget.controller.networks.toList());
  }

  @override
  void didUpdateWidget(covariant PlatformNetworksList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _source = _createSource(widget.controller.networks.toList());
    }
  }

  NetSalesDataGridSource<PlatformNetworkEntity> _createSource(
    List<PlatformNetworkEntity> items,
  ) => NetSalesDataGridSource<PlatformNetworkEntity>(
    items: items,
    columns: _columns,
  );

  List<AppDataGridColumn<PlatformNetworkEntity>> get _columns => [
    AppDataGridColumn<PlatformNetworkEntity>(
      name: 'network',
      label: widget.l10n.text('network_name'),
      width: 270,
      allowFiltering: false,
      valueGetter: (item) => item.name,
      cellBuilder: (context, item, _) => Row(
        children: [
          CustomCachedImage.avatar(
            url: item.logo,
            radius: 19,
            fallbackText: _initials(item.name),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.titleSmall),
                Text(
                  item.uuid ?? 'ID #${item.id}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(color: context.colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    AppDataGridColumn<PlatformNetworkEntity>(
      name: 'owner',
      label: widget.l10n.text('network_owner'),
      width: 190,
      valueGetter: (item) => item.ownerName,
      cellBuilder: (context, item, _) => Text(item.ownerName ?? '—', maxLines: 1, overflow: TextOverflow.ellipsis),
    ),
    AppDataGridColumn<PlatformNetworkEntity>(
      name: 'phone',
      label: widget.l10n.text('network_phone'),
      width: 150,
      allowFiltering: false,
      valueGetter: (item) => item.phoneNumber,
      cellBuilder: (context, item, _) => Text(item.phoneNumber ?? '—', maxLines: 1, overflow: TextOverflow.ellipsis),
    ),
    AppDataGridColumn<PlatformNetworkEntity>(
      name: 'location',
      label: widget.l10n.text('network_location'),
      width: 190,
      allowFiltering: false,
      valueGetter: (item) => item.governorateName,
      cellBuilder: (context, item, _) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.governorateName ?? '—', maxLines: 1, overflow: TextOverflow.ellipsis),
          if (item.directorateName != null)
            Text(item.directorateName!, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.caption.copyWith(color: context.colors.onSurfaceVariant)),
        ],
      ),
    ),
    AppDataGridColumn<PlatformNetworkEntity>(
      name: 'status',
      label: widget.l10n.text('network_status'),
      width: 145,
      allowFiltering: false,
      valueGetter: (item) => item.status,
      cellBuilder: (context, item, _) => PlatformNetworkStatusBadge(status: item.status, statusLabel: item.statusLabel),
    ),
    AppDataGridColumn<PlatformNetworkEntity>(
      name: 'created',
      label: widget.l10n.text('created_at'),
      width: 160,
      valueGetter: (item) => item.createdAt?.toIso8601String(),
      cellBuilder: (context, item, _) => Text(
        _formatDate(item.createdAt),
        style: AppTypography.bodySmall.copyWith(color: context.colors.onSurfaceVariant),
      ),
    ),
    AppDataGridColumn<PlatformNetworkEntity>(
      name: 'actions',
      label: widget.l10n.text('actions'),
      width: 130,
      allowSorting: false,
      allowFiltering: false,
      valueGetter: (item) => item.id,
      cellBuilder: (context, item, _) => CustomButton.text(
        text: widget.l10n.text('view_details'),
        size: AppButtonSize.small,
        onPressed: () => Get.toNamed<void>(AppRoutes.networkDetail(item.id)),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;
        return Column(
          children: [
            if (!compact)
              Expanded(
                child: AppDataGrid<PlatformNetworkEntity>(
                  source: _source,
                  features: const AppDataGridFeatures(
                    dataMode: AppDataGridDataMode.remote,
                    allowFiltering: false,
                    allowSelection: false,
                    allowMultiSelection: false,
                    allowColumnDragging: true,
                    allowColumnResizing: true,
                    rowHeight: 66,
                    headerRowHeight: 54,
                    columnWidthMode: ColumnWidthMode.none,
                  ),
                  viewState: widget.controller.viewState.value,
                  searchController: null,
                  pagination: AppDataGridPagination.cursorBased(
                    hasPrevious: false,
                    hasNext: widget.controller.hasMore,
                    onPrevious: () async {},
                    onNext: () => widget.controller.loadNetworks(append: true),
                    pageLabel: widget.l10n.text('network_page_label'),
                    isLoading: widget.controller.isLoadingMore.value,
                  ),
                  exportController: _exportController,
                  exportFileName: 'NetSales_Networks',
                  onRetry: widget.controller.loadNetworks,
                  errorTitle: widget.l10n.text('networks_load_error'),
                  errorMessage: widget.controller.errorMessage.value,
                  emptyTitle: widget.l10n.text('networks_empty'),
                  emptyMessage: widget.l10n.text('networks_empty_description'),
                  mobileItemBuilder: (context, item) => _NetworkCard(
                    item: item,
                    l10n: widget.l10n,
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: widget.controller.networks.length +
                      (widget.controller.hasMore ? 1 : 0),
                  separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    if (index == widget.controller.networks.length) {
                      return Center(
                        child: CustomButton.secondary(
                          text: widget.l10n.text('load_more'),
                          loading: widget.controller.isLoadingMore.value,
                          onPressed: widget.controller.isLoadingMore.value
                              ? null
                              : () => widget.controller.loadNetworks(append: true),
                        ),
                      );
                    }
                    return _NetworkCard(
                      item: widget.controller.networks[index],
                      l10n: widget.l10n,
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  String _initials(String name) {
    final words = name.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty);
    return words.take(2).map((word) => String.fromCharCode(word.runes.first)).join();
  }

  String _formatDate(DateTime? value) {
    if (value == null) return '—';
    final local = value.toLocal();
    return '${local.year.toString().padLeft(4, '0')}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
  }
}

class _NetworkCard extends StatelessWidget {
  const _NetworkCard({required this.item, required this.l10n});

  final PlatformNetworkEntity item;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Material(
    color: context.colors.surfaceContainerLowest,
    borderRadius: BorderRadius.circular(AppRadius.lg),
    child: InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: () => Get.toNamed<void>(AppRoutes.networkDetail(item.id)),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CustomCachedImage.avatar(url: item.logo, radius: 23, fallbackText: item.name.isEmpty ? '?' : item.name.characters.first),
                SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(item.name, style: AppTypography.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis)),
                PlatformNetworkStatusBadge(status: item.status, statusLabel: item.statusLabel),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            Text(item.ownerName ?? '—', style: AppTypography.bodyMedium),
            Text(item.phoneNumber ?? '—', style: AppTypography.bodySmall.copyWith(color: context.colors.onSurfaceVariant)),
            SizedBox(height: AppSpacing.sm),
            CustomButton.text(
              text: l10n.text('view_details'),
              onPressed: () => Get.toNamed<void>(AppRoutes.networkDetail(item.id)),
            ),
          ],
        ),
      ),
    ),
  );
}
