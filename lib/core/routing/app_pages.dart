import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/core/routing/middlewares/auth_guard.dart';
import 'package:netsales_dashboard/features/auth/presentation/bindings/forgot_password_binding.dart';
import 'package:netsales_dashboard/features/auth/presentation/bindings/login_binding.dart';
import 'package:netsales_dashboard/features/auth/presentation/bindings/reset_password_binding.dart';
import 'package:netsales_dashboard/features/auth/presentation/bindings/two_factor_auth_binding.dart';
import 'package:netsales_dashboard/features/auth/presentation/bindings/verify_otp_binding.dart';
import 'package:netsales_dashboard/features/auth/presentation/screens/auth_success_screen.dart';
import 'package:netsales_dashboard/features/auth/presentation/screens/auth_unauthorized_screen.dart';
import 'package:netsales_dashboard/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:netsales_dashboard/features/auth/presentation/screens/login_screen.dart';
import 'package:netsales_dashboard/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:netsales_dashboard/features/auth/presentation/screens/two_factor_auth_screen.dart';
import 'package:netsales_dashboard/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:netsales_dashboard/features/splash/presentation/bindings/splash_binding.dart';
import 'package:netsales_dashboard/features/splash/presentation/screens/splash_screen.dart';
import 'package:netsales_dashboard/widgets/dashboard_metrics/showcase/dashboard_metrics_showcase_binding.dart';
import 'package:netsales_dashboard/widgets/dashboard_metrics/showcase/dashboard_metrics_showcase_screen.dart';
import 'package:netsales_dashboard/widgets/data_grid/showcase/data_grid_showcase_binding.dart';
import 'package:netsales_dashboard/widgets/data_grid/showcase/data_grid_showcase_screen.dart';

/// ============================================================================
/// سجل صفحات ومسارات التطبيق (Application Pages Register)
/// ============================================================================
abstract final class AppPages {
  AppPages._();

  static const String initial = AppRoutes.initial;

  static final List<GetPage<dynamic>> routes = [
    GetPage<dynamic>(
      name: AppRoutes.initial,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: ForgotPasswordBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: AppRoutes.verifyOtp,
      page: () => const VerifyOtpScreen(),
      binding: VerifyOtpBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordScreen(),
      binding: ResetPasswordBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: AppRoutes.twoFactorAuth,
      page: () => const TwoFactorAuthScreen(),
      binding: TwoFactorAuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: AppRoutes.dashboard,
      page: () => const AuthSuccessScreen(),
      middlewares: [AuthGuard()],
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: AppRoutes.unauthorized,
      page: () => const AuthUnauthorizedScreen(),
      transition: Transition.fadeIn,
    ),

    // Developer-only visual verification; omitted from release builds.
    if (kDebugMode)
      GetPage<dynamic>(
        name: AppRoutes.dashboardMetricsShowcase,
        page: () => const DashboardMetricsShowcaseScreen(),
        binding: DashboardMetricsShowcaseBinding(),
      ),
    if (kDebugMode)
      GetPage<dynamic>(
        name: AppRoutes.dataGridShowcase,
        page: () => const DataGridShowcaseScreen(),
        binding: DataGridShowcaseBinding(),
      ),
  ];
}
