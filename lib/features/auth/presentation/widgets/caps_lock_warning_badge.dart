import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';

/// بطاقة التنبيه التفاعلي لزر Caps Lock عند تفعيله أثناء إدخال كلمة المرور
class CapsLockWarningBadge extends StatelessWidget {
  const CapsLockWarningBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.warningContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: colors.warning.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.keyboard_capslock_rounded,
            size: 15,
            color: colors.warning,
          ),
          AppSpacing.hXs,
          Text(
            'زر الأحرف الكبيرة (Caps Lock) مفعّل',
            style: AppTypography.badgeText.copyWith(
              color: colors.warning,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
