import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';

class AuthUnauthorizedScreen extends StatelessWidget {
  const AuthUnauthorizedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.no_accounts_outlined,
                  size: 64,
                  color: colors.warning,
                ),
                AppSpacing.vXl,
                Text(
                  'لا تملك صلاحية الوصول',
                  style: AppTypography.headlineSmall.copyWith(
                    color: colors.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.vSm,
                Text(
                  'حسابك لا يملك الإذن المطلوب لهذه الصفحة. '
                  'يظل الخادم هو المرجع النهائي للتحقق من الصلاحيات.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: colors.onSurfaceVariant,
                    height: 1.7,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.vXxl,
                CustomButton.primary(
                  text: 'العودة إلى الصفحة الرئيسية',
                  onPressed: () => Get.offAllNamed<void>(AppRoutes.dashboard),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
