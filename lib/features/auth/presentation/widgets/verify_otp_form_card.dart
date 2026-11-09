import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/core/utils/form_validators.dart';
import 'package:netsales_dashboard/features/auth/presentation/controllers/verify_otp_controller.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/auth_notice_banner.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_pin_field.dart';
import 'package:netsales_dashboard/widgets/interactions/custom_interactive_bounce.dart';

/// بطاقة نموذج التحقق من رمز OTP (VerifyOtpFormCard)
class VerifyOtpFormCard extends GetView<VerifyOtpController> {
  const VerifyOtpFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          controller.submitOtp();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'تأكيد الرمز',
              style: AppTypography.titleMedium.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            AppSpacing.vXs,
            Text(
              'يرجى إدخال رمز التحقق المكون من 6 أرقام لتأكيد ملكية رقم الهاتف.',
              style: AppTypography.bodySmall.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            AppSpacing.vXl,
            AuthNoticeBanner(
              icon: Icons.sms_outlined,
              title: 'رمز تحقق مؤقت',
              message: 'لا تشارك الرمز مع أي شخص. فريق NetSales لن يطلبه منك عبر الهاتف.',
              accentColor: colors.primary,
            ),
            AppSpacing.vLg,
            Obx(
              () => CustomPinField(
                controller: controller.otpController,
                length: 6,
                autofocus: true,
                useNativeKeyboard: controller.isCustomKeyboard.value,
                validator: FormValidators.otpValidator(length: 6),
                onCompleted: controller.submitOtp,
              ),
            ),
            AppSpacing.vXxl,
            Obx(
              () => CustomInteractiveBounce(
                child: CustomButton.primary(
                  text: 'التحقق والمتابعة',
                  prefix: const Icon(Icons.verified_user_outlined),
                  width: double.infinity,
                  height: 52,
                  loading: controller.isLoading.value,
                  enabled: !controller.isLoading.value,
                  onPressed: controller.submitOtp,
                ),
              ),
            ),
            AppSpacing.vLg,
            Obx(
              () => CustomButton.text(
                text: controller.canResend.value
                    ? 'إعادة إرسال الرمز'
                    : 'إعادة الإرسال بعد ${controller.cooldownSeconds.value} ثانية',
                loading: controller.isResending.value,
                enabled:
                    controller.canResend.value && !controller.isResending.value,
                onPressed: controller.resendOtp,
              ),
            ),
            AppSpacing.vXs,
            CustomButton.text(
              text: 'تغيير رقم الهاتف',
              prefix: const Icon(Icons.edit_outlined),
              onPressed: controller.goToChangePhone,
            ),
          ],
        ),
      ),
    );
  }
}
