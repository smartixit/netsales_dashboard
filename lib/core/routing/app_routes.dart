/// ============================================================================
/// ثوابت مسارات التطبيق (Application Routes)
/// ============================================================================
/// تُعرّف أسماء كافة المسارات في النظام لتفادي استخدام النصوص المباشرة في التوجيه.
abstract final class AppRoutes {
  AppRoutes._();

  // مسار البداية والتحقق الأولي
  static const String initial = '/splash';
  static const String login = '/login';
  static const String notFound = '/not-found';

  static const String dataGridShowcase = '/dev/data-grid';
  static const String dashboardMetricsShowcase = '/dev/dashboard-metrics';
}
