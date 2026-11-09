import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/core/utils/form_validators.dart';
import 'package:netsales_dashboard/features/auth/presentation/controllers/login_controller.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/caps_lock_warning_badge.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/device_attestation_badge.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_password_field.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_phone_field.dart';
import 'package:netsales_dashboard/widgets/interactions/custom_interactive_bounce.dart';

/// بطاقة نموذج تسجيل الدخول التفاعلية (LoginFormCard)
///
/// تمثل نموذج الإدخال الذكي مع دعم اختصارات لوحة المفاتيح في Windows
/// وكشف Caps Lock وعرض تأكيد الجهاز والمقاييس الحيوية.
class LoginFormCard extends GetView<LoginController> {
  const LoginFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Focus(
      onKeyEvent: (node, event) {
        // فحص حالة Caps Lock عند أي ضغط على لوحة المفاتيح
        final isLock = HardwareKeyboard.instance.lockModesEnabled.contains(
          KeyboardLockMode.capsLock,
        );
        controller.updateCapsLock(isLock);

        // إرسال النموذج عند الضغط على Enter
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          controller.submitLogin();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: AutofillGroup(
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header Subtitle ──
              Text(
                'بيانات الدخول',
                style: AppTypography.titleMedium.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              AppSpacing.vXs,
              Text(
                'أدخل رقم هاتفك وكلمة المرور المسجلة لدى منصة NetSales للوصول لحسابك.',
                style: AppTypography.bodySmall.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),

              AppSpacing.vXl,

              // ── Phone Input ──
              CustomPhoneField(
                controller: controller.phoneController,
                label: 'رقم الهاتف',
                hint: '77XXXXXXX',
                autofocus: true,
                textInputAction: TextInputAction.next,
                validator: FormValidators.phoneValidator(
                  fieldName: 'رقم الهاتف',
                ),
              ),

              AppSpacing.vLg,

              // ── Password Input ──
              CustomPasswordField(
                controller: controller.passwordController,
                label: 'كلمة المرور',
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => controller.submitLogin(),
              ),

              // ── Caps Lock Warning ──
              Obx(() {
                if (!controller.isCapsLockOn.value) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: EdgeInsets.only(top: AppSpacing.xs),
                  child: const CapsLockWarningBadge(),
                );
              }),

              AppSpacing.vSm,

              // ── Forgot Password ──
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: CustomButton.text(
                  text: 'نسيت كلمة المرور؟',
                  size: AppButtonSize.small,
                  onPressed: controller.goToForgotPassword,
                ),
              ),

              AppSpacing.vXl,

              // ── Primary Submit Button ──
              Obx(
                () => CustomInteractiveBounce(
                  child: CustomButton.primary(
                    text: 'تسجيل الدخول',
                    prefix: const Icon(Icons.arrow_forward_rounded),
                    width: double.infinity,
                    height: 52,
                    loading: controller.isLoading.value,
                    enabled: !controller.isLoading.value,
                    onPressed: controller.submitLogin,
                  ),
                ),
              ),

              // ── Biometric Authentication (If Supported) ──
              Obx(() {
                if (!controller.canCheckBiometrics.value) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: EdgeInsets.only(top: AppSpacing.md),
                  child: CustomInteractiveBounce(
                    child: CustomButton.outline(
                      text: 'الدخول بالبصمة البيومترية',
                      prefix: const Icon(Icons.fingerprint_rounded),
                      width: double.infinity,
                      height: 48,
                      enabled: !controller.isLoading.value,
                      onPressed: controller.authenticateWithBiometrics,
                    ),
                  ),
                );
              }),

              AppSpacing.vXl,

              // ── Device Attestation Badge ──
              const Center(child: DeviceAttestationBadge()),

              AppSpacing.vLg,

              // ── Trust & Security Footer ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shield_outlined, size: 15, color: colors.success),
                  AppSpacing.hXs,
                  Flexible(
                    child: Text(
                      'اتصال مشفر وجلسة عمل محمية بالخادم',
                      style: AppTypography.badgeText.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
