import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';

/// بطاقة عرض تفاصيل جلسة التحقق الثنائي والجهاز المستهدف
class TwoFactorDeviceInfoCard extends StatelessWidget {
  const TwoFactorDeviceInfoCard({
    super.key,
    required this.deviceName,
    this.initialMessage,
  });

  final String deviceName;
  final String? initialMessage;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.primaryContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  Icons.phonelink_lock_rounded,
                  color: colors.primary,
                  size: 20,
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'التحقق من أمان الجهاز',
                      style: AppTypography.titleSmall.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AppSpacing.vXxs,
                    Text(
                      'جهاز الدخول: $deviceName',
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.tertiaryContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  '2FA نشط',
                  style: AppTypography.badgeText.copyWith(
                    color: colors.tertiary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (initialMessage != null && initialMessage!.isNotEmpty) ...[
            AppSpacing.vSm,
            Divider(color: colors.outlineVariant.withValues(alpha: 0.4)),
            AppSpacing.vXs,
            Text(
              initialMessage!,
              style: AppTypography.caption.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
