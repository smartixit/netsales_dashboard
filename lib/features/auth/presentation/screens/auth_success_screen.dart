import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/core/services/session_service.dart';
import 'package:netsales_dashboard/core/themes/app_colors.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:netsales_dashboard/features/auth/presentation/widgets/auth_status_panel.dart';

/// Successful authentication result presented in the shared auth visual system.
class AuthSuccessScreen extends StatelessWidget {
  const AuthSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = SessionService.to.currentUser?.userFullName;
    final greetingName = userName?.trim().isNotEmpty == true
        ? userName!.trim()
        : 'بك';

    return AuthScaffold(
      icon: Icons.verified_user_rounded,
      title: 'اكتملت المصادقة',
      subtitle: 'تم التحقق من هويتك وتجهيز جلسة العمل الإدارية.',
      child: AuthStatusPanel(
        icon: Icons.check_circle_rounded,
        accentColor: context.colors.success,
        eyebrow: 'تم التحقق بنجاح',
        title: 'مرحباً $greetingName',
        message:
            'أصبحت جلسة العمل جاهزة. يمكنك الآن الانتقال إلى لوحة التحكم ومتابعة مهام المنصة.',
        primaryLabel: 'الانتقال إلى لوحة التحكم',
        onPrimaryPressed: () =>
            Get.offAllNamed<void>(AppRoutes.dashboard),
      ),
    );
  }
}
