/// ============================================================================
/// ثوابت مسارات التطبيق (Application Routes)
/// ============================================================================
abstract final class AppRoutes {
  AppRoutes._();

  static const String initial = '/splash';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String verifyOtp = '/verify-otp';
  static const String resetPassword = '/reset-password';
  static const String twoFactorAuth = '/two-factor-auth';

  /// Current authenticated landing surface until the platform home is delivered.
  static const String dashboard = '/dashboard';
  static const String unauthorized = '/unauthorized';
  static const String notFound = '/not-found';

  static const String dataGridShowcase = '/dev/data-grid';
  static const String dashboardMetricsShowcase = '/dev/dashboard-metrics';
}
