import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/dashboard_extras/custom_status_banner.dart';
import 'package:netsales_dashboard/widgets/dialogs/custom_dialog.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_empty_state.dart';

@immutable
class CustomNotificationItem {
  const CustomNotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    this.typeLabel,
    this.isRead = false,
  });
  final int id;
  final String title;
  final String message;
  final DateTime? createdAt;
  final String? typeLabel;
  final bool isRead;
}

class CustomNotificationCenter extends StatelessWidget {
  const CustomNotificationCenter({
    super.key,
    required this.items,
    required this.unreadCount,
    required this.isLoading,
    required this.hasError,
    required this.onRefresh,
    required this.onMarkRead,
    required this.onMarkAllRead,
    required this.onViewAll,
  });
  final RxList<CustomNotificationItem> items;
  final RxInt unreadCount;
  final RxBool isLoading;
  final RxBool hasError;
  final VoidCallback onRefresh;
  final ValueChanged<int> onMarkRead;
  final VoidCallback onMarkAllRead;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    return Obx(() {
      final count = unreadCount.value;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          CustomButton.icon(
            icon: Icons.notifications_none_rounded,
            tooltip: l10n.text('notifications'),
            onPressed: () {
              onRefresh();
              CustomDialog.show(
                type: DialogType.custom,
                title: l10n.text('notifications'),
                maxWidth: 620,
                confirmLabel: l10n.text('close'),
                content: Obx(
                  () => _NotificationPanel(
                    items: items.toList(growable: false),
                    unreadCount: unreadCount.value,
                    isLoading: isLoading.value,
                    hasError: hasError.value,
                    onRefresh: onRefresh,
                    onMarkRead: onMarkRead,
                    onMarkAllRead: onMarkAllRead,
                    onViewAll: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      onViewAll();
                    },
                  ),
                ),
              );
            },
            backgroundColor: colors.surfaceContainerLow,
            foregroundColor: colors.onSurfaceVariant,
            dimension: 40,
          ),
          if (count > 0)
            PositionedDirectional(
              top: 0,
              end: 0,
              child: Container(
                constraints: const BoxConstraints(minWidth: 17, minHeight: 17),
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
                decoration: BoxDecoration(
                  color: colors.error,
                  borderRadius: AppRadius.fullRadius,
                  border: Border.all(color: colors.surface, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(count > 99 ? '99+' : '$count', style: AppTypography.caption.copyWith(color: colors.onError, fontSize: 9)),
              ),
            ),
        ],
      );
    });
  }
}

class _NotificationPanel extends StatelessWidget {
  const _NotificationPanel({
    required this.items,
    required this.unreadCount,
    required this.isLoading,
    required this.hasError,
    required this.onRefresh,
    required this.onMarkRead,
    required this.onMarkAllRead,
    required this.onViewAll,
  });
  final List<CustomNotificationItem> items;
  final int unreadCount;
  final bool isLoading;
  final bool hasError;
  final VoidCallback onRefresh;
  final ValueChanged<int> onMarkRead;
  final VoidCallback onMarkAllRead;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(child: Text(l10n.isArabic ? 'غير المقروءة' : 'Unread', style: AppTypography.labelLarge.copyWith(color: colors.onSurfaceVariant))),
            if (unreadCount > 0)
              CustomButton.text(text: l10n.text('mark_all_read'), size: AppButtonSize.small, onPressed: onMarkAllRead),
          ],
        ),
        AppSpacing.vSm,
        if (isLoading)
          const LinearProgressIndicator()
        else if (hasError)
          CustomStatusBanner(
            title: l10n.text('network_error'),
            action: CustomButton.text(text: l10n.text('refresh'), onPressed: onRefresh),
            tone: CustomStatusBannerTone.danger,
            compact: true,
          )
        else if (items.isEmpty)
          CustomEmptyState.compact(title: l10n.text('notifications_empty'), icon: Icons.notifications_off_outlined)
        else
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 390),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: items.length,
              separatorBuilder: (_, _) => Divider(color: colors.outlineVariant),
              itemBuilder: (context, index) {
                final item = items[index];
                final time = item.createdAt == null
                    ? '—'
                    : DateFormat.MMMd(l10n.isArabic ? 'ar' : 'en').add_Hm().format(item.createdAt!);
                return Container(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: item.isRead ? colors.surface : colors.primaryContainer.withValues(alpha: 0.16),
                    borderRadius: AppRadius.mdRadius,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(item.isRead ? Icons.notifications_none_rounded : Icons.notifications_active_outlined, color: item.isRead ? colors.onSurfaceVariant : colors.primary),
                      AppSpacing.hSm,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title, style: AppTypography.titleSmall.copyWith(color: colors.onSurface)),
                            AppSpacing.vXxs,
                            Text(item.message, style: AppTypography.bodySmall.copyWith(color: colors.onSurfaceVariant), maxLines: 3, overflow: TextOverflow.ellipsis),
                            if (item.typeLabel != null) ...[AppSpacing.vXxs, Text(item.typeLabel!, style: AppTypography.caption.copyWith(color: colors.onSurfaceVariant))],
                            AppSpacing.vXs,
                            Text(time, style: AppTypography.caption.copyWith(color: colors.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      if (!item.isRead)
                        CustomButton.icon(
                          icon: Icons.done_rounded,
                          tooltip: l10n.text('mark_read'),
                          size: AppButtonSize.small,
                          dimension: 34,
                          onPressed: () => onMarkRead(item.id),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        AppSpacing.vMd,
        CustomButton.outline(text: l10n.text('view_all'), onPressed: onViewAll, width: double.infinity, size: AppButtonSize.small),
      ],
    );
  }
}
