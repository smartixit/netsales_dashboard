import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/core/utils/form_validators.dart';
import 'package:netsales_dashboard/features/auth/presentation/controllers/two_factor_auth_controller.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/two_factor_device_info_card.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_pin_field.dart';
import 'package:netsales_dashboard/widgets/interactions/custom_interactive_bounce.dart';

/// بطاقة إدخال وتأكيد المصادقة الثنائية (TwoFactorFormCard)
class TwoFactorFormCard extends GetView<TwoFactorAuthController> {
  const TwoFactorFormCard({super.key});

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
            TwoFactorDeviceInfoCard(
              deviceName: controller.displayDeviceName,
              initialMessage: controller.initialMessage,
            ),
            AppSpacing.vXl,
            Text(
              'رمز التحقق (OTP)',
              style: AppTypography.titleSmall.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            AppSpacing.vXs,
            Text(
              'أدخل الرمز المكون من 6 أرقام المرسل عبر الرسائل القصيرة.',
              style: AppTypography.bodySmall.copyWith(
                color: colors.onSurfaceVariant,
              ),
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
                  text: 'تأكيد الرمز والمتابعة',
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
                    ? 'إعادة إرسال رمز التحقق'
                    : 'يمكن إعادة الإرسال بعد ${controller.cooldownSeconds.value} ثانية',
                loading: controller.isResending.value,
                enabled:
                    controller.canResend.value && !controller.isResending.value,
                onPressed: controller.resendOtp,
              ),
            ),
            AppSpacing.vXs,
            CustomButton.text(
              text: 'العودة إلى تسجيل الدخول',
              prefix: const Icon(Icons.arrow_forward_rounded),
              onPressed: controller.cancelAndGoBack,
            ),
          ],
        ),
      ),
    );
  }
}
