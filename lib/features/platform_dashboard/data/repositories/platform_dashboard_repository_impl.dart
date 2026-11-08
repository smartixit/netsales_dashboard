import 'package:netsales_dashboard/features/platform_dashboard/data/datasources/platform_dashboard_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_activity_entity.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_dashboard_overview_entity.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_notification_entity.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/repositories/platform_dashboard_repository.dart';

/// يعيد نماذج Data مباشرة لأنها ترث كيانات Domain المطابقة.
class PlatformDashboardRepositoryImpl implements PlatformDashboardRepository {
  const PlatformDashboardRepositoryImpl(this._remote);

  final PlatformDashboardRemoteDataSource _remote;

  @override
  Future<PlatformDashboardOverviewEntity> getOverview({
    String period = '30d',
  }) {
    return _remote.getOverview(period: period);
  }

  @override
  Future<List<PlatformNotificationEntity>> getUnreadNotifications({
    int limit = 6,
  }) async {
    return _remote.getUnreadNotifications(limit: limit);
  }

  @override
  Future<int> getUnreadNotificationCount() {
    return _remote.getUnreadNotificationCount();
  }

  @override
  Future<void> markNotificationRead(int notificationId) {
    return _remote.markNotificationRead(notificationId);
  }

  @override
  Future<void> markAllNotificationsRead() {
    return _remote.markAllNotificationsRead();
  }

  @override
  Future<List<PlatformActivityEntity>> getRecentActivity({
    int limit = 6,
  }) async {
    return _remote.getRecentActivity(limit: limit);
  }
}
