import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_motion.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';

/// عنصر متناسق لعرض شروط ومعايير قوة كلمة المرور باستخدام قياسات ثابتة.
class CustomPasswordRequirementItem extends StatelessWidget {
  const CustomPasswordRequirementItem({
    super.key,
    required this.isValid,
    required this.label,
  });

  final bool isValid;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Row(
        children: [
          AnimatedContainer(
            duration: AppMotion.fast,
            curve: AppMotion.standard,
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isValid
                  ? colors.success.withValues(alpha: 0.15)
                  : colors.outlineVariant.withValues(alpha: 0.3),
            ),
            child: Icon(
              isValid ? Icons.check_rounded : Icons.circle_outlined,
              size: 13,
              color: isValid ? colors.success : colors.onSurfaceVariant,
            ),
          ),
          AppSpacing.hSm,
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: isValid ? colors.success : colors.onSurfaceVariant,
              fontWeight: isValid ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
