import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_activity_entity.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_notification_entity.dart';

abstract interface class PlatformDashboardRepository {
  Future<List<PlatformNotificationEntity>> getUnreadNotifications({int limit = 6});
  Future<int> getUnreadNotificationCount();
  Future<void> markNotificationRead(int notificationId);
  Future<void> markAllNotificationsRead();
  Future<List<PlatformActivityEntity>> getRecentActivity({int limit = 6});
}
