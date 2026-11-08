import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/utils/form_validators.dart';
import 'package:netsales_dashboard/features/auth/presentation/controllers/forgot_password_controller.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_phone_field.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      icon: Icons.key_rounded,
      title: 'استعادة كلمة المرور',
      subtitle: 'أدخل رقم الهاتف المرتبط بحسابك، وسنرسل إليه رمز تحقق لإكمال الاستعادة.',
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomPhoneField(
              controller: controller.phoneController,
              label: 'رقم الهاتف المسجل',
              hint: '77XXXXXXX',
              autofocus: true,
              validator: FormValidators.phoneValidator(fieldName: 'رقم الهاتف'),
            ),
            AppSpacing.vXxl,
            Obx(
              () => CustomButton.primary(
                text: 'إرسال رمز التحقق',
                prefix: const Icon(Icons.sms_outlined),
                width: double.infinity,
                height: 54,
                loading: controller.isLoading.value,
                enabled: !controller.isLoading.value,
                onPressed: controller.submit,
              ),
            ),
            AppSpacing.vMd,
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
