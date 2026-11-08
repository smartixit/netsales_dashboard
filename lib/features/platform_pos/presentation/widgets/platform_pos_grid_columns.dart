import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/features/platform_pos/domain/entities/platform_pos_entity.dart';
import 'package:netsales_dashboard/features/platform_pos/presentation/widgets/platform_pos_status_badge.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/data_grid/models/app_data_grid_column.dart';
import 'package:netsales_dashboard/widgets/images/custom_cached_image.dart';

abstract final class PlatformPosGridColumns {
  static List<AppDataGridColumn<PlatformPosEntity>> build(
    AppLocalizations l10n,
  ) => [
    AppDataGridColumn<PlatformPosEntity>(
      name: 'pos',
      label: l10n.text('pos_name'),
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
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleSmall,
                ),
                Text(
                  item.uuid ?? 'ID #${item.id}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    AppDataGridColumn<PlatformPosEntity>(
      name: 'owner',
      label: l10n.text('pos_owner'),
      width: 190,
      valueGetter: (item) => item.ownerName,
      cellBuilder: (context, item, _) => Text(
        item.ownerName ?? '—',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    AppDataGridColumn<PlatformPosEntity>(
      name: 'phone',
      label: l10n.text('pos_phone'),
      width: 150,
      allowFiltering: false,
      valueGetter: (item) => item.phoneNumber,
      cellBuilder: (context, item, _) => Text(
        item.phoneNumber ?? '—',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    AppDataGridColumn<PlatformPosEntity>(
      name: 'location',
      label: l10n.text('pos_location'),
      width: 190,
      allowFiltering: false,
      valueGetter: (item) => item.governorateName,
      cellBuilder: (context, item, _) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.governorateName ?? '—',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (item.directorateName != null)
            Text(
              item.directorateName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
        ],
      ),
    ),
    AppDataGridColumn<PlatformPosEntity>(
      name: 'status',
      label: l10n.text('pos_status'),
      width: 145,
      allowFiltering: false,
      valueGetter: (item) => item.status,
      cellBuilder: (context, item, _) => PlatformPosStatusBadge(
        status: item.status,
        statusLabel: item.statusLabel,
      ),
    ),
    AppDataGridColumn<PlatformPosEntity>(
      name: 'created',
      label: l10n.text('created_at'),
      width: 150,
      allowFiltering: false,
      valueGetter: (item) => item.createdAt?.toIso8601String(),
      cellBuilder: (context, item, _) => Text(
        _date(item.createdAt),
        style: AppTypography.bodySmall.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
    ),
    AppDataGridColumn<PlatformPosEntity>(
      name: 'actions',
      label: l10n.text('actions'),
      width: 130,
      allowSorting: false,
      allowFiltering: false,
      valueGetter: (item) => item.id,
      cellBuilder: (context, item, _) => CustomButton.text(
        text: l10n.text('view_details'),
        size: AppButtonSize.small,
        onPressed: () => Get.toNamed<void>(AppRoutes.posDetail(item.id)),
      ),
    ),
  ];

  static String _initials(String name) {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty);
    return words
        .take(2)
        .map((word) => String.fromCharCode(word.runes.first))
        .join();
  }

  static String _date(DateTime? value) {
    if (value == null) return '—';
    final date = value.toLocal();
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
