import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/features/auth/presentation/controllers/login_controller.dart';

/// بطاقة إثبات وهوية الجهاز السيادية (Device Attestation Badge)
///
/// تعرض بيانات الجهاز المتصل به حالياً بتنسيق هادئ وأنيق ومطمئن
/// مع إبراز نوع المنصة (مثل: Windows Desktop).
class DeviceAttestationBadge extends GetView<LoginController> {
  const DeviceAttestationBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Obx(() {
      final deviceName = controller.hardwareDeviceName.value;
      final deviceType = controller.hardwareDeviceType.value;

      if (deviceName.isEmpty && deviceType.isEmpty) {
        return const SizedBox.shrink();
      }

      final isWindows = deviceType.toUpperCase() == 'WINDOWS';

      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: colors.outlineVariant.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isWindows ? Icons.desktop_windows_rounded : Icons.devices_rounded,
              size: 16,
              color: colors.primary,
            ),
            AppSpacing.hSm,
            Flexible(
              child: Text(
                deviceName.isNotEmpty ? deviceName : 'جهاز Windows معتمد',
                style: AppTypography.bodySmall.copyWith(
                  color: colors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AppSpacing.hSm,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colors.primaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
              child: Text(
                'جلسة معتمدة',
                style: AppTypography.badgeText.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
