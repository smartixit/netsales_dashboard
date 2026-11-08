import 'package:netsales_dashboard/features/platform_dashboard/domain/repositories/platform_dashboard_repository.dart';

class MarkAllNotificationsReadUseCase {
  const MarkAllNotificationsReadUseCase(this._repository);

  final PlatformDashboardRepository _repository;

  Future<void> execute() => _repository.markAllNotificationsRead();

  Future<void> call() => execute();
}
