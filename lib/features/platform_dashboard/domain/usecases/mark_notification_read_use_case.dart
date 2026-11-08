import 'package:netsales_dashboard/features/platform_dashboard/domain/repositories/platform_dashboard_repository.dart';

class MarkNotificationReadUseCase {
  const MarkNotificationReadUseCase(this._repository);
  final PlatformDashboardRepository _repository;
  Future<void> call(int notificationId) =>
      _repository.markNotificationRead(notificationId);
}
