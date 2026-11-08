import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/utils/form_validators.dart';
import 'package:netsales_dashboard/features/auth/presentation/controllers/verify_otp_controller.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_pin_field.dart';

class VerifyOtpScreen extends GetView<VerifyOtpController> {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      icon: Icons.mark_email_read_outlined,
      title: 'تحقق من رقم هاتفك',
      subtitle: 'أدخل رمز التحقق المكوّن من ستة أرقام المرسل إلى ${controller.maskedPhone}.',
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
              () => CustomButton.primary(
                text: 'التحقق والمتابعة',
                prefix: const Icon(Icons.verified_user_outlined),
                width: double.infinity,
                height: 54,
                loading: controller.isLoading.value,
                enabled: !controller.isLoading.value,
                onPressed: controller.submitOtp,
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
              onPressed: controller.goToChangePhone,
            ),
          ],
        ),
      ),
    );
  }
}
