import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_notification_entity.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/repositories/platform_dashboard_repository.dart';

class GetPlatformNotificationsUseCase {
  const GetPlatformNotificationsUseCase(this._repository);
  final PlatformDashboardRepository _repository;
  Future<List<PlatformNotificationEntity>> call({int limit = 6}) =>
      _repository.getUnreadNotifications(limit: limit);
}
