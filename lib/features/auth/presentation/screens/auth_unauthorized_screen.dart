import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_gradients.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/dashboard_layout/desktop_title_bar.dart';
import 'package:netsales_dashboard/widgets/interactions/custom_interactive_bounce.dart';

/// واجهة رفض الصلاحية أو عدم التخويل (AuthUnauthorizedScreen)
class AuthUnauthorizedScreen extends StatelessWidget {
  const AuthUnauthorizedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            const DesktopTitleBar(),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppGradients.surfaceMesh(context),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(AppSpacing.xxl),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(AppSpacing.xxxl),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(AppRadius.xxl),
                          border: Border.all(
                            color: colors.outlineVariant.withValues(alpha: 0.6),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colors.shadow.withValues(alpha: 0.05),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: colors.warningContainer.withValues(
                                  alpha: 0.3,
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colors.warning.withValues(alpha: 0.4),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.gpp_maybe_rounded,
                                size: 44,
                                color: colors.warning,
                              ),
                            ),
                            AppSpacing.vXl,
                            Text(
                              'لا تملك صلاحية الوصول',
                              style: AppTypography.headlineMedium.copyWith(
                                color: colors.onSurface,
                                fontWeight: FontWeight.w800,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            AppSpacing.vSm,
                            Text(
                              'حسابك الحالي لا يمتلك الإذن المطلوب لعرض هذا المورد. '
                              'يظل خادم المنصة هو المرجع الأوحد للتحقق من الصلاحيات وأدوار المستخدمين.',
                              style: AppTypography.bodyMedium.copyWith(
                                color: colors.onSurfaceVariant,
                                height: 1.7,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            AppSpacing.vXxl,
                            CustomInteractiveBounce(
                              child: CustomButton.primary(
                                text: 'العودة إلى لوحة التحكم',
                                prefix: const Icon(Icons.arrow_forward_rounded),
                                width: double.infinity,
                                height: 50,
                                onPressed: () =>
                                    Get.offAllNamed<void>(AppRoutes.dashboard),
                              ),
                            ),
                            AppSpacing.vSm,
                            CustomButton.text(
                              text: 'تسجيل الخروج والتبديل لحساب آخر',
                              onPressed: () =>
                                  Get.offAllNamed<void>(AppRoutes.login),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
