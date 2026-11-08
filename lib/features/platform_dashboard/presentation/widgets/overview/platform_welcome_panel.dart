import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/themes/app_breakpoints.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';

class PlatformWelcomePanel extends StatelessWidget {
  const PlatformWelcomePanel({
    super.key,
    required this.userName,
    required this.onRefresh,
  });
  final String userName;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final greeting = userName.isEmpty
        ? l10n.text('welcome_back')
        : '${l10n.text('welcome_back')}${l10n.isArabic ? '، ' : ', '}$userName';
    final date = DateFormat.yMMMMEEEEd(l10n.isArabic ? 'ar' : 'en')
        .format(DateTime.now());

    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: colors.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < AppBreakpoints.desktopMax;
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: AppTypography.headlineSmall.copyWith(
                  color: colors.onSurface,
                ),
              ),
              AppSpacing.vXs,
              Text(
                l10n.text('platform_summary'),
                style: AppTypography.bodyMedium.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              AppSpacing.vXs,
              Text(
                date,
                style: AppTypography.caption.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          );
          final action = CustomButton.outline(
            text: l10n.text('refresh'),
            prefix: const Icon(Icons.refresh_rounded, size: 18),
            onPressed: onRefresh,
            size: AppButtonSize.small,
          );
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [copy, AppSpacing.vMd, action],
            );
          }
          return Row(
            children: [
              Expanded(child: copy),
              action,
            ],
          );
        },
      ),
    );
  }
}
