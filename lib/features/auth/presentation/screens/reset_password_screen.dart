import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/features/auth/presentation/controllers/reset_password_controller.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/auth_flow_progress.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/reset_password_form_card.dart';

/// Screen for setting or changing an account password.
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
          ? 'أكمل الخطوة الأخيرة واختر كلمة مرور قوية لحماية حسابك.'
          : 'استخدم كلمة مرور قوية وفريدة لمتابعة الوصول الآمن إلى مساحة المنصة.',
      progress: isDirectReset
          ? const AuthFlowProgress(
              currentStep: 3,
              totalSteps: 3,
              label: 'الخطوة الأخيرة · حماية الحساب',
            )
          : null,
      child: const ResetPasswordFormCard(),
    );
  }
}
