import 'package:get/get.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/presentation/enums/enum_presentation_registry.dart';
import 'package:netsales_dashboard/features/platform_network_pos_links/domain/entities/platform_network_pos_link_entity.dart';
import 'package:netsales_dashboard/widgets/badges/custom_status_badge.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_column.dart';

class PlatformNetworkPosLinkGridColumns {
  PlatformNetworkPosLinkGridColumns._();

  static List<AppDataGridColumn<PlatformNetworkPosLinkEntity>> build(
    AppLocalizations l10n,
  ) => [
    AppDataGridColumn(
      name: 'reference',
      label: l10n.text('link_reference'),
      valueGetter: (row) => row.id,
      width: 110,
      allowFiltering: false,
    ),
    AppDataGridColumn(
      name: 'network',
      label: l10n.text('network_name'),
      valueGetter: (row) => row.networkName ?? '—',
      width: 230,
    ),
    AppDataGridColumn(
      name: 'pos',
      label: l10n.text('pos_name'),
      valueGetter: (row) => row.posName ?? '—',
      width: 230,
    ),
    AppDataGridColumn(
      name: 'phone',
      label: l10n.text('pos_phone'),
      valueGetter: (row) => row.posPhoneNumber ?? '—',
      width: 150,
      allowFiltering: false,
    ),
    AppDataGridColumn(
      name: 'status',
      label: l10n.text('link_status'),
      valueGetter: (row) => row.isActive,
      width: 140,
      allowSorting: false,
      allowFiltering: false,
      cellBuilder: (context, row, value) => CustomStatusBadge.fromPresentation(
        EnumPresentationRegistry.resolveLinkStatus(row.isActive),
        isCompact: true,
      ),
    ),
    AppDataGridColumn(
      name: 'created_at',
      label: l10n.text('created_at'),
      valueGetter: (row) => row.createdAt?.toLocal().toString().split('.').first ?? '—',
      width: 180,
      allowFiltering: false,
    ),
    AppDataGridColumn(
      name: 'actions',
      label: l10n.text('actions'),
      valueGetter: (row) => row.id,
      width: 130,
      allowSorting: false,
      allowFiltering: false,
      cellBuilder: (context, row, value) => CustomButton.text(
        text: l10n.text('view_details'),
        size: AppButtonSize.small,
        onPressed: () => Get.toNamed<void>(AppRoutes.networkPosLinkDetail(row.id)),
      ),
    ),
  ];
}
