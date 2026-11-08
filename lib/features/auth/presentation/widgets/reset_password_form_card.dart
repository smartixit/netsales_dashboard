import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/themes/app_typography.dart';
import 'package:netsales_dashboard/core/utils/form_validators.dart';
import 'package:netsales_dashboard/features/auth/presentation/controllers/reset_password_controller.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_password_field.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_password_requirement_item.dart';
import 'package:netsales_dashboard/widgets/interactions/custom_interactive_bounce.dart';

/// بطاقة نموذج تعيين وتغيير كلمة المرور (ResetPasswordFormCard)
class ResetPasswordFormCard extends GetView<ResetPasswordController> {
  const ResetPasswordFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDirectReset = controller.isDirectReset;

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
            if (controller.isForced) ...[
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colors.warningContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: colors.warning.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: colors.warning,
                      size: 20,
                    ),
                    AppSpacing.hSm,
                    Expanded(
                      child: Text(
                        'يتطلب حسابك تغيير كلمة المرور الحالية قبل متابعة استخدام المنصة.',
                        style: AppTypography.bodySmall.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.vLg,
            ],
            if (!isDirectReset) ...[
              CustomPasswordField(
                controller: controller.currentPasswordController,
                label: 'كلمة المرور الحالية',
                textInputAction: TextInputAction.next,
              ),
              AppSpacing.vLg,
            ],
            CustomPasswordField.newPassword(
              controller: controller.newPasswordController,
              label: 'كلمة المرور الجديدة',
              validator: FormValidators.passwordValidator(
                fieldName: 'كلمة المرور الجديدة',
              ),
            ),
            AppSpacing.vMd,
            _PasswordStrengthIndicator(controller: controller),
            AppSpacing.vLg,
            CustomPasswordField.confirm(
              controller: controller.confirmPasswordController,
              label: 'تأكيد كلمة المرور الجديدة',
              validator: FormValidators.confirmPasswordValidator(
                passwordController: controller.newPasswordController,
              ),
            ),
            AppSpacing.vXxl,
            Obx(
              () => CustomInteractiveBounce(
                child: CustomButton.primary(
                  text: 'حفظ كلمة المرور',
                  prefix: const Icon(Icons.check_rounded),
                  width: double.infinity,
                  height: 52,
                  loading: controller.isLoading.value,
                  enabled: !controller.isLoading.value,
                  onPressed: controller.submit,
                ),
              ),
            ),
            AppSpacing.vMd,
            CustomButton.text(
              text: isDirectReset
                  ? 'العودة'
                  : controller.isForced
                  ? 'تسجيل الخروج'
                  : 'إلغاء',
              onPressed: controller.abortOrLogout,
            ),
          ],
        ),
      ),
    );
  }
}

class _PasswordStrengthIndicator extends StatelessWidget {
  const _PasswordStrengthIndicator({required this.controller});

  final ResetPasswordController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomPasswordRequirementItem(
            label: '8 أحرف على الأقل',
            isValid: controller.hasMinLength.value,
          ),
          AppSpacing.vXxs,
          CustomPasswordRequirementItem(
            label: 'حرف كبير واحد على الأقل (A-Z)',
            isValid: controller.hasUppercase.value,
          ),
          AppSpacing.vXxs,
          CustomPasswordRequirementItem(
            label: 'حرف صغير واحد على الأقل (a-z)',
            isValid: controller.hasLowercase.value,
          ),
          AppSpacing.vXxs,
          CustomPasswordRequirementItem(
            label: 'رقم واحد على الأقل (0-9)',
            isValid: controller.hasDigit.value,
          ),
          AppSpacing.vXxs,
          CustomPasswordRequirementItem(
            label: 'رمز خاص واحد على الأقل (@, #, \$, ...)',
            isValid: controller.hasSpecialChar.value,
          ),
        ],
      );
    });
  }
}
