import 'package:netsales_dashboard/features/platform_dashboard/data/datasources/platform_dashboard_remote_data_source.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_activity_entity.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_notification_entity.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/repositories/platform_dashboard_repository.dart';

class PlatformDashboardRepositoryImpl implements PlatformDashboardRepository {
  const PlatformDashboardRepositoryImpl(this._remote);
  final PlatformDashboardRemoteDataSource _remote;

  @override
  Future<List<PlatformNotificationEntity>> getUnreadNotifications({int limit = 6}) =>
      _remote.getUnreadNotifications(limit: limit);
  @override
  Future<int> getUnreadNotificationCount() => _remote.getUnreadNotificationCount();
  @override
  Future<void> markNotificationRead(int notificationId) =>
      _remote.markNotificationRead(notificationId);
  @override
  Future<void> markAllNotificationsRead() => _remote.markAllNotificationsRead();
  @override
  Future<List<PlatformActivityEntity>> getRecentActivity({int limit = 6}) =>
      _remote.getRecentActivity(limit: limit);
}
