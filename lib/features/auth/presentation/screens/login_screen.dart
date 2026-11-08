import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/features/auth/presentation/controllers/login_controller.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/login_form_card.dart';

/// واجهة تسجيل الدخول المؤسسية لمنصة NetSales (LoginScreen)
///
/// تمثل شاشة نظيفة مفككة وفق معايير Clean Architecture:
/// - لا تحتوي على تفاصيل داخلية للنموذج أو كتل تصميم ضخمة.
/// - تجمع فقط بين `AuthScaffold` والنموذج التفاعلي `LoginFormCard`.
class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthScaffold(
      icon: Icons.shield_rounded,
      title: 'مرحباً بك مجدداً',
      subtitle:
          'سجّل الدخول إلى لوحة التحكم الإدارية لمتابعة العمليات والحسابات.',
      child: LoginFormCard(),
    );
  }
}
