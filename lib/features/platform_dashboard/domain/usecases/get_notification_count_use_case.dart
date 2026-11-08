import 'package:netsales_dashboard/features/platform_dashboard/domain/repositories/platform_dashboard_repository.dart';

class GetNotificationCountUseCase {
  const GetNotificationCountUseCase(this._repository);

  final PlatformDashboardRepository _repository;

  Future<int> execute() => _repository.getUnreadNotificationCount();

  Future<int> call() => execute();
}
