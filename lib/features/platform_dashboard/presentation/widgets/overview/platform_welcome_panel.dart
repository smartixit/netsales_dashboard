import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/localization/app_localizations.dart';
import 'package:netsales_dashboard/core/themes/app_breakpoints.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/core/themes/app_gradients.dart';
import 'package:netsales_dashboard/core/themes/app_elevation.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';

class PlatformWelcomePanel extends StatelessWidget {
  const PlatformWelcomePanel({
    super.key,
    required this.userName,
    required this.onRefresh,
    this.isRefreshing = false,
  });
  final String userName;
  final VoidCallback onRefresh;
  final bool isRefreshing;

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
        gradient: AppGradients.financialHero(context),
        borderRadius: AppRadius.xxlRadius,
        boxShadow: AppElevation.tinted(
          context,
          colors.primary,
          alpha: 0.16,
          blur: 24,
          dy: 8,
        ),
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
                      Colors.black.withValues(alpha: 0.16),
                      Colors.black.withValues(alpha: 0.08),
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
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AppSpacing.vXxs,
                    Row(
                      children: [
                        Text(
                          l10n.text('platform_summary'),
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.84),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        AppSpacing.hSm,
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.62),
                          ),
                        ),
                        AppSpacing.hSm,
                        Text(
                          date,
                          style: AppTypography.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.72),
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
            onPressed: isRefreshing ? null : onRefresh,
            loading: isRefreshing,
            size: AppButtonSize.small,
            backgroundColor: Colors.white.withValues(alpha: 0.14),
            foregroundColor: Colors.white,
            borderColor: Colors.white.withValues(alpha: 0.24),
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
