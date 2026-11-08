import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/features/auth/presentation/controllers/forgot_password_controller.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/forgot_password_form_card.dart';

/// واجهة استعادة كلمة المرور (ForgotPasswordScreen)
class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthScaffold(
      icon: Icons.key_rounded,
      title: 'استعادة كلمة المرور',
      subtitle: 'أدخل رقم الهاتف المرتبط بحسابك، وسنرسل إليه رمز تحقق لإكمال استعادة الحساب.',
      child: ForgotPasswordFormCard(),
    );
  }
}
