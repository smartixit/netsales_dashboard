import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/utils/form_validators.dart';
import 'package:netsales_dashboard/features/auth/presentation/controllers/two_factor_auth_controller.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_pin_field.dart';

class TwoFactorAuthScreen extends GetView<TwoFactorAuthController> {
  const TwoFactorAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      icon: Icons.phonelink_lock_rounded,
      title: 'تأكيد تسجيل الدخول',
      subtitle: 'أدخل رمز التحقق المرسل إلى ' +
          controller.maskedPhone +
          ' لتأكيد هويتك.',
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DeviceInfo(
              deviceName: controller.displayDeviceName,
              initialMessage: controller.initialMessage,
            ),
            AppSpacing.vXl,
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
                text: 'تأكيد الجهاز والمتابعة',
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
                    ? 'إعادة إرسال رمز التحقق'
                    : 'يمكن إعادة الإرسال بعد ' +
                        controller.cooldownSeconds.value.toString() +
                        ' ثانية',
                loading: controller.isResending.value,
                enabled:
                    controller.canResend.value && !controller.isResending.value,
                onPressed: controller.resendOtp,
              ),
            ),
            AppSpacing.vXs,
            CustomButton.text(
              text: 'العودة إلى تسجيل الدخول',
              onPressed: controller.cancelAndGoBack,
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceInfo extends StatelessWidget {
  const _DeviceInfo({
    required this.deviceName,
    required this.initialMessage,
  });

  final String deviceName;
  final String? initialMessage;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.devices_rounded, color: colors.primary),
              AppSpacing.hSm,
              Expanded(
                child: Text(
                  'تأكيد الجهاز: ' + deviceName,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
          if (initialMessage != null && initialMessage!.trim().isNotEmpty) ...[
            AppSpacing.vSm,
            Text(
              initialMessage!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
