import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/features/auth/presentation/controllers/forgot_password_controller.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/auth_flow_progress.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/forgot_password_form_card.dart';

/// Password recovery entry screen.
class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthScaffold(
      icon: Icons.key_rounded,
      title: 'استعادة كلمة المرور',
      subtitle:
          'سنساعدك على استعادة الوصول إلى حسابك بخطوات واضحة وآمنة دون كشف بياناتك.',
      progress: AuthFlowProgress(
        currentStep: 1,
        totalSteps: 3,
        label: 'الخطوة الأولى · استعادة الحساب',
      ),
      child: ForgotPasswordFormCard(),
    );
  }
}
