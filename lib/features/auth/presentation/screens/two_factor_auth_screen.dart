import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/features/auth/presentation/controllers/two_factor_auth_controller.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/two_factor_form_card.dart';

/// واجهة المصادقة الثنائية (TwoFactorAuthScreen)
class TwoFactorAuthScreen extends GetView<TwoFactorAuthController> {
  const TwoFactorAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      icon: Icons.phonelink_lock_rounded,
      title: 'تأكيد تسجيل الدخول',
      subtitle:
          'أدخل رمز التحقق المرسل إلى ${controller.maskedPhone} لتأكيد هويتك وحماية حسابك.',
      child: const TwoFactorFormCard(),
    );
  }
}
