import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/features/auth/presentation/controllers/reset_password_controller.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/reset_password_form_card.dart';

/// واجهة تعيين وتغيير كلمة المرور (ResetPasswordScreen)
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
          ? 'اختر كلمة مرور جديدة وقوية لحماية حسابك والوصول للمنصة.'
          : 'استخدم كلمة مرور قوية لمتابعة الوصول الآمن إلى مساحة المنصة.',
      child: const ResetPasswordFormCard(),
    );
  }
}
