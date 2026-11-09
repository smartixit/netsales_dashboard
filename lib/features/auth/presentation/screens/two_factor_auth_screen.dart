import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/features/auth/presentation/controllers/two_factor_auth_controller.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/auth_flow_progress.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/two_factor_form_card.dart';

/// Device confirmation screen for two-factor authentication.
class TwoFactorAuthScreen extends GetView<TwoFactorAuthController> {
  const TwoFactorAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      icon: Icons.phonelink_lock_rounded,
      title: 'تأكيد تسجيل الدخول',
      subtitle:
          'نحتاج إلى خطوة تحقق إضافية لتأكيد هويتك وربط جلسة العمل بهذا الجهاز.',
      progress: const AuthFlowProgress(
        currentStep: 2,
        totalSteps: 2,
        label: 'الخطوة الأخيرة · التحقق من الجهاز',
      ),
      child: const TwoFactorFormCard(),
    );
  }
}
