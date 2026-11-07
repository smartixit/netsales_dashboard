import 'package:flutter/material.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/services/session_service.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_gradients.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';

/// Temporary authenticated landing destination until the Dashboard home
/// feature is delivered. It deliberately contains no dashboard business UI.
class AuthSuccessScreen extends StatelessWidget {
  const AuthSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final userName = SessionService.to.currentUser?.userFullName;
    final greeting = userName?.trim().isNotEmpty == true
        ? 'مرحباً ' + userName!.trim()
        : 'مرحباً بك';

    return Scaffold(
      backgroundColor: colors.surface,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppGradients.surfaceMesh(context),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.xxl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSpacing.xxxl),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppRadius.xxl),
                  border: Border.all(color: colors.outlineVariant),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: colors.successContainer.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        size: 44,
                        color: colors.success,
                      ),
                    ),
                    AppSpacing.vXl,
                    Text(
                      greeting,
                      style: AppTypography.headlineSmall.copyWith(
                        color: colors.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.vSm,
                    Text(
                      'تم تسجيل الدخول والتحقق من الجلسة بنجاح.',
                      style: AppTypography.bodyLarge.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.vLg,
                    Text(
                      'هذه وجهة انتقال مؤقتة إلى حين تسليم واجهة لوحة تحكم المنصة. '
                      'لم يتم عرض أي وحدات تشغيلية غير مكتملة.',
                      style: AppTypography.bodyMedium.copyWith(
                        color: colors.onSurfaceVariant,
                        height: 1.7,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
