import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/features/auth/presentation/controllers/verify_otp_controller.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/verify_otp_form_card.dart';

/// واجهة التحقق من رمز OTP (VerifyOtpScreen)
class VerifyOtpScreen extends GetView<VerifyOtpController> {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      icon: Icons.mark_email_read_outlined,
      title: 'تحقق من رقم هاتفك',
      subtitle:
          'أدخل رمز التحقق المكوّن من ستة أرقام المرسل إلى ${controller.maskedPhone}.',
      child: const VerifyOtpFormCard(),
    );
  }
}
