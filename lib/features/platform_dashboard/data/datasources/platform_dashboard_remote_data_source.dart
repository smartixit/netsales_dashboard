import 'package:netsales_dashboard/features/platform_dashboard/data/models/platform_activity_model.dart';
import 'package:netsales_dashboard/features/platform_dashboard/data/models/platform_dashboard_overview_model.dart';
import 'package:netsales_dashboard/features/platform_dashboard/data/models/platform_notification_model.dart';

abstract interface class PlatformDashboardRemoteDataSource {
  Future<PlatformDashboardOverviewModel> getOverview({required String period});
  Future<List<PlatformNotificationModel>> getUnreadNotifications({required int limit});
  Future<int> getUnreadNotificationCount();
  Future<void> markNotificationRead(int notificationId);
  Future<void> markAllNotificationsRead();
  Future<List<PlatformActivityModel>> getRecentActivity({required int limit});
}
