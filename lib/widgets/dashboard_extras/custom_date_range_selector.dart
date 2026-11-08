import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/services/date_picker_service.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/widgets/menus/custom_popup_menu.dart';

enum DateRangePreset { today, last7Days, last30Days, thisMonth, custom, clear }

class CustomDateRangeSelector extends StatelessWidget {
  const CustomDateRangeSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.enabled = true,
    this.showClear = true,
  });
  final DateTimeRange? value;
  final ValueChanged<DateTimeRange?> onChanged;
  final String? label;
  final bool enabled;
  final bool showClear;

  Future<void> _select(BuildContext context, DateRangePreset preset) async {
    final now = DateUtils.dateOnly(DateTime.now());
    switch (preset) {
      case DateRangePreset.today:
        onChanged(DateTimeRange(start: now, end: now));
        return;
      case DateRangePreset.last7Days:
        onChanged(
          DateTimeRange(start: now.subtract(const Duration(days: 6)), end: now),
        );
        return;
      case DateRangePreset.last30Days:
        onChanged(
          DateTimeRange(
            start: now.subtract(const Duration(days: 29)),
            end: now,
          ),
        );
        return;
      case DateRangePreset.thisMonth:
        onChanged(
          DateTimeRange(start: DateTime(now.year, now.month), end: now),
        );
        return;
      case DateRangePreset.clear:
        onChanged(null);
        return;
      case DateRangePreset.custom:
        final l10n = AppLocalizations.of(context);
        final range = await DatePickerService.to.pickDateRange(
          context: context,
          initialRange: value,
          title: l10n.text('date_range'),
        );
        if (range != null) onChanged(range);
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final text = value == null
        ? (label ?? l10n.text('date_range'))
        : '${DateFormat.yMMMd(l10n.isArabic ? 'ar' : 'en').format(value!.start)} – ${DateFormat.yMMMd(l10n.isArabic ? 'ar' : 'en').format(value!.end)}';
    final entries = <CustomPopupEntry<DateRangePreset>>[
      CustomPopupItem<DateRangePreset>(
        value: DateRangePreset.today,
        label: l10n.text('today'),
        icon: Icons.today_outlined,
      ),
      CustomPopupItem<DateRangePreset>(
        value: DateRangePreset.last7Days,
        label: l10n.text('previous_7_days'),
        icon: Icons.date_range_outlined,
      ),
      CustomPopupItem<DateRangePreset>(
        value: DateRangePreset.last30Days,
        label: l10n.text('previous_30_days'),
        icon: Icons.calendar_view_month_outlined,
      ),
      CustomPopupItem<DateRangePreset>(
        value: DateRangePreset.thisMonth,
        label: l10n.text('this_month'),
        icon: Icons.calendar_month_outlined,
      ),
      const CustomPopupDivider<DateRangePreset>(),
      CustomPopupItem<DateRangePreset>(
        value: DateRangePreset.custom,
        label: l10n.text('custom_range'),
        icon: Icons.edit_calendar_outlined,
      ),
      if (showClear && value != null)
        CustomPopupItem<DateRangePreset>(
          value: DateRangePreset.clear,
          label: l10n.text('clear_filters'),
          icon: Icons.filter_alt_off_outlined,
        ),
    ];
    return CustomPopupMenu<DateRangePreset>(
      items: entries,
      enabled: enabled,
      onSelected: (preset) => _select(context, preset),
      trigger: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: AppRadius.mdRadius,
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 18,
              color: colors.onSurfaceVariant,
            ),
            AppSpacing.hSm,
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelMedium.copyWith(
                  color: colors.onSurface,
                ),
              ),
            ),
            AppSpacing.hXs,
            Icon(
              Icons.expand_more_rounded,
              size: 18,
              color: colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
