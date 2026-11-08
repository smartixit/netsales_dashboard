import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/widgets/feedback/custom_empty_state.dart';

@immutable
class ActivityTimelineItem {
  const ActivityTimelineItem({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    this.icon = Icons.history_rounded,
    this.actor,
    this.tone,
  });
  final String id;
  final String title;
  final String description;
  final String timestamp;
  final IconData icon;
  final String? actor;
  final Color? tone;
}

class CustomActivityTimeline extends StatelessWidget {
  const CustomActivityTimeline({
    super.key,
    required this.items,
    this.emptyTitle = 'لا توجد نشاطات',
    this.emptyMessage = 'لا توجد أحداث متاحة في هذه الفترة.',
    this.compact = false,
  });
  final List<ActivityTimelineItem> items;
  final String emptyTitle;
  final String emptyMessage;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return CustomEmptyState.compact(
        title: emptyTitle,
        subtitle: emptyMessage,
        icon: Icons.history_toggle_off_rounded,
      );
    }
    final colors = context.colors;
    return Column(
      children: [
        for (var index = 0; index < items.length; index++)
          Padding(
            padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: compact ? 34 : 40,
                      height: compact ? 34 : 40,
                      decoration: BoxDecoration(
                        color: colors.primaryContainer.withValues(alpha: 0.6),
                        borderRadius: AppRadius.mdRadius,
                      ),
                      alignment: Alignment.center,
                      child: Icon(items[index].icon, size: 18, color: items[index].tone ?? colors.primary),
                    ),
                    if (index != items.length - 1)
                      Container(width: 1, height: compact ? 24 : 32, color: colors.outlineVariant),
                  ],
                ),
                AppSpacing.hMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(items[index].title, style: AppTypography.titleSmall.copyWith(color: colors.onSurface)),
                      AppSpacing.vXxs,
                      Text(items[index].description, style: AppTypography.bodySmall.copyWith(color: colors.onSurfaceVariant)),
                      if (items[index].actor != null) ...[
                        AppSpacing.vXxs,
                        Text(items[index].actor!, style: AppTypography.caption.copyWith(color: colors.onSurfaceVariant)),
                      ],
                    ],
                  ),
                ),
                AppSpacing.hSm,
                Text(items[index].timestamp, maxLines: 2, textAlign: TextAlign.end, style: AppTypography.caption.copyWith(color: colors.onSurfaceVariant)),
              ],
            ),
          ),
      ],
    );
  }
}
