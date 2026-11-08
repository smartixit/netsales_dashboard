import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/constants/app_spacing.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/core/utils/form_validators.dart';
import 'package:netsales_dashboard/features/auth/presentation/controllers/login_controller.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:netsales_dashboard/widgets/buttons/custom_button.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_password_field.dart';
import 'package:netsales_dashboard/widgets/inputs/custom_phone_field.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      icon: Icons.lock_open_rounded,
      title: 'مرحباً بعودتك',
      subtitle: 'سجّل الدخول إلى مساحة إدارة منصة NetSales.',
      footer: Text(
        'يتم التحقق من صلاحيات حسابك بشكل آمن عبر الخادم.',
        style: Theme.of(context).textTheme.bodySmall,
        textAlign: TextAlign.center,
      ),
      child: AutofillGroup(
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              CustomPasswordField(
                controller: controller.passwordController,
                label: 'كلمة المرور',
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => controller.submitLogin(),
              ),
              AppSpacing.vSm,
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: CustomButton.text(
                  text: 'نسيت كلمة المرور؟',
                  size: AppButtonSize.small,
                  onPressed: controller.goToForgotPassword,
                ),
              ),
              AppSpacing.vLg,
              Obx(
                () => CustomButton.primary(
                  text: 'تسجيل الدخول',
                  prefix: const Icon(Icons.arrow_forward_rounded),
                  width: double.infinity,
                  height: 54,
                  loading: controller.isLoading.value,
                  enabled: !controller.isLoading.value,
                  onPressed: controller.submitLogin,
                ),
              ),
              Obx(() {
                if (!controller.canCheckBiometrics.value) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: EdgeInsets.only(top: AppSpacing.md),
                  child: CustomButton.outline(
                    text: 'الدخول بالبصمة',
                    prefix: const Icon(Icons.fingerprint_rounded),
                    width: double.infinity,
                    height: 50,
                    enabled: !controller.isLoading.value,
                    onPressed: controller.authenticateWithBiometrics,
                  ),
                );
              }),
              AppSpacing.vLg,
              Row(
                children: [
                  Expanded(child: Divider(color: context.colors.outlineVariant)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(
                      'اتصال آمن',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                  Expanded(child: Divider(color: context.colors.outlineVariant)),
                ],
              ),
              AppSpacing.vMd,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 16,
                    color: context.colors.success,
                  ),
                  AppSpacing.hXs,
                  Text(
                    'بياناتك محمية أثناء تسجيل الدخول',
                    style: Theme.of(context).textTheme.labelSmall,
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
