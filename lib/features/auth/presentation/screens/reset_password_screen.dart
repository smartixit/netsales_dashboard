import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_radius.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/utils/form_validators.dart';
import 'package:netsales_dashboard/features/auth/presentation/controllers/reset_password_controller.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_password_field.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_password_requirement_item.dart';

class ResetPasswordScreen extends GetView<ResetPasswordController> {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDirectReset = controller.isDirectReset;

    return AuthScaffold(
      icon: Icons.password_rounded,
      title: isDirectReset
          ? 'تعيين كلمة مرور جديدة'
          : controller.isForced
          ? 'تغيير كلمة المرور مطلوب'
          : 'تغيير كلمة المرور',
      subtitle: isDirectReset
          ? 'اختر كلمة مرور جديدة لحماية حسابك.'
          : 'استخدم كلمة مرور قوية لمتابعة الوصول إلى مساحة المنصة.',
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (controller.isForced)
              const _PasswordNotice(
                text: 'يتطلب حسابك تغيير كلمة المرور الحالية قبل متابعة استخدام المنصة.',
              ),
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
            _PasswordStrength(controller: controller),
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
              () => CustomButton.primary(
                text: 'حفظ كلمة المرور',
                prefix: const Icon(Icons.check_rounded),
                width: double.infinity,
                height: 54,
                loading: controller.isLoading.value,
                enabled: !controller.isLoading.value,
                onPressed: controller.submit,
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

class _PasswordNotice extends StatelessWidget {
  const _PasswordNotice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.warningContainer.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: colors.warning),
          AppSpacing.hSm,
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

class _PasswordStrength extends StatelessWidget {
  const _PasswordStrength({required this.controller});

  final ResetPasswordController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'قوة كلمة المرور',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const Spacer(),
              Text(
                '${(controller.passwordScore.value * 100).round()}%',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
          AppSpacing.vXs,
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: controller.passwordScore.value,
              minHeight: 6,
              backgroundColor: context.colors.surfaceContainerHighest,
              color: context.colors.primary,
            ),
          ),
          AppSpacing.vSm,
          CustomPasswordRequirementItem(
            isValid: controller.hasMinLength.value,
            label: 'ثمانية أحرف على الأقل',
          ),
          CustomPasswordRequirementItem(
            isValid: controller.hasUppercase.value,
            label: 'حرف إنجليزي كبير',
          ),
          CustomPasswordRequirementItem(
            isValid: controller.hasLowercase.value,
            label: 'حرف إنجليزي صغير',
          ),
          CustomPasswordRequirementItem(
            isValid: controller.hasDigit.value,
            label: 'رقم واحد على الأقل',
          ),
          CustomPasswordRequirementItem(
            isValid: controller.hasSpecialChar.value,
            label: 'رمز خاص واحد على الأقل',
          ),
        ],
      ),
    );
  }
}
