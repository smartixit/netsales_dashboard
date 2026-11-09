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

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.xl),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: AppRadius.xlRadius,
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < AppBreakpoints.desktopMax;
          final copy = Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colors.primary,
                      colors.secondary,
                    ],
                  ),
                  borderRadius: AppRadius.cardRadius,
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: AppTypography.titleLarge.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    AppSpacing.vXxs,
                    Row(
                      children: [
                        Text(
                          l10n.text('platform_summary'),
                          style: AppTypography.bodySmall.copyWith(
                            color: colors.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        AppSpacing.hSm,
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                        ),
                        AppSpacing.hSm,
                        Text(
                          date,
                          style: AppTypography.caption.copyWith(
                            color: colors.onSurfaceVariant.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
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
              AppSpacing.hMd,
              action,
            ],
          );
        },
      ),
    );
  }
}
