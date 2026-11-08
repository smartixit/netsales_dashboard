import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/core/utils/form_validators.dart';
import 'package:netsales_dashboard/features/auth/presentation/controllers/forgot_password_controller.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_phone_field.dart';
import 'package:netsales_dashboard/widgets/interactions/custom_interactive_bounce.dart';

/// بطاقة نموذج استعادة كلمة المرور (ForgotPasswordFormCard)
class ForgotPasswordFormCard extends GetView<ForgotPasswordController> {
  const ForgotPasswordFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          controller.submit();
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
              'استرجاع الحساب',
              style: AppTypography.titleMedium.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            AppSpacing.vXs,
            Text(
              'أدخل رقم هاتفك المسجل وسنرسل رمز تحقق فوري لتأكيد هويتك وتعيين كلمة مرور جديدة.',
              style: AppTypography.bodySmall.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            AppSpacing.vXl,
            CustomPhoneField(
              controller: controller.phoneController,
              label: 'رقم الهاتف المسجل',
              hint: '77XXXXXXX',
              autofocus: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => controller.submit(),
              validator: FormValidators.phoneValidator(fieldName: 'رقم الهاتف'),
            ),
            AppSpacing.vXxl,
            Obx(
              () => CustomInteractiveBounce(
                child: CustomButton.primary(
                  text: 'إرسال رمز التحقق',
                  prefix: const Icon(Icons.sms_outlined),
                  width: double.infinity,
                  height: 52,
                  loading: controller.isLoading.value,
                  enabled: !controller.isLoading.value,
                  onPressed: controller.submit,
                ),
              ),
            ),
            AppSpacing.vLg,
            CustomButton.text(
              text: 'العودة إلى تسجيل الدخول',
              prefix: const Icon(Icons.arrow_forward_rounded),
              onPressed: controller.goToLogin,
            ),
          ],
        ),
      ),
    );
  }
}
