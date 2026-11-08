import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/core/services/session_service.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_gradients.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/dashboard_layout/desktop_title_bar.dart';
import 'package:netsales_dashboard/widgets/interactions/custom_interactive_bounce.dart';

/// واجهة تأكيد نجاح التوثيق (AuthSuccessScreen)
///
/// صُممت بأسلوب فاخر ومريح لتأكيد اكتمال التوثيق المؤسسي
/// وتوفير زر انتقال سلس وفوري للوحة التحكم الرئيسية.
class AuthSuccessScreen extends StatelessWidget {
  const AuthSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final userName = SessionService.to.currentUser?.userFullName;
    final greetingName = userName?.trim().isNotEmpty == true
        ? userName!.trim()
        : 'بك';
    final greeting = 'مرحباً $greetingName';

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
                                color: colors.successContainer.withValues(
                                  alpha: 0.25,
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colors.success.withValues(alpha: 0.3),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.check_circle_rounded,
                                size: 48,
                                color: colors.success,
                              ),
                            ),
                            AppSpacing.vXl,
                            Text(
                              greeting,
                              style: AppTypography.headlineMedium.copyWith(
                                color: colors.onSurface,
                                fontWeight: FontWeight.w800,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            AppSpacing.vSm,
                            Text(
                              'تم توثيق جلستك بنجاح واعتماد الصلاحيات.',
                              style: AppTypography.bodyLarge.copyWith(
                                color: colors.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            AppSpacing.vLg,
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              decoration: BoxDecoration(
                                color: colors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.md,
                                ),
                                border: Border.all(
                                  color: colors.outlineVariant.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.shield_outlined,
                                    size: 16,
                                    color: colors.primary,
                                  ),
                                  AppSpacing.hSm,
                                  Text(
                                    'جلسة العمل الإدارية جاهزة ومحمية بالكامل',
                                    style: AppTypography.badgeText.copyWith(
                                      color: colors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AppSpacing.vXxl,
                            CustomInteractiveBounce(
                              child: CustomButton.primary(
                                text: 'الانتقال إلى لوحة التحكم',
                                prefix: const Icon(Icons.dashboard_rounded),
                                width: double.infinity,
                                height: 50,
                                onPressed: () =>
                                    Get.offAllNamed<void>(AppRoutes.dashboard),
                              ),
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
