import 'package:netsales_dashboard/features/platform_dashboard/domain/entities/platform_activity_entity.dart';
import 'package:netsales_dashboard/features/platform_dashboard/domain/repositories/platform_dashboard_repository.dart';

class GetRecentPlatformActivityUseCase {
  const GetRecentPlatformActivityUseCase(this._repository);
  final PlatformDashboardRepository _repository;
  Future<List<PlatformActivityEntity>> call({int limit = 6}) =>
      _repository.getRecentActivity(limit: limit);
}
