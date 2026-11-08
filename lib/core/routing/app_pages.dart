import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';
import 'package:netsales_dashboard/core/routing/app_routes.dart';
import 'package:netsales_dashboard/core/routing/middlewares/auth_guard.dart';
import 'package:netsales_dashboard/core/constants/app_permissions.dart';
import 'package:netsales_dashboard/features/auth/presentation/bindings/forgot_password_binding.dart';
import 'package:netsales_dashboard/features/auth/presentation/bindings/login_binding.dart';
import 'package:netsales_dashboard/features/auth/presentation/bindings/reset_password_binding.dart';
import 'package:netsales_dashboard/features/auth/presentation/bindings/two_factor_auth_binding.dart';
import 'package:netsales_dashboard/features/auth/presentation/bindings/verify_otp_binding.dart';
import 'package:netsales_dashboard/features/auth/presentation/screens/auth_unauthorized_screen.dart';
import 'package:netsales_dashboard/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:netsales_dashboard/features/auth/presentation/screens/login_screen.dart';
import 'package:netsales_dashboard/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:netsales_dashboard/features/auth/presentation/screens/two_factor_auth_screen.dart';
import 'package:netsales_dashboard/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/bindings/platform_dashboard_binding.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/screens/platform_dashboard_screen.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/screens/platform_module_placeholder_screen.dart';
import 'package:netsales_dashboard/features/platform_dashboard/presentation/screens/platform_overview_screen.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/bindings/platform_users_binding.dart';
import 'package:netsales_dashboard/features/platform_users/presentation/screens/platform_users_screen.dart';
import 'package:netsales_dashboard/features/splash/presentation/bindings/splash_binding.dart';
import 'package:netsales_dashboard/features/splash/presentation/screens/splash_screen.dart';
import 'package:netsales_dashboard/widgets/dashboard_metrics/showcase/dashboard_metrics_showcase_binding.dart';
import 'package:netsales_dashboard/widgets/dashboard_metrics/showcase/dashboard_metrics_showcase_screen.dart';
import 'package:netsales_dashboard/widgets/data_grid/showcase/data_grid_showcase_binding.dart';
import 'package:netsales_dashboard/widgets/data_grid/showcase/data_grid_showcase_screen.dart';

abstract final class AppPages {
  AppPages._();
  static const String initial = AppRoutes.initial;

  static GetPage<dynamic> _module(String path, String id, String permission) =>
      GetPage<dynamic>(
        name: path,
        page: () => PlatformModulePlaceholderScreen(destinationId: id),
        middlewares: [PermissionGuardMiddleware(requiredPermission: permission)],
        transition: Transition.fadeIn,
      );

  static GetPage<dynamic> _superAdminModule(String path, String id) =>
      GetPage<dynamic>(
        name: path,
        page: () => PlatformModulePlaceholderScreen(destinationId: id),
        middlewares: [PermissionGuardMiddleware(requiredRole: AppRoles.superAdmin)],
        transition: Transition.fadeIn,
      );

  static final List<GetPage<dynamic>> routes = [
    GetPage<dynamic>(name: AppRoutes.initial, page: () => const SplashScreen(), binding: SplashBinding(), transition: Transition.fadeIn),
    GetPage<dynamic>(name: AppRoutes.login, page: () => const LoginScreen(), binding: LoginBinding(), transition: Transition.fadeIn),
    GetPage<dynamic>(name: AppRoutes.forgotPassword, page: () => const ForgotPasswordScreen(), binding: ForgotPasswordBinding(), transition: Transition.fadeIn),
    GetPage<dynamic>(name: AppRoutes.verifyOtp, page: () => const VerifyOtpScreen(), binding: VerifyOtpBinding(), transition: Transition.fadeIn),
    GetPage<dynamic>(name: AppRoutes.resetPassword, page: () => const ResetPasswordScreen(), binding: ResetPasswordBinding(), transition: Transition.fadeIn),
    GetPage<dynamic>(name: AppRoutes.twoFactorAuth, page: () => const TwoFactorAuthScreen(), binding: TwoFactorAuthBinding(), transition: Transition.fadeIn),
    GetPage<dynamic>(
      name: AppRoutes.dashboard,
      page: () => const PlatformDashboardScreen(),
      binding: PlatformDashboardBinding(),
      middlewares: [
        AuthGuard(),
        PermissionGuardMiddleware(
          anyRoles: const [
            AppRoles.superAdmin,
            AppRoles.supportAgent,
            AppRoles.accountant,
          ],
        ),
      ],
      transition: Transition.fadeIn,
      children: [
        GetPage<dynamic>(name: '/overview', page: () => const PlatformOverviewScreen(), transition: Transition.fadeIn),
        GetPage<dynamic>(name: '/account', page: () => const PlatformModulePlaceholderScreen(destinationId: 'account'), transition: Transition.fadeIn),
        GetPage<dynamic>(name: '/users', page: () => const PlatformUsersScreen(), binding: PlatformUsersBinding(), middlewares: [PermissionGuardMiddleware(requiredPermission: AppPermissions.usersView)], transition: Transition.fadeIn),
        _module('/roles', 'roles', AppPermissions.rolesView),
        _module('/networks', 'networks', AppPermissions.networksView),
        _module('/pos', 'pos', AppPermissions.posView),
        _module('/geography', 'geography', AppPermissions.geographyView),
        _module('/subscription-plans', 'subscription_plans', AppPermissions.subscriptionsView),
        _module('/provider-subscriptions', 'provider_subscriptions', AppPermissions.subscriptionsView),
        _module('/subscription-requests', 'subscription_requests', AppPermissions.subscriptionsView),
        _module('/sales', 'sales', AppPermissions.salesView),
        _module('/network-wallets', 'network_wallets', AppPermissions.networkWalletsView),
        _module('/pos-wallets', 'pos_wallets', AppPermissions.posWalletsView),
        _module('/expenses', 'expenses', AppPermissions.expensesView),
        _module('/bank-accounts', 'bank_accounts', AppPermissions.bankAccountsView),
        _module('/financial-reports', 'reports', AppPermissions.salesReport),
        _module('/support-tickets', 'support_tickets', AppPermissions.supportView),
        _module('/notifications', 'notifications', AppPermissions.notificationsView),
        _module('/notification-management', 'send_notifications', AppPermissions.notificationsCreate),
        _module('/sessions', 'sessions', AppPermissions.authView),
        _module('/audit-logs', 'audit_logs', AppPermissions.systemLogsView),
        _module('/settings', 'settings', AppPermissions.settingsView),
        _superAdminModule('/backups', 'backups'),
        _superAdminModule('/scheduled-tasks', 'scheduled_tasks'),
      ],
    ),
    GetPage<dynamic>(name: AppRoutes.unauthorized, page: () => const AuthUnauthorizedScreen(), transition: Transition.fadeIn),
    if (kDebugMode) GetPage<dynamic>(name: AppRoutes.dashboardMetricsShowcase, page: () => const DashboardMetricsShowcaseScreen(), binding: DashboardMetricsShowcaseBinding()),
    if (kDebugMode) GetPage<dynamic>(name: AppRoutes.dataGridShowcase, page: () => const DataGridShowcaseScreen(), binding: DataGridShowcaseBinding()),
  ];
}
