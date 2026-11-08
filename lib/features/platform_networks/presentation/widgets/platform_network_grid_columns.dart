import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/features/platform_networks/domain/entities/platform_network_entity.dart';
import 'package:netsales_dashboard/features/platform_networks/presentation/widgets/platform_network_status_badge.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_column.dart';
import 'package:netsales_dashboard/widgets/images/custom_cached_image.dart';

abstract final class PlatformNetworkGridColumns {
  static List<AppDataGridColumn<PlatformNetworkEntity>> build(
    AppLocalizations l10n,
  ) => [
    AppDataGridColumn<PlatformNetworkEntity>(
      name: 'network',
      label: l10n.text('network_name'),
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
      label: l10n.text('network_owner'),
      width: 190,
      valueGetter: (item) => item.ownerName,
      cellBuilder: (context, item, _) => Text(item.ownerName ?? '—', maxLines: 1, overflow: TextOverflow.ellipsis),
    ),
    AppDataGridColumn<PlatformNetworkEntity>(
      name: 'phone',
      label: l10n.text('network_phone'),
      width: 150,
      allowFiltering: false,
      valueGetter: (item) => item.phoneNumber,
      cellBuilder: (context, item, _) => Text(item.phoneNumber ?? '—', maxLines: 1, overflow: TextOverflow.ellipsis),
    ),
    AppDataGridColumn<PlatformNetworkEntity>(
      name: 'location',
      label: l10n.text('network_location'),
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
      label: l10n.text('network_status'),
      width: 145,
      allowFiltering: false,
      valueGetter: (item) => item.status,
      cellBuilder: (context, item, _) => PlatformNetworkStatusBadge(status: item.status, statusLabel: item.statusLabel),
    ),
    AppDataGridColumn<PlatformNetworkEntity>(
      name: 'created',
      label: l10n.text('created_at'),
      width: 160,
      valueGetter: (item) => item.createdAt?.toIso8601String(),
      cellBuilder: (context, item, _) => Text(
        _formatDate(item.createdAt),
        style: AppTypography.bodySmall.copyWith(color: context.colors.onSurfaceVariant),
      ),
    ),
  ];

  static String _initials(String name) {
    final words = name.trim().split(RegExp(r'\\s+')).where((word) => word.isNotEmpty);
    return words.take(2).map((word) => String.fromCharCode(word.runes.first)).join();
  }

  static String _formatDate(DateTime? value) {
    if (value == null) return '—';
    final local = value.toLocal();
    return '${local.year.toString().padLeft(4, '0')}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
  }
}
